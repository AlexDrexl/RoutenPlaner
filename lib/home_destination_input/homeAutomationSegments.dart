import 'package:flutter/material.dart';
import 'package:routenplaner/data/custom_colors.dart';
import 'package:routenplaner/overview/autom_segment_pupup.dart';
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
          mainAxisAlignment: MainAxisAlignment.start, //spaceBetween
          children: <Widget>[
            Icon(
              Icons.directions_car_rounded,
              color: iconColor,
            ),
          
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
            // Abschnitt Löschen-Button
            // Wenn getimed
              child: keyWhen != null
                  ? Text(
                      timedSection,
                      style: TextStyle(fontSize: 17, color: myDarkGrey),
                    )
                  // Wenn nicht getimed
                  : Text(
                      "$automationLength" + " min",
                      style: TextStyle(fontSize: 17, color: myDarkGrey),
                    ),
            ),
            SizedBox(
              width: 25,
              child: RawMaterialButton(  //RawMaterialButton
              //color: myMiddleTurquoise,
                shape: CircleBorder(),
                elevation: 2.0,
                fillColor: myMiddleTurquoise,
                child: Icon(
                  Icons.delete,
                  size: 18, //30
                  color: myWhite,
                ),

              
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
              
            ),)
            
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
      crossAxisAlignment: CrossAxisAlignment.start, //CrossAxisAlignment.start
      children: [
        // Hier die Segment rows
        Consumer<DesiredAutomSections>(
          builder: (context, desiredAutomationSections, child) => Column(
            children: printAllSegments(
              timedSections: desiredAutomationSections.timedSections,
              sections: desiredAutomationSections.sections,
            ),
          ),
        ),
        // Gesamte Reihe zum Hinzufügen eines Elements
        Row(
          mainAxisAlignment: MainAxisAlignment.start, //start
          children: [
            // Expanded für das Auto Symbol
            Icon(
              Icons.directions_car_rounded,
              color: iconColor,
            ),
            Padding(
              padding: EdgeInsets.only(left: 10),
              /*child: Text(
                "Segment hinzufügen",
                style: TextStyle(fontSize: 15, color: myDarkGrey),
              ), */
            ), 
            // Expanded für den Button zum Hinzufügen eines Elements
            Container(
              height: 60, //35, Abstand nach oben zur Überschrift
              width: 35, //35
              padding: EdgeInsets.only(left: 10),
              child: RawMaterialButton( //FloatingActionButton,
                shape: CircleBorder(),
                elevation: 2.0,
                fillColor: myMiddleTurquoise,
                // Wenn Button gedrückt, dann Popup Menu um die Länge einzustellen
                onPressed: () {
                  showDialog(
                      context: context,
                      // Dialog Popup
                      builder: (_) => PupUpAutomInput(
                          overviewMode: false, context: context));
                },
                child: Icon(
                  Icons.add,
                  color: myWhite,
                  size: 20,
                ),
              ),
            ),
          ],
        )
      ],
    );
  }
}
