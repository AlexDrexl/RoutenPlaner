// DO TO
// Slider lässt im Moment noch das Gesamte Popup aktualisieren -> Performance
// nicht gut, evtl mit provider Slider -> Text Im popup, Text im Overview

import 'package:flutter/material.dart';
import 'package:routenplaner/data/custom_colors.dart';
import 'package:provider/provider.dart';
import 'package:routenplaner/provider_classes/desired_Autom_Sections.dart';

class PopUpInput extends StatefulWidget {
  final BuildContext segmentContext;
  // onstructor
  PopUpInput({Key key, @required this.segmentContext}) : super(key: key);
  @override
  _PopUpInputState createState() => _PopUpInputState(segmentContext);
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
  _PopUpInputState(this.segmentContext);

  // Methoden
  Future<Null> selectTime(BuildContext context, bool start) async {
    TimeOfDay locTimeVar = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (locTimeVar != null) {
      setState(() {
        if (start) {
          beginningOfAutom =
              DateTime(0, 0, 0, locTimeVar.hour, locTimeVar.minute);
        } else {
          endOfAutom = DateTime(0, 0, 0, locTimeVar.hour, locTimeVar.minute);
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
                                print("POP");
                                Provider.of<DesiredAutomSections>(context,
                                        listen: false)
                                    .addSection(beginningOfAutom,
                                        DateTime(0, 0, 0, 0, duration.toInt()));
                                Navigator.pop(context);
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
                                    "${beginningOfAutom.hour} : ${beginningOfAutom.minute}"),
                              ),
                              Text(
                                "-",
                                style: TextStyle(
                                  fontSize: 30,
                                  color: myDarkGrey,
                                ),
                              ),
                              // Zweite Zeiteingabe
                              MaterialButton(
                                color: myMiddleTurquoise,
                                textColor: myWhite,
                                onPressed: () {
                                  selectTime(context, false);
                                  setState(() {});
                                },
                                child: Text(
                                    "${endOfAutom.hour} : ${endOfAutom.minute}"),
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
                                      .addSection(
                                    beginningOfAutom,
                                    DateTime(0, 0, 0, 0, duration.toInt()),
                                  );
                                  Navigator.pop(context);
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
