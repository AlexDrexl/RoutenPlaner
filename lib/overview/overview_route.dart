import 'package:flutter/material.dart';
import 'package:routenplaner/data/custom_colors.dart';
import 'package:provider/provider.dart';
import 'package:routenplaner/drawer/drawer_home.dart';
import 'package:routenplaner/overview/overview_footer_pupup.dart';
import 'package:routenplaner/overview/overview_route_builder.dart';
import 'package:routenplaner/provider_classes/final_routes.dart';
import 'package:routenplaner/provider_classes/overview_change.dart';
import 'overview_route_input.dart';
import 'package:routenplaner/overview/overview_route_options.dart';
import 'package:async/async.dart';

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
      bottomNavigationBar: BottomAppBar(
        color: Colors.white.withOpacity(0),
        child: Container(
          padding: EdgeInsets.only(top: 5, bottom: 5, left: 5, right: 5),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.white.withOpacity(0.1),
                Colors.white.withOpacity(0.9),
              ],
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                    color: myMiddleTurquoise,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                          blurRadius: 10, color: myWhite, spreadRadius: 5),
                    ]),
                child: CircleAvatar(
                  radius: 30,
                  backgroundColor: myMiddleTurquoise,
                  child: IconButton(
                    icon: Icon(Icons.home, color: myWhite, size: 30),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return OverviewFooterPopup();
                        },
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      drawer: DrawerHome(),
      body: Scrollbar(
        controller: _scrollController,
        isAlwaysShown: true,
        child: SingleChildScrollView(
          controller: _scrollController,
          child: Container(
            // Container benötigt, um den Background zu erstellen
            decoration: BoxDecoration(
              image: DecorationImage(
                colorFilter: new ColorFilter.mode(
                    Colors.grey.withOpacity(0.15), BlendMode.dstATop),
                image: AssetImage("assets/images/citybackground.png"),
                fit: BoxFit.fitWidth,
              ),
            ),
            // Spalte für die zwei Cards
            child: Column(
              // Damit der Container über die gesamte Breite geht
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                // Überschrift ROUTENEINGABE
                Container(
                  // generelles Aussehen
                  decoration: BoxDecoration(
                    border: Border.all(width: 0, color: myMiddleGrey),
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(14),
                        topRight: Radius.circular(14)),
                    color: myMiddleTurquoise,
                    boxShadow: [
                      BoxShadow(
                        color: myMiddleGrey,
                        blurRadius: 4,
                      )
                    ],
                  ),
                  // Platzierung des Text Widgets in der Zeile
                  padding: EdgeInsets.only(top: 8, bottom: 8, left: 15),
                  margin: EdgeInsets.only(left: 25, right: 25, top: 25),
                  // String ROUTENEINGABE
                  child: Text(
                    "ROUTENEINGABE",
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
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(14),
                        bottomRight: Radius.circular(14),
                      ),
                      color: myWhite,
                      boxShadow: [
                        BoxShadow(
                          color: myMiddleGrey,
                          blurRadius: 4,
                        )
                      ]),
                  padding:
                      EdgeInsets.only(top: 8, bottom: 8, left: 15, right: 15),
                  margin: EdgeInsets.only(left: 25, right: 25, bottom: 25),
                  child: OverviewRouteInput(
                    context: context,
                    myCallback: mySetState,
                  ),
                ),
                // Überschrift ROUTENOPTIONEN
                Container(
                  // generelles Aussehen
                  decoration: BoxDecoration(
                      border: Border.all(width: 0, color: myMiddleGrey),
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(14),
                          topRight: Radius.circular(14)),
                      color: myMiddleTurquoise,
                      boxShadow: [
                        BoxShadow(
                          color: myMiddleGrey,
                          blurRadius: 4,
                        )
                      ]),
                  // Platzierung des Text Widgets in der Zeile
                  padding: EdgeInsets.only(top: 8, bottom: 8, left: 15),
                  margin: EdgeInsets.only(left: 25, right: 25, top: 25),
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
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(14),
                      bottomRight: Radius.circular(14),
                    ),
                    color: myWhite,
                    boxShadow: [
                      BoxShadow(
                        color: myMiddleGrey,
                        blurRadius: 4,
                      )
                    ],
                  ),
                  padding:
                      EdgeInsets.only(top: 8, bottom: 8, left: 15, right: 15),
                  margin: EdgeInsets.only(left: 25, right: 25, bottom: 25),
                  // Gesamtübersicht Routenoptionen
                  ///////////
                  ///
                  ///
                  /// WICHTIG: Wenn Änderung, dann wird dieser Block rebuilded
                  /// dadurch wird der gesamte Routenerstellungsprozess erneut gestartet
                  /// DIESES WIDGET WIRD AUS IRGENDEINEM GRUND IMMER WIEDER NEU AUFGEBAUT
                  child: Consumer<OverviewChange>(
                      builder: (context, finalRoutes, _) {
                    return OverviewRouteBuilder(
                      myCallback: mySetState,
                    );
                  }),
                ),
                // Überschrift "and das Fahrzeug übertragen"
                Container(
                  // generelles Aussehen
                  decoration: BoxDecoration(
                      border: Border.all(width: 0, color: myMiddleGrey),
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(14),
                          topRight: Radius.circular(14)),
                      color: myMiddleTurquoise,
                      boxShadow: [
                        BoxShadow(
                          color: myMiddleGrey,
                          blurRadius: 4,
                        )
                      ]),
                  // Platzierung des Text Widgets in der Zeile
                  padding: EdgeInsets.only(top: 8, bottom: 8, left: 15),
                  margin: EdgeInsets.only(left: 25, right: 25, top: 25),
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
                  // generelles Aussehen
                  decoration: BoxDecoration(
                    border: Border.all(width: 0, color: myMiddleGrey),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(14),
                      bottomRight: Radius.circular(14),
                    ),
                    color: myWhite,
                    boxShadow: [
                      BoxShadow(
                        color: myMiddleGrey,
                        blurRadius: 4,
                      )
                    ],
                  ),
                  margin: EdgeInsets.only(left: 25, right: 25, bottom: 25),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 10,
                      ),
                      // Text mit Disclaimer
                      Container(
                        margin: EdgeInsets.only(left: 20, right: 20),
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
                        child: MaterialButton(
                          onPressed: () {
                            ///////
                            ///Übertragen an das Fahrzeug
                          },
                          child: Container(
                            padding: EdgeInsets.all(15),
                            decoration: BoxDecoration(
                              color: myDarkTurquoise,
                              border: Border.all(width: 0, color: myDarkGrey),
                              borderRadius: BorderRadius.all(
                                Radius.circular(0),
                              ),
                            ),
                            child: Align(
                              alignment: Alignment.center,
                              child: Text(
                                "Route an Fahrzeug übertragen",
                                style: TextStyle(
                                  color: myWhite,
                                  fontSize: 15,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
