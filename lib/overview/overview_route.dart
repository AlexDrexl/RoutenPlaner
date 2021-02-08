import 'package:flutter/material.dart';
import 'package:routenplaner/data/custom_colors.dart';
import 'package:routenplaner/drawer/drawer_home.dart';
import 'package:routenplaner/overview/overview_footer_pupup.dart';
import 'package:routenplaner/overview/overview_route_builder.dart';
import 'overview_route_input.dart';
import 'package:routenplaner/data/layoutData.dart';

class Overview extends StatefulWidget {
  @override
  _OverviewState createState() => _OverviewState();
}

class _OverviewState extends State<Overview> {
  final _scrollController = ScrollController();

  mySetState() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'uPlan',
          style: TextStyle(color: Colors.white, fontSize: 30),
        ),
        iconTheme: new IconThemeData(color: Colors.white),
      ),
      drawer: DrawerHome(
        screen: "overview",
      ),
      // Container um Hintergrund und margin einzustellen
      body: WillPopScope(
        onWillPop: () => showDialog(
          context: context,
          builder: (context) {
            return OveriewConfirmation(
              targetPage: "home",
            );
          },
        ),
        child: Container(
          margin: EdgeInsets.fromLTRB(
              contentMarginLR, contentMarginTB, contentMarginLR, 0),
          color: backgroundColor,
          child: Scrollbar(
            controller: _scrollController,
            child: SingleChildScrollView(
              controller: _scrollController,
              child: Column(
                // Damit der Container über die gesamte Breite geht
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  // Abstand zu Oben
                  SizedBox(
                    height: distanceBoxes,
                  ),
                  // Überschrift ROUTENEINGABE
                  Container(
                    padding: EdgeInsets.only(
                        top: contentPaddingTB,
                        bottom: contentPaddingTB,
                        left: contentPaddingLR,
                        right: contentPaddingLR),
                    // generelles Aussehen
                    decoration: BoxDecoration(
                      border: Border.all(width: 0, color: myMiddleGrey),
                      color: myMiddleTurquoise,
                      boxShadow: [
                        BoxShadow(
                          color: myMiddleGrey,
                          blurRadius: 4,
                        )
                      ],
                    ),
                    // Platzierung des Text Widgets in der Zeile
                    // String ROUTENEINGABE
                    child: Text(
                      "ÜBERSICHT",
                      style: TextStyle(
                        color: myWhite,
                        fontSize: 20,
                      ),
                    ),
                  ),
                  // Eigentlicher Überblick über eingegebe Route
                  // Routen input Overview
                  Container(
                    // generelles Aussehen
                    decoration: BoxDecoration(
                        border: Border.all(width: 0, color: myMiddleGrey),
                        color: myWhite,
                        boxShadow: [
                          BoxShadow(
                            color: myMiddleGrey,
                            blurRadius: 4,
                          )
                        ]),
                    padding: EdgeInsets.fromLTRB(contentPaddingLR,
                        contentPaddingTB, contentMarginLR, contentMarginTB),
                    child: OverviewRouteInput(
                      context: context,
                      myCallback: mySetState,
                    ),
                  ),
                  // Abstand zwischen den Boxen
                  SizedBox(
                    height: distanceBoxes,
                  ),
                  // Überschrift ROUTENOPTIONEN
                  Container(
                    // generelles Aussehen
                    decoration: BoxDecoration(
                        border: Border.all(width: 0, color: myMiddleGrey),
                        color: myMiddleTurquoise,
                        boxShadow: [
                          BoxShadow(
                            color: myMiddleGrey,
                            blurRadius: 4,
                          )
                        ]),
                    // Platzierung des Text Widgets in der Zeile
                    padding: EdgeInsets.fromLTRB(contentPaddingLR,
                        contentPaddingTB, contentPaddingLR, contentPaddingTB),
                    // String ROUTENEINGABE
                    child: Text(
                      "ROUTENOPTIONEN",
                      style: TextStyle(
                        color: myWhite,
                        fontSize: 20,
                      ),
                    ),
                    // Eigentlicher Überblick über eingegebe Route
                  ),
                  // Routen Optionen
                  Container(
                    // generelles Aussehen
                    decoration: BoxDecoration(
                      border: Border.all(width: 0, color: myMiddleGrey),
                      color: myWhite,
                      boxShadow: [
                        BoxShadow(
                          color: myMiddleGrey,
                          blurRadius: 4,
                        )
                      ],
                    ),
                    padding: EdgeInsets.fromLTRB(contentPaddingLR,
                        contentPaddingTB, contentPaddingLR, contentPaddingTB),
                    // Gesamtübersicht Routenoptionen
                    ///////////
                    ///
                    ///
                    /// WICHTIG: Wenn Änderung, dann wird dieser Block rebuilded
                    /// dadurch wird der gesamte Routenerstellungsprozess erneut gestartet
                    /// DIESES WIDGET WIRD AUS IRGENDEINEM GRUND IMMER WIEDER NEU AUFGEBAUT
                    child: OverviewRouteBuilder(
                      myCallback: mySetState,
                    ),
                  ),
                  // Abstand zwischen den Boxen
                  SizedBox(
                    height: distanceBoxes,
                  ),
                  // Überschrift "and das Fahrzeug übertragen"
                  Container(
                    // generelles Aussehen
                    decoration: BoxDecoration(
                        border: Border.all(width: 0, color: myMiddleGrey),
                        color: myMiddleTurquoise,
                        boxShadow: [
                          BoxShadow(
                            color: myMiddleGrey,
                            blurRadius: 4,
                          )
                        ]),
                    // Platzierung des Text Widgets in der Zeile
                    padding: EdgeInsets.fromLTRB(contentPaddingLR,
                        contentPaddingTB, contentPaddingLR, contentPaddingTB),
                    // String ROUTENEINGABE
                    child: Text(
                      "ÜBERTRAGUNG STARTEN",
                      style: TextStyle(
                        color: myWhite,
                        fontSize: 20,
                      ),
                    ),
                    // Eigentlicher Überblick über eingegebe Route
                  ),
                  // An das Fahrzeug übertragen
                  Container(
                    padding: EdgeInsets.fromLTRB(contentPaddingLR,
                        contentPaddingTB, contentPaddingLR, contentPaddingTB),
                    // generelles Aussehen
                    decoration: BoxDecoration(
                      border: Border.all(width: 0, color: myMiddleGrey),
                      color: myWhite,
                      boxShadow: [
                        BoxShadow(
                          color: myMiddleGrey,
                          blurRadius: 4,
                        )
                      ],
                    ),
                    child: Column(
                      children: [
                        // Text mit Disclaimer
                        Container(
                          child: Text(
                            "Durch kurzfristige Änderungen bei Verkehr und Umgebungsbedingungen kann es zu Abweichungen von Planung und tatsächlichem Fahrtverlauf kommen",
                            style: TextStyle(fontSize: 10, color: myDarkGrey),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        // Material Button
                        Container(
                          color: myDarkTurquoise,
                          child: MaterialButton(
                            onPressed: () {
                              ///////
                              ///Übertragen an das Fahrzeug
                            },
                            child: Center(
                              child: Text(
                                "Route an Fahrzeug übertragen",
                                style: TextStyle(
                                  color: myWhite,
                                  fontSize: 18,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Abstand nach unten
                  SizedBox(
                    height: distanceBoxes,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
