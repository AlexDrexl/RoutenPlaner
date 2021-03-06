import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:routenplaner/drawer/travel_detail.dart';
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
    // Schaue, ob denn der gleiche name wieder eingegeben, wenn modifiziert
    if (modifyMode) {
      if (collection.travelProfileCollection[indexTravelProfile].name == name) {
        return false;
      }
    }
    // Überprüfe, ob der name gleich mit dem eines anderen Profils ist
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
          modifyMode ? "Profilnamen ändern" : "Profilname"),
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
              textColor: myMiddleTurquoise,
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
              textColor: myMiddleTurquoise,
              onPressed: () async {
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
                    await Provider.of<TravelProfileCollection>(context,
                            listen: false)
                        .addEmptyTravelProfile(name: name);
                    Navigator.push(
                      context,
                      MaterialPageRoute<Widget>(
                        builder: (BuildContext context) => TravelDetail(
                          indexProfile: Provider.of<TravelProfileCollection>(
                                      context,
                                      listen: false)
                                  .travelProfileCollection
                                  .length -
                              1,
                        ),
                      ),
                    );
                  }
                } else {
                  // Keine Eingabe oder Bereits vorhandener Name
                  setState(() {});
                }
              },
              child: Text(
                modifyMode ? "Änderung speichern" : "Profil erstellen",
                style: TextStyle(fontSize: 15),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
