import 'package:flutter/material.dart';
import 'package:routenplaner/data/custom_colors.dart';
import 'package:routenplaner/drawer/travel_profiles.dart';
import 'package:routenplaner/drawer/user_profiles.dart';
import 'package:routenplaner/home/route_planning.dart';
import 'package:routenplaner/provider_classes/desired_Autom_Sections.dart';
import 'package:provider/provider.dart';
import 'package:routenplaner/provider_classes/final_routes.dart';
import 'package:routenplaner/provider_classes/route_details.dart';

class OveriewConfirmation extends StatefulWidget {
  final String targetPage;
  OveriewConfirmation({@required this.targetPage});
  @override
  _OveriewConfirmationState createState() =>
      _OveriewConfirmationState(targetPage: targetPage);
}

class _OveriewConfirmationState extends State<OveriewConfirmation> {
  // bool homeButtonPressed = false;
  String targetPage;
  _OveriewConfirmationState({@required this.targetPage});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            flex: 10,
            child: Text(
              "Möchten Sie die Route wirklich verwerfen?",
              overflow: TextOverflow.ellipsis,
              maxLines: 3,
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(),
          ),
        ],
      ),
      content: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            decoration: BoxDecoration(
              color: myLightGrey,
            ),
            // Abbrechen, schließen des Popups
            child: MaterialButton(
              child: Text(
                "Abbrechen",
                style: TextStyle(
                  fontSize: 15,
                  color: myDarkGrey,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop(false);
              },
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: myMiddleTurquoise,
            ),
            child: MaterialButton(
              child: Text(
                "Ja",
                style: TextStyle(
                  fontSize: 15,
                  color: myWhite,
                ),
              ),
              //////////////////// ZURÜCKSETZEN ALLER WICHTIGEN DATEN
              /// Eingegebene Routen
              onPressed: () {
                // Lösche die Automatisierten Segmente
                Provider.of<DesiredAutomSections>(context, listen: false)
                    .sections
                    .clear();
                Provider.of<DesiredAutomSections>(context, listen: false)
                    .timedSections
                    .clear();
                // Start ziel Zurücksetzen
                Provider.of<RouteDetails>(context, listen: false)
                    .resetRouteDetails();
                print(Provider.of<RouteDetails>(context, listen: false)
                    .destinationLocation);
                // Ausgewählte Route zurücksetzen
                Provider.of<FinalRoutes>(context, listen: false)
                    .indexSelectedRoute = 0;
                Navigator.push(
                  context,
                  MaterialPageRoute<Widget>(
                    builder: (BuildContext context) => RoutePlanning(),
                  ),
                );
                switch (targetPage) {
                  case "home":
                    Navigator.push(
                      context,
                      MaterialPageRoute<Widget>(
                        builder: (BuildContext context) => RoutePlanning(),
                      ),
                    );
                    break;
                  case "userprofiles":
                    Navigator.push(
                      context,
                      MaterialPageRoute<Widget>(
                        builder: (BuildContext context) => UserProfiles(),
                      ),
                    );
                    break;
                  case "travelprofiles":
                    Navigator.push(
                      context,
                      MaterialPageRoute<Widget>(
                        builder: (BuildContext context) => TravelProfiles(),
                      ),
                    );
                    break;
                  default:
                    break;
                }
              },
            ),
          )
        ],
      ),
    );
  }
}
