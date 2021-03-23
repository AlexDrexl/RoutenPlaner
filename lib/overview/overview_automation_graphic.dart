import 'package:flutter/material.dart';
import 'package:routenplaner/data/custom_colors.dart';
import 'package:provider/provider.dart';
import 'package:routenplaner/provider_classes/final_routes.dart';

// Grafik für die dynamische Übersicht über die Automationslängen
class AutomationGraphic extends StatefulWidget {
  // Map mit Liste an Start/Ende Zeitabschnitte, und dazugehörig bool ob Autom oder nicht
  final int routeIndex;
  AutomationGraphic({@required this.routeIndex});

  @override
  _AutomationGraphicState createState() => _AutomationGraphicState();
}

class _AutomationGraphicState extends State<AutomationGraphic>
    with TickerProviderStateMixin {
  bool zoomIn = false;
  int zoomFactor = 1;
  int maxZoom;
  double height, width;
  ScrollController scrollController = ScrollController();

  // Bestimmt ob rein oder rausgezoomt werden soll, Regelt Zoom Stufen
  void zoom({Offset targetPosition}) {
    zoomIn = !zoomIn;
    setState(() {
      // Reinzoomen
      if (zoomIn) {
        zoomFactor = maxZoom;
        if (targetPosition != null) {
          // Zielposition -1, warum nicht ganz klar
          scrollController.jumpTo(targetPosition.dx * (zoomFactor - 1));
        }
        return;
      }
      zoomFactor = 1;
    });
  }

  // Gebe eine Reihe von Drei Columns zurück, 1. Column ist icon + start, dann Linie + Zeiten
  // dann icon + ende
  Widget graphLine(BuildContext context) {
    // Daten aus Provider
    Map<List<int>, int> automationSections =
        Provider.of<FinalRoutes>(context, listen: false)
            .routes[widget.routeIndex]
            .automationSections;
    DateTime start = Provider.of<FinalRoutes>(context, listen: false)
        .routes[widget.routeIndex]
        .startDateTime;
    DateTime end = Provider.of<FinalRoutes>(context, listen: false)
        .routes[widget.routeIndex]
        .arrivalDateTime;

    // Liste der Widgets
    List<Widget> widgetList = [];
    List<Widget> widgetListGraph = [];
    List<Widget> widgetListTimeTop = [];
    List<Widget> widgetListTimeBottom = [];
    // Werte für die Höhe der Balken
    double heightManual = 5;
    double heightAutom = 6;
    double heightTermAutom = 7;
    // Wenn Reingezoomed, dann Balken größer
    if (zoomIn) {
      heightManual = 15;
      heightAutom = 18;
      heightTermAutom = 20;
    }

    // Liste mit den Start/End Einträgen
    var listOfSections = automationSections.keys.toList();
    // Liste mit Bool, ob autom oder nicht
    List<int> listOfAutomation = automationSections.values.toList();
    // Einzelnen Flex Werte
    List<int> flexValues = [];
    // Textstyle, wird immer wieder verwendet
    var customTextStyle = TextStyle(
      color: myDarkGrey,
      fontSize: 15,
    );

    // Füge das Start Icon + Zeit am Anfang der Linie hinzu
    widgetList.add(
      Expanded(
        flex: 1,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.location_on,
              color: myDarkGrey,
              size: zoomIn ? 40 : 20,
            ),
            zoomIn
                ? Text(
                    "${start.hour.toString().padLeft(2, '0')}:${start.minute.toString().padLeft(2, '0')}",
                    style: customTextStyle,
                  )
                : Container(),
          ],
        ),
      ),
    );

    // Erstelle die Reihe mit den Grafik Segmenten
    for (int i = 0; i < listOfSections.length; i++) {
      flexValues
          .add(listOfSections[i][1] - listOfSections[i][0] + 1); // Flex Val
      widgetListGraph.add(
        Expanded(
          flex: flexValues[i],
          child: Container(
            height: listOfAutomation[i] == 2
                ? heightTermAutom
                : listOfAutomation[i] == 1
                    ? heightAutom
                    : heightManual,
            color: listOfAutomation[i] == 2
                ? myDarkTurquoise
                : listOfAutomation[i] == 1
                    ? myMiddleTurquoise
                    : myDarkGrey,
          ),
        ),
      );
    }

    // Liste mit den Segmente für die Zeit, oben
    for (int i = 0; i < listOfSections.length - 1; i += 2) {
      // Flex bis dahin aufaddieren
      var flexRaw = 0.0; // Im endeffekt auch gleich die dauer bis dahin
      var flexTotal = flexValues.fold(0, (p, e) => p + e);
      for (int j = 0; j <= i; j++) {
        flexRaw += flexValues[j];
      }
      var time = start.add(Duration(minutes: flexRaw.toInt()));
      widgetListTimeTop.add(
        Align(
          alignment: Alignment((2 * flexRaw / flexTotal) - 1, 0),
          child: Container(
            child: Text(
              "${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}",
              style: customTextStyle,
            ),
          ),
        ),
      );
    }
    // Liste für Zeitangaben unten
    for (int i = 1; i < listOfSections.length - 1; i += 2) {
      // Flex bis dahin aufaddieren
      var flexRaw = 0.0; // Im endeffekt auch gleich die dauer bis dahin
      var flexTotal = flexValues.fold(0, (p, e) => p + e);
      for (int j = 0; j <= i; j++) {
        flexRaw += flexValues[j];
      }
      var time = start.add(Duration(minutes: flexRaw.toInt()));
      widgetListTimeBottom.add(
        Align(
          alignment: Alignment((2 * flexRaw / flexTotal) - 1, 0),
          child: Container(
            child: Text(
              "${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}",
              style: customTextStyle,
            ),
          ),
        ),
      );
    }
    // Füge Zeiten und Graph der Liste hinzu
    widgetList.add(
      Expanded(
        flex: 10,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              // height: 10,
              child: zoomIn ? Stack(children: widgetListTimeTop) : Container(),
            ),
            Row(
              children: widgetListGraph,
            ),
            Container(
              // height: 10,
              child:
                  zoomIn ? Stack(children: widgetListTimeBottom) : Container(),
            ),
          ],
        ),
      ),
    );

    // Füge die Fahne + Zeit am Ende hinzu
    widgetList.add(
      Expanded(
        flex: 1,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.flag_rounded,
              color: myDarkGrey,
              size: zoomIn ? 40 : 20,
            ),
            zoomIn
                ? Text(
                    "${end.hour.toString().padLeft(2, '0')}:${end.minute.toString().padLeft(2, '0')}",
                    style: customTextStyle,
                  )
                : Container(),
          ],
        ),
      ),
    );
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: widgetList,
    );
  }

  @override
  Widget build(BuildContext context) {
    var lenghtInHour = Provider.of<FinalRoutes>(context, listen: false)
        .routes[widget.routeIndex]
        .duration
        .inHours;
    // Zoom Faktor abhängig von der Gesamtzeit, minimal 3
    maxZoom = 3;
    if (lenghtInHour > 3) {
      maxZoom = lenghtInHour;
    }
    // GEsture Detector benötigt um Doppeltippen zu erkennen
    return GestureDetector(
      onDoubleTap: () {},
      // Wenn der nutzer nach dem Zweiten Tippen den Finger vom Bildschirm lässt
      onDoubleTapDown: (details) {
        print(details.localPosition);
        zoom(targetPosition: details.localPosition);
      },
      child: Stack(
        fit: StackFit.loose,
        children: [
          Container(
            height: 120,
            decoration: BoxDecoration(
              color: myWhite,
              border: Border.all(width: 0, color: myDarkGrey),
              borderRadius: BorderRadius.all(
                Radius.circular(10),
              ),
            ),
            child: LayoutBuilder(
              builder: (context, constraints) {
                height = constraints.maxHeight;
                width = constraints.maxWidth;
                return Container(
                  height: constraints.maxHeight,
                  width: constraints.maxWidth,
                  child: Scrollbar(
                    thickness: 8,
                    controller: scrollController,
                    child: ListView.builder(
                      controller: scrollController,
                      scrollDirection: Axis.horizontal,
                      itemCount: 1,
                      itemBuilder: (context, index) => Container(
                        height: constraints.maxHeight,
                        width: constraints.maxWidth * zoomFactor,
                        child: graphLine(context),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Align(
            alignment: Alignment.topRight,
            child: GestureDetector(
              onTap: () => zoom(),
              child: Container(
                padding: EdgeInsets.only(right: 10, top: 10), //10, 10
                child: Icon(
                  zoomIn ? Icons.zoom_out : Icons.zoom_in,
                  color: iconColor,
                  size: 30,
                ),
              ),
            ),
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
  final int routeIndex;
  TimeTotals({@required this.routeIndex});

  List<int> getFlexValues(BuildContext context) {
    Duration totalManual = Provider.of<FinalRoutes>(context, listen: false)
        .routes[routeIndex]
        .manualDuration;
    Duration totalAutom = Provider.of<FinalRoutes>(context, listen: false)
        .routes[routeIndex]
        .automationDuration;
    int flexManual = totalManual.inMinutes;
    int flexAutom = totalAutom.inMinutes;

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
    return "${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}h";
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 50,
      child: Consumer<FinalRoutes>(
        builder: (context, finalRoutes, child) => Column(
          children: [
            Row(
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
                        finalRoutes.getFormattedTime(
                            finalRoutes.routes[routeIndex].manualDuration),
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
                        finalRoutes.getFormattedTime(
                            finalRoutes.routes[routeIndex].automationDuration),
                        style: TextStyle(fontSize: 17, color: myWhite),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            // Gesamte Fahrzeit
            SizedBox(
              height: 15,
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Gesamtfahrzeit: ${finalRoutes.getFormattedTime(finalRoutes.routes[routeIndex].duration)} h",
                style: TextStyle(
                  color: myDarkGrey,
                  fontSize: 15,
                ),
              ),
            ),
            SizedBox(
              height: 5,
            ),

            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Ankunftszeit: ${finalRoutes.routes[routeIndex].arrivalDateTime.hour.toString().padLeft(2, '0')}:${finalRoutes.routes[routeIndex].arrivalDateTime.minute.toString().padLeft(2, '0')} Uhr",
                style: TextStyle(
                  color: myDarkGrey,
                  fontSize: 15,
                ),
              ),
            ),
            SizedBox(
              height: 5,
            ),

            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Wechsel: ${finalRoutes.routes[routeIndex].automationSections.length - 1}",
                style: TextStyle(
                  color: myDarkGrey,
                  fontSize: 15,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
