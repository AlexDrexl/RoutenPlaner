// Klasse/Struct für die Daten der Reiseprofile
class TravelProfileData {
  int userID = 0;
  String name = "";
  // Alle Zeiten in minuten, da man in der Datenbank keine komplexeren Datentypen
  // speichern kann
  int maxDetour = 0; // In %, Verglichen zur minimalen möglichen Route
  int minDurationAutomSegment = 0;
  // Index des DropTargets aus dem Dreieck, muss noch interpretiert werden
  double xPosTriangle, yPosTriangle;
  // Höhe und Breite des Dreicks
  double triangleWidth, triangleHeight;

  // Anteilige Routeneinstellungen
  int maxAutomDuration = 0;
  int minTravelTime = 0;
  int admd = 0;

  // Konstruktor um Daten zu füllen
  TravelProfileData({
    this.userID,
    this.name,
    this.maxDetour,
    this.xPosTriangle,
    this.yPosTriangle,
    this.minDurationAutomSegment,
    this.triangleWidth,
    this.triangleHeight,
  });
}
