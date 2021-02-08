import 'package:flutter/material.dart';
import 'package:routenplaner/data/custom_colors.dart';

class TriangleHelper extends StatefulWidget {
  @override
  _TriangleHelperState createState() => _TriangleHelperState();
}

class _TriangleHelperState extends State<TriangleHelper> {
  final usedTextStyle = TextStyle(
    color: myDarkGrey,
    fontSize: 17,
  );

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      scrollable: true,
      insetPadding: EdgeInsets.fromLTRB(20, 80, 20, 120),
      actions: [
        MaterialButton(
          color: myMiddleTurquoise,
          child: Center(
            child: Text(
              "OK",
              style: TextStyle(color: myWhite, fontSize: 20),
            ),
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ],
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 10,
          ),
          // Überschrift
          Center(
            child: Text(
              "Reisedreieck - Erklärung",
              style: TextStyle(color: myDarkGrey, fontSize: 20),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          // GIF
          Container(
            width: MediaQuery.of(context).size.width - 20,
            height: MediaQuery.of(context).size.width - 100,
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(
                      "assets/images/DreieckHelper_groß_zugeschnitten.gif"),
                  fit: BoxFit.fitHeight,
                ),
              ),
            ),
          ),
          // Allgemeiner Erklärungstext
          Text(
            "Verschiebe das blaue Icon, um festzulegen, auf was bei der Routenerstellung am meisten Wert gelegt werden soll",
            style: usedTextStyle,
          ),
          SizedBox(
            height: 15,
          ),

          // Genauere Erklärungen zu den Dreiecksdaten
          // Max Automationsdauer
          Text(
            "Max. Automationsdauer:",
            style: TextStyle(
                color: myDarkGrey, fontSize: 17, fontWeight: FontWeight.bold),
          ),
          Text(
            "Routen mit einem hohen Anteil an automatisierter Gesamtfahrzeit werden priorisiert.",
            style: usedTextStyle,
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            "Min. Reisezeit:",
            style: TextStyle(
                color: myDarkGrey, fontSize: 17, fontWeight: FontWeight.bold),
          ),
          Text(
            "Routen mit einer geringeren Reisezeit werden priorisiert. Eine kurze Reisedauer lässt sich oftmals nur auf Kosten der gesamten Automationsdauer erreichen.",
            style: usedTextStyle,
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            "Wenig Wechsel AD/MD:",
            style: TextStyle(
                color: myDarkGrey, fontSize: 17, fontWeight: FontWeight.bold),
          ),
          Text(
            "Routen mit einer geringen Anzahl an Wechsel zwischen automatisiertem und manuellem Fahren werden priorisiert.",
            style: usedTextStyle,
          ),
        ],
      ),
    );
  }
}
