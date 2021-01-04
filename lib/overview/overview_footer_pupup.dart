import 'package:flutter/material.dart';
import 'package:routenplaner/data/custom_colors.dart';
import 'package:routenplaner/provider_classes/desired_Autom_Sections.dart';
import 'package:provider/provider.dart';
import 'package:routenplaner/provider_classes/final_routes.dart';
import 'package:routenplaner/provider_classes/route_details.dart';
import '../main/route_planning.dart';

class OverviewFooterPopup extends StatefulWidget {
  @override
  _OverviewFooterPopupState createState() => _OverviewFooterPopupState();
}

class _OverviewFooterPopupState extends State<OverviewFooterPopup> {
  bool homeButtonPressed = false;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            flex: 6,
            child: Text(
              "Möchten Sie die Route wirklich verwerfen?",
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
              borderRadius: BorderRadius.all(Radius.circular(14)),
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
                print("GO BACK TO HOME");
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
              },
            ),
          )
        ],
      ),
    );
  }
}
