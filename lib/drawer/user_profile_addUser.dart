import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:routenplaner/data/custom_colors.dart';
import 'package:routenplaner/provider_classes/travel_profiles_collection.dart';
import 'package:routenplaner/provider_classes/user_profile_collection.dart';

class AddUserProfileDialogue extends StatefulWidget {
  final bool modifyMode;
  final int profileIndex4modify;
  AddUserProfileDialogue({this.modifyMode, this.profileIndex4modify});
  @override
  _AddUserProfileDialogueState createState() =>
      _AddUserProfileDialogueState(modifyMode, profileIndex4modify);
}

class _AddUserProfileDialogueState extends State<AddUserProfileDialogue> {
  String name = "";
  String email = "";
  bool showHint = false;
  bool modify = false;
  int profileIndex4Modify;
  _AddUserProfileDialogueState(bool modify, int index) {
    this.modify = modify;
    profileIndex4Modify = index;
    print("CALLED");
  }
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(modify ? "Profil bearbeiten" : "Profil erstellen"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "Benutzername:",
              style: TextStyle(
                color: myDarkGrey,
                fontSize: 12,
              ),
            ),
          ),
          TextField(
            decoration: InputDecoration(
              hintText: showHint ? "Eingabe erfordert" : "",
              hintStyle: TextStyle(color: Colors.red),
            ),
            onChanged: (name) {
              this.name = name;
            },
          ),
          SizedBox(height: 20),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "Email:",
              style: TextStyle(
                color: myDarkGrey,
                fontSize: 12,
              ),
            ),
          ),
          TextField(
            decoration: InputDecoration(
              hintStyle: TextStyle(color: Colors.red),
            ),
            onChanged: (email) {
              this.email = email;
            },
          ),
        ],
      ),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            // Abbrechen, einfach nichts machen, nur den namen aus null setzen
            FlatButton(
              onPressed: () {
                name = "";
                Navigator.pop(context);
              },
              child: Text(
                "Abbrechen",
                style: TextStyle(fontSize: 15),
              ),
            ),
            SizedBox(width: 20),
            // Profil erstellen
            FlatButton(
              onPressed: () {
                if (name != "") {
                  // Name eingegeben
                  if (modify) {
                    // Ändern, nicht erstellen
                    Provider.of<UserProfileCollection>(context, listen: false)
                        .modifyUserProfile(
                            name: name,
                            email: email,
                            userProfileIndex: profileIndex4Modify);
                    Navigator.pop(context);
                  } else {
                    // wenn nicht geändert, sondern hinzugefügt werden soll:
                    Provider.of<UserProfileCollection>(context, listen: false)
                        .addProfile(name: name, email: email);
                    Navigator.pop(context);
                  }
                } else {
                  // Keine eingabe
                  showHint = true;
                  setState(() {});
                }
              },
              child: Text(
                "Profil erstellen",
                style: TextStyle(fontSize: 15),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
