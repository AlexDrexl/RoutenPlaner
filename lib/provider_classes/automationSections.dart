/*
import 'package:flutter/material.dart';

// Wenn man einen
class AutomationSections with ChangeNotifier {
  // Konstruktor
  AutomationSections() {
    // Setzem der automationTimeTotals
    setAutomationTimeTotals(automationSections);
    setFlexValues();
  }

  // Bis jetzt noch keine Funktion, mit der man die Automationszeiten
  // Verändern kann
  var letter = "B";
  // Liste mit den Date Time
  DateTime totalManual = DateTime(0);
  DateTime totalAutom = DateTime(0);
  int flexManual = 1;
  int flexAutom = 1;
  Map<List<int>, bool> automationSections = ({
    [0, 10]: true,
    [10, 50]: false,
    [50, 55]: true,
    [55, 60]: false,
    [60, 70]: true,
  });

  // Methoden
  void setAutomationTimeTotals(Map<List<int>, bool> automationSections) {
    // Liste mit den Start/End Einträgen
    var listOfSections = automationSections.keys.toList();
    // Liste mit Bool, ob autom oder nicht
    List<bool> listOfAutomation = automationSections.values.toList();
    // Einzelnen Flex Werte
    for (int i = 0; i < listOfSections.length; i++) {
      // Automatisiertes Fahren möglich
      if (listOfAutomation[i]) {
        totalAutom = totalAutom.add(
            Duration(minutes: listOfSections[i][1] - listOfSections[i][0]));
      } else {
        totalManual = totalManual.add(
            Duration(minutes: listOfSections[i][1] - listOfSections[i][0]));
      }
    }
  }

  // Flex Values müssen mit minimalwerten Bestimmt werden, da ansonsten die Zeiten nicht
  // Mehr richtig angezeigt werden können
  void setFlexValues() {
    flexManual = totalManual.minute + totalManual.hour * 60;
    flexAutom = totalAutom.minute + totalAutom.hour * 60;

    // Manual doppelt so groß wie Autom
    if (flexManual > 2 * flexAutom) {
      flexManual = 2;
      flexAutom = 1;
    }
    // Autom doppelt so groß wie Manual
    if (flexAutom > 2 * flexManual) {
      flexAutom = 2;
      flexManual = 1;
    }
  }
}
*/
