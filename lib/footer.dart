import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:routenplaner/provider_classes/addresses.dart';
import 'package:routenplaner/provider_classes/road_connections.dart';
import 'package:routenplaner/route_planning2.dart';
import 'route_planning.dart';
import 'data/custom_colors.dart';
import 'package:provider/provider.dart';
import 'package:routenplaner/provider_classes/route_details.dart';

class Footer extends StatelessWidget {
  // Manchmal ist es Unterschiedlich, was denn beim Footer betätigen gemacht werden soll
  // übergebe die ToDos als List von Funktionen, wird dann vom Footer aufgerufen
  static List<Function> toDoFunctions;
  Footer({List<Function> functions}) {
    if (functions != null && functions.length != 0) {
      toDoFunctions = functions;
    }
  }

  void doFunctions() {
    if (toDoFunctions != null && toDoFunctions.length > 0) {
      for (int i = 0; i < toDoFunctions.length; i++) {
        toDoFunctions[i].call();
      }
    }
  }

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
                    /*
                    Provider.of<RouteDetails>(context, listen: false)
                        .startingLocation = null;
                    Provider.of<RouteDetails>(context, listen: false)
                        .destinationLocation = null;
                    */
                    doFunctions();
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => RoutePlanning()),
                    );
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
