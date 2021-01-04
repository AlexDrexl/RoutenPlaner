import 'package:flutter/material.dart';
import 'package:routenplaner/data/custom_colors.dart';
import 'package:provider/provider.dart';
import 'package:routenplaner/provider_classes/travel_profile_modifier.dart';
import 'dart:math';

class DragComplex extends StatefulWidget {
  final BuildContext context;
  final int indexProfile;
  DragComplex({@required this.context, @required this.indexProfile});
  @override
  _DragComplexState createState() => _DragComplexState(context, indexProfile);
}

// Funktion, die die verschiedenen Targets erstellt, an der richtigen Position
// mitschreiben der Aktuellen Position in einer Liste/ Map
// Erstelle die Builder in den Targets nach dieser Liste, ist also das Widget im
// Moment an dieser Stelle??
// bei onAccepted wird die Liste/Map aktualisiert, und dann basierend aus dieser
// Liste die Widgets neu aufgebaut
class _DragComplexState extends State<DragComplex> {
  // Map mit Koordinaten und dazugehörig ob denn dort ein Widget vorhanden ist
  // oder nicht
  var targetMap = Map<List<double>, bool>();
  double height;
  double width;
  int currentDragTargetIndex = 6;
  int indexProfile;
  _DragComplexState(BuildContext context, this.indexProfile) {
    double width = (MediaQuery.of(context).size.width - 150); // Um die 311
    double height = (width * sqrt(3) / 2) - 30;
    targetMap = {
      // Breite, Höhe : widget da oder nicht
      [0, 0]: false,
      [width / 2, 0]: false,
      [width, 0]: false,
      [width / 4, height / 6]: false,
      [width / 2, height / 6]: false,
      [3 * width / 4, height / 6]: false,
      [width / 2, height / 3]: false, // StartPunkt
      [3 * width / 8, 5 * height / 12]: false,
      [5 * width / 8, 5 * height / 12]: false,
      [width / 4, height / 2]: false,
      [3 * width / 4, height / 2]: false,
      [width / 2, 2 * height / 3]: false,
      [width / 2, height]: false,
    };
    // Setze den Startwert, der im Profile Objekt gespeichert wird
    var i = Provider.of<TravelProfileDetailModifier>(context, listen: false)
        .getIndexTriangle();
    currentDragTargetIndex = i;
    var listCoord = targetMap.keys.toList();
    targetMap.update(listCoord[i], (value) => true);
  }
  // Evtl Löschen
  void resetTargetMap(double width, double height) {
    targetMap = {
      // Breite, Höhe : widget da oder nicht
      [0, 0]: false,
      [width / 2, 0]: false,
      [width, 0]: false,
      [width / 4, height / 6]: false,
      [width / 2, height / 6]: false,
      [3 * width / 4, height / 6]: false,
      [width / 2, height / 3]: false, // StartPunkt
      [3 * width / 8, 5 * height / 12]: false,
      [5 * width / 8, 5 * height / 12]: false,
      [width / 4, height / 2]: false,
      [3 * width / 4, height / 2]: false,
      [width / 2, 2 * height / 3]: false,
      [width / 2, height]: false,
    };
  }

  Stack printTargets(double width, double height) {
    List<Widget> widgetList = List<Widget>();
    var listCoord = targetMap.keys.toList();
    var listBool = targetMap.values.toList();
    for (int i = 0; i < targetMap.length; i++) {
      widgetList.add(
        Positioned(
          left: listCoord[i][0], // Breite
          bottom: listCoord[i][1], // Höhe
          child: Container(
            height: 50,
            width: 50,
            // color: Colors.red,
            child: DragTarget(
              builder: (context, _, __) {
                return listBool[i] ? CustomDraggable() : Container();
              },
              onWillAccept: (data) {
                return true;
              },
              onAccept: (data) {
                // Provider den Index übergeben. wird dann von diesem zu Zahlen
                // interpretiert
                Provider.of<TravelProfileDetailModifier>(context, listen: false)
                    .setIndexTriangle(indexTriangle: i);

                targetMap.update(
                    listCoord[currentDragTargetIndex], (value) => false);
                targetMap.update(listCoord[i], (value) => true);
                currentDragTargetIndex = i;
                setState(() {});
              },
            ),
          ),
        ),
      );
    }
    return Stack(
      children: widgetList,
    );
  }

  @override
  Widget build(BuildContext context) {
    return printTargets(width, height);
  }
}

class CustomDraggable extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Draggable(
      child: CircleAvatar(
        radius: 20,
        backgroundColor: myMiddleTurquoise,
        child: Icon(
          Icons.touch_app,
          color: myWhite,
        ),
      ),
      // Feedback ist das, was man während dem verschieben sieht
      feedback: CircleAvatar(
        radius: 20,
        backgroundColor: myMiddleTurquoise,
        child: Icon(
          Icons.touch_app,
          color: myWhite,
        ),
      ),
    );
  }
}
