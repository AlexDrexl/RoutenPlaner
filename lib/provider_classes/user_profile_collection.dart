import 'package:flutter/material.dart';
import 'package:routenplaner/provider_classes/addresses.dart';
import 'package:routenplaner/provider_classes/road_connections.dart';
import 'package:sqflite/sqflite.dart';
import 'package:routenplaner/database/database_helper.dart';
import 'package:provider/provider.dart';
import 'travel_profiles_collection.dart';

// Nutzerprofile haben verschiedene TravelProfile hinterlegt
// ausserdem haben Verschiedene Favoriten
class UserProfileCollection with ChangeNotifier {
  BuildContext context;
  int selectedUserProfileIndex = 0;
  List<UserProfileData> userProfileCollection = List<UserProfileData>();

  // Im Konstruktor werden die Profile initialisiert d.h Profile in der
  // Datenbankw werden lokal gespeichert und angezeigt
  UserProfileCollection(this.context) {
    initProfiles();
  }

  // Setze die Werte, die bereits in der Datenbank vorhanden sind
  void initProfiles() async {
    var tableUser = await DatabaseHelper.instance.queryAllRows("User");
    selectedUserProfileIndex = 0; // Default
    // print(tableUser);
    // Drei Spalten: ID Name Email
    for (int i = 0; i < tableUser.length; i++) {
      var valueList = tableUser[i].values.toList();
      userProfileCollection.add(
        UserProfileData(
          databaseID: valueList[0],
          name: valueList[1],
          email: valueList[2],
        ),
      );
      // Setze zudem das Profil, das ausgewählt wurde
      if (valueList[3] == 1) {
        selectedUserProfileIndex = i;
      }
    }
    // Nicht nötig, da in select User Profile schon aktualisiert wird
    notifyListeners();
  }

  // lösche ein Profil, lokal und in Datenbank
  void deleteProfile({@required int indexUserProfile}) async {
    // Wenn das aktive Profil gelöscht werden soll, dann setze das neue aktive
    // profil automatisch auf den ersten Eintrag im User Profile Array
    // In Datenbank wird dann automatisch der User mit korrespondierender userID
    // Aktiviert
    Database db = await DatabaseHelper.instance.database;
    if (selectedUserProfileIndex == indexUserProfile) {
      db.rawUpdate('UPDATE User SET Selected = ? WHERE ID = ?',
          [1, userProfileCollection[0].databaseID]);
      selectedUserProfileIndex = 0;
    }
    // Lösche alle zugehörigen ReiseProfile, basierend auf der UserID
    db.rawDelete('''
    DELETE FROM TravelProfile
    WHERE UserID = ?
    ''', [userProfileCollection[indexUserProfile].databaseID]);
    // Lösche alle Adressen, basierend auf der UserID
    db.rawDelete('''
    DELETE FROM Address 
    WHERE UserID = ?
    ''', [userProfileCollection[indexUserProfile].databaseID]);
    // Lösche alle Verbindungen, basierend auf der UserID
    db.rawDelete('''
    DELETE FROM RoadConnection
    WHERE UserID = ?
    ''', [userProfileCollection[indexUserProfile].databaseID]);
    // Lösche den User in der Datenbank
    await DatabaseHelper.instance
        .deleteUser(userID: userProfileCollection[indexUserProfile].databaseID);
    // Lösche User lokal
    userProfileCollection.removeAt(indexUserProfile);
    print("DELETE PROFILE");

    // Wenn ein Profil gelöscht wird, dessen Index kleiner ist als der Index
    // Des selected, verringert sich der Index des Selected um eins
    if (indexUserProfile < selectedUserProfileIndex) {
      selectUserProfile(userIndex: (selectedUserProfileIndex - 1));
    }
    notifyListeners();
  }

  // Füge Profil hinzu, lokal und in Datenbank
  Future<void> addProfile({@required String name, String email}) async {
    // In Datenbank user hinzufügen
    await DatabaseHelper.instance.addUser(
      name: name,
      email: email == null ? " " : email,
    );
    // UserID/ID aus Datenbank holen
    Database db = await DatabaseHelper.instance.database;
    var dbID = await db.rawQuery('SELECT ID FROM User WHERE Name = ?', [name]);
    print('dbID : ${dbID[0].values.toList()[0]}');
    // Lokal in das Objekt
    userProfileCollection.add(
      UserProfileData(
        databaseID: dbID[0].values.toList()[0],
        name: name,
        email: email == null ? "" : email,
      ),
    );
    print("ADD PROFILE");
    // Wenn es das erste Profil ist, dass erstellt wird, dann muss
    // dieses automatisch selected werden
    if (userProfileCollection.length == 1) {
      selectUserProfile(userIndex: 0);
    }
    notifyListeners();
  }

  // Dupliziere Profil,
  // ändere Namen
  // Füge in der Datenbank hinzu
  // Füge lokalem Objekt hinzu
  // Dupliziere alle zugehörigen TravelProfiles,
  void duplicateProfile({@required int indexUserProfile}) async {
    print("DUPLICATE");
    var copiedProfile = userProfileCollection[indexUserProfile];
    // Rufe lokale addUser FUnktion auf, kümmert sich um Datenbank u Lok Obj
    await addProfile(
        name: copiedProfile.name + " - Kopie", email: copiedProfile.email);
    //////////////// KOPIEREN DER TRAVELPROFILES ///////////////
    // Suche alle Travel Profile des zu kopierenden Users
    Database db = await DatabaseHelper.instance.database;
    print(userProfileCollection);
    var copiedTravelProfiles = await db.rawQuery('''
    SELECT *
    FROM TravelProfile
    WHERE UserID = ?
    ''', [userProfileCollection[indexUserProfile].databaseID]);
    // Füge leeres Profil hinzu, modifiziere es dann im Anschluss gleich,
    // sodass es die kopierten Werte enthält
    for (int i = 0; i < copiedTravelProfiles.length; i++) {
      var row = copiedTravelProfiles[i];
      Provider.of<TravelProfileCollection>(context, listen: false)
          .addEmptyTravelProfile(
              name: row["NameTrav"],
              userID: userProfileCollection.last.databaseID);
      Provider.of<TravelProfileCollection>(context, listen: false)
          .modifyTravelProfile(
        profileIndex: i,
        maxDetour: row["MaxDetour"],
        minDurationAutomSegment: row["MinSegment"].toDouble(),
        indexTriangle: row["IndexTriangle"],
        userID: userProfileCollection.last.databaseID,
      );
    }
    /////////////////////////////////////////////////////////////
  }

  // Setze das ausgewählte Nutzerprofil
  void selectUserProfile({@required int userIndex}) async {
    Database db = await DatabaseHelper.instance.database;
    // Rücksetzen aller Selected auf 0
    db.rawUpdate('UPDATE User SET Selected = ?', [0]);
    // Setze das Selected in der DB, anhand des databaseID in den Objekten
    db.rawUpdate('UPDATE User SET Selected = ? WHERE ID = ?',
        [1, userProfileCollection[userIndex].databaseID]);
    // Lokales setzen des Profile Index
    selectedUserProfileIndex = userIndex;
    // Setze Reiseprofile
    Provider.of<TravelProfileCollection>(context, listen: false)
        .setTravelProfiles();
    // Setze die Adressen und Verbindungen
    Provider.of<AddressCollection>(context, listen: false).setAddresses();
    Provider.of<RoadConnections>(context, listen: false).setRoadConnections();
    notifyListeners();
  }

  // Ändern eines Profils
  void modifyUserProfile(
      {String name, String email, @required userProfileIndex}) async {
    // lokal ändern
    print("MODIFY USER");
    userProfileCollection[userProfileIndex].name = name;
    userProfileCollection[userProfileIndex].email = email;
    // in der Datenbank ändern
    Database db = await DatabaseHelper.instance.database;
    db.rawUpdate('''
    UPDATE User 
    SET Name = ?, Email = ?
    WHERE ID = ?
    ''', [name, email, userProfileCollection[userProfileIndex].databaseID]);
    notifyListeners();
  }
}

class UserProfileData {
  String name;
  String email;
  int databaseID;
  List<String> addressFavorite = List<String>();
  List<String> addressLast = List<String>();
  List<String> roadConnectionFavorite = List<String>();
  List<String> roadConnectionLast = List<String>();

  UserProfileData({
    this.databaseID,
    this.name,
    this.email,
  });
}
