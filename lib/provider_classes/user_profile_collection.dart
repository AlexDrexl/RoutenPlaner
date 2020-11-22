import 'package:flutter/material.dart';

// Nutzerprofile haben verschiedene TravelProfile hinterlegt
// ausserdem haben Verschiedene Favoriten
class UserProfileCollection with ChangeNotifier {
  int selectedUserProfileIndex = 0;
  List<UserProfileData> userProfileCollection = List<UserProfileData>();

  // Konstruktor, manuelles Einfügen von Profile, nachher noch aus
  // der Datenbank holen
  UserProfileCollection() {
    userProfileCollection.add(UserProfileData(name: "Alex"));
    userProfileCollection.add(UserProfileData(name: "Tobi"));
    userProfileCollection.add(UserProfileData(name: "Steffi"));
  }

  void deleteProfile({@required int indexUserProfile}) {
    userProfileCollection.removeAt(indexUserProfile);
    // Wenn aktive Profil gelöscht, setze aktives Profil wieder auf 0
    if (selectedUserProfileIndex == indexUserProfile) {
      selectedUserProfileIndex = 0;
    }
    notifyListeners();
  }

  void addProfile({@required String name}) {
    userProfileCollection.add(UserProfileData(name: name));
    notifyListeners();
  }

  void selectUserProfile({@required int userIndex}) {
    selectedUserProfileIndex = userIndex;
    notifyListeners();
  }
}

class UserProfileData {
  String name;
  List<String> addressFavorite = List<String>();
  List<String> addressLast = List<String>();
  List<String> roadConnectionFavorite = List<String>();
  List<String> roadConnectionLast = List<String>();

  UserProfileData({
    this.name,
  });
}
