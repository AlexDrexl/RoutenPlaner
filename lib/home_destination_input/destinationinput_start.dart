import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:async';
import 'package:routenplaner/data/custom_colors.dart';
import 'package:routenplaner/provider_classes/route_details.dart';

class DestinationinputStart extends StatefulWidget {
  @override
  _DestinationinputStartState createState() => _DestinationinputStartState();
}

// Hier befindet sich das erste Textfeld, in dem der Start eingegeben wird
// Der Wert wird einfach in einem Lokalen String gespeichert
class _DestinationinputStartState extends State<DestinationinputStart> {
  void updateUserTextStart(String text) {
    setState(() {
      userTextStart = text;
    });
  }

  String userTextStart = '';

  @override
  Widget build(BuildContext context) {
    return Container(
      child: TextField(
        maxLines: 1,
        // Input noch nicht in lokale Variable gespeichert
        onChanged: (startingLocation) {
          Provider.of<RouteDetails>(context, listen: false).startingLocation =
              startingLocation;
          updateUserTextStart(startingLocation);
        }, //onChanged or onSubmitted
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          icon: Icon(
            Icons.place,
            color: myYellow,
          ),
          labelText: 'Start',
          hintText: 'Start',
          suffixIcon: Icon(Icons.keyboard, color: myMiddleTurquoise),
        ),
      ),
    );
  }
}
