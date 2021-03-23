import 'package:flutter/material.dart';

// Regelt die Verarbeitung der gewünschten automat. Segmente
class DesiredAutomSections with ChangeNotifier {
  // Terminiert automatisierte Segmente
  Map<DateTime, Duration> timedSections = Map<DateTime, Duration>();
  // Nicht terminierte automatisierte Segemente
  List<Duration> sections = List<Duration>();

  void addSection(Duration duration) {
    sections.add(duration);
    notifyListeners();
  }

  void addTimedSection(DateTime start, DateTime end) {
    var duration = Duration(minutes: end.difference(start).inMinutes);
    timedSections.putIfAbsent(start, () => duration);
    notifyListeners();
  }

  void deleteSection(int index) {
    sections.removeAt(index);
    notifyListeners();
  }

  void deleteTimedSection(DateTime when) {
    timedSections.remove(when);
    notifyListeners();
  }
}
