import 'package:flutter/material.dart';
import 'package:routenplaner/data/custom_colors.dart';
import 'package:routenplaner/drawer/drag_complex.dart';
import 'package:routenplaner/drawer/input_dashed_line.dart';
import 'package:routenplaner/drawer/triangle_painter.dart';
import 'triangle_painter.dart';

class InputTriangle extends StatefulWidget {
  final int indexProfile;
  InputTriangle({@required this.indexProfile});
  @override
  _InputTriangleState createState() => _InputTriangleState(indexProfile);
}

class _InputTriangleState extends State<InputTriangle> {
  bool isSuccessful = false;
  int indexProfile;
  _InputTriangleState(this.indexProfile);

  @override
  Widget build(BuildContext context) {
    return Container(
      // Stack, damit man
      child: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          CustomPaint(
            painter: TrianglePainter(
                strokeColor: myLightGrey,
                paintingStyle: PaintingStyle.fill,
                strokeWidth: 0),
          ),
          CustomPaint(
            painter: TrianglePainter(
                strokeColor: myDarkGrey,
                paintingStyle: PaintingStyle.stroke,
                strokeWidth: 3),
          ),
          CustomPaint(
            painter: DashedLine(start: "right"),
          ),
          CustomPaint(
            painter: DashedLine(start: "left"),
          ),
          CustomPaint(
            painter: DashedLine(start: "top"),
          ),
          Container(
            child: DragComplex(
              context: context,
              indexProfile: indexProfile,
            ),
          ),
          // Um Widget bei unterem Drittel zu Plazieren werden Expanded verwendet
          /*
          Column(
            children: <Widget>[
              Expanded(
                flex: 3,
                child: Container(),
              ),
              // Expanded für das Drag Element
              Expanded(
                flex: 2,
                child: Align(
                  alignment: Alignment.center,
                  child: Draggable(
                    child: CircleAvatar(
                      backgroundColor: myMiddleTurquoise,
                      child: Icon(
                        Icons.touch_app,
                        color: myWhite,
                      ),
                    ),
                    feedback: CircleAvatar(
                      backgroundColor: myMiddleTurquoise,
                      child: Icon(
                        Icons.touch_app,
                        color: myWhite,
                      ),
                    ),
                    childWhenDragging: Container(),
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Container(),
              ),
            ],
          ),
          */
        ],
      ),
    );
  }
}
