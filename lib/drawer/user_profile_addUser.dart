import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:routenplaner/data/custom_colors.dart';
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
  bool duplicate = false;
  int profileIndex4Modify;
  _AddUserProfileDialogueState(bool modify, int index) {
    this.modify = modify;
    profileIndex4Modify = index;
  }

  bool check4duplicate(UserProfileCollection collection, String name) {
    // Wenn bei bearbeiten der selbe name noch einmal eingegeben wird, ist das
    // erlaubt
    if (modify) {
      if (collection.userProfileCollection[profileIndex4Modify].name == name) {
        return false;
      }
    }
    // Überprüfe den rest der Namen
    for (int i = 0; i < collection.userProfileCollection.length; i++) {
      if (collection.userProfileCollection[i].name == name) {
        return true;
      }
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    // Wenn Modify, dann setze Gleich den Namen und email
    if (modify) {
      name = Provider.of<UserProfileCollection>(context, listen: false)
          .userProfileCollection[profileIndex4Modify]
          .name;
      email = Provider.of<UserProfileCollection>(context, listen: false)
          .userProfileCollection[profileIndex4Modify]
          .email;
      email == null ? email = "" : email = email;
    }
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
              hintText: showHint ? "Eingabe erfordert" : name,
              hintStyle: showHint ? TextStyle(color: Colors.red) : TextStyle(),
              helperText: duplicate ? "Profilname bereits vorhanden" : "",
              helperStyle:
                  duplicate ? TextStyle(color: Colors.red) : TextStyle(),
            ),
            maxLength: 12,
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
              hintText: email,
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
                style: TextStyle(fontSize: 15, color: myMiddleTurquoise),
              ),
            ),
            SizedBox(width: 20),
            // Profil erstellen
            FlatButton(
              onPressed: () {
                showHint = (name == null || name == "");
                duplicate = check4duplicate(
                    Provider.of<UserProfileCollection>(context, listen: false),
                    name);
                if (!showHint && !duplicate) {
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
                  // Eingabe entweder nicht vorhanden oder doppelt
                  setState(() {});
                }
              },
              child: Text(
                modify ? "Änderungen speichern" : "Profil erstellen",
                style: TextStyle(fontSize: 15, color: myMiddleTurquoise),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
