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
  // Eine Reihe eines Autom. Segments
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

  // Alle Segmente printen
  List<Widget> printAllSegments(Map<DateTime, DateTime> sections) {
    // Liste mit den Duration Einträgen, noch in DateTime
    var valueList = sections.values.toList();
    // Liste mit den Keys
    var keyList = sections.keys.toList();
    // Liste für die Widgets
    var allSegments = List<Widget>();
    for (int i = 0; i < valueList.length; i++) {
      allSegments.add(segmentRow(keyList[i], valueList[i]));
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
            children: printAllSegments(desiredAutomationSections.sections),
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
