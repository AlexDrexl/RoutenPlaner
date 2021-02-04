import 'dart:math';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:routenplaner/provider_classes/travel_profiles_collection.dart';
import 'package:vector_math/vector_math.dart' as vec;
import 'desired_Autom_Sections.dart';
import 'route_details.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'dart:math' show cos, sqrt, asin;
import 'package:dio/dio.dart';

// Übergestellte Klasse, erhält alle daten aus den verschiedenen provider Klassen
// verwendet sie um finale Routen zu berechnen
// Hier auch die Nutzerprofile mit einbeziehen
// Routen werden nach Prio geordnet in einem Array gespeichert
// zudem gibt es das Attribut selected Route, das die manuell geänderte Route
// hält

class FinalRoutes with ChangeNotifier {
  // API KEY
  String apiKey = "AIzaSyC0DgP0BdEXEybFlEReSj_ghex8jTDOeWE";
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
  double minRandomSegment = 0.1; // Min länge eines Segments abh. von Gesamtzeit
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

  // Benötigte Provider Dateien im Konstruktor mit einbinden
  FinalRoutes() {
    /////////// ERSTELLUNG DER ROUTEN OBJEKTE ////////////
    print("FINAL_ROUTES CALLED");
  }

  bool running = false;

  // Aktualisierungsfunktion
  // void refresh() => notifyListeners();

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
  Future<bool> computeFinalRoutes(BuildContext context) async {
    if (running) {
      return false;
    }
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
    // Berechne die theoretische Reisezeit, ist immer gleich
    Duration travelTime = await getTravelTime(polylineCoordinates,
        routeDetails.geoCoordStart, routeDetails.geoCoordDestination);
    for (int i = 0; i < 5; i++) {
      // Für die Linie ist nur die Map Mit automatisierten Segmenten nötig
      // in overview automation graphic, bereits mit finalRoutes verbunden
      // Für die Anzeige an gesamt autom/manuel Fahrzeit sind autom und man duration nötig, berechne

      // Randomise die Dauer der Fahrt, und darauf basierend dann die Ankommzeit
      // Die Dauer der Fahrt darf nicht länger sein als die
      // Fehlt: XArrivalDateTime, automationDuration, manualDuration,
      // XautomSections, XautomMintes

      // Variiere die ReiseDauer, um 0% bis 20%
      /*
      Duration duration = getTravelTime() +
          Duration(
            minutes: rng.nextInt(
              (getTravelTime().inMinutes * durationFactor).toInt(),
            ),
          );
       */
      // Hole die Reisezeit und variiere sie dann
      Duration duration = Duration(
          minutes: (travelTime.inMinutes *
                  (1 + (rng.nextInt((100 * durationFactor).toInt()) / 100)))
              .toInt());
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
          geoCoordStart: routeDetails.geoCoordStart,
          geoCoordDestination: routeDetails.geoCoordDestination,
          automMinutes: automMinutes,
          automationSections: automSections,
        ),
      );
    }
    // Am end noch die Routen Ranken, da auch die Buchstaben hinzufügen
    await rankRoutes(travelProfile, travelTime);
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
          if (automDriving[j] == true) {
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
          points[i] = (validSectionCount / totalSectionCount) * segmentFactor;
        }
      }
      // Bewertung der maximalen abweichung von der theoretischen Dauer
      // Berechne prozentuale Abweichung der tatsächlichen Zeit von der theretischen Zeit
      for (int i = 0; i < routes.length; i++) {
        // SollReisezeit
        double targetDuration = (1 + (travelProfile.maxDetour / 100)) *
            theoreticalDuration.inMinutes.toDouble(); // in minuten
        // Ist Reisezeit
        double actualDuration = routes[i].duration.inMinutes.toDouble();
        // Abweichung soll-ist/soll
        double deviation = (targetDuration - actualDuration) / targetDuration;
        // TODO: Evtl 1+diviation quadrieren um Unterschied zu verstärken
        points[i] += (1 + deviation) * detourFactor;
      }
      ///////////
      // Dreieck Daten verwerten
      // Interpretiere zunächst den Dreecksindex
      // [automDauer, MinReisezeit, admd]
      // TODO: ÄNDERE ZU FUNKTIONAL
      var interpretIndex = interpretTrianglePosition(
          travelProfile.xPosTriangle,
          travelProfile.yPosTriangle,
          travelProfile.triangleHeight,
          travelProfile.triangleWidth);
      var maxAutomTime = interpretIndex[0];
      var minTravelTime = interpretIndex[1];
      var minADMD = interpretIndex[2];
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
      // print(points);
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

  // Interpretiere den index des Triangles
  // [automDauer, MinReisezeit, admd]
  List<num> interpretTrianglePosition(
      double posX, double posY, double height, double width) {
    // Sollte das Reiseprofil angelegt, aber nie aufgerufen worden sein, können
    // höhe und breite nicht init werden, in dem Fall, setze alles auf 1/3
    if (posX == null || posY == null || height == null || width == null) {
      print("Travel Profile never opened");
      return [1 / 3, 1 / 3, 1 / 3];
    }
    var posMiddle = vec.Vector2(width / 2, (width / 2) * tan(pi * 1 / 6));
    var posIcon = vec.Vector2(posX, posY);
    var rotMatrixLeft = vec.Matrix2(
        cos(pi * 2 / 3), sin(pi * 2 / 3), -sin(pi * 2 / 3), cos(pi * 2 / 3));
    var rotMatrixRight = vec.Matrix2(
        cos(pi * 2 / 3), -sin(pi * 2 / 3), sin(pi * 2 / 3), cos(pi * 2 / 3));
    Map<String, double> posVals = {
      "maxAutom": 0,
      "minTravTime": 0,
      "minADMD": 0,
    };

    //Verschiebung in die Mitte
    // ROTATION GEHT NOCH NICHT
    // TODO: Wenn odirekt nach dem Start das ein Reiseprofil gewählt, ist die größe
    // des Dreicks nicht bekannt, entweder Wichtigkeitswerte speichern und dann bei  Bedarf umrechenen
    // oder immer die Größe des Bildschirms merken
    // Rechne immer die Höhre der Mitte drauf um keine negativen Wert zu erhalten
    // Icon hat eine gewisse Eigengröße, weshalb 0 nicht ganz erreicht werden kann.
    // da aber trotzdem viel kleiner egal
    // TODO: GANZE interpretation der Reisedreiecke in das Reiseprofil, merke dann nur
    // die ergebnisse in der DB, Rückinterpretiere die ergebnisse zu der Position
    posIcon -= posMiddle;
    // Abstand zu maxAutom direkt ablesbar
    posVals["maxAutom"] = posIcon.y + posMiddle.y;
    // Rotation um 120 grad im Urzeigersinn
    posVals["minTravTime"] = (rotMatrixRight * posIcon).y + posMiddle.y;
    // Rotation um 120 grad gegen den Uhrzeigersinn, geht von mittlerem Kosy aus
    posVals["minADMD"] = (rotMatrixLeft * posIcon).y + posMiddle.y;
    double tot =
        posVals["maxAutom"] + posVals["minTravTime"] + posVals["minADMD"];
    /*
    print([
      posVals["maxAutom"] / tot,
      posVals["minTravTime"] / tot,
      posVals["minADMD"] / tot,
    ]);
    */
    return [
      posVals["maxAutom"] / tot,
      posVals["minTravTime"] / tot,
      posVals["minADMD"] / tot,
    ];
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
      // breche ab, wenn die Route zu kurz ist
      if (automMinutes.fold(0, (p, c) => p + c) >= maxAutomTime ||
          duration.inMinutes < 4) {
        break;
      }
      int maxLength = (duration.inMinutes.toDouble() * maxRandomSegment).ceil();
      int minLength =
          (duration.inMinutes.toDouble() * minRandomSegment).floor();
      int randLength = rng.nextInt(maxLength - minLength) + minLength;
      int randStart = rng.nextInt(automMinutes.length - randLength);
      automMinutes.fillRange(randStart, randStart + randLength, 1);
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

  // einfache funktion, die die Distanz zwischen zwei geografischen Koordinaten berechnet
  double coordinateDistance(lat1, lon1, lat2, lon2) {
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 -
        c((lat2 - lat1) * p) / 2 +
        c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a));
  }

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

// Erzeuger für das RoutenObjekt, hält im Endeffekt nur die einzelnen Parameter
// Dadurch einfach zu übergeben
class FinalRoute {
  DateTime startDateTime = DateTime(0);
  DateTime arrivalDateTime = DateTime(0);
  Duration duration = Duration();
  Duration automationDuration;
  Duration manualDuration;
  // TravelProfileData selectedTravelProfile;
  // Orte und Zwischenstopps
  String startLocation;
  String destinationLocation;
  LatLng geoCoordStart;
  LatLng geoCoordDestination;
  // Weitere Routen Zugaben
  List<int> automMinutes = List<int>();
  String routeLetter;
  var automationSections = Map<List<int>, bool>();

  // Constructor, named, um die Daten zu füllen
  FinalRoute({
    this.startDateTime,
    this.arrivalDateTime,
    this.duration,
    this.automationDuration,
    this.manualDuration,
    this.startLocation,
    this.destinationLocation,
    this.geoCoordStart,
    this.geoCoordDestination,
    this.automMinutes,
    this.automationSections,
    this.routeLetter,
  });
}
