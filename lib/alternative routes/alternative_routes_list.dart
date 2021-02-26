import 'package:flutter/material.dart';
import 'package:routenplaner/data/custom_colors.dart';
import 'package:routenplaner/overview/overview_automation_graphic.dart';
import 'package:routenplaner/controller/final_routes.dart';
import 'package:provider/provider.dart';

class AlternativeRoutesList extends StatelessWidget {
  List<Widget> printAlternativeRoutes(
      BuildContext context, FinalRoutes finalRoutes) {
    int length = finalRoutes.routes.length;
    int indexSelectedRoute = finalRoutes.indexSelectedRoute;
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
                  width: i == indexSelectedRoute ? 4 : 1,
                  // Schaue, ob ausgewähltes Element gerade im Loop
                  color:
                      i == indexSelectedRoute ? myMiddleTurquoise : myDarkGrey),
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
                // ROUTEINDEX HIER IMMER ULL; MUSS ABER I SEIN
                Expanded(
                  flex: 10,
                  child: Column(
                    children: [
                      AutomationGraphic(routeIndex: i),
                      SizedBox(height: 40),
                      Row(
                        children: [
                          Expanded(
                            flex: 5,
                            child: TimeTotals(routeIndex: i),
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
            print("ALTERNATIVE ROUTE SELECTED");
            finalRoutes.selectRoute(i);
            Navigator.pop(context);
          },
        ),
      );
    }
    return widgetList;
  }

  Future<List<Widget>> getAlternativeRoutes(
      BuildContext context, FinalRoutes finalRoutes) async {
    return Future<List<Widget>>.delayed(Duration(seconds: 0),
        () => printAlternativeRoutes(context, finalRoutes));
  }

  @override
  Widget build(BuildContext context) {
    print("BUILD ALTERNATIVE ROUTES");
    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height - 180,
      ),
      // height: MediaQuery.of(context).size.height - 240,
      /////////////////////////////////////////////////////////////
      ///Mache aus printAlternativeRoutes ein Future, zeige dann erst an, wenn
      ///fertig
      /// drei Stadien: ferig, noch kein Wert, error
      child: Consumer<FinalRoutes>(
        builder: (context, finalRoutes, __) => Container(
          child: FutureBuilder<List<Widget>>(
            future: getAlternativeRoutes(context, finalRoutes),
            builder: (context, snapshot) {
              // Aktuelles Widget, das dargstellt werden soll, für fertig, kein wert und error
              Widget child;
              // Wenn Fertig
              if (snapshot.hasData) {
                print("ALTERNATIVE ROUTES LOADED");
                child = ListView(
                  // Snapshot data enthält das fertige Widget
                  children: snapshot.data,
                );
              }
              // wenn Fehlermeldung
              else if (snapshot.hasError) {
                print("ERROR");
                child = Text("ERROR");
              }
              // Daten werden noch geladen
              else {
                print("LOADING ALTERANTIVE ROUTES");
                child = Align(
                  alignment: Alignment.center,
                  child: SizedBox(
                    width: 50,
                    height: 50,
                    child: CircularProgressIndicator(),
                  ),
                );
              }
              return Container(
                child: child,
              );
            },
          ),
        ),
      ),
    );
  }
}
