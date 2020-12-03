import 'package:flutter/material.dart';

class RouteDetails with ChangeNotifier {
  // Alle benötigten RoutenEingaben
  String startingLocation;
  String destinationLocation;
  String routeProfile;
  TimeOfDay startTime = TimeOfDay.now();
  DateTime startDate = DateTime.now();
  List<String> stopovers = List<String>();
  Map<DateTime, DateTime> desiredAutomSections = Map<DateTime, DateTime>();
  bool startLocValid = true;
  bool destinationLocValid = true;

  // Methoden
  void refresh() {
    print("refresh");
    notifyListeners();
  }

  bool validInputs() {
    startLocValid = (startingLocation != null && startingLocation != "");
    destinationLocValid =
        (destinationLocation != null && destinationLocation != "");
    notifyListeners();
    return startLocValid && destinationLocValid ? true : false;
  }

  // Formatierung der Zeit
  String formatedTime() {
    return "${startTime.hour}:${startTime.minute} Uhr";
  }

  // Formatierung des Datums
  String formatedDate() {
    return "${startDate.day}.${startDate.month}.${startDate.year}";
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
    return weekDays[(startDate.weekday) - 1];
  }
}
