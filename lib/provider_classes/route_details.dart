import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:routenplaner/data/custom_colors.dart';

class RouteDetails with ChangeNotifier {
  // Alle benötigten RoutenEingaben
  String startingLocation;
  String destinationLocation;
  // TravelProfileData selectedTravelProfile = TravelProfileData();
  DateTime startDateTime;
  LatLng geoCoordStart;
  LatLng geoCoordDestination;
  bool startLocValid = true;
  bool destinationLocValid = true;

  // Paar variablen für Home mit der Eingabe von Ziel und Start
  String hintTextStart = "Start";
  Color hintColorStart = myDarkGrey;
  String hintTextDestination = "Ziel";
  Color hintColorDestination = myDarkGrey;

  // Konstruktor zum setzen der Startzeit
  RouteDetails() {
    startDateTime = DateTime.now();
    startDateTime = DateTime(startDateTime.year, startDateTime.month,
        startDateTime.day, startDateTime.hour, startDateTime.minute, 0, 0);
  }

  // reset aller Eingaben
  void resetRouteDetails() {
    hintTextStart = "Start";
    hintColorStart = myDarkGrey;
    hintTextDestination = "Ziel";
    hintColorDestination = myDarkGrey;
    startLocValid = true;
    destinationLocValid = true;
    startingLocation = "";
    destinationLocation = "";
  }

  // setze den Start:
  void setStart(String start) {
    hintTextStart = start;
    hintColorStart = myDarkGrey;
    startingLocation = start;
    notifyListeners();
  }

  // Setze das Ziel
  void setDestination(String destination) {
    hintTextDestination = destination;
    hintColorDestination = myDarkGrey;
    destinationLocation = destination;
    notifyListeners();
  }

  void refresh() {
    print("refresh");
    notifyListeners();
  }

  bool validInputs() {
    startLocValid = (startingLocation != null && startingLocation != "");
    destinationLocValid =
        (destinationLocation != null && destinationLocation != "");
    startLocValid && destinationLocValid
        ? print("INPUT VALID")
        : print("INPUT INVALID");
    // Setze die hint Texte und farben
    if (!startLocValid) {
      hintTextStart = "Eingabe erfordert";
      hintColorStart = Colors.red;
    } else {
      hintColorStart = myDarkGrey;
    }
    if (!destinationLocValid) {
      hintTextDestination = "Eingabe erfordert";
      hintColorDestination = Colors.red;
    } else {
      hintColorDestination = myDarkGrey;
    }

    notifyListeners();
    return startLocValid && destinationLocValid ? true : false;
  }

  // Formatierung des Datums
  String formatedDate() {
    return "${startDateTime.day}.${startDateTime.month}.${startDateTime.year}";
  }

  // Ausgabe des Wochentags
  String weekDay() {
    List<String> weekDays = [
      "Montag",
      "Dienstag",
      "Mittwoch",
      "Donnerstg",
      "Freitag",
      "Samstag",
      "Sonntag"
    ];
    return weekDays[(startDateTime.weekday) - 1];
  }

  // Setze die Start minuten und stunden
  void setStartTime({int min, int hour}) {
    // kopieren des bisherigen stands, geht nicht anders
    var localDateTime = startDateTime;
    startDateTime = DateTime(localDateTime.year, localDateTime.month,
        localDateTime.day, hour, min, 0, 0);
  }

  void setStartDate(int year, int month, int day) {
    var localDateTime = startDateTime;
    startDateTime =
        DateTime(year, month, day, localDateTime.hour, localDateTime.minute);
  }

  String getHintString({@required bool start}) {
    // Für start
    if (start) {
      if (startingLocation != null && startingLocation != "") {
        return startingLocation;
      } else {
        return "Eingabe erfordert";
      }
    }
    if (!start) {
      if (destinationLocation != null && destinationLocation != "") {
        return destinationLocation;
      } else {
        return "Eingabe erfordert";
      }
    }
    return "ERROR";
  }
}
