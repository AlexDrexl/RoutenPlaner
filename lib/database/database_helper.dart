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
    // print("DATABASE PATH: $path");
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
            Name TEXT,
            Email TEXT,
            Selected INT
          )
          ''');
    await db.execute('''
      CREATE TABLE $addressTable (
            ID INTEGER PRIMARY KEY,
            UserID INTEGER,
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
            UserID INTEGER,
            NameTrav TEXT,
            MaxDetour INTEGER,
            MinSegment INTEGER,
            XPosTriangle INTEGER, 
            YPosTriangle INTEGER,
            WidthTriangle INTEGER,
            HeightTriangle INTEGER
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
  Future<int> addTravelProfile(
      {int userID,
      int maxDetour,
      int minSegment,
      double xPosTriangle,
      double yPosTriangle,
      String name,
      @required double widthTriangle,
      @required double heightTriangle}) async {
    var row = {
      "NameTrav": name,
      "UserID": userID,
      "MaxDetour": maxDetour,
      "MinSegment": minSegment,
      "XPosTriangle": xPosTriangle,
      "YPosTriangle": yPosTriangle,
      "WidthTriangle": widthTriangle,
      "HeightTriangle": heightTriangle,
    };
    Database db = await instance.database;
    return await db.insert(travelProfileTable, row);
  }

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
}
