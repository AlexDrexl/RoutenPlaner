import 'package:flutter/material.dart';
import 'package:routenplaner/provider_classes/travel_profiles_collection.dart';
import 'package:provider/provider.dart';

class RouteDetails with ChangeNotifier {
  // Alle benötigten RoutenEingaben
  String startingLocation;
  String destinationLocation;
  TravelProfileData selectedTravelProfile = TravelProfileData();
  DateTime startDateTime = DateTime.now();
  List<String> stopovers = List<String>();
  Map<DateTime, DateTime> desiredAutomSections = Map<DateTime, DateTime>();
  bool startLocValid = true;
  bool destinationLocValid = true;

  // Methoden
  void refresh() {
    print("refresh");
    notifyListeners();
  }

  // setze das TravelProfil, basierend auf dessen Namen
  void setTravelProfile(
      {@required String travelProfileName, @required BuildContext context}) {
    var travelProfileCollection =
        Provider.of<TravelProfileCollection>(context, listen: false)
            .travelProfileCollection;
    for (int i = 0; i < travelProfileCollection.length; i++) {
      if (travelProfileCollection[i].name == travelProfileName) {
        selectedTravelProfile = travelProfileCollection[i];
        break;
      }
    }
    print("SELECT TRAVEL PROFILE");
    notifyListeners();
  }

  bool validInputs() {
    startLocValid = (startingLocation != null && startingLocation != "");
    destinationLocValid =
        (destinationLocation != null && destinationLocation != "");
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
        localDateTime.day, hour, min, 0);
  }

  void setStartDate(int year, int month, int day) {
    var localDateTime = startDateTime;
    startDateTime =
        DateTime(year, month, day, localDateTime.hour, localDateTime.minute);
  }
}
