import 'package:flutter/material.dart';
import 'package:routenplaner/database/database_helper.dart';
import 'package:sqflite/sqflite.dart';

class RoadConnections with ChangeNotifier {
  // 2D Array mit Start und Ziel
  List<List<String>> favoriteConnections = List<List<String>>();
  List<List<String>> lastConnections = List<List<String>>();

  RoadConnections() {
    setRoadConnections();
  }

  // Setze die Favoriten und letzten Ziele, müsste eigentlich nach jeder Änderung
  // aufgerufen werden
  Future<bool> setRoadConnections() async {
    print("SET ROAD CONNECTIONS");
    favoriteConnections.clear();
    lastConnections.clear();
    Database db = await DatabaseHelper.instance.database;
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
      favoriteConnections.add([
        "${favCon[i]["StartLocation"]}",
        "${favCon[i]["DestinationLocation"]}"
      ]);
      lastConnections.add([
        "${lastCon[i]["StartLocation"]}",
        "${lastCon[i]["DestinationLocation"]}"
      ]);
    }
    notifyListeners();
    return true;
  }

  // Falls die Adresse nicht gespeichert, füge hinzu, erhöhe sonst nur den Aufrufwert um 1
  Future<bool> addRoadConnection(
      {String start, String destination, @required DateTime timeNow}) async {
    Database db = await DatabaseHelper.instance.database;
    int selectedUserID = await DatabaseHelper.instance.getCurrentUserID();
    if (selectedUserID == null) return false;
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
    setRoadConnections();
    return true;
  }

  // Lösche die Einträge eines Users
  void deleteRoadConnections({@required int userID}) async {
    Database db = await DatabaseHelper.instance.database;
    db.rawDelete('''
    DELETE FROM RoadConnection
    WHERE UserID = ?
    ''', [userID]);
  }
}
