// DO TO
// Slider lässt im Moment noch das Gesamte Popup aktualisieren -> Performance
// nicht gut, evtl mit provider Slider -> Text Im popup, Text im Overview

//import 'dart:math';

import 'package:flutter/material.dart';
import 'package:routenplaner/data/custom_colors.dart';
import 'package:provider/provider.dart';
import 'package:routenplaner/data/layoutData.dart';
import 'package:routenplaner/provider_classes/desired_Autom_Sections.dart';
import 'package:routenplaner/provider_classes/route_details.dart';

class PupUpAutomInput extends StatefulWidget {
  final bool overviewMode;
  final Function callback;
  final BuildContext context;
  // onstructor
  PupUpAutomInput(
      {void myCallback(), @required this.overviewMode, @required this.context})
      : callback = myCallback;
  @override
  _PupUpAutomInputState createState() =>
      _PupUpAutomInputState(overviewMode: overviewMode, context: context);
}

class _PupUpAutomInputState extends State<PupUpAutomInput>
    with SingleTickerProviderStateMixin {
  // Benutzte Variablen, evtl noch mit Provider verknüpfen!
  double duration = 1;
  TabController _controller;
  DateTime beginningOfAutom; // = DateTime.now();
  DateTime endOfAutom; // = DateTime.now();
  BuildContext context;
  bool firstTimeSelected = true;

  bool overviewMode;
  _PupUpAutomInputState({this.overviewMode, this.context}) {
    beginningOfAutom =
        Provider.of<RouteDetails>(context, listen: false).startDateTime;
    endOfAutom = 
        Provider.of<RouteDetails>(context, listen: false).startDateTime; //startDateTime
  }

  // Methoden
  Future<Null> selectTime(BuildContext context, bool start) async {
    //Startzeit bestimmen
    //var startDateTime = beginningOfAutom;
        //Provider.of<RouteDetails>(context, listen: false).startDateTime; //Provider.of<RouteDetails>(context, listen: false).startDateTime
    TimeOfDay locTimeVar = await showTimePicker(
      context: context,
      cancelText: "ABBRECHEN",
      helpText: "ZEIT AUSWÄHLEN",
      initialTime: 
        TimeOfDay(hour: beginningOfAutom.hour, minute: beginningOfAutom.minute), //TimeOfDay(hour: startDateTime.hour, minute: startDateTime.minute),
    );
    
    if (locTimeVar != null) {
      setState(() {
        if (start) {
          beginningOfAutom = DateTime(
              beginningOfAutom.year,
              beginningOfAutom.month,
              beginningOfAutom.day,
              locTimeVar.hour,
              locTimeVar.minute);
        if (firstTimeSelected) {
          endOfAutom = beginningOfAutom;
          firstTimeSelected = false;
        }
        } else {
          endOfAutom = DateTime(
            endOfAutom.year,
            endOfAutom.month,
            endOfAutom.day,
            locTimeVar.hour,
            locTimeVar.minute,
          );
        }
      });
    }
  }

  void initState() {
    super.initState();
    _controller = new TabController(length: 2, vsync: this);
  }

  void correctTime() {
    //wenn Start nach dem Ende ist, dann muss das am nächsten Tag sein
    if (beginningOfAutom.isAfter(endOfAutom)) {
      endOfAutom = endOfAutom.add(Duration(days: 1));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Builder(
      // Selber Bauen eines PopUps, da die verfügbaren schlecht sind
      builder: (context) {
        //var height = MediaQuery.of(context).size.height;
        var width = MediaQuery.of(context).size.width;

        return Dialog(
          //contentPadding: EdgeInsets.fromLTRB(0, 0, 0, 0),
          child: Container(
            //height: height - 500, //-500
            height: 280,
            width: width + 10,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Container für die TabBar
                Container(
                  // Container Design
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(5),
                      bottom: Radius.zero,
                    ),
                    border: Border.all(width: 0, color: Colors.grey), //1
                    color: myWhite,
                  ),
                  // Tab Bar mit DAUER UND UHRZEIT
                  child: TabBar(
                    controller: _controller,
                    indicatorColor: myMiddleTurquoise,
                    indicatorWeight: 5,
                    labelColor: myWhite,
                    tabs: [
                      Tab(
                        child: Text(
                          "DAUER",
                          style: TextStyle(
                            color: myDarkGrey,
                            fontSize: 18,
                          ),
                        ),
                      ),
                      Tab(
                        child: Text(
                          "UHRZEIT",
                          style: TextStyle(
                            color: myDarkGrey,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // Zwei Tabs
                Container(
                  height: 220, // 170 Höhe hardcoden, sonst geht das nicht ka wieso
                  // Nur ein bisschen Kosmetik
                  decoration: BoxDecoration(
                    color: myWhite, //Colors.white,
                  ),
                  // Eigentlicher Inhalt der Tabs
                  child: TabBarView(
                    controller: _controller,
                    children: <Widget>[
                      // ERSTER TAB
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: contentPaddingLR1,
                            vertical: contentMarginTB), //contentMarginTB
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            SizedBox(
                              height: 15, //15
                            ),
                            // Vom Slider eingestellte Dauer
                            Center(
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    vertical: 5, horizontal: 10), //5, 10
                                decoration: BoxDecoration(
                                  color: myWhite,
                                  border:
                                      Border.all(width: 0, color: myMiddleGrey),
                                  boxShadow: [
                                    BoxShadow(
                                      color: myMiddleGrey,
                                      blurRadius: 0,
                                    )
                                  ],
                                ),
                                child: Text(
                                  "${duration.toInt()}" + " min",
                                  style: TextStyle(
                                    color: myDarkGrey,
                                    fontSize: 17,
                                  ),
                                ),
                              ),
                            ),
                            // Slider und Überschrift des Sliders +
                            Column(
                              children: <Widget>[
                                // Überschrift
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Text(
                                      "1 min",
                                      style: TextStyle(
                                          color: myDarkGrey, fontSize: 17),
                                    ),
                                    Text(
                                      "60 min",
                                      style: TextStyle(
                                          color: myDarkGrey, fontSize: 17),
                                    ),
                                  ],
                                ),
                                // Slider zum Einstellen von Dauer
                                SliderTheme(
                                  data: SliderThemeData(
                                      valueIndicatorColor: myMiddleTurquoise,
                                      inactiveTrackColor: myMiddleGrey,
                                      activeTrackColor: myMiddleTurquoise, 
                                      thumbColor: myMiddleTurquoise,
                                      //overlayColor: myMiddleTurquoise,
                                      showValueIndicator:
                                          ShowValueIndicator.never),
                                  child: Slider(
                                    value: duration,
                                    min: 1,
                                    max: 60,
                                    divisions: 59,
                                    label: "",
                                    onChanged: (inputDuration) {
                                      // SET STATE MIT PROVIDER ERSETZEN
                                      setState(() {
                                        duration = inputDuration;
                                      });
                                    },
                                  ),
                                ),
                              ],
                            ),
                            // Zurück Button, MUSS zurück zum Overview springen
                            // und auch die werte an Provider übergeben
                            SizedBox(
                              height: 9, //9
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                MaterialButton(
                                  //color: myDarkGrey,
                                  onPressed: () {
                                    Navigator.of(context).pop(false);
                                  },
                                  child: Text("Abbrechen",
                                      style: TextStyle(
                                          color: myMiddleTurquoise, fontSize: 15)),
                                ),
                                MaterialButton(
                                  color: myMiddleTurquoise,
                                  onPressed: () {
                                    // Wert wird an Provider übergeben
                                    // SETZE IN NICHT GETIMED SECTIONS
                                    Provider.of<DesiredAutomSections>(context,
                                            listen: false)
                                        .addSection(
                                      Duration(
                                        minutes: duration.toInt(),
                                      ),
                                    );
                                    Navigator.pop(context);
                                    // Wenn im Overview ein Element hinzugefügt wird,
                                    // muss die Routenberechnung neu gestartet werden
                                    if (overviewMode) {
                                      // Callback um Aktualisierung zu erwingen
                                      widget.callback();
                                    }
                                  },
                                  child: Text("Abschnitt hinzufügen",
                                      style: TextStyle(
                                          color: myWhite, fontSize: 15)),
                                          
                                ),
                              ],
                            ),
                            /*SizedBox(
                              height: 200,
                            ),*/
                          ],
                        ),
                      ),

                      // ZWEITER TAB
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: contentPaddingLR1,
                            vertical: 15), //contentMarginTB
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            SizedBox(
                              height: 1, //1
                            ),
                            // Die beiden Time Picker
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                // Erste Zeiteingabe
                                MaterialButton(
                                  color: myMiddleTurquoise,
                                  textColor: myWhite,
                                  onPressed: () {
                                    selectTime(context, true);
                                    setState(() {});
                                  },
                                  child: Text(
                                      // pickedDate.day.toString().padLeft(2, '0')
                                      "${beginningOfAutom.hour.toString().padLeft(2, '0')} : ${beginningOfAutom.minute.toString().padLeft(2, '0')}"),
                                ),
                                Text(
                                  "-",
                                  style: TextStyle(
                                    fontSize: 30,
                                    color: myDarkGrey,
                                  ),
                                ),
                                MaterialButton(
                                  color: myMiddleTurquoise,
                                  textColor: myWhite,
                                  onPressed: () {
                                    selectTime(context, false);
                                    setState(() {});
                                  },
                                  child: Text(
                                      "${endOfAutom.hour.toString().padLeft(2, '0')} : ${endOfAutom.minute.toString().padLeft(2, '0')}"),
                                ),
                                // Zurück Button
                              ],
                            ),
                            // Die beiden Button
                            Align(
                              alignment: Alignment.bottomCenter,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  // Abbrechen Button
                                  MaterialButton(
                                    //color: myDarkGrey,
                                    onPressed: () {
                                      Navigator.of(context).pop(false);
                                    },
                                    child: Text("Abbrechen",
                                        style: TextStyle(
                                            color: myMiddleTurquoise, fontSize: 15)), //myWhite
                                  ),
                                  // Hinzufügen Button
                                  MaterialButton(
                                    color: myMiddleTurquoise,
                                    elevation: 2,
                                    onPressed: () {
                                      //Überprüfe, ob die Zeiten passen (Start nicht nach Ende)
                                      correctTime();
                                      // IMPLEMENTIERUNG
                                      Provider.of<DesiredAutomSections>(context,
                                              listen: false)
                                          .addTimedSection(
                                              beginningOfAutom, endOfAutom);
                                      Navigator.pop(context);
                                      if (overviewMode) {
                                        // Callback um Aktualisierung zu erwingen
                                        widget.callback();
                                      }
                                    },
                                    child: Text("Abschnitt hinzufügen",
                                        style: TextStyle(
                                            color: myWhite, fontSize: 15)),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
