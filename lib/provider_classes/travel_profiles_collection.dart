import 'package:flutter/cupertino.dart';
import 'package:routenplaner/database/database_helper.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:routenplaner/data_structures/TravelProfileData.dart';

// Ähnlich wie Final Routes hat auch TravelProfileCollection mehrere
// Objekte der Klasse Travel Profile
// Collection basierend auf den User Profiles erstellen
// Dafür eventuelle sogar mit Provider das selected Profile in UserProfiles
// referenzieren und listen. Basierend auf der UserID die zugehörigen Travel Profile
// aus der Datenbank holen
class TravelProfileCollection with ChangeNotifier {
  List<TravelProfileData> travelProfileCollection = List<TravelProfileData>();
  TravelProfileData selectedTravelProfile;
  // Höhe und Breite des Dreiecks, ist wichtig wür die interpretation des Icons

  TravelProfileCollection() {
    setTravelProfiles();
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
    SELECT UserID, NameTrav, MaxDetour, MinSegment, MaxAutomFactor, MinTravelTimeFactor, MinADMDFactor
    FROM TravelProfile JOIN User
    ON User.ID = TravelProfile.UserID
    WHERE User.Selected = ?
      ''', [1]);
    // Schreibe die Werte aus der Datenbank in das collection Objekt
    for (int i = 0; i < selectedTravelProfiles.length; i++) {
      var valuesList = selectedTravelProfiles[i].values.toList();
      travelProfileCollection.add(
        TravelProfileData(
          userID: valuesList[0],
          name: valuesList[1],
          maxDetour: valuesList[2],
          minDurationAutomSegment: valuesList[3],
          factorMaxAutom: valuesList[4],
          factorMinTravTime: valuesList[5],
          factorMinADMD: valuesList[6],
        ),
      );
    }
    // Setze das ausgewählte Travel Profil auf 0, als standart
    if (travelProfileCollection.length > 0) {
      selectedTravelProfile = travelProfileCollection[0];
    } else {
      selectedTravelProfile = null;
    }
    print("TravelProfiles set");
    notifyListeners();
  }

  // getter um Zugriff aus die Profile Liste zu bekommen
  //TravelProfileData getProfile(int index) => travelProfileCollection[index];
  // Wird die User ID nicht explizit gegeben, wird automatisch das TravelProfil
  // dem ausgewählten User zugeteilt
  Future<bool> addEmptyTravelProfile({String name, int userID}) async {
    // Initialisieren der Daten, zuerst lokal
    // Sind alles Startwerte, kann man ändern
    travelProfileCollection.add(
      TravelProfileData(
        name: name,
        userID: userID == null
            ? await DatabaseHelper.instance.getCurrentUserID()
            : userID,
        maxDetour: 10,
        minDurationAutomSegment: 10,
        factorMaxAutom: 1 / 3,
        factorMinADMD: 1 / 3,
        factorMinTravTime: 1 / 3,
      ),
    );
    // Auch in der Datenbank hinzufügen
    DatabaseHelper.instance.addTravelProfile(
      name: name,
      userID: userID == null
          ? await DatabaseHelper.instance.getCurrentUserID()
          : userID,
      maxDetour: 10,
      minSegment: 10,
      factorMaxAutom: 1 / 3,
      factorMinADMD: 1 / 3,
      factorMinTravTime: 1 / 3,
    );
    // Falls dies das erste Reiseprofil ist, wird das standartmäßig ausgewählt
    if (travelProfileCollection.length == 1)
      selectedTravelProfile = travelProfileCollection[0];
    notifyListeners();
    return true;
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
      userID: copiedTravelProfile.userID,
      factorMaxAutom: copiedTravelProfile.factorMaxAutom,
      factorMinADMD: copiedTravelProfile.factorMinADMD,
      factorMinTravTime: copiedTravelProfile.factorMinTravTime,
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
    // Schaue, ob denn Überhaupt ein Travel Profil vorhanden
    if (travelProfileCollection == null ||
        travelProfileCollection.length == 0) {
      print("NO TRAVEL PROFILE EXISTEND");
      return;
    }
    // Suche nach dem Richtigen Reiseprofil
    if (name != null) {
      selectedTravelProfile =
          travelProfileCollection.firstWhere((element) => element.name == name);
    } else if (index != null) {
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
      double factorMaxAutom,
      double factorMinADMD,
      double factorMinTravTime,
      int userID}) async {
    // ändern der des Lokalen Profils
    travelProfileCollection[profileIndex].maxDetour = maxDetour;
    travelProfileCollection[profileIndex].minDurationAutomSegment =
        minDurationAutomSegment.toInt();
    travelProfileCollection[profileIndex].factorMaxAutom = factorMaxAutom;
    travelProfileCollection[profileIndex].factorMinADMD = factorMinADMD;
    travelProfileCollection[profileIndex].factorMinTravTime = factorMinTravTime;
    // Änderungen in die Datenbank pushen
    // Profil anhand der aktuellen UserID und Namen eindeutig identifizieren
    print("Update called");
    Database db = await DatabaseHelper.instance.database;
    db.rawUpdate(
      '''
    UPDATE TravelProfile 
    SET MaxDetour = $maxDetour, MinSegment = $minDurationAutomSegment, MaxAutomFactor = $factorMaxAutom, MinTravelTimeFactor = $factorMinTravTime, MinADMDFactor = $factorMinADMD
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
    for (int i = 0; i < travelProfileCollection.length; i++) {
      names.add(travelProfileCollection[i].name);
    }
    return names;
  }
}
