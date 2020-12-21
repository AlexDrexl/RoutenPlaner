import 'package:flutter/cupertino.dart';
import 'package:routenplaner/database/database_helper.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

// Ähnlich wie Final Routes hat auch TravelProfileCollection mehrere
// Objekte der Klasse Travel Profile
// Collection basierend auf den User Profiles erstellen
// Dafür eventuelle sogar mit Provider das selected Profile in UserProfiles
// referenzieren und listen. Basierend auf der UserID die zugehörigen Travel Profile
// aus der Datenbank holen
class TravelProfileCollection with ChangeNotifier {
  List<TravelProfileData> travelProfileCollection = List<TravelProfileData>();
  TravelProfileData selectedTravelProfile = TravelProfileData();

  TravelProfileCollection() {
    print("TRAVEL PROFILES INSTATIATE");
    // setTravelProfiles();
  }
  // init funktion. Setzt die Profile, basierend auf der userID. Holt dies
  // aus der Datenbank bzw von dem user, der Selected ist.
  // Immer dann aufrufen, wenn das Nutzerprofil geändert wurde
  // War mal mit Future, weis nicht genau, ob sich jetzt was geändert hat
  Future<void> setTravelProfiles() async {
    print("set TravelProfiles");
    travelProfileCollection.clear();
    // Hole aus der Datenbank alle Einträge, dessen UserID selected ist
    // mit left Join. FÜge also an jedes TravelProfil ein passendes
    // User Profil, basierend auf der userID
    Database db = await DatabaseHelper.instance.database;
    var selectedTravelProfiles = await db.rawQuery('''
    SELECT NameTrav, UserID, MaxAutom, MinTravel, ADMD, MaxDetour, MinSegment, IndexTriangle 
    FROM TravelProfile LEFT JOIN User
    ON User.ID = TravelProfile.UserID
    WHERE User.Selected = ?
      ''', [1]);
    // Schreibe die Werte aus der Datenbank in das collection Objekt
    for (int i = 0; i < selectedTravelProfiles.length; i++) {
      var valuesList = selectedTravelProfiles[i].values.toList();
      travelProfileCollection.add(
        TravelProfileData(
          name: valuesList[0],
          userID: valuesList[1],
          maxAutomDuration: valuesList[2],
          minTravelTime: valuesList[3],
          admd: valuesList[4],
          maxDetour: valuesList[5],
          minDurationAutomSegment: valuesList[6],
          indexTriangle: valuesList[7],
        ),
      );
    }
    // Setze das ausgewählte Travel Profil auf 0, als standart
    if (travelProfileCollection.length > 0) {
      selectedTravelProfile = travelProfileCollection[0];
    }
    notifyListeners();
  }

  // getter um Zugriff aus die Profile Liste zu bekommen
  //TravelProfileData getProfile(int index) => travelProfileCollection[index];
  // Wird die User ID nicht explizit gegeben, wird automatisch das TravelProfil
  // dem ausgewählten User zugeteilt
  void addEmptyTravelProfile({String name, int userID}) async {
    // Initialisieren der Daten, zuerst lokal
    // Sind alles Startwerte, kann man ändern
    travelProfileCollection.add(TravelProfileData(
      name: name,
      userID: userID == null
          ? await DatabaseHelper.instance.getCurrentUserID()
          : userID,
      maxDetour: 10,
      minDurationAutomSegment: 10,
      maxAutomDuration: 1,
      minTravelTime: 1,
      admd: 1,
      indexTriangle: 6,
    ));
    // Auch in der Datenbank hinzufügen
    DatabaseHelper.instance.addTravelProfile(
      name: name,
      userID: userID == null
          ? await DatabaseHelper.instance.getCurrentUserID()
          : userID,
      maxDetour: 10,
      minSegment: 10,
      maxAutom: 1,
      minTravel: 1,
      admd: 1,
      indexTriangle: 6,
    );
    // Führe notify Listeners nur aus, wenn keine UserID gegeben ist, also
    // das UserProfil NICHT dupliziert wird
    notifyListeners();
  }

  void deleteTravelProfile(int indexProfile) async {
    // In der Datenbank, basierend auf der UserID und Namen löschen
    Database db = await DatabaseHelper.instance.database;
    print("DELETE");
    db.rawDelete(
      '''
    DELETE FROM TravelProfile 
    WHERE UserID = ? AND NameTrav = ?
    ''',
      [
        await DatabaseHelper.instance.getCurrentUserID(),
        travelProfileCollection[indexProfile].name
      ],
    );
    // Lokal löschen
    travelProfileCollection.removeAt(indexProfile);
    notifyListeners();
  }

  TravelProfileData getTravelProfile({@required int indexProfile}) {
    return travelProfileCollection[indexProfile];
  }

  // Dupliziere ein TravelProfile
  void duplicateTravelProfile({@required int indexTravelProfile}) {
    // Lokal Duplizieren
    var copiedTravelProfile = travelProfileCollection[indexTravelProfile];
    addEmptyTravelProfile(
      name: copiedTravelProfile.name + " - Kopie",
      userID: copiedTravelProfile.userID,
    );
    modifyTravelProfile(
      profileIndex: travelProfileCollection.length - 1,
      maxDetour: copiedTravelProfile.maxDetour,
      minDurationAutomSegment:
          copiedTravelProfile.minDurationAutomSegment.toDouble(),
      indexTriangle: copiedTravelProfile.indexTriangle,
      userID: copiedTravelProfile.userID,
    );
    notifyListeners();
  }

  // Ändere den Namen eines Profils
  void changeName({int indexTravelprofile, String name}) async {
    // In der Datenbank ändern
    Database db = await DatabaseHelper.instance.database;
    db.rawUpdate(
      '''
    UPDATE TravelProfile
    SET NameTrav = ?
    WHERE UserID = ? AND NameTrav = ? 
    ''',
      [
        name,
        await DatabaseHelper.instance.getCurrentUserID(),
        travelProfileCollection[indexTravelprofile].name
      ],
    );
    // lokal ändern
    travelProfileCollection[indexTravelprofile].name = name;
    notifyListeners();
  }

  // wähle ein Travel Profile aus
  void selectTravelProfile({int index, String name}) {
    if (name != null) {
      selectedTravelProfile =
          travelProfileCollection.firstWhere((element) => element.name == name);
    } else {
      selectedTravelProfile = travelProfileCollection[index];
    }
    print("SELECTED TRAVEL PROFILE: ${selectedTravelProfile.name}");
    notifyListeners();
  }

  // Ändern eines ReiseProfils, wenn keine UserID explizit gegeben, wird
  // der aktuell ausgewählte user genommen
  void modifyTravelProfile(
      {int profileIndex,
      int maxDetour,
      double minDurationAutomSegment,
      int indexTriangle,
      int userID}) async {
    // ändern der des Lokalen Profils
    travelProfileCollection[profileIndex].maxDetour = maxDetour;
    travelProfileCollection[profileIndex].minDurationAutomSegment =
        minDurationAutomSegment.toInt();
    travelProfileCollection[profileIndex].indexTriangle = indexTriangle;

    // Änderungen in die Datenbank pushen
    // Profil anhand der aktuellen UserID und Namen eindeutig identifizieren
    print("Update called");
    Database db = await DatabaseHelper.instance.database;
    db.rawUpdate(
      '''
    UPDATE TravelProfile 
    SET MaxDetour = $maxDetour, MinSegment = $minDurationAutomSegment, IndexTriangle = $indexTriangle
    WHERE UserID = ? AND NameTrav = ?    
    ''',
      [
        userID == null
            ? await DatabaseHelper.instance.getCurrentUserID()
            : userID,
        travelProfileCollection[profileIndex].name
      ],
    );
  }

  Future<List<String>> getTravelProfileNames() async {
    List<String> names = List<String>();
    if (travelProfileCollection.length == 0) {
      await setTravelProfiles();
    }
    for (int i = 0; i < travelProfileCollection.length; i++) {
      names.add(travelProfileCollection[i].name);
    }
    print(names);
    return names;
  }
}

// Klasse, nur als Struct verwended
class TravelProfileData {
  int userID = 0;
  String name = "";
  // Alle Zeiten in minuten, da man in der Datenbank keine komplexeren Datentypen
  // speichern kann
  int maxDetour = 0; // In %, Verglichen zur minimalen möglichen Route
  int minDurationAutomSegment = 0;
  // Index des DropTargets aus dem Dreieck, muss noch interpretiert werden
  int indexTriangle = 6; // Default auf 6, der Mitte, wenn neu instatiiert

  // Anteilige Routeneinstellungen
  int maxAutomDuration = 0;
  int minTravelTime = 0;
  int admd = 0;

  // Konstruktor um Daten zu füllen
  TravelProfileData({
    this.userID,
    this.name,
    this.maxDetour,
    this.indexTriangle,
    this.minDurationAutomSegment,
    this.maxAutomDuration,
    this.minTravelTime,
    this.admd,
  });
}

/*
    travelProfileCollection.add(TravelProfileData(
        userID: 0,
        name: "Arbeit",
        maxDetour: 10,
        minDurationAutomSegment: 10,
        maxAutomDuration: 0.5,
        minTravelTime: 0.3,
        minChanging: 0.4));
    travelProfileCollection.add(TravelProfileData(
        userID: 0,
        name: "Freizeit",
        maxDetour: 20,
        minDurationAutomSegment: 20,
        maxAutomDuration: 0.5,
        minTravelTime: 0.3,
        minChanging: 0.4));
    travelProfileCollection.add(TravelProfileData(
        userID: 0,
        name: "Kinder",
        maxDetour: 30,
        minDurationAutomSegment: 30,
        maxAutomDuration: 0.5,
        minTravelTime: 0.3,
        minChanging: 0.4));
        */
