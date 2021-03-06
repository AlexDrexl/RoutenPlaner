import 'dart:math';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:routenplaner/controller/travel_profiles_collection.dart';
import 'package:routenplaner/data_structures/TravelProfileData.dart';
import 'desired_Autom_Sections.dart';
import 'route_details.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'dart:math' show cos, sqrt, asin;
import 'package:dio/dio.dart';
import 'package:routenplaner/data_structures/RouteData.dart';

// Übergestellte Klasse, erhält alle Daten aus den verschiedenen Controller Klassen
// verwendet sie um finale Routen zu berechnen

class FinalRoutes with ChangeNotifier {
  // API KEY
  String apiKey = "AIzaSyC0DgP0BdEXEybFlEReSj_ghex8jTDOeWE";
  // Liste mit den verfügbaren Routen
  List<RouteData> routes = List<RouteData>();
  int indexSelectedRoute = 0;
  int routeQuantity = 5;

  // Mehrere Faktoren, um den Zufallsprozess einzuschränken
  double durationFactor = 0.2; // Varriert dauer um +0 bis +20%
  double automationFactorMin =
      0.6; // Varriert verhältnismäßige automFahrtdauer minimum
  double automationFactorMax =
      0.9; // Varriert verhältnismäßige automFahrtdauer maximum
  // MinMax Segmentlänge, kann mit bereits bestehenden Segmenten überlappen
  double minRandomSegment =
      0.05; // Min länge eines Segments abh. von Gesamtzeit
  double maxRandomSegment = 0.3; // Max länge eines Segments abh. von Gesamtzeit

  // Einzelne Faktoren für die Das Ranking.
  double segmentFactor = 0.5;
  double detourFactor = 0.5;
  double admdFactor = 1;
  double travelTimeFactor = 1;
  double maxAutomTimeFactor = 1;

  // Variablen für die Routenberechnung
  // Marker Map für Start und Ziel Marker
  Map<MarkerId, Marker> markers = {};
  // Map enhält die Polylines, die durch das Verbinden wzeier Punkte entstanden ist
  Map<PolylineId, Polyline> polylines = {};
  // Koordinaten, die man verbinden muss
  List<LatLng> polylineCoordinates = [];

  FinalRoutes() {
    print("FINAL_ROUTES CALLED");
  }

  // Route wechseln
  void selectRoute(int index) {
    indexSelectedRoute = index;
    print("SELECT ROUTE ${routes[index].routeLetter}");
    notifyListeners();
  }

  // SIMULATION: Simuliere die automatisierten Segmente
  Future<bool> computeFinalRoutes(BuildContext context) async {
    print("/////////////////START ROUTE COMPUTATION////////////////");
    routes.clear();
    // Random Number generator
    Random rng = Random();
    // Hole alle benötigten Provider Dateien:
    var routeDetails = Provider.of<RouteDetails>(context, listen: false);
    var desiredAutomSections =
        Provider.of<DesiredAutomSections>(context, listen: false);
    var travelProfile =
        Provider.of<TravelProfileCollection>(context, listen: false)
            .selectedTravelProfile;
    // Starte die Berechnung der Maps Daten
    await computePolylines(
        routeDetails.geoCoordStart, routeDetails.geoCoordDestination);

    // Berechne die theoretische Reisezeit, für alle Routen gleich
    Duration travelTime = await getTravelTime(polylineCoordinates,
        routeDetails.geoCoordStart, routeDetails.geoCoordDestination);

    for (int i = 0; i < routeQuantity; i++) {
      // Hole die Startzeit
      DateTime startDateTime = routeDetails.startDateTime;

      // Hole die Reisezeit und variiere sie dann
      Duration duration = Duration(
          minutes: (travelTime.inMinutes *
                  (1 + (rng.nextInt((100 * durationFactor).toInt()) / 100)))
              .toInt());

      // Berechne Ankunftszeit
      DateTime arrivalDateTime = startDateTime.add(duration);

      // Setze zufällig die Automatisierten Minuten
      var automMinutes = getRandomAutomMinutes(
          desiredAutomSections.timedSections,
          desiredAutomSections.sections,
          routeDetails.startDateTime,
          duration);

      // Setze die Automation Sections in der Map
      var automSections = getAutomSections(automMinutes);

      // Bestimme die gesamte automatisierte Fahrzeit
      int automDurMinutes = 0;
      for (int i = 0; i < automMinutes.length; i++) {
        if (automMinutes[i] > 0) automDurMinutes++;
      }
      var automationDuration = Duration(minutes: automDurMinutes);

      // Bestimme die gesamte manuelle Fahrzeit
      var manualDuration =
          Duration(minutes: duration.inMinutes - automationDuration.inMinutes);

      // Füge Objekt der Liste hinzu
      routes.add(
        RouteData(
          startDateTime: startDateTime,
          arrivalDateTime: arrivalDateTime,
          duration: duration,
          automationDuration: automationDuration,
          manualDuration: manualDuration,
          startLocation: routeDetails.startingLocation,
          destinationLocation: routeDetails.destinationLocation,
          geoCoordStart: routeDetails.geoCoordStart,
          geoCoordDestination: routeDetails.geoCoordDestination,
          automMinutes: automMinutes,
          automationSections: automSections,
        ),
      );
    }
    // Am end noch die Routen Ranken, da auch die Buchstaben hinzufügen
    await rankRoutes(travelProfile, travelTime);
    // Setze die ausgewählte Route auf den ersten Wert, wichtig bei Neustart
    // der Routenberechnung
    indexSelectedRoute = 0;
    print("ROUTE COMPUTATION FINISHED");
    return true;
  }

  // Hier die Routen basierend auf Reiseprofil Ranken,
  Future<bool> rankRoutes(
      TravelProfileData travelProfile, Duration theoreticalDuration) async {
    // SORTIERE DIE ROUTEN
    // Stelle eine Punktebewertung auf. Jede Route wird dann anhand der Kriterien bewertet
    // Sortiere dann nach Punketzahl
    // Ranking basiert auf Reiseprofil. Wenn dieses nicht vorhanden ist, dann fällt das Ranking aus
    if (travelProfile != null) {
      print("RANKING ROUTES");
      List<double> points = List<double>.filled(routes.length, 0);

      // Überprüfe, ob die minimale Segmentlänge bei ALLEN autom Segmenten erreicht wurde
      // Gebe Prozentualwert an, wie viele von allen segmenten erfüllen die Anforderungen?
      int minSegmentDuration = travelProfile.minDurationAutomSegment;
      for (int i = 0; i < routes.length; i++) {
        // iteration zwischen routen
        var automDriving = routes[i].automationSections.values.toList();
        var sections = routes[i].automationSections.keys.toList();
        int totalSectionCount = 0;
        int validSectionCount = 0;
        for (int j = 0; j < routes[i].automationSections.length; j++) {
          if (automDriving[j] > 0) {
            // Automatisiertes segment erkannt
            totalSectionCount++;
            if (sections[j][1] - sections[j][0] >= minSegmentDuration) {
              // Valides Segment erkannt
              validSectionCount++;
            }
          }
        }
        // Füge die prozentuale Bewertung in die punkteListe mit ein
        if (totalSectionCount != 0) {
          points[i] += (validSectionCount / totalSectionCount) * segmentFactor;
        }
      }

      // Bewertung der maximalen abweichung von der theoretischen Dauer
      // Berechne prozentuale Abweichung der tatsächlichen Zeit von der therotischen Zeit
      for (int i = 0; i < routes.length; i++) {
        // SollReisezeit
        double targetDuration = (1 + (travelProfile.maxDetour / 100)) *
            theoreticalDuration.inMinutes.toDouble(); // in minuten
        // Ist Reisezeit
        double actualDuration = routes[i].duration.inMinutes.toDouble();
        // Abweichung soll-ist/soll
        double deviation = (targetDuration - actualDuration) / targetDuration;
        points[i] += (1 + deviation) * detourFactor;
      }

      ///////////
      // Dreieck Daten verwerten
      var maxAutomTime = travelProfile.factorMaxAutom;
      var minTravelTime = travelProfile.factorMinTravTime;
      var minADMD = travelProfile.factorMinADMD;

      // Wenig Wechsel AD/MD.
      // 1/Anzahl der Wechsel.
      // Differenz zwischen 1/Anzahl Wechsel und dem Wert aud dem Reiseprofil
      // 1 - Differenz ist die Punktezahl, Da umso kleiner differenz, desto höher die Punktezahl
      List<int> admdAlternation = List<int>();
      // Alternierungen von den einzelnen Routen
      for (int i = 0; i < routes.length; i++) {
        admdAlternation.add(routes[i].automationSections.length - 1);
      }
      // Doppelte Alternierungen raus, damit es mehrere erste/zweite/dritte... Plätze gibt
      var admdAlternationNoDouble = admdAlternation.toSet().toList();
      // Sortiere aufsteigend
      admdAlternationNoDouble.sort();
      // Erstelle die Bewertungsliste mit [admdAlternation][Proz. Gewichtungsanteil]
      var rankedADMD = List<List<double>>();
      for (int i = 0; i < admdAlternationNoDouble.length; i++) {
        var admdAlt = admdAlternationNoDouble[i].toDouble();
        var ranking = 1 - (i / admdAlternationNoDouble.length);
        rankedADMD.add([admdAlt, ranking]);
      }
      // Vergleiche die bewertungen in Ranked mit den gewollten Bewertungen.
      for (int i = 0; i < admdAlternation.length; i++) {
        for (int j = 0; j < rankedADMD.length; j++) {
          if (admdAlternation[i] == rankedADMD[j][0]) {
            var importanceFactor = minADMD;
            points[i] += importanceFactor * rankedADMD[j][1] * admdFactor;
            break;
          }
        }
      }

      // Minimale Reisezeit. Ähnlich wie oben. Ranke die Routen nach ihrer Reisezeit
      // Verteile Prozentuale Bewertungen
      var durations = List<int>();
      // Reisezeiten der Routen, im minuten
      for (int i = 0; i < routes.length; i++) {
        durations.add(routes[i].duration.inMinutes);
      }
      // Eliminiere die doppelten, für die Bewertung
      var durationsNoDouble = durations.toSet().toList();
      durationsNoDouble.sort();
      // Erstelle die Ranking liste. mit [Dauer][Proz. Ranking anteil]
      var rankedDurations = List<List<double>>();
      for (int i = 0; i < durationsNoDouble.length; i++) {
        var duration = durationsNoDouble[i].toDouble();
        var ranking = 1 - (i / durationsNoDouble.length);
        rankedDurations.add([duration, ranking]);
      }
      // Vergleiche die bewertungen in Ranked mit den gewollten Bewertungen.
      for (int i = 0; i < durations.length; i++) {
        for (int j = 0; j < rankedDurations.length; j++) {
          if (durations[i] == rankedDurations[j][0]) {
            var importanceFactor = minTravelTime;
            points[i] +=
                importanceFactor * rankedDurations[j][1] * travelTimeFactor;
            break;
          }
        }
      }

      // Maximale autmationsdauer, Gleich wie oben
      // Angabe in Minuten
      var automationDurations = List<int>();
      // Hole die Automationszeiten
      for (int i = 0; i < routes.length; i++) {
        automationDurations.add(routes[i].automationDuration.inMinutes);
      }
      // Eliminiere die doppelten, für die Bewertung
      var automDurationsNoDouble = automationDurations.toSet().toList();
      automDurationsNoDouble.sort();
      // Erstelle die Ranking liste. mit [Dauer][Proz. Ranking anteil]
      var rankedautomDurations = List<List<double>>();
      for (int i = 0; i < automDurationsNoDouble.length; i++) {
        var duration = automDurationsNoDouble[i].toDouble();
        var ranking = ((i + 1) / automDurationsNoDouble.length);
        rankedautomDurations.add([duration, ranking]);
      }
      // Vergleiche die bewertungen in Ranked mit den gewollten Bewertungen.
      // Nehme hierfür wieder die absolute Differenz
      for (int i = 0; i < automationDurations.length; i++) {
        for (int j = 0; j < rankedautomDurations.length; j++) {
          if (automationDurations[i] == rankedautomDurations[j][0]) {
            points[i] += rankedautomDurations[j][1] * maxAutomTime;
            break;
          }
        }
      }
      // Einfacher Sortieralgorithmus. Punkte werden sortiert, parallel dazu die Routen
      for (int i = 0; i < points.length; i++) {
        for (int j = i; j < points.length; j++) {
          if (points[j] > points[i]) {
            var helperPoints = points[j];
            var helperRoute = routes[j];
            points[j] = points[i];
            routes[j] = routes[i];
            points[i] = helperPoints;
            routes[i] = helperRoute;
          }
        }
      }
      print("RANKING SUCCESSFULL");
    }
    // Wenn kein Reiseprofil ausgewählt, dann sollen die Routen nach der Reisezeit sortiert werden
    else {
      for (int i = 0; i < routes.length; i++) {
        for (int j = i; j < routes.length; j++) {
          if (routes[j].duration < routes[i].duration) {
            var helper = routes[i];
            routes[i] = routes[j];
            routes[j] = helper;
          }
        }
      }
    }
    // Füge den Routen absteigend einen Buchstaben zu
    int letter = "A".codeUnitAt(0);
    for (int i = 0; i < routes.length; i++) {
      routes[i].routeLetter = String.fromCharCode(letter);
      letter++;
    }
    return true;
  }

  // Wandle das minuten Array in die vorgesehene Map um:
  // Zeitraum : true bzw [4, 20] : true
  Map<List<int>, int> getAutomSections(List<int> automMinutes) {
    var automSections = Map<List<int>, int>();
    for (int i = 0; i < automMinutes.length;) {
      int start = i;
      int end = i;
      // Timed Automatisierung erkannt
      if (automMinutes[i] == 2) {
        while (i < automMinutes.length && automMinutes[i] == 2) {
          end++;
          i++;
        }
        // Füge zur Map hinzu
        automSections.putIfAbsent([start, (end - 1)], () => 2);
        start = end;
      }
      // Normale Automatisierung erkannt
      if (automMinutes[i] == 1) {
        while (i < automMinutes.length && automMinutes[i] == 1) {
          end++;
          i++;
        }
        // Füge zur Map hinzu
        automSections.putIfAbsent([start, (end - 1)], () => 1);
        start = end;
      }
      // Keine Automatisierung erkannt
      if (automMinutes[i] == 0) {
        while (i < automMinutes.length && automMinutes[i] == 0) {
          end++;
          i++;
        }
        // Füge zur Map hinzu
        automSections.putIfAbsent([start, (end - 1)], () => 0);
        start = end;
      }
    }
    return automSections;
  }

  // Setze die gewünschten Automatisierten Abschnitte
  // timedSections: start : dauer
  // 0 = keine Automation
  // 1 = normale Automation
  // 2 = terminierte automation
  List<int> getRandomAutomMinutes(Map<DateTime, Duration> timedSections,
      List<Duration> sections, DateTime start, Duration duration) {
    Random rng = Random(); // Random number generator
    // Array, jeder Eintrag eine minute, immer 0, 1, 2
    // gesamtlänge = duration
    List<int> automMinutes = List<int>.filled(duration.inMinutes, 0);
    // Maximaler Anteil an automatisierten Segmenten
    double maxAutomTime = duration.inMinutes * automationFactorMin +
        rng.nextInt(
            (duration.inMinutes * (automationFactorMax - automationFactorMin))
                .round());

    // Setze die terminierten Sektionen
    var startOfSegment = timedSections.keys.toList();
    var segmentDuration = timedSections.values.toList();
    for (int i = 0; i < timedSections.length; i++) {
      // Speichere ein Backuparray, falls zu viele Minuten hinzugefügt werden
      List<int> backupArray = List.from(automMinutes);

      // Bei dieser Minute startet autom Fahren
      int startInMin = startOfSegment[i].difference(start).inMinutes;
      // Breche ab, sobald autom Section nach ankunft noch gefordert werden würde
      for (int j = startInMin;
          j < startInMin + segmentDuration[i].inMinutes &&
              j < automMinutes.length;
          j++) {
        if (j >= 0) {
          automMinutes[j] =
              2; // Überprüfe, ob ner Nutzer nicht einen Zeitpunkt zu früh anegegeben hat
        }
      }
      // Wenn maximale Autom zeit überschritten dann lade Backup
      if (automMinutes.fold(0, (p, e) => p + e) / 2 >= maxAutomTime) {
        automMinutes = backupArray;
        break;
      }
    }

    // Versuche die Terminlosen Sections unter zu bringen
    // Fülle leere Stellen
    for (int i = 0; i < sections.length; i++) {
      // Backup array, falls nach dem setzen des autom segments die Zeit überschitten wurde
      List<int> backupArray = List.from(automMinutes);
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
      int total = 0;
      for (int i = 0; i < automMinutes.length; i++) {
        if (automMinutes[i] > 0) total++;
      }
      if (total >= maxAutomTime) {
        automMinutes = backupArray;
        break;
      }
    }

    // Setze nun, falls maxAutomTime noch nicht erreicht zufällig weitere automSegmente
    // segmente müssen eine gewisse Länge haben, damit nicht zu winzig
    while (true) {
      // Backup Array, falls die max automationsdauer überschritten wurde
      List<int> backupArray = List.from(automMinutes);

      int maxLength = (duration.inMinutes.toDouble() * maxRandomSegment).ceil();
      int minLength =
          (duration.inMinutes.toDouble() * minRandomSegment).floor();
      int randLength = rng.nextInt(maxLength - minLength) + minLength;
      int randStart = rng.nextInt(automMinutes.length - randLength);
      // Setze nur dann 1, wenn diese Stelle noch frei, sonst würden timedSections
      // verloren gehen können
      for (int i = 0; i < randLength; i++) {
        if (automMinutes[randStart + i] == 0) automMinutes[randStart + i] = 1;
      }

      // Überprüfe, ob zu viel autom Zeit, Undo falls ja, break falls ja
      int total = 0;
      for (int i = 0; i < automMinutes.length; i++) {
        if (automMinutes[i] > 0) total++;
      }
      if (total >= maxAutomTime) {
        automMinutes = backupArray;
        break;
      }
    }
    return automMinutes;
  }

  // Request an google distance api
  Future<Duration> getTravelTime(List<LatLng> polylineCoordinates, LatLng start,
      LatLng destination) async {
    Dio dio = new Dio();
    Response response = await dio.get(
        "https://maps.googleapis.com/maps/api/distancematrix/json?units=metric&origins=${start.latitude},${start.longitude}&destinations=${destination.latitude},${destination.longitude}&key=$apiKey");
    var durationInSec = response.data["rows"][0]["elements"][0]["duration"]
        ["value"]; // Reisezeit in Sekunden
    return Duration(seconds: durationInSec);
    /*
    double totalDistance = 0;
    for (int i = 0; i < (polylineCoordinates.length - 1); i++) {
      totalDistance += coordinateDistance(
          polylineCoordinates[i].latitude,
          polylineCoordinates[i].longitude,
          polylineCoordinates[i + 1].latitude,
          polylineCoordinates[i + 1].longitude);
    }
    // Nehme eine durchschnittsgeschwindigkeit von 50 km/h bzw
    double durationInMin = 60 * totalDistance / (50);
    // Variiere die Dauer
    return Duration(minutes: durationInMin.floor());
    */
  }

  // Einfache Funktion, die die Distanz zwischen zwei geografischen Koordinaten berechnet
  double coordinateDistance(lat1, lon1, lat2, lon2) {
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 -
        c((lat2 - lat1) * p) / 2 +
        c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a));
  }

  // Berechne die Polylinien, um die Route auf der Map zeigen zu können
  Future<void> computePolylines(LatLng start, LatLng destiantion) async {
    print("START POLYLINE CALCULATION");
    // Objekte Clearen
    polylineCoordinates.clear();
    markers.clear();
    polylines.clear();
    // Polyline objekt
    PolylinePoints polylinePoints = PolylinePoints();
    // Füge den Start und Zielmarker hinzu
    MarkerId markerIdStart = MarkerId("origin");
    Marker markerStart = Marker(
        markerId: markerIdStart,
        icon: BitmapDescriptor.defaultMarker,
        position: start);
    MarkerId markerIdDestination = MarkerId("destination");
    Marker markerDestination = Marker(
        markerId: markerIdDestination,
        icon: BitmapDescriptor.defaultMarkerWithHue(90),
        position: destiantion);
    // hinzufügen
    markers[markerIdStart] = markerStart;
    markers[markerIdDestination] = markerDestination;

    // Erstellung der Polyline
    polylinePoints = PolylinePoints();
    // Etgentliche Polyline Berechnung
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      apiKey,
      PointLatLng(start.latitude, start.longitude), // start
      PointLatLng(destiantion.latitude, destiantion.longitude), // Ziel
    );
    // Füge der polyline Koordinatenliste hinzu
    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
    }
    // Füge die Fertige Polylines in die variable
    PolylineId id = PolylineId("poly");
    Polyline polyline = Polyline(
      polylineId: id,
      color: Colors.blue,
      points: polylineCoordinates,
      width: 3,
    );
    polylines[id] = polyline;
  }
}
