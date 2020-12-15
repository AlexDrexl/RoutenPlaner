import 'dart:math';
import 'package:provider/provider.dart';
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

  // Mehrere Faktoren, um den Zufallsprozess einzuschränken
  double durationFactor = 0.2; // Varriert dauer um 0 bis 100%
  double automationFactorMin =
      0.6; // Varriert verhältnismäßige automFahrtdauer minimum
  double automationFactorMax =
      0.9; // Varriert verhältnismäßige automFahrtdauer maximum
  // MinMax Segmentlänge, kann mit bereits bestehenden Segmenten überlappen
  int minRandomSegment = 5; // Min länge eines Zufälligen Segments
  int maxRandomSegment = 15; // Max Länge eines zufälligen Segments

  // Benötigte Provider Dateien im Konstruktor mit einbinden
  FinalRoutes(
      RouteDetails routeDetails, DesiredAutomSections desiredAutomSections) {
    /////////// ERSTELLUNG DER ROUTEN OBJEKTE ////////////
    print("FINAL_ROUTES CALLED");
    /*
    routes.add(
      FinalRoute(
          routeLetter: 'A',
          automationDuration: Duration(minutes: 20),
          manualDuration: Duration(minutes: 20),
          automationSections: {
            [0, 10]: true,
            [10, 50]: false,
            [50, 55]: true,
            [55, 60]: false,
            [60, 70]: true,
          }),
    );
    routes.add(
      FinalRoute(
          routeLetter: 'B',
          automationDuration: Duration(minutes: 20),
          manualDuration: Duration(minutes: 20),
          automationSections: {
            [0, 10]: true,
            [10, 50]: false,
            [50, 55]: true,
            [55, 60]: false,
            [60, 70]: true,
          }),
    );
    routes.add(
      FinalRoute(
          routeLetter: 'C',
          automationDuration: Duration(minutes: 20),
          manualDuration: Duration(minutes: 20),
          automationSections: {
            [0, 10]: true,
            [10, 50]: false,
            [50, 55]: true,
            [55, 60]: false,
            [60, 70]: true,
          }),
    );
    */
  }

  // Aktualisierungsfunktion
  void refresh() => notifyListeners();

  // setze gewünschte Route
  void selectRoute(int index) {
    indexSelectedRoute = index;
    print("SELECT ROUTE ${routes[index].routeLetter}");
    notifyListeners();
  }

  String getFormattedTime(Duration duration) {
    int minutes = duration.inMinutes;
    int hours = (minutes / 60).floor();
    minutes = minutes - hours * 60;
    return "$hours:${minutes.toString().padLeft(2, '0')}";
  }

  // SIMULATION: Simuliere die automatisierten Segmente. Erstelle so mit einer
  // random Funktion FÜNF zufällige Routen und zeige diese an
  void computeFinalRoutes(BuildContext context) {
    print("START ROUTE COMPUTATION");
    routes.clear();
    // Random Number Generator
    var routeDetails = Provider.of<RouteDetails>(context, listen: false);
    var desiredAutomSections =
        Provider.of<DesiredAutomSections>(context, listen: false);
    var rng = Random();
    for (int i = 0; i < 5; i++) {
      // Für die Linie ist nur die Map Mit automatisierten Segmenten nötig
      // in overview automation graphic, bereits mit finalRoutes verbunden
      // Für die Anzeige an gesamt autom/manuel Fahrzeit sind autom und man duration nötig, berechne

      // Randomise die Dauer der Fahrt, und darauf basierend dann die Ankommzeit
      // Die Dauer der Fahrt darf nicht länger sein als die
      // Fehlt: XArrivalDateTime, automationDuration, manualDuration,
      // XautomSections, XautomMintes

      // Variiere die ReiseDauer, um 0% bis 20%
      Duration duration = getTravelTime() +
          Duration(
            minutes: rng.nextInt(
              (getTravelTime().inMinutes * durationFactor).toInt(),
            ),
          );

      // Berechne Ankunftszeit
      DateTime arrivalDateTime = DateTime.now().add(duration);

      // Setze zufällig die Automatisierten Minuten
      var automMinutes = getRandomAutomMinutes(
          desiredAutomSections.timedSections,
          desiredAutomSections.sections,
          routeDetails.startDateTime,
          duration);

      // Setze die Automation Sections in der Map
      var automSections = getAutomSections(automMinutes);

      // Bestimme die automatisierte Fahrzeit
      var automationDuration =
          Duration(minutes: automMinutes.fold(0, (p, c) => p + c));

      // Bestimme die Manuelle Fahrzeit
      var manualDuration =
          Duration(minutes: duration.inMinutes - automationDuration.inMinutes);

      // Füge fertiges Objekt der Liste hinzu
      routes.add(
        FinalRoute(
          startDateTime: routeDetails.startDateTime,
          arrivalDateTime: arrivalDateTime,
          duration: duration,
          automationDuration: automationDuration,
          manualDuration: manualDuration,
          startLocation: routeDetails.startingLocation,
          destinationLocation: routeDetails.destinationLocation,
          automMinutes: automMinutes,
          automationSections: automSections,
        ),
      );
    }
    // Am end noch die Routen Ranken, da auch die Buchstaben hinzufügen
    rankRoutes();
  }

  // Hier die Routen basierend auf Reiseprofil Ranken,
  void rankRoutes() {
    print("RANKING ROUTES");
    ////// SORTIERE DIE ROUTEN
    ///// SORTIERPROZESS

    // Füge den Routen absteigend einen Buchstaben zu
    int letter = "A".codeUnitAt(0);
    for (int i = 0; i < routes.length; i++) {
      routes[i].routeLetter = String.fromCharCode(letter);
      letter++;
    }
  }

  // Wandle das minuten Array in die vorgesehene Map um:
  // Zeitraum : true bzw [4, 20] : true
  Map<List<int>, bool> getAutomSections(List<int> automMinutes) {
    var automSections = Map<List<int>, bool>();
    for (int i = 0; i < automMinutes.length;) {
      int start = i;
      int end = i;
      // Start erkannt
      if (automMinutes[i] == 1) {
        while (i < automMinutes.length && automMinutes[i] != 0) {
          end++;
          i++;
        }
        // Füge zur Map hinzu
        automSections.putIfAbsent([start, (end - 1)], () => true);
        start = end;
      }
      // Keine Automatisierung erkannt
      if (automMinutes[i] == 0) {
        while (i < automMinutes.length && automMinutes[i] != 1) {
          end++;
          i++;
        }
        // Füge zur Map hinzu
        automSections.putIfAbsent([start, (end - 1)], () => false);
        start = end;
      }
    }
    return automSections;
  }

  // Setze die gewünschten Automatisierten Abschnitte, füge, falls weniger
  // als 70% automatisiert zufällig automatisierte Abschnitte hinzu
  // timedSections: start : dauer
  List<int> getRandomAutomMinutes(Map<DateTime, Duration> timedSections,
      List<Duration> sections, DateTime start, Duration duration) {
    // Random number generator
    Random rng = Random();
    // Array, jeder Eintrag eine minute, immer true oder false,
    // gesamtlänge = duration
    List<int> automMinutes = List<int>.filled(duration.inMinutes, 0);

    // Setze die terminierten Sektionen
    var startOfSegment = timedSections.keys.toList();
    var segmentDuration = timedSections.values.toList();
    for (int i = 0; i < timedSections.length; i++) {
      // Bei dieser Minute startet autom Fahren
      int startInMin = startOfSegment[i].difference(start).inMinutes;
      // Breche ab, sobald autom Section nach ankunft noch gefordert werden würde
      for (int j = startInMin;
          j < startInMin + segmentDuration[i].inMinutes &&
              j < automMinutes.length;
          j++) {
        if (j >= 0) {
          automMinutes[j] =
              1; // Überprüfe, ob ner Nutzer nicht einen Zeitpunkt zu früh anegegeben hat
        }
      }
    }

    // Versuche die Terminlosen Sections unter zu bringen, beschränke die maximale
    // automatisierte Dauer auf einen Wert zwischen 60% und 90%
    // Maximaler Anteil an automatisierten Segmenten
    double maxAutomTime = duration.inMinutes * automationFactorMin +
        rng.nextInt(
            (duration.inMinutes * (automationFactorMax - automationFactorMin))
                .round());
    // Fülle leere Stellen
    for (int i = 0; i < sections.length; i++) {
      // Suche die leeren Stellen raus, speichere diese
      List<List<int>> emptySections = List<List<int>>();
      for (int i = 0; i < automMinutes.length; i++) {
        if (automMinutes[i] == 0) {
          emptySections.add([i, 0]);
          for (i = i; i < automMinutes.length; i++) {
            if (automMinutes[i] != 0) {
              break;
            }
            emptySections.last[1]++;
          }
        }
      }
      // Versuche den i-ten Eintrag in einer der Freien Stellen zu passen
      // Setze das autom segment in die erstbeste position
      for (int j = 0; j < emptySections.length; j++) {
        if (sections[i].inMinutes <= emptySections[j][1]) {
          // Falls genügend Platz, füge zufällig in die Lücke ein
          int freeSpacesLeft = emptySections[j][1] - sections[i].inMinutes;
          int start = emptySections[j][0] +
              (freeSpacesLeft > 0 ? rng.nextInt(freeSpacesLeft) : 0);
          automMinutes.fillRange(start, start + sections[i].inMinutes, 1);
          break;
        }
      }
      // Überprüfe, ob die max Anteil an automatisierten Segmenten erreicht, breche ab, wenn ja
      if (automMinutes.fold(0, (p, c) => p + c) >= maxAutomTime) {
        break;
      }
    }

    // Setze nun, falls maxAutomTime noch nicht erreicht zufällig weitere automSegmente
    // segmente müssen eine gewisse Länge haben, damit nicht zu winzig
    while (true) {
      // breche ab, falls die maximale automationsdauer erreicht
      if (automMinutes.fold(0, (p, c) => p + c) >= maxAutomTime) {
        break;
      }
      int randLength =
          rng.nextInt(maxRandomSegment - minRandomSegment) + minRandomSegment;
      int randStart = rng.nextInt(automMinutes.length - randLength);
      automMinutes.fillRange(randStart, randStart + randLength, 1);
    }
    return automMinutes;
  }

  // TODO: HIER DIE ZEIT VON GOOGLE MAPS RETURNEN, SUMULIERE
  // EINFACH MIT FESTEM WERT
  Duration getTravelTime() {
    return Duration(hours: 1, minutes: 30);
  }
}

// Erzeuger für das RoutenObjekt, hält im Endeffekt nur die einzelnen Parameter
// Dadurch einfach zu übergeben
class FinalRoute {
  // Zeiten
  // TimeOfDay startTime = TimeOfDay(hour: 0, minute: 0);
  DateTime startDateTime = DateTime(0);
  // TimeOfDay arrivalTime = TimeOfDay(hour: 0, minute: 0);
  DateTime arrivalDateTime = DateTime(0);
  Duration duration = Duration();
  Duration automationDuration;
  Duration manualDuration;
  // TravelProfileData selectedTravelProfile;
  // Orte und Zwischenstopps
  String startLocation;
  String destinationLocation;
  // Weitere Routen Zugaben
  List<int> automMinutes = List<int>();
  String routeLetter;
  // TODO: LÖSCHE, Bisher nur zur Simulation
  Map<List<int>, bool> automationSections = ({
    [0, 10]: true,
    [10, 50]: false,
    [50, 55]: true,
    [55, 60]: false,
    [60, 70]: true,
  });

  // Constructor, named, um die Daten zu füllen
  FinalRoute({
    this.startDateTime,
    this.arrivalDateTime,
    this.duration,
    this.automationDuration,
    this.manualDuration,
    this.startLocation,
    this.destinationLocation,
    this.automMinutes,
    this.automationSections,
    this.routeLetter,
  });
}
