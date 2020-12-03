import 'package:flutter/material.dart';
import 'package:routenplaner/provider_classes/travel_profiles_collection.dart';
import 'package:provider/provider.dart';

class RouteDetails with ChangeNotifier {
  // Alle benötigten RoutenEingaben
  String startingLocation;
  String destinationLocation;
  TravelProfileData selectedTravelProfile = TravelProfileData();
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
