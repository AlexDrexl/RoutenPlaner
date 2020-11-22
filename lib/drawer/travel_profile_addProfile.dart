import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:routenplaner/provider_classes/travel_profiles_collection.dart';

class AddProfileDialogue extends StatefulWidget {
  @override
  _AddProfileDialogueState createState() => _AddProfileDialogueState();
}

class _AddProfileDialogueState extends State<AddProfileDialogue> {
  _AddProfileDialogueState();
  String name = "";
  bool showHint = false;
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Gebe einen Profilnamen ein"),
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
                  Provider.of<TravelProfileCollection>(context, listen: false)
                      .addProfile(name);
                  Navigator.pop(context);
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
