import 'package:flutter/material.dart';
import 'package:routenplaner/data/custom_colors.dart';
import 'package:routenplaner/data/layoutData.dart';
import 'package:routenplaner/overview/autom_segment_pupup.dart';
import 'package:provider/provider.dart';
import 'package:routenplaner/controller/desired_Autom_Sections.dart';

class OverviewSegments extends StatefulWidget {
  final Function callback;
  OverviewSegments({@required void myCallback()}) : callback = myCallback;
  @override
  _OverviewSegmentsState createState() => _OverviewSegmentsState(callback);
}

class _OverviewSegmentsState extends State<OverviewSegments> {
  int flexFirstColumn = 4;
  int flexSecondColumn = 1;
  int flexThirdColumn = 8;
  Function myCallback;
  _OverviewSegmentsState(this.myCallback);

  Row segmentRow({DateTime keyWhen, Duration valueDuration, int index}) {
    // Dauer in int umrechnen(in minuten)
    int automationLength = valueDuration.inMinutes;
    String timedSection;
    // Wenn timedSection, dann Uhrzeitstring für die ANzeuge berechnen
    if (keyWhen != null) {
      var end = keyWhen.add(valueDuration);
      timedSection =
          '${keyWhen.hour.toString().padLeft(2, '0')}:${keyWhen.minute.toString().padLeft(2, '0')} - ${end.hour.toString().padLeft(2, '0')}:${end.minute.toString().padLeft(2, '0')} Uhr';
    }
    return Row(
      children: <Widget>[
        // Auto Sympol
        Expanded(
          flex: flexSecondColumn,
          child: Icon(
            Icons.directions_car_rounded,
            color: iconColor,
          ),
        ),
        // Minuten Anzahl und Löschen Button
        Expanded(
          flex: flexThirdColumn,
          child: Container(
            padding: EdgeInsets.only(left: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  flex: 2,
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
                Expanded(
                  flex: 1,
                  child: RawMaterialButton(
                    shape: CircleBorder(),
                    highlightColor: myWhite,
                    onPressed: () {
                      // LÖSCHE WIDGET
                      // wenn getimed
                      if (keyWhen != null) {
                        Provider.of<DesiredAutomSections>(context,
                                listen: false)
                            .deleteTimedSection(keyWhen);
                        // Routenerstellungsprozess muss wieder erneut gestartet werden
                        widget?.callback();
                      } else {
                        // wenn nicht getimed
                        Provider.of<DesiredAutomSections>(context,
                                listen: false)
                            .deleteSection(index);
                        widget?.callback();
                      }
                    },
                    child: Icon(
                      Icons.delete,
                      color: myMiddleTurquoise,
                      size: 25,
                    ),
                  ),
                )
              ],
            ),
          ),
        )
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
    return Container(
      padding: EdgeInsets.only(bottom: contentPaddingTB),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Text
          Expanded(
            flex: flexFirstColumn,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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
          // Alle Elemente plus Hinzufügen
          Expanded(
            flex: flexSecondColumn + flexThirdColumn,
            child: Column(
              children: [
                // Bereits erstelle autom Segmente
                Consumer<DesiredAutomSections>(
                  builder: (context, desiredAutomationSections, child) =>
                      Column(
                    children: printAllSegments(
                      timedSections: desiredAutomationSections.timedSections,
                      sections: desiredAutomationSections.sections,
                    ),
                  ),
                ),
                Row(
                  children: <Widget>[
                    // Auto Icon
                    Expanded(
                      flex: flexSecondColumn,
                      child: Icon(
                        Icons.directions_car_rounded,
                        color: iconColor,
                      ),
                    ),
                    // Button zum Hinzufügen eines Elements
                    Expanded(
                      flex: flexThirdColumn,
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                          padding: EdgeInsets.only(left: 10),
                          height: 35,
                          width: 35,
                          child: FloatingActionButton(
                            // Wenn Button gedrückt, dann Popup Menu um die Länge einzustellen
                            onPressed: () {
                              showDialog(
                                context: context,
                                // Dialog Popup
                                builder: (_) => PupUpAutomInput(
                                    myCallback: myCallback,
                                    overviewMode: true,
                                    context: context),
                              );
                            },
                            child: Icon(
                              Icons.add,
                              color: myWhite,
                              size: 20,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
