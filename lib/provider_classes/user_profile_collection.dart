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
  void deleteProfile(
      {@required int indexUserProfile, @required BuildContext context}) async {
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

    // Lösche User, zugehörige Reiseprofile, Adressen/Verbindungen lokal
    userProfileCollection.removeAt(indexUserProfile);
    Provider.of<TravelProfileCollection>(context, listen: false)
        .travelProfileCollection
        .clear();
    Provider.of<TravelProfileCollection>(context, listen: false)
        .selectedTravelProfile = null;
    Provider.of<AddressCollection>(context, listen: false)
        .favoriteAddress
        .clear();
    Provider.of<AddressCollection>(context, listen: false).lastAddress.clear();
    Provider.of<RoadConnections>(context, listen: false)
        .favoriteConnections
        .clear();
    Provider.of<RoadConnections>(context, listen: false)
        .lastConnections
        .clear();
    print("DELETE PROFILE");

    // Wenn ein Profil gelöscht wird, dessen Index kleiner ist als der Index
    // Des selected, verringert sich der Index des Selected um eins
    if (indexUserProfile < selectedUserProfileIndex) {
      selectUserProfile(userIndex: (selectedUserProfileIndex - 1));
    }
    notifyListeners();
  }

  // Füge Profil hinzu, lokal und in Datenbank
  Future<int> addProfile({@required String name, String email}) async {
    // In Datenbank user hinzufügen
    var newUserID = await DatabaseHelper.instance.addUser(
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
    return newUserID;
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
    var newUserID = await addProfile(
        name: copiedProfile.name + " - Kopie", email: copiedProfile.email);
    //////////////// KOPIEREN DER TRAVELPROFILES ///////////////
    // Suche alle Travel Profile des zu kopierenden Users
    Database db = await DatabaseHelper.instance.database;
    // Suche alle Reiseprofile raus uns speichere sie unter einem neuen Nutzer
    await db.rawInsert('''
    INSERT INTO TravelProfile (UserID, NameTrav, MaxDetour, MinSegment, IndexTriangle)
    SELECT ?, NameTrav, MaxDetour, MinSegment, IndexTriangle
    FROM TravelProfile
    WHERE UserID = ?
    ''', [newUserID, userProfileCollection[indexUserProfile].databaseID]);
    // Suche alle Adressen raus und speichere sie unter einem neuen Nutzer
    await db.rawInsert('''
    INSERT INTO Address (UserID, AddressName, AddressCalls, Date)
    SELECT ?, AddressName, AddressCalls, Date 
    FROM Address
    WHERE UserID = ?
    ''', [newUserID, userProfileCollection[indexUserProfile].databaseID]);
    // Suche alle Verbindungen raus, speichere sie unter einem neuen Nutzer
    await db.rawInsert('''
    INSERT INTO RoadConnection (UserID, StartLocation, DestinationLocation, ConnectionCalls, Date)
    SELECT ?, StartLocation, DestinationLocation, ConnectionCalls, Date
    FROM RoadConnection
    WHERE UserID = ?
    ''', [newUserID, userProfileCollection[indexUserProfile].databaseID]);
  }

  // Setze das ausgewählte Nutzerprofil
  void selectUserProfile({@required int userIndex}) async {
    print("SELECT USER PROFILE");
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
