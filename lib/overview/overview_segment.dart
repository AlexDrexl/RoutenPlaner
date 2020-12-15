import 'package:flutter/material.dart';
import 'package:routenplaner/data/custom_colors.dart';
import 'package:routenplaner/overview/segment_pupup_dialogue.dart';
import 'package:provider/provider.dart';
import 'package:routenplaner/provider_classes/desired_Autom_Sections.dart';

class OverviewSegments extends StatefulWidget {
  @override
  _OverviewSegmentsState createState() => _OverviewSegmentsState();
}

class _OverviewSegmentsState extends State<OverviewSegments> {
  int flexFirstColumn = 5;
  int flexSecondColumn = 2;
  int flexThirdColumn = 8;
  int automatedDrivingLength = 12;

  Column segmentRow({DateTime keyWhen, Duration valueDuration, int index}) {
    // Dauer in int umrechnen(in minuten)
    int automationLength = valueDuration.inMinutes;
    return Column(
      children: <Widget>[
        SizedBox(height: 10), // Nur um ein wenig Abstand zu schaffen
        // Eigentliche Row
        Row(
          children: <Widget>[
            // Auto Sympol
            Expanded(
              flex: flexSecondColumn,
              child: Icon(
                Icons.directions_car_rounded,
                color: myYellow,
              ),
            ),
            // Minuten Anzahl und Löschen Button
            Expanded(
              flex: flexThirdColumn,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "${automationLength.toString().padLeft(2, '0')}" + " min",
                    style: TextStyle(fontSize: 17, color: myDarkGrey),
                  ),
                  RawMaterialButton(
                    shape: CircleBorder(),
                    highlightColor: myWhite,
                    onPressed: () {
                      // LÖSCHE WIDGET
                      // wenn getimed
                      if (keyWhen != null) {
                        Provider.of<DesiredAutomSections>(context,
                                listen: false)
                            .deleteTimedSection(keyWhen);
                      } else {
                        // wenn nicht getimed
                        Provider.of<DesiredAutomSections>(context,
                                listen: false)
                            .deleteSection(index);
                      }
                    },
                    child: Icon(
                      Icons.delete,
                      color: myMiddleTurquoise,
                      size: 30,
                    ),
                  )
                ],
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
    return Row(
      children: <Widget>[
        // Text, der nur sagt: Automat. Fahrsegment
        Expanded(
          flex: flexFirstColumn,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            // texte mit dem "Automat. Fahrsegment"
            children: <Widget>[
              Text(
                "Automat.",
                style: TextStyle(fontSize: 17, color: myDarkGrey),
              ),
              Text(
                "Fahrsegment",
                strutStyle: StrutStyle(),
                style: TextStyle(fontSize: 17, color: myDarkGrey),
              ),
            ],
          ),
        ),
        // Spalte, mit den ganzen Segmenten, falls diese hinzugefügt wurden
        Expanded(
          flex: flexSecondColumn + flexThirdColumn,
          // Eigentliche Spalte mir Reihenelemten
          child: Column(
            children: <Widget>[
              ///////// LISTE VON SEGMENT ROWS ////////
              Consumer<DesiredAutomSections>(
                builder: (context, desiredAutomationSections, child) => Column(
                  children: printAllSegments(
                    timedSections: desiredAutomationSections.timedSections,
                    sections: desiredAutomationSections.sections,
                  ),
                ),
              ),
              ////////LISTE VON SEGMENT ROWS////////
              // Reihe, zum hinzufügen eines Elements
              Row(
                children: <Widget>[
                  // Auto Icon
                  Expanded(
                    flex: flexSecondColumn,
                    child: Icon(
                      Icons.directions_car_rounded,
                      color: myYellow,
                    ),
                  ),
                  // Button zum Hinzufügen eines Elements
                  Expanded(
                    flex: flexThirdColumn,
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
                            content: PopUpInput(segmentContext: context),
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
                ],
              )
            ],
          ),
        )
      ],
    );
  }
}

/*
Column(
      children: <Widget>[
        // segmentRow(automatedDrivingLength),
        Row(
          children: <Widget>[
            // Automat. Fahrsegment
            Expanded(
              flex: flexFirstColumn,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                // texte mit dem "Automat. Fahrsegment"
                children: <Widget>[
                  Text(
                    "Automat.",
                    style: TextStyle(fontSize: 17, color: myDarkGrey),
                  ),
                  Text(
                    "Fahrsegment",
                    strutStyle: StrutStyle(),
                    style: TextStyle(fontSize: 17, color: myDarkGrey),
                  ),
                ],
              ),
            ),
            // Auto Icon
            Expanded(
              flex: flexSecondColumn,
              child: Icon(
                Icons.directions_car_rounded,
                color: myYellow,
              ),
            ),
            // Button zum Hinzufügen eines Elements
            Expanded(
              flex: flexThirdColumn,
              child: FloatingActionButton(
                onPressed: () {
                  // POPUP MIT SLIDER
                  // FÜGE ROW EIN
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
          ],
        ),
      ],
    );
    */
