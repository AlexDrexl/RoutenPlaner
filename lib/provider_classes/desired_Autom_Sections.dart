import 'package:flutter/material.dart';

class DesiredAutomSections with ChangeNotifier {
  // 11.11.2020 um 12:30 : 01:15h lang automatisiert
  Map<DateTime, DateTime> sections = Map<DateTime, DateTime>();

  void deleteSection(DateTime dateKey, DateTime durationValue) {
    sections
        .removeWhere((key, value) => key == dateKey && value == durationValue);
    notifyListeners();
  }

  void addSection(DateTime when, DateTime duration) {
    sections.putIfAbsent(when, () => duration);
    notifyListeners();
  }
}
