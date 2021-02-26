import 'package:flutter/material.dart';
import 'package:routenplaner/data/custom_colors.dart';
import 'package:provider/provider.dart';
import 'package:routenplaner/controller/final_routes.dart';

// Automationsgrafik, basierend auf den Automationsabschnitten in einer Map
// start : ende

// Grafik für die dynamische Übersicht über die Automationslängen
class AutomationGraphic extends StatefulWidget {
  // Map mit Liste an Start/Ende Zeitabschnitte, und dazugehörig bool ob Autom oder nicht
  // zeit in Min
  final int routeIndex;
  AutomationGraphic({@required this.routeIndex});

  @override
  _AutomationGraphicState createState() => _AutomationGraphicState();
}

class _AutomationGraphicState extends State<AutomationGraphic>
    with TickerProviderStateMixin {
  final routeLetter = "A";
  bool zoomIn = false;
  GlobalKey key = GlobalKey();

  final transformationController = TransformationController();
  // TapDownDetails doubleTapDetails;
  var position = Offset(0, 0);

  void tabDownSetPosition(Offset locPosition) {
    position = locPosition;
  }

  void zoom() {
    // Zoom out
    if (transformationController.value != Matrix4.identity()) {
      transformationController.value = Matrix4.identity();
      setState(() {
        zoomIn = false;
      });
    }
    // Zoom in
    else {
      // For a 3x zoom
      transformationController.value = Matrix4.identity()
        ..translate(-position.dx * 2, -position.dy * 2)
        ..scale(3.0);
      // Fox a 2x zoom
      // ..translate(-position.dx, -position.dy)
      // ..scale(2.0);
      setState(() {
        zoomIn = true;
      });
    }
  }

  // Gebe eine Reihe von Drei Columns zurück, 1. Column ist icon + start, dann Linie + Zeiten
  // dann icon + ende
  Widget graphLine(
      Map<List<int>, int> automationSections, DateTime start, DateTime end) {
    // Liste der Widgets
    List<Widget> widgetList = [];
    List<Widget> widgetListGraph = [];
    List<Widget> widgetListTimeTop = [];
    List<Widget> widgetListTimeBottom = [];
    // Liste mit den Start/End Einträgen
    var listOfSections = automationSections.keys.toList();
    // Liste mit Bool, ob autom oder nicht
    List<int> listOfAutomation = automationSections.values.toList();
    // Einzelnen Flex Werte
    List<int> flexValues = [];
    // Textstyle, wird immer wieder verwendet
    var smallTextStyle = TextStyle(
      color: myDarkGrey,
      fontSize: 6,
    );

    // Füge das Start Icon + Zeitr am Anfang der Linie hinzu
    widgetList.add(
      Expanded(
        flex: 1,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.location_on,
              color: myDarkGrey,
              size: 20,
            ),
            zoomIn
                ? Text(
                    "${start.hour.toString().padLeft(2, '0')}:${start.minute.toString().padLeft(2, '0')}",
                    style: smallTextStyle,
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
                  ? 7
                  : listOfAutomation[i] == 1
                      ? 6
                      : 5,
              color: listOfAutomation[i] == 2
                  ? myDarkTurquoise
                  : listOfAutomation[i] == 1
                      ? myMiddleTurquoise
                      : myDarkGrey),
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
            style: smallTextStyle,
          )),
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
              style: smallTextStyle,
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
              height: 10,
              child: zoomIn ? Stack(children: widgetListTimeTop) : Container(),
            ),
            Row(
              children: widgetListGraph,
            ),
            Container(
              height: 10,
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
              size: 20,
            ),
            zoomIn
                ? Text(
                    "${end.hour.toString().padLeft(2, '0')}:${end.minute.toString().padLeft(2, '0')}",
                    style: smallTextStyle,
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
    // GEsture Detector benötigt um das Scrollen zu verhindern
    // dadurch kein Gesture disambiguation
    return GestureDetector(
      onTap: () {
        // NeverScrollableScrollPhysics();
      },
      onVerticalDragStart: (DragStartDetails _) {
        // NeverScrollableScrollPhysics();
      },
      onDoubleTap: () => zoom(),
      // Wenn der nutzer nach dem Zweiten Tippen den Finger vom Bildschirm lässt
      onDoubleTapDown: (details) {
        tabDownSetPosition(details.localPosition);
      },
      child: Stack(
        key: key,
        fit: StackFit.loose,
        children: [
          Container(
            height: 150,
            decoration: BoxDecoration(
              color: myWhite,
              border: Border.all(width: 0, color: myDarkGrey),
              borderRadius: BorderRadius.all(
                Radius.circular(14),
              ),
            ),
            child: ClipRect(
              child: InteractiveViewer(
                transformationController: transformationController,
                onInteractionEnd: (details) {
                  // Gibt die TrafoMatrix einträge zurück, wenn voll eingezoomed
                  // dann sind die DIagonaleneinträge, bis auf den Letzten, bei 2.57
                  if (transformationController.value.row0.x > 2) {
                    setState(() {
                      zoomIn = true;
                    });
                  } else if (zoomIn == true) {
                    setState(() {
                      zoomIn = false;
                    });
                  }
                },
                child: Container(
                  child: graphLine(
                      Provider.of<FinalRoutes>(context, listen: false)
                          .routes[widget.routeIndex]
                          .automationSections,
                      Provider.of<FinalRoutes>(context, listen: false)
                          .routes[widget.routeIndex]
                          .startDateTime,
                      Provider.of<FinalRoutes>(context, listen: false)
                          .routes[widget.routeIndex]
                          .arrivalDateTime),
                  constraints: BoxConstraints.expand(),
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.topRight,
            child: GestureDetector(
              onTapDown: (details) {
                Offset center = Offset(details.localPosition.dx - 10,
                    details.localPosition.dy + 50);
                tabDownSetPosition(center);
              },
              onTap: () => zoom(),
              child: Container(
                padding: EdgeInsets.only(right: 10, top: 10),
                child: Icon(
                  zoomIn ? Icons.zoom_out : Icons.zoom_in,
                  color: iconColor,
                  size: 40,
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
