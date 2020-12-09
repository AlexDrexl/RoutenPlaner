import 'package:flutter/material.dart';
import 'package:routenplaner/database/database_helper.dart';
import 'package:sqflite/sqflite.dart';

class RoadConnections with ChangeNotifier {
  List<String> favoriteConnections = List<String>();
  List<String> lastConnections = List<String>();

  RoadConnections() {
    setRoadConnections();
  }

  // Setze die Favoriten und letzten Ziele, müsste eigentlich nach jeder Änderung
  // aufgerufen werden
  void setRoadConnections() async {
    print("SET ROAD CONNECTIONS");
    favoriteConnections.clear();
    lastConnections.clear();
    Database db = await DatabaseHelper.instance.database;

    // NUR FÜRS TESTEN TODO: LÖSCHEN
    /*
    await db.rawDelete('''
    DELETE FROM RoadConnection
    WHERE UserID = ?
    ''', [1]);
    await DatabaseHelper.instance.addConnectionRow(
        userID: 1,
        startLocation: "S1",
        destinationLocation: "D1",
        connectionCalls: 1);
    await DatabaseHelper.instance.addConnectionRow(
        userID: 1,
        startLocation: "S2",
        destinationLocation: "D2",
        connectionCalls: 2);
    await DatabaseHelper.instance.addConnectionRow(
        userID: 1,
        startLocation: "S3",
        destinationLocation: "D3",
        connectionCalls: 3);
    await DatabaseHelper.instance.addConnectionRow(
        userID: 1,
        startLocation: "S4",
        destinationLocation: "D4",
        connectionCalls: 1);
        */
    // NUR FÜRS TESTEN

    // Suche zunächst die Verbindungen, die am meisten verwendet wurden
    var favCon = await db.rawQuery('''
    SELECT StartLocation, DestinationLocation
    FROM RoadConnection LEFT JOIN User
    ON RoadConnection.UserID = User.ID
    WHERE User.Selected = ?
    ORDER BY ConnectionCalls DESC
    LIMIT 3
    ''', [1]);
    // Suche nach den Verbindungen, die als letztes verwendet wurden, also
    // die höchste ID haben
    var lastCon = await db.rawQuery('''
    SELECT StartLocation, DestinationLocation
    FROM RoadConnection LEFT JOIN User 
    ON RoadConnection.UserID = User.ID
    WHERE User.Selected = ?
    ORDER BY RoadConnection.ID DESC
    LIMIT 3
    ''', [1]);
    // Schreibe in die Localen Variablen, als formatierter String
    // Theoretisch immer gleich lang
    for (int i = 0; i < lastCon.length; i++) {
      favoriteConnections.add(
          "${favCon[i]["StartLocation"]} > ${favCon[i]["DestinationLocation"]}");
      lastConnections.add(
          "${lastCon[i]["StartLocation"]} > ${lastCon[i]["DestinationLocation"]}");
    }
    notifyListeners();
  }

  // Falls die Adresse nicht gespeichert, füge hinzu, erhöhe sonst nur den Aufrufwert um 1
  void addRoadConnection(
      {String start, String destination, @required DateTime timeNow}) async {
    Database db = await DatabaseHelper.instance.database;
    int selectedUserID = await DatabaseHelper.instance.getCurrentUserID();
    var updatedRoadConnections = await db.rawUpdate('''
    UPDATE RoadConnection 
    SET ConnectionCalls = ConnectionCalls + 1, Date = '${timeNow.toString()}'
    WHERE UserID = ? AND StartLocation = ? AND DestinationLocation = ?
    ''', [selectedUserID, start, destination]);
    // Falls dieser Eintrag noch nicht vorhanden, füge hinzu
    if (updatedRoadConnections == 0) {
      DatabaseHelper.instance.addConnectionRow(
        userID: selectedUserID,
        startLocation: start,
        destinationLocation: destination,
        connectionCalls: 1,
        timeNow: timeNow,
      );
    }
  }
}
/*
Database db = await DatabaseHelper.instance.database;
    int selectedUserID = await DatabaseHelper.instance.getCurrentUserID();
    var updatedAddresses = await db.rawUpdate('''
    UPDATE Address
    SET AddressCalls = AddressCalls + 1
    WHERE UserID = ? AND AddressName = ?
    ''', [selectedUserID, addressName]);
    // Falls updatedAddresses = 0, Eintrag noch nicht vorhanden, füge hinzu
    if (updatedAddresses == 0) {
      DatabaseHelper.instance.addAddressRow(
        userID: selectedUserID,
        addressName: addressName,
        addressCalls: 1,
      );
 */
