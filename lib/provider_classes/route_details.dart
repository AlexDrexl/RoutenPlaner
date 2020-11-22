import 'package:flutter/material.dart';

class RouteDetails with ChangeNotifier {
  // Alle benötigten RoutenEingaben
  String startingLocation;
  String destinationLocation;
  String routeProfile;
  DateTime startTime = DateTime(0, 0, 0, 0, 0, 0);
  DateTime startDate = DateTime(0);
  List<String> stopovers = List<String>();
  Map<DateTime, DateTime> desiredAutomSections = Map<DateTime, DateTime>();

  // Methoden
  void refresh() {
    print("refresh");
    notifyListeners();
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
