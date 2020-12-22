import 'package:flutter/material.dart';
import 'package:routenplaner/data/custom_colors.dart';
import 'package:routenplaner/provider_classes/travel_profiles_collection.dart';
import 'package:routenplaner/provider_classes/user_profile_collection.dart';

class DeletePopUp extends StatefulWidget {
  final TravelProfileCollection travelProfileCollection;
  final UserProfileCollection userProfileCollection;
  final int index;
  DeletePopUp(
      {this.index, this.travelProfileCollection, this.userProfileCollection});
  @override
  _DeletePopUpState createState() => _DeletePopUpState(
      travelProfileCollection: travelProfileCollection,
      userProfileCollection: userProfileCollection,
      index: index);
}

class _DeletePopUpState extends State<DeletePopUp> {
  var index;
  TravelProfileCollection travelProfileCollection;
  UserProfileCollection userProfileCollection;
  bool travProf;
  // init der Trav Prof, so kann dieses Popup wieder verwendet werden
  _DeletePopUpState(
      {this.index, this.travelProfileCollection, this.userProfileCollection}) {
    if (travelProfileCollection == null) {
      travProf = false;
    } else {
      travProf = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: travProf
          ? Text("Reiseprofil wirklich löschen?")
          : Text("Nutzerprofil wirklich löschen?"),
      actions: [
        // Löschen
        MaterialButton(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(
                Radius.circular(14),
              ),
              color: myDarkGrey,
            ),
            padding: EdgeInsets.all(10),
            child: Text(
              "Löschen",
              style: TextStyle(
                color: myWhite,
                fontSize: 15,
              ),
            ),
          ),
          onPressed: () {
            // Lösche das Reiseprofil mit dem Index i
            if (travProf) {
              travelProfileCollection.deleteTravelProfile(index);
              Navigator.of(context).pop(true);
            } else {
              userProfileCollection.deleteProfile(indexUserProfile: index);
              Navigator.of(context).pop(true);
            }
          },
        ),
        // Abbrechen
        MaterialButton(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(
                Radius.circular(14),
              ),
              color: myMiddleTurquoise,
            ),
            padding: EdgeInsets.all(10),
            child: Text(
              "Abbrechen",
              style: TextStyle(
                color: myWhite,
                fontSize: 15,
              ),
            ),
          ),
          onPressed: () {
            Navigator.of(context).pop(true);
          },
        ),
      ],
    );
  }
}
