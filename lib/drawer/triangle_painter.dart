import 'package:flutter/material.dart';
import 'package:routenplaner/data/custom_colors.dart';

class TrianglePainter extends CustomPainter {
  final Color strokeColor;
  final PaintingStyle paintingStyle;
  final double strokeWidth;

  TrianglePainter({this.strokeColor, this.paintingStyle, this.strokeWidth});

  @override
  // Canvas ist wie der context, setzt automatisch den Nullpunkt links oben
  void paint(Canvas canvas, Size size) {
    // Paint Onjekt erzeugen
    Paint paint = Paint();
    paint.color = strokeColor;
    paint.strokeWidth = strokeWidth;
    paint.style = paintingStyle;
    canvas.drawPath(getTrianglePath(size.width, size.height), paint);
  }

  // Weg der Äuseren Linie muss gegeben werden
  Path getTrianglePath(double x, double y) {
    Path path = Path()
      ..moveTo(0, y)
      ..lineTo(x / 2, 0)
      ..lineTo(x, y)
      ..lineTo(0, y);
    return path;
  }

  @override
  bool shouldRepaint(TrianglePainter oldDelegate) {
    return oldDelegate.strokeColor != strokeColor ||
        oldDelegate.paintingStyle != paintingStyle ||
        oldDelegate.strokeWidth != strokeWidth;
  }
}
