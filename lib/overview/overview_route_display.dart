import 'package:flutter/material.dart';
import 'package:routenplaner/main.dart';
import 'package:routenplaner/data/custom_colors.dart';
import 'package:routenplaner/overview/overview_automation_graphic.dart';
import 'package:routenplaner/provider_classes/automationSections.dart';
import 'package:provider/provider.dart';
import 'package:routenplaner/provider_classes/final_routes.dart';

class RouteDisplay extends StatelessWidget {
  // Noch mit Hilfe von Provider ersetzen, da dies hier eigentlich ein Stateles
  // Widget ist
  final TimeOfDay totalAutomation = TimeOfDay(hour: 0, minute: 30);
  final TimeOfDay totalManual = TimeOfDay(hour: 0, minute: 10);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 10, right: 10, top: 10),
      // Reihe, da noch der Buchstabe davor gehört
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Buchstabe
          Expanded(
            flex: 1,
            child: Consumer<FinalRoutes>(
              builder: (context, finalRoutes, child) => Text(
                finalRoutes.routes[finalRoutes.indexSelectedRoute].routeLetter +
                    ")",
                style: TextStyle(fontSize: 17, color: myDarkGrey),
              ),
            ),
          ),

          SizedBox(width: 5),
          // Rest mit Graphic, Button etc
          Expanded(
            flex: 10,
            child: Column(
              children: <Widget>[
                // Platzhalter für die kommende Routen Automations Anzeige??
                Consumer<FinalRoutes>(
                  builder: (context, finalRoutes, _) => AutomationGraphic(
                    routeIndex: finalRoutes.indexSelectedRoute,
                  ),
                ),
                SizedBox(height: 10),
                // Reihe mit den gesamteZeiten an Automation und manuell + Button
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    ///// ZEIT AUFTEILUNG /////
                    //// die Route mithöchster Prio nehmen
                    Expanded(
                      flex: 3,
                      child: Consumer<FinalRoutes>(
                        builder: (context, finalRoutes, _) => Container(
                          padding: EdgeInsets.only(right: 10),
                          child: TimeTotals(
                              routeIndex: finalRoutes.indexSelectedRoute),
                        ),
                      ),
                    ),
                    // Uhr Button
                    /*
                    Expanded(
                      flex: 1,
                      child: FloatingActionButton(
                        // Braucht man, damit es
                        heroTag: null,
                        onPressed: () {
                          // HERAUSFINDEN, WAS DENN DER BUTTON MACHEN SOLL
                        },
                        child: Icon(
                          Icons.access_time_outlined,
                          color: myWhite,
                          size: 40,
                        ),
                      ),
                    )
                    */
                  ],
                ),
                SizedBox(height: 15),
                // Reihe mit der Erklärung, was Manuell Fahrt ist
                Row(
                  children: <Widget>[
                    // Quadrat
                    Container(
                      height: 30,
                      width: 30,
                      color: myDarkGrey,
                    ),
                    SizedBox(width: 20),
                    Text(
                      "Manuelle Fahrt",
                      style: TextStyle(color: myDarkGrey),
                    )
                  ],
                ),
                SizedBox(height: 10),
                // Reihe mit der Erklärung, was Atomatisierte Fahrt ist
                Row(
                  children: <Widget>[
                    // Quadrat
                    Container(
                      height: 30,
                      width: 30,
                      color: myMiddleTurquoise,
                    ),
                    SizedBox(width: 20),
                    Text(
                      "Automatisierte Fahrt",
                      style: TextStyle(color: myDarkGrey),
                    )
                  ],
                ),
                SizedBox(height: 20)
              ],
            ),
          ),
        ],
      ),
    );
  }
}
