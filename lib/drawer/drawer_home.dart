import 'package:flutter/material.dart';
import 'package:routenplaner/drawer/travel_detail_confirmation.dart';
import 'package:routenplaner/drawer/user_profiles.dart';
import 'package:routenplaner/home/route_planning.dart';
import 'package:routenplaner/overview/overview_footer_pupup.dart';
import 'package:routenplaner/provider_classes/user_profile_collection.dart';
import 'package:provider/provider.dart';
import 'travel_profiles.dart';
import 'user_profiles.dart';
import '../data/custom_colors.dart';

// Drawer an der Seite, link zu den weiteren Seiten wie Nutzerprofile,
// Reiseprofile, Meine Karten, Einstellungen
class DrawerHome extends StatelessWidget {
  // Da es nicht bekannt ist, wo der Nutzer gerade ist, muss zu jedem Drawer aufruf
  // die Aufrufposition übergeben werden
  final String screen;
  final int indexTravelProfile;
  DrawerHome({@required this.screen, this.indexTravelProfile});
  // Überprüfe, ob profileCollection existent und name nicht null
  String checkName(UserProfileCollection profileCollection) {
    if (profileCollection.userProfileCollection != null &&
        profileCollection.userProfileCollection.length > 0 &&
        profileCollection.selectedUserProfileIndex != null) {
      return profileCollection
          .userProfileCollection[profileCollection.selectedUserProfileIndex]
          .name;
    }
    return '-';
  }

  String checkEmail(UserProfileCollection profileCollection) {
    if (profileCollection.userProfileCollection != null &&
        profileCollection.userProfileCollection.length > 0) {
      if (profileCollection.selectedUserProfileIndex != null) {
        return profileCollection
            .userProfileCollection[profileCollection.selectedUserProfileIndex]
            .email;
      }
    }
    return '-';
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: <Widget>[
          // Nutzer und Email
          Consumer<UserProfileCollection>(
            builder: (context, userProfileCollection, _) =>
                UserAccountsDrawerHeader(
              accountName: Text(checkName(userProfileCollection),
                  style: TextStyle(color: Colors.white, fontSize: 20)),
              accountEmail: Text(checkEmail(userProfileCollection),
                  style: TextStyle(color: Colors.white, fontSize: 20)),
              currentAccountPicture: CircleAvatar(),
            ),
          ),
          // Home, Überprüfe von wo aufgerufen!
          ListTile(
            leading: Icon(Icons.home, color: iconColor, size: 50),
            title: Text(
              'Home',
              style: TextStyle(
                fontSize: 20,
                color: myDarkGrey, //#707070
              ),
            ),
            onTap: () {
              switch (screen) {
                // In home soll nichts passieren
                case "home":
                  Navigator.of(context).pop();
                  break;
                // in overview soll geschaut werden, ob der Nutzer wirklich die Route verwerfen möchte
                // Dazu zählt auch alternative Routes
                case "overview":
                  showDialog(
                    context: context,
                    builder: (context) {
                      return OveriewConfirmation(
                        targetPage: "home",
                      );
                    },
                  );
                  break;
                // In den Reiseprofilen soll abgefragt werden, ob gespeichert werden soll
                case "travelprofiledetails":
                  showDialog(
                    context: context,
                    builder: (context) {
                      return TravelDetailConirmation(
                        indexProfile: indexTravelProfile,
                        targetPage: "home",
                      );
                    },
                  );
                  break;
                // In allen anderen Fällen soll einfach zu home zurückgegangen werden
                default:
                  Navigator.push(
                    context,
                    MaterialPageRoute<Widget>(
                      builder: (BuildContext context) => RoutePlanning(),
                    ),
                  );
                  break;
              }
            },
          ),
          Divider(
            thickness: 1,
          ),

          // Listenzeile Nutzerprofile
          ListTile(
            leading: Icon(Icons.person, color: iconColor, size: 50),
            title: Text(
              'Nutzerprofile',
              style: TextStyle(
                fontSize: 20,
                color: myDarkGrey, //#707070
              ),
            ),
            onTap: () {
              switch (screen) {
                // In home soll nichts passieren
                case "home":
                  Navigator.push(
                    context,
                    MaterialPageRoute<Widget>(
                      builder: (BuildContext context) => UserProfiles(),
                    ),
                  );

                  break;
                case "overview":
                  showDialog(
                    context: context,
                    builder: (context) {
                      return OveriewConfirmation(
                        targetPage: "userprofiles",
                      );
                    },
                  );
                  break;
                // In den Reiseprofilen soll abgefragt werden, ob gespeichert werden soll
                case "travelprofiledetails":
                  showDialog(
                    context: context,
                    builder: (context) {
                      return TravelDetailConirmation(
                        indexProfile: indexTravelProfile,
                        targetPage: "userprofiles",
                      );
                    },
                  );
                  break;
                // In allen anderen Fällen soll einfach zu home zurückgegangen werden
                default:
                  Navigator.push(
                    context,
                    MaterialPageRoute<Widget>(
                      builder: (BuildContext context) => UserProfiles(),
                    ),
                  );
                  break;
              }
            },
          ),
          Divider(
            thickness: 1,
          ),
          // Listenzeile Reiseprofile
          ListTile(
            leading: Icon(Icons.card_travel, color: iconColor, size: 50),
            title: Text(
              'Reiseprofile',
              style: TextStyle(
                fontSize: 20,
                color: myDarkGrey, //#707070
              ),
            ),
            onTap: () {
              switch (screen) {
                // In home soll einfach zu Reiseprofilen gewechselt werden
                case "home":
                  Navigator.push(
                    context,
                    MaterialPageRoute<Widget>(
                      builder: (BuildContext context) => TravelProfiles(),
                    ),
                  );
                  break;
                // in overview soll geschaut werden, ob der Nutzer wirklich die Route verwerfen möchte
                // Dazu zählt auch alternative Routes
                case "overview":
                  showDialog(
                    context: context,
                    builder: (context) {
                      return OveriewConfirmation(
                        targetPage: "travelprofiles",
                      );
                    },
                  );
                  break;
                // In den Reiseprofilen soll abgefragt werden, ob gespeichert werden soll
                case "travelprofiledetails":
                  showDialog(
                    context: context,
                    builder: (context) {
                      return TravelDetailConirmation(
                        indexProfile: indexTravelProfile,
                        targetPage: "travelprofiles",
                      );
                    },
                  );
                  break;
                // In allen anderen Fällen soll einfach zu home zurückgegangen werden
                default:
                  Navigator.push(
                    context,
                    MaterialPageRoute<Widget>(
                      builder: (BuildContext context) => TravelProfiles(),
                    ),
                  );
                  break;
              }
            },
          ),
          Divider(
            thickness: 1,
          ),
        ],
      ),
    );
  }
}
