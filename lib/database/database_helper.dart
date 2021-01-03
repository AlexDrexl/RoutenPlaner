import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

// Path, in der die Datenbank gespeichert wird:
// /data/user/0/com.example.routenplaner/app_flutter/RoutePlanerDatabase.db

class DatabaseHelper {
  static final _databaseName = "RoutePlanerDatabase.db";
  static final _databaseVersion = 1;

  // Tabellennamen
  static final userTable = 'User';
  static final addressTable = 'Address';
  static final roadConnectionTable = 'RoadConnection';
  static final travelProfileTable = 'TravelProfile';

  // Private Constructor -> nur eine Objekt dieser Klasse
  DatabaseHelper._privateConstructor();

  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  // Getter der Database, wird erstellt, falls diese nicht existiert
  static Database _database;
  Future<Database> get database async {
    if (_database != null) return _database;
    // lazily instantiate the db the first time it is accessed
    _database = await _initDatabase();
    return _database;
  }

  // Erstelle eine Datenbank, falls diese nicht exisitiert und öffnet diese
  _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);
    print("DATABASE PATH: $path");
    // Öffnen der Datenbank
    return await openDatabase(path,
        version: _databaseVersion, onCreate: _onCreate);
  }

  // Instantiieren der Datenbank
  // Jede tabelle verfügt über die Spalte userID, anhand dieser kann
  // in jeder Tabelle jede zweile mit einem User in verbindung gebracht werden
  Future _onCreate(Database db, int version) async {
    // Table für die Nutzerprofile
    await db.execute('''
          CREATE TABLE $userTable (
            ID INTEGER PRIMARY KEY,
            Name TEXT NOT NULL,
            Email TEXT NOT NULL,
            Selected INT NOT NULL
          )
          ''');
    await db.execute('''
      CREATE TABLE $addressTable (
            ID INTEGER PRIMARY KEY,
            UserID INTEGER NOT NULL,
            AddressName TEXT,
            AddressCalls INTEGER,
            Date DATETIME
          )
          ''');
    await db.execute('''
          CREATE TABLE $roadConnectionTable (
            ID INTEGER PRIMARY KEY,
            UserID INTEGER,
            StartLocation TEXT,
            DestinationLocation TEXT, 
            ConnectionCalls INTEGER,
            Date DATETIME
          )
          ''');
    await db.execute('''
          CREATE TABLE $travelProfileTable (
            ID INTEGER PRIMARY KEY,
            NameTrav TEXT,
            UserID INTEGER,
            MaxAutom INTEGER ,
            MinTravel INTEGER,
            ADMD INTEGER,
            MaxDetour INTEGER,
            MinSegment INTEGER,
            IndexTriangle INTEGER
          )
          ''');
  }

  // Helper Methoden für das hinzufügen einer Zeile
  Future<int> getCurrentUserID() async {
    var db = await DatabaseHelper.instance.database;
    var table =
        await db.rawQuery('SELECT ID FROM User WHERE Selected = ?', [1]);
    if (table == null || table.length == 0) {
      return null;
    } else {
      return table[0].values.toList()[0];
    }
  }

  // User Tabelle
  Future<int> addUser({String name, String email}) async {
    var row = {
      "Name": name,
      "Email": email,
      "Selected": 0,
    };
    Database db = await instance.database;
    return await db.insert(userTable, row);
  }

  // Adressen Tabelle
  Future<int> addAddressRow({
    int userID,
    String addressName,
    int addressCalls,
    DateTime timeNow,
  }) async {
    var row = {
      "UserID": userID,
      "AddressName": addressName,
      "AddressCalls": addressCalls,
      "Date": timeNow.toString(),
    };
    Database db = await instance.database;
    return await db.insert(addressTable, row);
  }

  // Connection Tabelle
  Future<int> addConnectionRow({
    int userID,
    String startLocation,
    String destinationLocation,
    int connectionCalls,
    DateTime timeNow,
  }) async {
    var row = {
      "UserID": userID,
      "StartLocation": startLocation,
      "DestinationLocation": destinationLocation,
      "ConnectionCalls": connectionCalls,
      "Date": timeNow.toString(),
    };
    Database db = await instance.database;
    return await db.insert(roadConnectionTable, row);
  }

  // Travel Profile
  Future<int> addTravelProfile({
    int userID,
    int maxAutom,
    int minTravel,
    int admd,
    int maxDetour,
    int minSegment,
    int indexTriangle,
    String name,
  }) async {
    var row = {
      "NameTrav": name,
      "UserID": userID,
      "MaxAutom": maxAutom,
      "MinTravel": minTravel,
      "ADMD": admd,
      "MaxDetour": maxDetour,
      "MinSegment": minSegment,
      "IndexTriangle": indexTriangle,
    };
    Database db = await instance.database;
    return await db.insert(travelProfileTable, row);
  }

  // TODO: Evtl alle Delete Funktionen auch hier rein schreiben
  // weitere Funktionen
  // Gebe den gesamten Table als Liste von Maps aus
  // Jede Row ist dabei eine map mit "Zelle1" : "Wert1"
  //                                 "Zelle2" : "Wert2" ...
  Future<List<Map<String, dynamic>>> queryAllRows(String tableName) async {
    Database db = await instance.database;
    return await db.query(tableName);
  }

  // Lösche einen Eintrag, identifiziert durch UserID in einer Tabelle
  Future<void> deleteUser({@required int userID}) async {
    Database db = await instance.database;
    // Lösche eintrag in Tabelle User
    db.rawDelete('DELETE FROM User WHERE ID = ?', [userID]);
  }

  // Alle TabellenInhalte Löschen
  Future<void> deleteAllTables() async {
    Database db = await instance.database;
    db.delete("User");
    db.delete("Address");
    db.delete("RoadConnection");
    db.delete("TravelProfile");
  }
/*

  // Helper methods
  // Identifikation der Zeilen mit der userID, diese bei der Intantiierung der DB
  // in flutter merken
  // Table Name benötigt, damit man weis, in welcher Tabelle die ROW eingefügt
  // werden soll
  // Setzte die Werte in einer Zeile, Angabe mit einer Map
  // "columnName1" : "value1",
  // "columnName2" : "value2",
  // gibt Zeilennummer zurück
  Future<int> insert({Map<String, dynamic> row, String table}) async {
    Database db = await instance.database;
    return await db.insert(table, row);
  }

  // Gibt den gesamten Table zurück
  // in einer Liste, in der die Reihen wie bei insert dargestellt werden
  // columnName1 : value1
  // Also eine Liste aus Maps
  Future<List<Map<String, dynamic>>> queryAllRows({String tableName}) async {
    Database db = await instance.database;
    return await db.query(tableName);
  }

  // Gibt die Reihenanzahl zurück
  Future<int> queryRowCount({String tableName}) async {
    Database db = await instance.database;
    return Sqflite.firstIntValue(
        await db.rawQuery('SELECT COUNT(*) FROM $tableName'));
  }

  // We are assuming here that the id column in the map is set. The other
  // column values will be used to update the row.
  // Updated einer Reihe, dafür ist ein eindeutiger Bezeichner nötig (userID)
  /*
  Diese Funktion speziell für jeweilige Tabellen erstellen
  Future<int> update({Map<String, dynamic> row, int myUserID}) async {
    Database db = await instance.database;
    return await db
        .update(userTable, row, where: '$userID = ?', whereArgs: [myUserID]);
  }
  */
  // Alle zeilen mit der userID werden gelöscht. ACHTUNG:
  // in allen Tabellen, ausser der user tabelle gibt es mehrere Zeilen mit der
  // selben userID
  Future<int> delete({String tableName, int myUserID}) async {
    Database db = await instance.database;
    return await db
        .delete(tableName, where: '$userID = ?', whereArgs: [myUserID]);
  }
  */
}

// Ein paar raw SQL Commands
// Sucht ein Attribut/Spalte, das gewisse Bedingungen erfüllt und in Tabname ist
// SELECT Attribut FROM Tabname WHERE Bedingung;
// Bsp: SELECT Name, Schwere FROM Ereignisse ( WHERE Schwere =‚5' );

// Löscht die Zeile mit CustomerName AlfredFutterkiste aus Customers
// DELETE FROM Customers WHERE CustomerName='Alfreds Futterkiste';

//  int id2 = await txn.rawInsert(
//      'INSERT INTO Test(name, value, num) VALUES(?, ?, ?)',
//      ['another name', 12345678, 3.1416]);
