import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:routenplaner/provider_classes/travel_profiles_collection.dart';

class AddTravelProfileDialogue extends StatefulWidget {
  final int indexTravelProfile;
  final bool modifyMode;
  AddTravelProfileDialogue(
      {this.indexTravelProfile, @required this.modifyMode});
  @override
  _AddTravelProfileDialogueState createState() =>
      _AddTravelProfileDialogueState(
        indexTravelProfile: indexTravelProfile,
        modifyMode: modifyMode,
      );
}

class _AddTravelProfileDialogueState extends State<AddTravelProfileDialogue> {
  int indexTravelProfile;
  bool modifyMode;
  _AddTravelProfileDialogueState(
      {this.indexTravelProfile, @required this.modifyMode});
  String name = "";
  bool showHint = false;
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(modifyMode
          ? "Gebe neuen Profilnamen ein"
          : "Gebe einen Profilnamen ein"),
      content: TextField(
        decoration: InputDecoration(
          hintText: showHint ? "Eingabe erfordert" : "",
          hintStyle: TextStyle(color: Colors.red),
        ),
        onChanged: (name) {
          this.name = name;
        },
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
                  if (modifyMode) {
                    Provider.of<TravelProfileCollection>(context, listen: false)
                        .changeName(
                      indexTravelprofile: indexTravelProfile,
                      name: name,
                    );
                    Navigator.pop(context);
                  } else {
                    Provider.of<TravelProfileCollection>(context, listen: false)
                        .addEmptyTravelProfile(name: name);
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
