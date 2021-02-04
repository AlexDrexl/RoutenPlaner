import 'package:flutter/material.dart';
import 'package:routenplaner/data/custom_colors.dart';
import 'package:routenplaner/data/layoutData.dart';
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
        // Nach Obenhin Platz Schaffen
        SizedBox(
          height: 20,
        ),
        // Container für die Überschrift
        Container(
          margin: EdgeInsets.only(
              left: contentMarginLR,
              right: contentMarginLR,
              bottom: distanceBoxes),
          padding: EdgeInsets.fromLTRB(contentPaddingLR, contentPaddingTB,
              contentPaddingLR, contentPaddingTB),
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
          child: new Column(
            mainAxisSize: MainAxisSize.min,
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
          ),
        ),
      ],
    );
  }
}
