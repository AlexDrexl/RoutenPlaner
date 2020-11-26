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
  // int currentUserID = 1;

  TravelProfileCollection() {
    print("TRAVEL PROFILES INSTATIATE");
    setTravelProfiles();
  }
  // init funktion. Setzt die Profile, basierend auf der userID. Holt dies
  // aus der Datenbank bzw von dem user, der Selected ist.
  // Immer dann aufrufen, wenn das Nutzerprofil geändert wurde
  void setTravelProfiles() async {
    print("set TravelProfiles");
    travelProfileCollection.clear();
    // Hole aus der Datenbank alle Einträge, dessen UserID selected ist
    // mit left Join. FÜge also an jedes TravelProfil ein passendes
    // User Profil, basierend auf der userID
    Database db = await DatabaseHelper.instance.database;
    var selectedTravelProfiles = await db.rawQuery('''
    SELECT NameTrav, UserID, MaxAutom, MinTravel, ADMD, MaxDetour, MinSegment 
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
          indexTriangle: 6,
        ),
      );
    }
    notifyListeners();
  }

  // getter um Zugriff aus die Profile Liste zu bekommen
  //TravelProfileData getProfile(int index) => travelProfileCollection[index];
  // Beim erstellen eines neuen Profils wird zunächst nur der Name Abgefragt
  void addProfile(String name) async {
    // Initialisieren der Daten, zuerst lokal
    // Sind alles Startwerte, kann man ändern
    travelProfileCollection.add(TravelProfileData(
      name: name,
      userID: await getCurrentUserID(),
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
      userID: await getCurrentUserID(),
      maxDetour: 10,
      minSegment: 10,
      maxAutom: 1,
      minTravel: 1,
      admd: 1,
    );
    notifyListeners();
  }

  void deleteProfile(int indexProfile) {
    travelProfileCollection.removeAt(indexProfile);
    notifyListeners();
  }

  TravelProfileData getProfile({@required int indexProfile}) {
    return travelProfileCollection[indexProfile];
  }

  Future<int> getCurrentUserID() async {
    var db = await DatabaseHelper.instance.database;
    var table =
        await db.rawQuery('SELECT ID FROM User WHERE Selected = ?', [1]);
    return (table != null) ? table[0].values.toList()[0] : 1;
  }

  // Ändert bisher nur lokal. Änderungen noch nicht in DB gepushed, bei neustart
  // verloren
  void modifyProfile(
      {int profileIndex,
      int maxDetour,
      double minDurationAutomSegment,
      int indexTriangle}) {
    travelProfileCollection[profileIndex].maxDetour = maxDetour;
    travelProfileCollection[profileIndex].minDurationAutomSegment =
        minDurationAutomSegment.toInt();
    travelProfileCollection[profileIndex].indexTriangle = indexTriangle;
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
