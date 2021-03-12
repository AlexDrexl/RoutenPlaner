import 'package:flutter/material.dart';
import 'package:routenplaner/data/custom_colors.dart';
import 'package:routenplaner/maps/maps.dart';

import 'package:routenplaner/overview/overview_route_display.dart';
import 'package:routenplaner/alternative%20routes/alternative_routes.dart';

class OverviewRouteOptions extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      //mainAxisSize: MainAxisSize.max,
      //crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        // Grau hinterlegte Karte, mit den Routen Daten bzgl Manueller Fahrt
        Container(
          decoration: BoxDecoration(
            color: myLightGrey,
            border: Border.all(width: 0, color: myDarkGrey),
            borderRadius: BorderRadius.all(
              Radius.circular(0), //14
            ),
          ),
          padding: EdgeInsets.fromLTRB(10,5,20,10),
          //////////
          ///// Anzeige von Linie mit automat Segmenten und der propotionalen Zeitanzeige
          child: RouteDisplay(),
          //////////
        ),
        SizedBox(height: 10),
        // Container für die Buttons unten
        Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween, //spaceBetween
            children: <Widget>[
              MaterialButton(
                child: Container(
                  width: 150, //150
                  height: 40,
                  decoration: BoxDecoration(
                    color: myMiddleTurquoise,
                    //border: Border.all(width: 1, color: myMiddleTurquoise),
                    borderRadius: BorderRadius.all(
                      Radius.circular(3), //14
                    ),
                  ),
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      "Alternative Routen",
                      style: TextStyle(
                        color: myWhite,
                      ),
                    ),
                  ),
                ),
                onPressed: () {
                  // ALTERNATIVE ROUTEN ANZEIGEN
                  Navigator.push(
                    context,
                    MaterialPageRoute<Widget>(
                      builder: (BuildContext context) => AlternativeRoutes(),
                    ),
                  );
                },
              ),
              FlatButton( //FloatingActionButton
                //heroTag: null,
                height: 40,
                splashColor: myWhite,
                shape: CircleBorder(
                  side: BorderSide(color: myMiddleTurquoise)
                ),
                
                child: Icon(
                  Icons.map_outlined,
                  color: myMiddleTurquoise,
                  size: 25,
                ),
                onPressed: () {
                  // LINK ZU DEN MAPS
                  Navigator.push(
                    context,
                    MaterialPageRoute<Widget>(
                      builder: (BuildContext context) => Maps(),
                    ),
                  );
                },
              )
            ],
          ),
        ),
        SizedBox(
          height: 5,
         ),
      ],
    );
  }
}
