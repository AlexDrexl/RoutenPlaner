import 'package:flutter/material.dart';
import 'package:routenplaner/data/custom_colors.dart';
import 'package:routenplaner/overview/overview_automation_graphic.dart';
import 'package:routenplaner/provider_classes/final_routes.dart';
import 'package:provider/provider.dart';
import 'package:routenplaner/provider_classes/route_details.dart';

class AlternativeRoutesList extends StatelessWidget {
  List<Widget> printAlternativeRoutes(
      BuildContext context, FinalRoutes finalRoutes) {
    int length = finalRoutes.routes.length;
    int index = finalRoutes.indexSelectedRoute;
    List<Widget> widgetList = List<Widget>();

    for (int i = 0; i < length; i++) {
      widgetList.add(
        MaterialButton(
          child: Container(
            margin: EdgeInsets.only(top: 30),
            padding: EdgeInsets.fromLTRB(10, 20, 30, 20),
            decoration: BoxDecoration(
              color: myLightGrey,
              border: Border.all(
                  width: i == index ? 4 : 1,
                  // Schaue, ob ausgewähltes Element gerade im Loop
                  color: i == index ? myMiddleTurquoise : myDarkGrey),
              borderRadius: BorderRadius.all(
                Radius.circular(14),
              ),
            ),
            // Inhalt einer Karte
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Erstes Expanded für den Buchstaben
                Expanded(
                  flex: 1,
                  child: Text(
                    finalRoutes.routes[i].routeLetter + ")",
                    style: TextStyle(
                      fontSize: 17,
                      color: myDarkGrey,
                    ),
                  ),
                ),
                // Zweites Expanded für die Linie und Zeitanzeige
                Expanded(
                  flex: 10,
                  child: Column(
                    children: [
                      AutomationGraphic(routePrioIndex: 0),
                      SizedBox(height: 40),
                      Row(
                        children: [
                          Expanded(
                            flex: 5,
                            child: TimeTotals(routePrioIndex: 0),
                          ),
                          Expanded(
                            flex: 1,
                            // Leerer Platz gefordert
                            child: Container(),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          onPressed: () {
            finalRoutes.selectRoute(i);
          },
        ),
      );
    }
    return widgetList;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height - 240,
      ),
      // height: MediaQuery.of(context).size.height - 240,
      child: Consumer<FinalRoutes>(
        builder: (context, finalRoutes, __) => ListView(
          children: printAlternativeRoutes(context, finalRoutes),
        ),
      ),
    );
  }
}
