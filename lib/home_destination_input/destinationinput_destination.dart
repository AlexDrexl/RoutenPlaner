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
  void updateUserTextDestination(String text) {
    setState(() {
      userTextZiel = text;
    });
  }

  String userTextZiel = '';

  @override
  Widget build(BuildContext context) {
    return Container(
      child: TextField(
        maxLines: 1,
        onChanged: (destination) {
          updateUserTextDestination(destination);
          // Provider benachrichtigen
          Provider.of<RouteDetails>(context, listen: false)
              .destinationLocation = destination;
        }, //gibt auch onsubmitted;
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          icon: Icon(
            Icons.flag,
            color: myYellow,
          ),
          labelText: 'Ziel',
          hintText: 'Ziel',
          suffixIcon: Icon(Icons.keyboard, color: myMiddleGrey),
        ),
      ),
    );
  }
}
