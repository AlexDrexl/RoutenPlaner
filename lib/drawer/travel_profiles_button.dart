import 'package:flutter/material.dart';
import 'package:routenplaner/data/custom_colors.dart';
import 'package:routenplaner/drawer/travel_profile_addTravelProfile.dart';
import 'package:provider/provider.dart';
import 'package:routenplaner/controller/user_profile_collection.dart';

class TravelProfileButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      backgroundColor: myMiddleTurquoise,
      // Eintrag Hinzufügen, noch implentieren
      // um aktualisierung gültig zu machen muss man WidgetList rebuilden
      // einfach
      onPressed: () {
        // Wenn noch kein Nutzer angelegt, dann zeige eine Snackbar
        if (Provider.of<UserProfileCollection>(context, listen: false)
                .userProfileCollection
                .length ==
            0) {
          final snackBar = SnackBar(
            backgroundColor: myMiddleTurquoise,
            content: Text(
              'Es muss zuerst ein Nutzerprofil angelegt werden',
              style: TextStyle(color: myWhite),
            ),
          );
          Scaffold.of(context).showSnackBar(snackBar);
          return;
        }
        showDialog(
          context: context,
          // Dialog Popup
          builder: (context) => Builder(
            builder: (BuildContext context) {
              return AddTravelProfileDialogue(modifyMode: false);
            },
          ),
        );
      },
      child: Icon(Icons.add, color: myWhite, size: 30),
    );
  }
}
