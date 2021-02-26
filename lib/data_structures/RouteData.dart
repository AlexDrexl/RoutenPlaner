import 'package:google_maps_flutter/google_maps_flutter.dart';

// Klasse/Struct für die Daten der Routen
class RouteData {
  DateTime startDateTime = DateTime(0);
  DateTime arrivalDateTime = DateTime(0);
  Duration duration = Duration();
  Duration automationDuration;
  Duration manualDuration;
  // Orte und Zwischenstopps
  String startLocation;
  String destinationLocation;
  LatLng geoCoordStart;
  LatLng geoCoordDestination;
  // Weitere Routen Zugaben
  List<int> automMinutes = List<int>();
  String routeLetter;
  var automationSections = Map<List<int>, int>();

  // Constructor, named, um die Daten zu füllen
  RouteData({
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
