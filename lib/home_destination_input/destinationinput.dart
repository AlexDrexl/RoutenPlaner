import 'package:flutter/material.dart';
import 'package:routenplaner/data/custom_colors.dart';
import 'destinationinput_destination.dart';
import 'destinationinput_details.dart';
import 'destinationinput_start.dart';

class Destinationinput extends StatefulWidget {
  @override
  _DestinationinputState createState() => _DestinationinputState();
}

// Die Zieleingabe:
// Setzte sich aus weiteren 3 Klassen zusammen
class _DestinationinputState extends State<Destinationinput> {
  @override
  Widget build(BuildContext context) {
    // Zieleingabe nun in zwei Container in einer Spalte aufgeteilt
    // Überschrift und den Body darunter
    return Column(
      children: [
        // Container für die Üerschrift
        Container(
          decoration: BoxDecoration(
              border: Border.all(width: 0, color: myMiddleGrey),
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(14), topRight: Radius.circular(14)),
              color: myMiddleTurquoise,
              boxShadow: [
                BoxShadow(
                  color: myMiddleGrey,
                  blurRadius: 4,
                )
              ]),
          padding: EdgeInsets.only(top: 8, bottom: 8, left: 15),
          margin: EdgeInsets.only(left: 25, right: 25, top: 25),
          alignment: Alignment.centerLeft,
          child: Text(
            'ZIELEINGABE',
            style: TextStyle(color: myWhite, fontSize: 20),
          ),
        ),
        // Container für den Body
        Container(
          margin: EdgeInsets.only(left: 25, right: 25, bottom: 25),
          padding: EdgeInsets.only(top: 10, bottom: 10, left: 20, right: 20),
          decoration: BoxDecoration(
              border: Border.all(width: 0, color: myMiddleGrey),
              borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(14),
                  bottomLeft: Radius.circular(14)),
              color: myWhite,
              boxShadow: [
                BoxShadow(
                  color: myMiddleGrey,
                  blurRadius: 4,
                )
              ]),
          // Container enthät ein child, in dem in einer Spalte nun
          // StartInput (DestinationinputStart)
          // ZielInput (DestinationinputDestination)
          // Eingabedetails (DestinationInputDetails) sind
          child: new Column(
            mainAxisSize: MainAxisSize.min,
            //mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //mainAxisAlignment: MainAxisAlignment.spaceAround,
            //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              new Flexible(
                child: DestinationinputStart(),
              ),
              new Flexible(
                child: DestinationinputDestination(),
              ),
              DestinationInputDetails(context),
            ],
            //onChanged: ,
          ),
        ),
      ],
    );
  }
}
