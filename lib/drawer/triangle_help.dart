import 'package:flutter/material.dart';
import 'package:routenplaner/data/custom_colors.dart';

class TriangleHelper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
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
          // Inhalt
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
          // Erklärungstext
          Align(
            alignment: Alignment.centerLeft,
            child: Container(
              margin: EdgeInsets.only(left: 10, top: 10, right: 10, bottom: 10),
              child: Text(
                "Verschiebe das blaue Icon, um festzulegen, auf was bei der Routenerstellung am meisten Wert gelegt werden soll",
                style: TextStyle(color: myDarkGrey, fontSize: 17),
              ),
            ),
          ),
          // Zurückicon
          Align(
            alignment: Alignment.centerRight,
            child: MaterialButton(
              child: Container(
                height: 40,
                width: 70,
                decoration: BoxDecoration(
                  color: myMiddleTurquoise,
                  border: Border.all(width: 0, color: myDarkGrey),
                  borderRadius: BorderRadius.all(
                    Radius.circular(14),
                  ),
                ),
                child: Center(
                  child: Text(
                    "OK",
                    style: TextStyle(color: myWhite, fontSize: 20),
                  ),
                ),
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
        ],
      ),
    );
  }
}
