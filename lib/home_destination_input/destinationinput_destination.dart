import 'package:flutter/material.dart';
import 'dart:async';
import 'package:routenplaner/data/custom_colors.dart';
import 'package:routenplaner/provider_classes/route_details.dart';
import 'package:provider/provider.dart';

class DestinationinputDestination extends StatefulWidget {
  @override
  _DestinationinputDestinationState createState() =>
      _DestinationinputDestinationState();
}

class _DestinationinputDestinationState
    extends State<DestinationinputDestination> {
  String userTextZiel = '';

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Consumer<RouteDetails>(
        builder: (context, routeDetails, _) => TextField(
          maxLines: 1,
          onChanged: (destination) {
            // Provider benachrichtigen
            routeDetails.destinationLocation = destination;
            setState(() {
              userTextZiel = destination;
            });
          }, //gibt auch onsubmitted;
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            icon: Icon(
              Icons.flag,
              color: myYellow,
            ),
            hintText:
                routeDetails.destinationLocValid ? "Ziel" : "Eingabe erfordert",
            hintStyle: routeDetails.destinationLocValid
                ? TextStyle()
                : TextStyle(color: Colors.red),
          ),
        ),
      ),
    );
  }
}
/*
helperText:
                routeDetails.destinationLocValid ? 'Ziel' : 'Eingabe erfordert',
            hintStyle: routeDetails.destinationLocValid
                ? TextStyle()
                : TextStyle(color: Colors.red),
            hintText:
                routeDetails.destinationLocValid ? 'Ziel' : 'Eingabe erfordert',
            suffixIcon: Icon(Icons.keyboard, color: myMiddleGrey),
*/
