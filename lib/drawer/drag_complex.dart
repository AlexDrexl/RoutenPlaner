import 'package:flutter/material.dart';
import 'package:routenplaner/data/custom_colors.dart';
import 'package:provider/provider.dart';
import 'package:routenplaner/provider_classes/travel_profile_modifier.dart';
import 'dart:math';
import 'package:vector_math/vector_math.dart' as vec;

class DragComplex extends StatefulWidget {
  final BuildContext context;
  final double width, height;
  final int indexProfile;
  DragComplex(
      {@required this.context,
      @required this.height,
      @required this.width,
      @required this.indexProfile});
  @override
  _DragComplexState createState() => _DragComplexState(
      context: context,
      height: height,
      width: width,
      indexProfile: indexProfile);
}

class _DragComplexState extends State<DragComplex> {
  int indexProfile;
  double width, height;
  Offset theoreticalPosition = Offset(0, 0);
  Offset positionIcon;
  vec.Vector2 positionMiddle;
  GlobalKey key;
  double radiusIcon = 20;
  vec.Vector2 vecPoint,
      vecLeft,
      vecBottom,
      vecRight,
      pointLeftStart,
      pointBottomStart,
      pointRightStart;
  _DragComplexState(
      {BuildContext context, this.height, this.width, this.indexProfile}) {
    // Mittelposition
    positionMiddle = vec.Vector2(width / 2, (width / 2) * tan(pi * 1 / 6));

    // Drei Vektoren der drei Dreiecksseiten
    vecLeft = vec.Vector2(cos(pi * 1 / 3), sin(pi * 1 / 3)).normalized();
    vecBottom = vec.Vector2(1, 0).normalized();
    vecRight = vec.Vector2(-cos(pi * 1 / 3), sin(pi * 1 / 3)).normalized();

    // Drei Startpunkte für die Unsichtbaren Grenzgeraden
    // Unsichtbare Grenzgeraden nötig, damit das Icon innerhalbd des Dreiecks bleibt
    // Sind die Schnittpunkte mit der y Achse
    pointLeftStart = vec.Vector2(0, -radiusIcon / sin(pi * 1 / 6));
    pointBottomStart = vec.Vector2(0, radiusIcon);
    pointRightStart = vec.Vector2(
        0, (-radiusIcon / sin(pi / 6)) - (vecRight.y / vecRight.x) * width);

    // Bestimme die theoretische Position des Icons
    theoreticalPosition =
        Provider.of<TravelProfileDetailModifier>(context, listen: false)
            .getTrianglePosition(Offset(width, height));

    // Setze die Position des Icons etwas daneben, sodass zentriert
    positionIcon = Offset(theoreticalPosition.dx - radiusIcon,
        theoreticalPosition.dy - radiusIcon);
  }

  // Dreiecksdaten
  Offset getOldPosition() {
    RenderBox box = key.currentContext.findRenderObject();
    return box.localToGlobal(Offset.zero);
  }

  // Überprüfe, ob das Icon ausserhalb des Dreiecks
  Offset checkPosition(double x, double y) {
    var vecPoint = vec.Vector2(x, y);
    if (outOfBound(vecPoint)) {
      vecPoint = getclosestIntersection(vecPoint);
    }
    return Offset(vecPoint.x, vecPoint.y);
  }

  // Sche Schnittpunkt mit einer der Dreiecksseiten
  vec.Vector2 getclosestIntersection(vec.Vector2 point) {
    // Berechne den Winkel, den Mid zu Point zur x achse hat. Lese daran ab, in welchen Abschnitt
    var phiInDegrees = 180 +
        atan2((point - positionMiddle).y, (point - positionMiddle).x) *
            180 /
            pi;
    var mPointToMid =
        (point.y - positionMiddle.y) / (point.x - positionMiddle.x);
    var tPointToMid = positionMiddle.y - mPointToMid * positionMiddle.x;
    // Im unteren Teil
    if (phiInDegrees >= 30 && phiInDegrees < 150) {
      return getIntersection(
          m1: vecBottom.y / vecBottom.x,
          t1: pointBottomStart.y,
          m2: mPointToMid,
          t2: tPointToMid);
    }
    // Im rechten Teil
    if (phiInDegrees >= 150 && phiInDegrees < 270) {
      return getIntersection(
          m1: vecRight.y / vecRight.x,
          t1: pointRightStart.y,
          m2: mPointToMid,
          t2: tPointToMid);
    }
    // Im Linken Teil
    if (phiInDegrees >= 270 && phiInDegrees < 360 ||
        phiInDegrees >= 0 && phiInDegrees < 30) {
      return getIntersection(
        m1: vecLeft.y / vecLeft.x,
        t1: pointLeftStart.y,
        m2: mPointToMid,
        t2: tPointToMid,
      );
    }
    return positionMiddle;
  }

  // a1*x+b1 = a2*x+b2
  vec.Vector2 getIntersection({double m1, double t1, double m2, double t2}) {
    var x = (t2 - t1) / (m1 - m2);
    var y = m1 * x + t1;
    return vec.Vector2(x, y);
  }

  bool outOfBound(vec.Vector2 posIcon) {
    // Funktion mx+t erstellen
    // m = vec.y/vec.x
    // t = vecStart.y
    if (vecLeft.y / vecLeft.x * posIcon.x + pointLeftStart.y < posIcon.y)
      return true;
    if (vecRight.y / vecRight.x * posIcon.x + pointRightStart.y < posIcon.y)
      return true;
    if (pointBottomStart.y > posIcon.y) return true;
    return false;
  }

  @override
  Widget build(BuildContext context) {
    // hier: width: 311.42857142857144
    // hier: height: 269.70505432143943
    key = GlobalKey();
    return Stack(
      children: [
        Positioned(
          left: positionIcon.dx,
          bottom: positionIcon.dy,
          child: Draggable(
            child: Stack(
              children: [
                Container(
                  key: key,
                  width: 10,
                  height: 10,
                  //color: Colors.blue,
                  child: Container(),
                ),
                CircleAvatar(
                  radius: radiusIcon,
                  backgroundColor: myMiddleTurquoise,
                  child: Icon(
                    Icons.touch_app,
                    color: myWhite,
                  ),
                ),
              ],
            ),
            feedback: CircleAvatar(
              radius: 20,
              backgroundColor: myMiddleTurquoise,
              child: Icon(
                Icons.touch_app,
                color: myWhite,
              ),
            ),
            onDraggableCanceled: (Velocity velocity, Offset offset) {
              setState(() {
                var oldPostion = getOldPosition();
                var newPosition = offset;
                var dx = newPosition.dx - oldPostion.dx;
                var dy = oldPostion.dy - newPosition.dy;
                // Rechne mit theoretic position weiter!
                theoreticalPosition = checkPosition(
                    theoreticalPosition.dx + dx, theoreticalPosition.dy + dy);
                positionIcon = Offset(theoreticalPosition.dx - radiusIcon,
                    theoreticalPosition.dy - radiusIcon);
                Provider.of<TravelProfileDetailModifier>(context, listen: false)
                    .setTriangleFactors(
                        theoreticalPosition, Offset(width, height));
                print(theoreticalPosition);
              });
            },
          ),
        ),
      ],
    );
  }
}
