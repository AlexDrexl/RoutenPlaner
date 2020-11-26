import 'package:flutter/material.dart';
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
    if (selectedUserProfileIndex == indexUserProfile) {
      Database db = await DatabaseHelper.instance.database;
      db.rawUpdate('UPDATE User SET Selected = ? WHERE ID = ?',
          [1, userProfileCollection[0].databaseID]);
      selectedUserProfileIndex = 0;
    }

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
  void addProfile({@required String name}) async {
    // In Datenbank user hinzufügen
    await DatabaseHelper.instance.addUser(
      name: name,
      email: "bsp@mail.com",
    );
    // UserID aus Datenbank holen
    Database db = await DatabaseHelper.instance.database;
    var dbID = await db.rawQuery('SELECT ID FROM User WHERE Name = ?', [name]);
    print('dbID : ${dbID[0].values.toList()[0]}');
    // Lokal in das Objekt
    userProfileCollection.add(
      UserProfileData(
        databaseID: dbID[0].values.toList()[0],
        name: name,
        email: "",
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
    // Rufe die init Funktion der travelprofile Klasse auf, um
    // dort die Travelprofile zu setzen
    int databaseUserID =
        userProfileCollection[selectedUserProfileIndex].databaseID;
    Provider.of<TravelProfileCollection>(context, listen: false)
        .setTravelProfiles();
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
