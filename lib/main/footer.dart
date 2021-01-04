import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'route_planning.dart';
import '../data/custom_colors.dart';
import 'package:provider/provider.dart';
import 'package:routenplaner/provider_classes/route_details.dart';
import 'package:routenplaner/provider_classes/desired_Autom_Sections.dart';

class Footer extends StatelessWidget {
  // Manchmal ist es Unterschiedlich, was denn beim Footer betätigen gemacht werden soll
  // übergebe die ToDos als List von Funktionen, wird dann vom Footer aufgerufen

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
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
                    BoxShadow(blurRadius: 10, color: myWhite, spreadRadius: 5),
                  ]),
              child: CircleAvatar(
                radius: 30,
                backgroundColor: myMiddleTurquoise,
                child: IconButton(
                  icon: Icon(Icons.home, color: myWhite, size: 30),
                  onPressed: () {
                    // Aktualisiere zuerst noch die Adresse und Verbindungen
                    /*
                    Provider.of<AddressCollection>(context, listen: false)
                        .setAddresses();
                    Provider.of<RoadConnections>(context, listen: false)
                        .setRoadConnections();
                    */
                    // setze das eingegebene Ziel und Start wieder auf null, damit
                    // man wieder neu eingeben MUSS

                    // doFunctions();
                    // autom Segmente zurücksetzen
                    Provider.of<DesiredAutomSections>(context, listen: false)
                        .sections
                        .clear();
                    Provider.of<DesiredAutomSections>(context, listen: false)
                        .timedSections
                        .clear();
                    // Zum hauptmenü
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => RoutePlanning()),
                    );
                    // Start ziel Zurücksetzen
                    Provider.of<RouteDetails>(context, listen: false)
                        .resetRouteDetails();
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
