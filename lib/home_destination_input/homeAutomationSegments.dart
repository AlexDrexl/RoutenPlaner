import 'package:flutter/material.dart';
import 'package:routenplaner/data/custom_colors.dart';
import 'package:routenplaner/overview/segment_pupup_dialogue.dart';
import 'package:routenplaner/provider_classes/desired_Autom_Sections.dart';
import 'package:provider/provider.dart';

class HomeAutomationSegments extends StatefulWidget {
  @override
  _HomeAutomationSegmentsState createState() => _HomeAutomationSegmentsState();
}

class _HomeAutomationSegmentsState extends State<HomeAutomationSegments> {
  Column segmentRow({DateTime keyWhen, Duration valueDuration, int index}) {
    // Dauer in int umrechnen(in minuten)
    int automationLength = valueDuration.inMinutes;
    String timedSection;
    // Wenn timedSection, dann Uhrzeitstring für die ANzeuge berechnen
    if (keyWhen != null) {
      var end = keyWhen.add(valueDuration);
      timedSection =
          '${keyWhen.hour.toString().padLeft(2, '0')}:${keyWhen.minute.toString().padLeft(2, '0')} - ${end.hour.toString().padLeft(2, '0')}:${end.minute.toString().padLeft(2, '0')} Uhr';
    }
    return Column(
      children: <Widget>[
        SizedBox(height: 10), // Nur um ein wenig Abstand zu schaffen
        // Eigentliche Row
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Icon(
              Icons.directions_car_rounded,
              color: myYellow,
            ),
            // Minuten Anzahl und Löschen Button
            // Wenn getimed
            keyWhen != null
                ? Text(
                    timedSection,
                    style: TextStyle(fontSize: 17, color: myDarkGrey),
                  )
                // Wenn nicht getimed
                : Text(
                    "$automationLength" + " min",
                    style: TextStyle(fontSize: 17, color: myDarkGrey),
                  ),
            RawMaterialButton(
              shape: CircleBorder(),
              highlightColor: myWhite,
              onPressed: () {
                // LÖSCHE WIDGET
                // wenn getimed
                if (keyWhen != null) {
                  Provider.of<DesiredAutomSections>(context, listen: false)
                      .deleteTimedSection(keyWhen);
                } else {
                  // wenn nicht getimed
                  Provider.of<DesiredAutomSections>(context, listen: false)
                      .deleteSection(index);
                }
              },
              child: Icon(
                Icons.delete,
                size: 30,
                color: myMiddleTurquoise,
              ),
            )
          ],
        ),
      ],
    );
  }

  List<Widget> printAllSegments(
      {Map<DateTime, Duration> timedSections, List<Duration> sections}) {
    // Liste mit den Duration Einträgen, noch in DateTime
    var valueList = timedSections.values.toList();
    // Liste mit den Keys
    var keyList = timedSections.keys.toList();
    // Liste für die Widgets
    var allSegments = List<Widget>();

    // Füge die timedSections hinzu
    for (int i = 0; i < valueList.length; i++) {
      allSegments
          .add(segmentRow(keyWhen: keyList[i], valueDuration: valueList[i]));
    }
    // Füge die normalen Sections hinzu, ohne timing
    for (int i = 0; i < sections.length; i++) {
      allSegments.add(segmentRow(valueDuration: sections[i], index: i));
    }

    return allSegments;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 20),
        // Hier die Segment rows
        Consumer<DesiredAutomSections>(
          builder: (context, desiredAutomationSections, child) => Column(
            children: printAllSegments(
              timedSections: desiredAutomationSections.timedSections,
              sections: desiredAutomationSections.sections,
            ),
          ),
        ),
        // Gesamte Reihe zum hinzufügen eines Elements
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            // Expanded für das Auto Symbol
            Expanded(
              flex: 1,
              child: Align(
                alignment: Alignment.centerLeft,
                child: Icon(
                  Icons.directions_car_rounded,
                  color: myYellow,
                ),
              ),
            ),
            SizedBox(width: 50),
            // Expanded für den Button zum hinzufügen eines Elements
            Expanded(
              flex: 1,
              child: Align(
                alignment: Alignment.centerLeft,
                child: FloatingActionButton(
                  // Wenn Button gedrückt, dann Popup Menu um die Länge einzustellen
                  onPressed: () {
                    showDialog(
                      context: context,
                      // Dialog Popup
                      builder: (_) => AlertDialog(
                        shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(14.0))),
                        contentPadding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                        content: PopUpInput(
                            segmentContext: context, overviewMode: false),
                      ),
                    );
                  },
                  child: Text(
                    "+",
                    style: TextStyle(
                      color: myWhite,
                      fontSize: 50,
                    ),
                  ),
                ),
              ),
            ),
            // Platzhalter um andere Elemente zu plazieren
            Expanded(
              flex: 3,
              child: Container(),
            )
          ],
        )
      ],
    );
  }
}

/*
Column segmentRow(DateTime keyWhen, DateTime valueDuration) {
    // Dauer in int umrechnen(in minuten)
    int automationLength = valueDuration.minute + valueDuration.hour * 60;
    return Column(
      children: <Widget>[
        SizedBox(height: 10), // Nur um ein wenig Abstand zu schaffen
        // Eigentliche Row
        Row(
          children: <Widget>[
            // Auto Sympol
            Expanded(
              flex: 1,
              child: Align(
                alignment: Alignment.centerLeft,
                child: Icon(
                  Icons.directions_car_rounded,
                  color: myYellow,
                ),
              ),
            ),
            // Minuten Anzahl und Löschen Button
            Expanded(
              flex: 1,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "$automationLength" + " min",
                    style: TextStyle(fontSize: 17, color: myDarkGrey),
                  ),
                ],
              ),
            ),
            Expanded(
              
              child: Align(
                alignment: Alignment.centerLeft,
                child: RawMaterialButton(
                  shape: CircleBorder(),
                  highlightColor: myWhite,
                  onPressed: () {
                    // LÖSCHE WIDGET
                    Provider.of<DesiredAutomSections>(context, listen: false)
                        .deleteSection(keyWhen, valueDuration);
                  },
                  child: Icon(
                    Icons.do_disturb_on_sharp,
                    color: myYellow,
                    size: 30,
                  ),
                ),
              ),
            )
          ],
        ),
      ],
    );
  }

 */
