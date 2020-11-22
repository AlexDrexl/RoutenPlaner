import 'package:flutter/material.dart';
import 'package:routenplaner/data/custom_colors.dart';
import 'dart:math';

// Idee ist einen Path zu legen, der aber jeden zweiten Abschnitt überspringt
class DashedLine extends CustomPainter {
  final Color strokeColor = myMiddleGrey;
  final double strokeWidth = 2;
  final String start;
  DashedLine({@required this.start});

  @override
  void paint(Canvas canvas, Size size) {
    var list = getOffsetList(size.width, size.height);
    final paint = Paint()
      ..color = strokeColor
      ..strokeWidth = strokeWidth;

    bool draw = true;

    for (int i = 0; i < (list.length) - 1; i++) {
      if (draw) {
        canvas.drawLine(list[i], list[i + 1], paint);
        draw = false;
      } else {
        draw = true;
      }
    }
  }

  // x und y sind nur Pixelpunkte. x ist breite, y ist höhe,
  // 0 ist oben links, y und x in Positive richtung nach unten bzw. nach rechts
  List<Offset> getOffsetList(double width, double height) {
    // Switch Case, um
    List<Offset> offsetList = List<Offset>();
    // Ersten Punkt in die Mitte des Dreiecks legen
    double pitch = (3 / sqrt(3));
    switch (start) {
      case "left":
        {
          for (double i = 0; i < height / 3; i += 4) {
            offsetList.add(Offset((width / 2) + i * pitch, (height / 1.5) + i));
          }
        }
        break;
      case "right":
        {
          for (double i = 0; i < height / 3; i += 4) {
            offsetList.add(Offset((width / 2) - i * pitch, (height / 1.5) + i));
          }
        }
        break;
      case "top":
        {
          for (double i = 0; i < (2 * height) / 3; i += 8) {
            offsetList.add(Offset(width / 2, (height / 1.5) - i));
          }
        }
        break;
    }
    return offsetList;
  }

  @override
  bool shouldRepaint(DashedLine oldDelegate) {
    return oldDelegate.strokeColor != strokeColor ||
        oldDelegate.strokeWidth != strokeWidth;
  }
}
