import 'package:flutter/material.dart';
import 'package:routenplaner/data/custom_colors.dart';
import 'package:provider/provider.dart';
import 'package:routenplaner/footer.dart';
import 'package:routenplaner/drawer/drawer_home.dart';
import 'package:routenplaner/provider_classes/route_details.dart';
import 'overview_route_input.dart';
import 'package:routenplaner/provider_classes/desired_Autom_Sections.dart';
import 'package:routenplaner/overview/overview_route_options.dart';
// Noch nichts implementiert. hier gehts weiter, wenn der User noch einen
// zwischenstopp einlegen möchte, oder ein Autom. Fahrsegment

class Overview extends StatelessWidget {
  final _scrollController = ScrollController();

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
      bottomNavigationBar: Footer(),
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
                  // Eigentlicher Überblick über eingegebe Route
                ),
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
                  child: OverviewRouteInput(),
                ),
                // Überschrif ROUTENOPTIONEN
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
                      ]),
                  padding:
                      EdgeInsets.only(top: 8, bottom: 8, left: 15, right: 15),
                  margin: EdgeInsets.only(left: 25, right: 25, bottom: 25),
                  // Gesamtübersicht Routenoptionen
                  child: OverviewRouteOptions(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
