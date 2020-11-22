import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';

// Ähnlich wie Final Routes hat auch TravelProfileCollection mehrere
// Objekte der Klasse Travel Profile
class TravelProfileCollection with ChangeNotifier {
  List<TravelProfileData> travelProfileCollection = List<TravelProfileData>();

  // getter um Zugriff aus die Profile Liste zu bekommen
  //TravelProfileData getProfile(int index) => travelProfileCollection[index];

  // Beim erstellen eines neuen Profils wird zunächst nur der Name Abgefragt
  void addProfile(String name) {
    travelProfileCollection.add(
      // initialisieren der Daten, bisher nur name bekannt, deshalb
      // rest auf 0 setzen um keine null error zu erhalten
      TravelProfileData(
          name: name,
          maxDetour: 0,
          minDurationAutomSegment: 0,
          maxAutomDuration: 0,
          minTravelTime: 0.0,
          minChanging: 0.0),
    );
    notifyListeners();
  }

  void deleteProfile(int indexProfile) {
    travelProfileCollection.removeAt(indexProfile);
    notifyListeners();
  }

  // Hardcoden von einigen Profilen, damit man diese für Tests nutzen kann
  //  Nachher noch alle benötigten Daten aus der Datenbank holen
  // Bei initalizierung alle Daten aus der Datenbank hier in die benötigten
  // Profile Objekte laden
  // Beim ersten Installieren der App in der Profile Klasse die Startwerte eingeben
  TravelProfileCollection() {
    print("TRAVEL PROFILES INSTATIATE");
    travelProfileCollection.add(TravelProfileData(
        name: "Arbeit",
        maxDetour: 10,
        minDurationAutomSegment: 10,
        maxAutomDuration: 0.5,
        minTravelTime: 0.3,
        minChanging: 0.4));
    travelProfileCollection.add(TravelProfileData(
        name: "Freizeit",
        maxDetour: 20,
        minDurationAutomSegment: 20,
        maxAutomDuration: 0.5,
        minTravelTime: 0.3,
        minChanging: 0.4));
    travelProfileCollection.add(TravelProfileData(
        name: "Kinder",
        maxDetour: 30,
        minDurationAutomSegment: 30,
        maxAutomDuration: 0.5,
        minTravelTime: 0.3,
        minChanging: 0.4));
  }
}

// Klasse, nur als Struct verwended
class TravelProfileData {
  String name = "";
  // Alle Zeiten in minuten, da man in der Datenbank keine komplexeren Datentypen
  // speichern kann
  int maxDetour = 0; // In %, Verglichen zur minimalen möglichen Route
  double minDurationAutomSegment = 0;
  // Anteilige Routeneinstellungen
  double maxAutomDuration = 0;
  double minTravelTime = 0;
  double minChanging = 0;

  // Index des DropTargets aus dem Dreieck, muss noch interpretiert werden
  int indexTriangle = 6; // Default auf 6, der Mitte, wenn neu instatiiert

  // Konstruktor um Daten zu füllen
  TravelProfileData({
    this.name,
    this.maxDetour,
    this.minDurationAutomSegment,
    this.maxAutomDuration,
    this.minTravelTime,
    this.minChanging,
  });
}
