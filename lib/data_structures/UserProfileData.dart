// Klasse/Struct für die Daten der Nutzerprofile
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
