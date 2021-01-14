// DO TO
// Slider lässt im Moment noch das Gesamte Popup aktualisieren -> Performance
// nicht gut, evtl mit provider Slider -> Text Im popup, Text im Overview

import 'package:flutter/material.dart';
import 'package:routenplaner/data/custom_colors.dart';
import 'package:provider/provider.dart';
import 'package:routenplaner/provider_classes/desired_Autom_Sections.dart';

class PopUpInput extends StatefulWidget {
  final BuildContext segmentContext;
  final bool overviewMode;
  final Function callback;
  // onstructor
  PopUpInput(
      {void myCallback(),
      @required this.segmentContext,
      @required this.overviewMode})
      : callback = myCallback;
  @override
  _PopUpInputState createState() =>
      _PopUpInputState(segmentContext, overviewMode);
}

class _PopUpInputState extends State<PopUpInput>
    with SingleTickerProviderStateMixin {
  // Benutzte Variablen, evtl noch mit Provider verknüpfen!
  double duration = 1;
  TabController _controller;
  DateTime beginningOfAutom = DateTime.now();
  DateTime endOfAutom = DateTime.now();
  // initialize Context
  BuildContext segmentContext;
  bool overviewMode;
  _PopUpInputState(this.segmentContext, this.overviewMode);

  // Methoden
  Future<Null> selectTime(BuildContext context, bool start) async {
    TimeOfDay locTimeVar = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
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

  @override
  Widget build(BuildContext context) {
    return Builder(
      // Selber Bauen eines PopUps, da die verfügbaren schlecht sind
      builder: (context) {
        var height = MediaQuery.of(context).size.height;
        var width = MediaQuery.of(context).size.width;

        return Container(
          height: height - 450,
          width: width,
          child: Column(
            children: [
              // COntainer für die TabBar
              Container(
                // Container Desing
                decoration: BoxDecoration(
                  border: Border.all(width: 1, color: Colors.grey),
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(14),
                      topLeft: Radius.circular(14)),
                  color: myMiddleTurquoise,
                ),
                // Tab Bar mit DAUER UND UHRZEIT
                child: TabBar(
                  controller: _controller,
                  indicatorColor: myWhite,
                  labelColor: myWhite,
                  tabs: [
                    Tab(
                      child: Text(
                        "DAUER",
                        style: TextStyle(
                          color: myWhite,
                          fontSize: 20,
                        ),
                      ),
                    ),
                    Tab(
                      child: Text(
                        "UHRZEIT",
                        style: TextStyle(
                          color: myWhite,
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // Zwei Tabs
              Container(
                height: 170, // Höhe hardcoden, sonst geht das nicht ka wieso
                margin:
                    EdgeInsets.only(left: 25, right: 25, bottom: 0, top: 25),
                // Nur ein bisschen Kosmetik
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(14),
                      bottomRight: Radius.circular(14)),
                  color: myWhite, //Colors.white,
                ),
                // Eigentlicher Inhalt der Tabs
                child: TabBarView(
                  controller: _controller,
                  children: <Widget>[
                    // ERSTER TAB
                    Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          // Vom Slider eingestellte Dauer
                          Container(
                            padding: EdgeInsets.only(
                                left: 10, right: 10, top: 5, bottom: 5),
                            decoration: BoxDecoration(
                              color: myLightGrey,
                              borderRadius: BorderRadius.all(
                                Radius.circular(5),
                              ),
                              border: Border.all(width: 1, color: myDarkGrey),
                            ),
                            child: Text("${duration.toInt()}" + " min"),
                          ),
                          // Slider und Überschrift des Sliders +
                          Column(
                            children: <Widget>[
                              // Überschrift
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text("1 min"),
                                  Text("60 min"),
                                ],
                              ),
                              // Slider zum Einstellen vo Dauer
                              Slider(
                                value: duration,
                                min: 1,
                                max: 60,
                                divisions: 59,
                                label: "${duration.toInt()}",
                                onChanged: (inputDuration) {
                                  // SET STATE MIT PROVIDER ERSETZEN
                                  setState(() {
                                    duration = inputDuration;
                                  });
                                },
                              ),
                            ],
                          ),
                          // Zurück Button, MUSS zurück zum Overview springen
                          // und auch die werte an Provider übergeben
                          Align(
                            alignment: Alignment.bottomRight,
                            child: FloatingActionButton(
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
                              child: Icon(
                                Icons.arrow_forward_ios,
                                color: myWhite,
                                size: 40,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    // ZWEITER TAB
                    Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
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
                          // zurück Button
                          Container(
                            child: Align(
                              alignment: Alignment.bottomRight,
                              child: FloatingActionButton(
                                onPressed: () {
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
                                child: Icon(
                                  Icons.arrow_forward_ios,
                                  color: myWhite,
                                  size: 40,
                                ),
                              ),
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
        );
      },
    );
  }
}
