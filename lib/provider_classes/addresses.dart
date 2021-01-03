import 'package:flutter/material.dart';
import 'package:routenplaner/database/database_helper.dart';
import 'package:sqflite/sqflite.dart';

class AddressCollection with ChangeNotifier {
  // Address COllection hat zwei zentrale Attribute,
  // eine liste an letzten Adressen und eine Liste an Favorisierten Adressen
  List<String> favoriteAddress = List<String>();
  List<String> lastAddress = List<String>();

  // Beim Öffnen die Adressen initialisieren, hier schon im Kosnturktor
  // evtl noch ändern
  AddressCollection() {
    setAddresses();
  }

  //init Funktion, holt alle Adressen aus der Datenbank, basierend auf der
  // UserID
  Future<bool> setAddresses() async {
    print("SET ADDRESSES");

    // Lösche bisherige Einträge, um Verdopplung zu vermeiden
    favoriteAddress.clear();
    lastAddress.clear();
    // Suche zunächst die Favoriten Adressen, basierend wie oft aufgerufen,
    // Datum egal
    Database db = await DatabaseHelper.instance.database;
    var favAdresses = await db.rawQuery('''
    SELECT AddressName
    FROM Address LEFT JOIN User 
    ON Address.UserID = User.ID
    WHERE User.Selected = ?
    ORDER BY AddressCalls DESC
    LIMIT 3
    ''', [1]);

    // Suche letzte Adresse, wird nach dem AufrufDatum sortiert
    var lastAddresses = await db.rawQuery('''
    SELECT AddressName
    FROM Address LEFT JOIN User
    ON Address.UserID = User.ID
    WHERE User.Selected = ?
    ORDER BY Address.Date DESC
    LIMIT 3
    ''', [1]);
    // Setze in lokale Variablen, in einer schleife, da eigentlich immer gleich lang
    for (int i = 0; i < lastAddresses.length; i++) {
      favoriteAddress.add(favAdresses[i]["AddressName"]);
      lastAddress.add(lastAddresses[i]["AddressName"]);
    }
    notifyListeners();
    return true;
  }

  // Falls die Adresse noch nicht gespeichert, füge diese hinzu
  Future<bool> addAddress(
      {@required String addressName, @required DateTime timeNow}) async {
    Database db = await DatabaseHelper.instance.database;
    int selectedUserID = await DatabaseHelper.instance.getCurrentUserID();
    print("USER ID IST: $selectedUserID");
    if (selectedUserID == null) return false;
    var updatedAddresses = await db.rawUpdate('''
    UPDATE Address
    SET AddressCalls = AddressCalls + 1, Date = '${timeNow.toString()}'
    WHERE UserID = ? AND AddressName = ?
    ''', [selectedUserID, addressName]);
    // Falls updatedAddresses = 0, Eintrag noch nicht vorhanden, füge hinzu
    if (updatedAddresses == 0) {
      DatabaseHelper.instance.addAddressRow(
        userID: selectedUserID,
        addressName: addressName,
        addressCalls: 1,
        timeNow: timeNow,
      );
    }
    print("ADDRESS ADDED");
    setAddresses();
    return true;
  }

  // Lösche alle Adressen, basierend auf der UserID
  void deleteAllAddresses({@required int userID}) async {
    Database db = await DatabaseHelper.instance.database;
    db.rawDelete('''
    DELETE FROM Address
    WHERE UserID = ?
    ''', [userID]);
    setAddresses();
  }
}
