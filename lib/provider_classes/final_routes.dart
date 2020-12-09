import 'package:flutter/material.dart';
import 'package:routenplaner/provider_classes/travel_profiles_collection.dart';
import 'desired_Autom_Sections.dart';
import 'route_details.dart';

// Übergestellte Klasse, erhält alle daten aus den verschiedenen provider Klassen
// verwendet sie um finale Routen zu berechnen
// Hier auch die Nutzerprofile mit einbeziehen
// Routen werden nach Prio geordnet in einem Array gespeichert
// zudem gibt es das Attribut selected Route, das die manuell geänderte Route
// hält
class FinalRoutes with ChangeNotifier {
  // Liste mit den verfügbaren Routen
  List<FinalRoute> routes = List<FinalRoute>();
  int indexSelectedRoute = 0;
  // Benötigte Provider Dateien im Konstruktor mit einbinden
  FinalRoutes(
      RouteDetails routeDetails, DesiredAutomSections desiredAutomSections) {
    /////////// ERSTELLUNG DER ROUTEN OBJEKTE ////////////
    print("FINAL_ROUTES CALLED");
    routes.add(
      FinalRoute(
        routeLetter: 'A',
        automationDuration: DateTime(0, 0, 0, 0, 30),
        manualDuration: DateTime(0, 0, 0, 0, 20),
      ),
    );
    routes.add(
      FinalRoute(
        routeLetter: 'B',
        automationDuration: DateTime(0, 0, 0, 0, 30),
        manualDuration: DateTime(0, 0, 0, 0, 20),
      ),
    );
    routes.add(
      FinalRoute(
        routeLetter: 'C',
        automationDuration: DateTime(0, 0, 0, 0, 30),
        manualDuration: DateTime(0, 0, 0, 0, 20),
      ),
    );
  }

  // SIMULATION: Simuliere die automatisierten Segmente. Erstelle so mit einer
  // random Funktion FÜNF zufällige Routen und zeige diese an
  void computeFinalRoutes(
      RouteDetails routeDetails, DesiredAutomSections desiredAutomSections) {
    for (int i = 0; i < 5; i++) {
      // Erzeuge das Objekt, das der Liste hinzugefügt werden soll
      FinalRoute route = FinalRoute(
        // Fülle zunächst alle bereits bekannten Werte in ein FinalRoute Objekt
        routeLetter: String.fromCharCode("A".codeUnitAt(0) + i),
        startDate: routeDetails.startDate,
        startTime: routeDetails.startTime,
      );
    }
  }

  // TODO: HIER DIE ZEIT VON GOOGLE MAPS RETURNEN, SUMULIERE
  // EINFACH MIT FESTEM WERT
  int getTravelTime() {
    return 90;
  }

  // Aktualisierungsfunktion
  void refresh() => notifyListeners();
  // setze gewünschte Route
  void selectRoute(int index) {
    indexSelectedRoute = index;
    notifyListeners();
  }
}

// Erzeuger für das RoutenObjekt, hält im Endeffekt nur die einzelnen Parameter
// Dadurch einfach zu übergeben
class FinalRoute {
  // Zeiten
  TimeOfDay startTime = TimeOfDay(hour: 0, minute: 0);
  DateTime startDate = DateTime(0);
  TimeOfDay arrivalTime = TimeOfDay(hour: 0, minute: 0);
  DateTime arrivalDate = DateTime(0);
  DateTime duration = DateTime(0);
  DateTime automationDuration;
  DateTime manualDuration;
  TravelProfileData selectedTravelProfile;
  // Orte und Zwischenstopps
  String startLocation;
  String destinationLocation;
  List<String> stopovers;
  // Weitere Routen Zugaben
  Map<DateTime, DateTime> desiredAutomSections = Map<DateTime, DateTime>();
  String routeLetter;
  Map<List<int>, bool> automationSections = ({
    [0, 10]: true,
    [10, 50]: false,
    [50, 55]: true,
    [55, 60]: false,
    [60, 70]: true,
  });

  // Constructor, named, um die Daten zu füllen
  FinalRoute({
    this.startTime,
    this.startDate,
    this.arrivalDate,
    this.arrivalTime,
    this.duration,
    this.automationDuration,
    this.manualDuration,
    this.startLocation,
    this.destinationLocation,
    this.stopovers,
    this.desiredAutomSections,
    this.routeLetter,
  });
}
