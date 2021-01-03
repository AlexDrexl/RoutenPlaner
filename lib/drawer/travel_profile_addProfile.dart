import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:routenplaner/data/custom_colors.dart';
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
  bool duplicate = false;

  bool check4duplicate(TravelProfileCollection collection, String name) {
    for (int i = 0; i < collection.travelProfileCollection.length; i++) {
      if (collection.travelProfileCollection[i].name == name) return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    // Wenn modifiziert werden soll, dann Speichere gleich die bereits
    // vorhandenen Daten
    if (modifyMode) {
      name = Provider.of<TravelProfileCollection>(context, listen: false)
          .travelProfileCollection[indexTravelProfile]
          .name;
    }
    return AlertDialog(
      title: Text(
          modifyMode ? "Ändere den Profilnamen" : "Gebe einen Profilnamen ein"),
      content: TextField(
        decoration: InputDecoration(
          hintText: showHint ? "Eingabe erfordert" : name,
          hintStyle: showHint ? TextStyle(color: Colors.red) : TextStyle(),
          helperText: duplicate ? "Profilname bereits vorhanden" : "",
          helperStyle: duplicate ? TextStyle(color: Colors.red) : TextStyle(),
        ),
        maxLength: 12,
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
                showHint = (name == "" || name == null);
                duplicate = check4duplicate(
                    Provider.of<TravelProfileCollection>(context,
                        listen: false),
                    name);
                if (!showHint && !duplicate) {
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
                  // Keine Eingabe oder Bereits vorhandener Name
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
