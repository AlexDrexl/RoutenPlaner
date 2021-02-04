import 'package:flutter/material.dart';
import 'package:routenplaner/data/custom_colors.dart';
import 'package:routenplaner/drawer/travel_profiles.dart';
import 'package:routenplaner/home/route_planning.dart';
import 'package:routenplaner/provider_classes/travel_profile_modifier.dart';
import 'package:provider/provider.dart';

class TravelDetailConirmation extends StatelessWidget {
  final int indexProfile;
  TravelDetailConirmation({@required this.indexProfile});
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            flex: 6,
            child: Text(
              "Möchten Sie die Änderungen speichern?",
              overflow: TextOverflow.ellipsis,
              maxLines: 3,
            ),
          ),
          Expanded(
            flex: 1,
            child: FloatingActionButton(
              child: Icon(
                Icons.close,
                color: myWhite,
                size: 40,
              ),
              onPressed: () {
                Navigator.of(context).pop(false);
              },
            ),
          ),
        ],
      ),
      content: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(14)),
              color: myLightGrey,
            ),
            child: MaterialButton(
              child: Text(
                "Nicht Speichern",
                style: TextStyle(
                  fontSize: 15,
                  color: myDarkGrey,
                ),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute<Widget>(
                    builder: (BuildContext context) => RoutePlanning(),
                  ),
                );
              },
            ),
          ),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(14)),
              color: myMiddleTurquoise,
            ),
            child: MaterialButton(
              child: Text(
                "Speichern",
                style: TextStyle(
                  fontSize: 15,
                  color: myWhite,
                ),
              ),
              onPressed: () {
                // Wenn gedrückt, dann sollen alle Daten auch wirklich in
                // Travel Profile Collection gespeichert werden bzw in der
                // Datenbank
                Provider.of<TravelProfileDetailModifier>(context, listen: false)
                    .safe(indexProfile, context);

                Navigator.push(
                  context,
                  MaterialPageRoute<Widget>(
                    builder: (BuildContext context) => RoutePlanning(),
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
