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
    // print(MediaQuery.of(context).size.width);
    // print(MediaQuery.of(context).size.height);
    return Container(
      // Stack, damit man die einzelnen Elemente übereinande legen kann
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
            // Verwende Layout builder um Zugriff auf die Größe der Widgets zu haben
            // Seitenverhältnis durch Aspectration schon voher bestimmt
            child: LayoutBuilder(
              builder: (context, constraints) {
                return DragComplex(
                  context: context,
                  height: constraints.maxHeight,
                  width: constraints.maxWidth,
                  indexProfile: indexProfile,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
