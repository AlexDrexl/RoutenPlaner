import 'package:flutter/material.dart';
import 'package:routenplaner/data/custom_colors.dart';
import 'package:routenplaner/drawer/travel_profiles.dart';
import 'package:routenplaner/drawer/user_profiles.dart';
import 'package:routenplaner/home/route_planning.dart';
import 'package:routenplaner/controller/travel_profile_modifier.dart';
import 'package:provider/provider.dart';

class TravelDetailConirmation extends StatelessWidget {
  final int indexProfile;
  final String targetPage;
  TravelDetailConirmation(
      {@required this.indexProfile, @required this.targetPage});
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
                switch (targetPage) {
                  case "home":
                    Navigator.push(
                      context,
                      MaterialPageRoute<Widget>(
                        builder: (BuildContext context) => RoutePlanning(),
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
                  case "userprofiles":
                    Navigator.push(
                      context,
                      MaterialPageRoute<Widget>(
                        builder: (BuildContext context) => UserProfiles(),
                      ),
                    );
                    break;
                  default:
                    break;
                }
              },
            ),
          ),
          Container(
            decoration: BoxDecoration(
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
                Provider.of<TravelProfileDetailModifier>(context, listen: false)
                    .safe(indexProfile, context);
                switch (targetPage) {
                  case "home":
                    Navigator.push(
                      context,
                      MaterialPageRoute<Widget>(
                        builder: (BuildContext context) => RoutePlanning(),
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
                  case "userprofiles":
                    Navigator.push(
                      context,
                      MaterialPageRoute<Widget>(
                        builder: (BuildContext context) => UserProfiles(),
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
