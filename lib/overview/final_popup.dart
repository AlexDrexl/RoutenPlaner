import 'package:flutter/material.dart';
import 'package:routenplaner/data/custom_colors.dart';
import 'package:routenplaner/drawer/travel_profiles.dart';
import 'package:routenplaner/drawer/user_profiles.dart';
import 'package:routenplaner/home/route_planning.dart';
import 'package:routenplaner/provider_classes/desired_Autom_Sections.dart';
import 'package:provider/provider.dart';
import 'package:routenplaner/provider_classes/final_routes.dart';
import 'package:routenplaner/provider_classes/route_details.dart';

class FinalConfirmation extends StatefulWidget {
  final String targetPage;
  FinalConfirmation({@required this.targetPage});
  @override
  _FinalConfirmationState createState() =>
      _FinalConfirmationState(targetPage: targetPage);
}

class _FinalConfirmationState extends State<FinalConfirmation> {
  // bool homeButtonPressed = false;
  String targetPage;
  _FinalConfirmationState({@required this.targetPage});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween, //spaceBetween
        children: [
          Expanded(
            flex: 10,
            child: Text(
              "Vielen Dank! \nIhre Route wurde gespeichert und steht im Fahrzeug für Sie zur Verfügung.",
              overflow: TextOverflow.ellipsis,
              maxLines: 5,
              style: TextStyle(
                  fontSize: 15,
                  //color: myWhite,
                ),
            ),
          ),
          /*Expanded(
            flex: 1,
            child: Container(),
          ),*/
        ],
      ),
      content: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            decoration: BoxDecoration(
              //borderRadius: BorderRadius.all(Radius.circular(14)),
              //color: myLightGrey,
            ),
            // Abbrechen, schließen des Popups
            child: MaterialButton(
              child: Text(
                "Nochmal ändern",
                style: TextStyle(
                  fontSize: 15,
                  color: myMiddleTurquoise,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop(false);
              },
            ),
          ),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(3)),
              color: myMiddleTurquoise,
            ),
            child: MaterialButton(
              child: Text(
                "Verstanden",
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
