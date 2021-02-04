import 'package:flutter/material.dart';
import 'package:routenplaner/data/custom_colors.dart';
import 'package:provider/provider.dart';
import 'package:routenplaner/provider_classes/final_routes.dart';

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
  bool showTimes = false;

  final _transformationController = TransformationController();
  TapDownDetails _doubleTapDetails;

  void _handleDoubleTapDown(TapDownDetails details) {
    _doubleTapDetails = details;
  }

  void _handleDoubleTap() {
    // Zoom out
    if (_transformationController.value != Matrix4.identity()) {
      _transformationController.value = Matrix4.identity();
      setState(() {
        showTimes = false;
      });
    }
    // Zoom in
    else {
      final position = _doubleTapDetails.localPosition;
      // For a 3x zoom
      _transformationController.value = Matrix4.identity()
        ..translate(-position.dx * 2, -position.dy * 2)
        ..scale(3.0);
      // Fox a 2x zoom
      // ..translate(-position.dx, -position.dy)
      // ..scale(2.0);
      setState(() {
        showTimes = true;
      });
    }
  }

  // Gebe eine Reihe von Drei Columns zurück, 1. Column ist icon + start, dann Linie + Zeiten
  // dann icon + ende
  Widget graphLine(
      Map<List<int>, bool> automationSections, DateTime start, DateTime end) {
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
    // Textstyle, wird immer wieder verwendet
    var smallTextStyle = TextStyle(
      color: myDarkGrey,
      fontSize: 6,
    );

    // Füge das Start Icon + Zeitr am Anfang der Linie hinzu
    widgetList.add(
      Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.location_on,
            color: myDarkGrey,
            size: 20,
          ),
          showTimes
              ? Text(
                  "${start.hour.toString().padLeft(2, '0')}:${start.minute.toString().padLeft(2, '0')}",
                  style: smallTextStyle,
                )
              : Container(),
        ],
      ),
    );

    // Erstelle die Reihe mit den Segmenten
    for (int i = 0; i < listOfSections.length; i++) {
      flexValues
          .add(listOfSections[i][1] - listOfSections[i][0] + 1); // Flex Val
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
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                height: myHeight,
                color: myColor,
              ),
            ],
          ),
        ),
      );
    }
    // Füge die Fahne + Zeit am Ende hinzu
    widgetList.add(
      Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.flag_rounded,
            color: myDarkGrey,
            size: 20,
          ),
          showTimes
              ? Text(
                  "${end.hour.toString().padLeft(2, '0')}:${end.minute.toString().padLeft(2, '0')}",
                  style: smallTextStyle,
                )
              : Container(),
        ],
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
      onDoubleTap: _handleDoubleTap,
      onDoubleTapDown: _handleDoubleTapDown,
      child: Container(
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
            transformationController: _transformationController,
            onInteractionEnd: (details) {
              // Gibt die TrafoMatrix einträge zurück, wenn voll eingezoomed
              // dann sind die DIagonaleneinträge, bis auf den Letzten, bei 2.57
              if (_transformationController.value.row0.x > 2) {
                setState(() {
                  showTimes = true;
                });
              } else if (showTimes == true) {
                setState(() {
                  showTimes = false;
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
