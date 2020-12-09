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
  // Idee: Speichere Start/Ziel Ort (insgesamt 50 oder so), gebe jederm Ort
  // das Attribut wie oft aufgerufen, basierend darauf dann die Favoriten
  // Angabe, bei Aufruf, erhöhe den Wert um 1
  // folgender befehl sucht top 3: select top 3 * from Test order by f1 desc
  void setAddresses() async {
    print("SET ADDRESSES");

    // NUR ZUM TESTEN TODO: LÖSCHEN
    /*
    Database db1 = await DatabaseHelper.instance.database;
    await db1.rawDelete('''
    DELETE FROM Address
    ''');
    DatabaseHelper.instance
        .addAddressRow(userID: 1, addressName: "A", addressCalls: 1);
    DatabaseHelper.instance
        .addAddressRow(userID: 1, addressName: "B", addressCalls: 1);
    DatabaseHelper.instance
        .addAddressRow(userID: 1, addressName: "C", addressCalls: 2);
    DatabaseHelper.instance
        .addAddressRow(userID: 1, addressName: "D", addressCalls: 2);
    print("SET ADDRESSES");
    */
    // NUR ZUM TESTEN

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
  }

  // Falls die Adresse noch nicht gespeichert, füge diese hinzu
  void addAddress(
      {@required String addressName, @required DateTime timeNow}) async {
    Database db = await DatabaseHelper.instance.database;
    int selectedUserID = await DatabaseHelper.instance.getCurrentUserID();
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
  }

  // Lösche alle Adressen, basierend auf der UserID
  void deleteAllAddresses({@required int userID}) async {
    Database db = await DatabaseHelper.instance.database;
    db.rawDelete('''
    DELETE FROM Address
    WHERE UserID = ?
    ''', [userID]);
  }
}
