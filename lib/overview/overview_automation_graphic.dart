import 'package:flutter/material.dart';
import 'package:routenplaner/data/custom_colors.dart';
import 'package:routenplaner/provider_classes/automationSections.dart';
import 'package:provider/provider.dart';
import 'package:routenplaner/provider_classes/final_routes.dart';
import 'package:routenplaner/provider_classes/final_routes.dart';

// Automationsgrafik, basierend auf den Automationsabschnitten in einer Map
// start : ende

// Grafik für die dynamische Übersicht über die Automationslängen
class AutomationGraphic extends StatelessWidget {
  // Map mit Liste an Start/Ende Zeitabschnitte, und dazugehörig bool ob Autom oder nicht
  // zeit in Min
  final routeLetter = "A";
  final int routePrioIndex;
  AutomationGraphic({@required this.routePrioIndex});

  Widget graphLine(Map<List<int>, bool> automationSections) {
    double myHeight;
    Color myColor;
    // Liste der Widgets
    List<Widget> widgetList = [];
    // Liste mit den Start/End Einträgen
    var listOfSections = automationSections.keys.toList();
    // Liste mit Bool, ob autom oder nicht
    List<bool> listOfAutomation = automationSections.values.toList();
    // Einzelnen Flex Werte
    List<int> flexValues = [];

    for (int i = 0; i < listOfSections.length; i++) {
      flexValues.add(listOfSections[i][1] - listOfSections[i][0]); // Flex Val
      // If Else um herauszufinden, ob denn blau oder net
      if (listOfAutomation[i] == true) {
        // BLAU / AUTOM
        myColor = myMiddleTurquoise;
        myHeight = 7;
      } else {
        // GRAU / NICHT AUTOM
        myColor = myDarkGrey;
        myHeight = 5;
      }
      widgetList.add(
        Flexible(
          flex: flexValues[i],
          child: Container(
            height: myHeight,
            color: myColor,
          ),
        ),
      );
    }
    // Liste An Widgets erstellen
    // Liste von Abschnitten erstellen, Liste aus Flexible mit gegebenen Flex Wert
    return Row(children: widgetList);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          // Erste Reihe mit den zwei Icons am Ende
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Icon(
                Icons.location_on,
                color: myDarkGrey,
                size: 20,
              ),
              Icon(
                Icons.flag_rounded,
                color: myDarkGrey,
                size: 20,
              )
            ],
          ),
          // Linie, zur Anzeige der Fahrabschnitte
          Consumer<FinalRoutes>(
            builder: (context, finalRoutes, child) =>
                graphLine(finalRoutes.routes[0].automationSections),
          ),
        ],
      ),
    );
  }
}

// Anzeige für die Zeit, die automatisiert gefahren werden kann bzw nicht automat
// isiert gefahren wird
class TimeTotals extends StatelessWidget {
  // Funktion, mit der die Dauer der nicht autom und Autom. Fahrzeit ausgegeben wird
  //  Muss Konstructor haben, damit die datei wieder verwertbar ist
  final int routePrioIndex;
  TimeTotals({@required this.routePrioIndex});

  List<int> getFlexValues(BuildContext context) {
    DateTime totalManual = Provider.of<FinalRoutes>(context, listen: false)
        .routes[routePrioIndex]
        .manualDuration;
    DateTime totalAutom = Provider.of<FinalRoutes>(context, listen: false)
        .routes[routePrioIndex]
        .automationDuration;
    int flexManual = totalManual.minute + totalManual.hour * 60;
    int flexAutom = totalAutom.minute + totalAutom.hour * 60;

    // Manual doppelt so groß wie Autom
    if (flexManual > 2 * flexAutom) {
      flexManual = 2;
      flexAutom = 1;
    }
    // Autom doppelt so groß wie Manual
    if (flexAutom > 2 * flexManual) {
      flexAutom = 2;
      flexManual = 1;
    }
    return [flexManual, flexAutom];
  }

  String getFormattedTime(DateTime t) {
    return "${t.hour}:${t.minute}h";
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 50,
      child: Consumer<FinalRoutes>(
        builder: (context, finalRoutes, child) => Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // MANUAL
            Expanded(
              // [0] enthält wert für manual
              flex: getFlexValues(context)[0],
              child: Container(
                decoration: BoxDecoration(
                  color: myDarkGrey,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(10),
                    topLeft: Radius.circular(10),
                  ),
                ),
                child: Center(
                  child: Text(
                    getFormattedTime(
                        Provider.of<FinalRoutes>(context, listen: false)
                            .routes[routePrioIndex]
                            .manualDuration),
                    style: TextStyle(fontSize: 17, color: myWhite),
                  ),
                ),
              ),
            ),
            // AUTOM
            Expanded(
              // [1] enthält flex für Autom
              flex: getFlexValues(context)[1],
              child: Container(
                decoration: BoxDecoration(
                  color: myMiddleTurquoise,
                  borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(10),
                    topRight: Radius.circular(10),
                  ),
                ),
                child: Center(
                  child: Text(
                    getFormattedTime(
                        Provider.of<FinalRoutes>(context, listen: false)
                            .routes[routePrioIndex]
                            .automationDuration),
                    style: TextStyle(fontSize: 17, color: myWhite),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/*
Row(
                  children: [
                    // Container für die Anzeige der Gesamt Manuel Fahrzeit
                    Container(
                      padding: EdgeInsets.fromLTRB(30, 2, 30, 2),
                      decoration: BoxDecoration(
                        color: myDarkGrey,
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(10),
                          topLeft: Radius.circular(10),
                        ),
                      ),
                      child: Center(
                        child: Text(
                          "${totalManual.hour}:${totalManual.minute}h",
                          style: TextStyle(
                            color: myWhite,
                          ),
                        ),
                      ),
                    ),
                    // Container für die Anzeig der gesamt Automation Fahrzeit
                    Container(
                      padding: EdgeInsets.fromLTRB(30, 2, 30, 2),
                      decoration: BoxDecoration(
                        color: myMiddleTurquoise,
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(10),
                          bottomRight: Radius.circular(10),
                        ),
                      ),
                      child: Center(
                        child: Text(
                          "${totalAutomation.hour}:${totalAutomation.minute}h",
                          style: TextStyle(
                            color: myWhite,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
*/

/*


  @override
  Widget build(BuildContext context) {
    return Consumer<AutomationSections>(
      builder: (context, automationSections, chil) => Expanded(
        child: Container(
          padding: EdgeInsets.only(right: 20),
          child: Row(
            children: [
              // Manuelle Fahrzeit
              ConstrainedBox(
                constraints: BoxConstraints(minWidth: 60),
                child: Expanded(
                  flex: automationSections.totalManual.minute +
                      automationSections.totalManual.hour * 60,
                  child: Container(
                    decoration: BoxDecoration(
                      color: myDarkGrey,
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(10),
                        topLeft: Radius.circular(10),
                      ),
                    ),
                    child: Center(
                      child: Text(
                        "${automationSections.totalManual.hour} : ${automationSections.totalManual.minute}h",
                        style: TextStyle(fontSize: 17, color: myWhite),
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: automationSections.totalAutom.minute +
                    automationSections.totalAutom.hour * 60,
                child: Container(
                  decoration: BoxDecoration(
                    color: myMiddleTurquoise,
                    borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(10),
                      topRight: Radius.circular(10),
                    ),
                  ),
                  child: Center(
                    child: Text(
                      "${automationSections.totalAutom.hour} : ${automationSections.totalAutom.minute}h",
                      style: TextStyle(fontSize: 17, color: myWhite),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );

*/
