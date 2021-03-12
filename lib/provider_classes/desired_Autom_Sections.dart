import 'package:flutter/material.dart';

class DesiredAutomSections with ChangeNotifier {
  // 11.11.2020 um 12:30 : 01:15h lang automatisiert
  Map<DateTime, Duration> timedSections = Map<DateTime, Duration>();
  List<Duration> sections = List<Duration>();

  void deleteSection(int index) {
    sections.removeAt(index);
    notifyListeners();
  }

  void addSection(Duration duration) {
    sections.add(duration);
    notifyListeners();
  }

  // immer gleiche kombi: StartZeit und Dauer
  void addTimedSection(DateTime start, DateTime end) {
    var duration = Duration(minutes: end.difference(start).inMinutes);
    timedSections.putIfAbsent(start, () => duration);
    notifyListeners();
  }

  void deleteTimedSection(DateTime when) {
    timedSections.remove(when);
    notifyListeners();
  }
}
