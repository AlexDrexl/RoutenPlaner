import 'package:flutter/material.dart';
import 'package:routenplaner/drawer/delete_pupup.dart';
import 'package:routenplaner/drawer/travel_detail.dart';
import 'package:routenplaner/drawer/travel_profile_addTravelProfile.dart';
import 'package:routenplaner/drawer/travel_profiles_button.dart';
import 'package:routenplaner/drawer/travel_profiles_welcome.dart';
import 'package:routenplaner/controller/travel_profiles_collection.dart';
import 'drawer_home.dart';
import '../data/custom_colors.dart';
import 'package:provider/provider.dart';

class TravelProfiles extends StatefulWidget {
  // Wenn ein Profile DELETED wird, dann MUSS danach der gesamte Widget neu
  // ausgebaurt werden, damit die Index wieder stimmen!!!
  @override
  _TravelProfilesState createState() => _TravelProfilesState();
}

class _TravelProfilesState extends State<TravelProfiles> {
  List<Widget> printTravelProfiles(
      TravelProfileCollection travelProfileCollection) {
    List<Widget> widgetList = List<Widget>();
    int length = travelProfileCollection.travelProfileCollection.length;
    for (int i = 0; i < length; i++) {
      GlobalKey key = GlobalKey();
      widgetList.add(
        Column(
          children: [
            SizedBox(height: 30),
            // Container für die Karten
            Container(
              key: key,
              padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
              width: MediaQuery.of(context).size.width - 30,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: myWhite,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  width: 0,
                  color: myLightGrey,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 5,
                    blurRadius: 7,
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Expanded für den Auswahl Button bzw Icon und Text
                  Expanded(
                    child: MaterialButton(
                      // reihe mit Icon und Text
                      child: Row(
                        children: [
                          Icon(
                            Icons.wallet_travel,
                            color: iconColor,
                            size: 40,
                          ),
                          // Flexible für Bezeichnung
                          Expanded(
                            child: Center(
                              child: Text(
                                travelProfileCollection
                                    .travelProfileCollection[i].name,
                                style: TextStyle(
                                  fontSize: 20,
                                  color: myDarkGrey,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      // Wenn gedrückt dann Link zu neuen Seite, diese immer neu
                      // aufbauen, mit Hilfe eines übergebenen Routen objekts
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute<Widget>(
                            builder: (BuildContext context) =>
                                TravelDetail(indexProfile: i),
                          ),
                        );
                      },
                    ),
                  ),
                  // Weitere Reihe, um die Divider und Button aneinander zu
                  // bringen
                  Row(
                    children: [
                      // Flex für Divider
                      Container(
                        height: 50,
                        width: 3,
                        color: myLightGrey,
                      ),
                      SizedBox(width: 10),
                      // Flexible für Button
                      MaterialButton(
                        // Folgende zwei Properties benötigt, um Button kleiner zu machen
                        minWidth: 0,
                        padding: EdgeInsets.all(0),
                        child: Icon(
                          Icons.more_vert,
                          color: myMiddleTurquoise,
                          size: 50,
                        ),
                        onPressed: () {
                          // profiles.deleteProfile(indexUserProfile: i);
                          RenderBox box = key.currentContext.findRenderObject();
                          Offset position = box.localToGlobal(Offset.zero);
                          var fullHeight = MediaQuery.of(context).size.height;
                          var fullWidth = MediaQuery.of(context).size.width;
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return Dialog(
                                insetPadding: EdgeInsets.only(
                                  top: position.dy - 25,
                                  right: 15,
                                  bottom: fullHeight - position.dy - 60,
                                  left: fullWidth - 310,
                                ),
                                backgroundColor: myMiddleTurquoise,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    // Drei Container für die Drei Button
                                    // Bearbeiten
                                    Container(
                                      padding: EdgeInsets.only(right: 5),
                                      child: FloatingActionButton(
                                        onPressed: () {
                                          Navigator.of(context).pop(true);
                                          showDialog(
                                            context: context,
                                            // Dialog Popup
                                            builder: (context) => Builder(
                                              builder: (BuildContext context) {
                                                return (
                                                    // modifyMode: true,
                                                    // profileIndex4modify: i,
                                                    AddTravelProfileDialogue(
                                                  modifyMode: true,
                                                  indexTravelProfile: i,
                                                ));
                                              },
                                            ),
                                          );
                                        },
                                        child: Icon(
                                          Icons.edit,
                                          color: myWhite,
                                        ),
                                      ),
                                    ),
                                    // Delete
                                    Container(
                                      padding: EdgeInsets.only(right: 5),
                                      child: FloatingActionButton(
                                        onPressed: () async {
                                          /*
                                          travelProfileCollection
                                              .deleteTravelProfile(i);
                                          Navigator.of(context).pop(true);
                                          */
                                          Navigator.of(context).pop(true);
                                          await showDialog(
                                            context: context,
                                            // Dialog Popup, fragt den user nach bestätigung
                                            builder: (context) => Builder(
                                              builder: (BuildContext context) {
                                                return DeletePopUp(
                                                  index: i,
                                                  travelProfileCollection:
                                                      travelProfileCollection,
                                                );
                                              },
                                            ),
                                          );
                                        },
                                        child: Icon(
                                          Icons.delete,
                                          color: myWhite,
                                        ),
                                      ),
                                    ),
                                    // Duplicate
                                    Container(
                                      padding: EdgeInsets.only(right: 5),
                                      child: FloatingActionButton(
                                        onPressed: () {
                                          travelProfileCollection
                                              .duplicateTravelProfile(
                                                  indexTravelProfile: i);
                                          Navigator.of(context).pop(true);
                                        },
                                        child: Icon(
                                          Icons.copy,
                                          color: myWhite,
                                        ),
                                      ),
                                    ),
                                    // Container für vertikalen Strich
                                    Container(
                                      height: 40,
                                      width: 2,
                                      color: myWhite,
                                    ),
                                    // Container für den Drei Punkte Icon, Wird
                                    // verwendet um Höhe einzustellen
                                    Container(
                                      padding: EdgeInsets.only(
                                          right: 0, top: 5, bottom: 15),
                                      child: MaterialButton(
                                        minWidth: 0,
                                        onPressed: () {
                                          Navigator.of(context).pop(true);
                                        },
                                        child: Icon(
                                          Icons.more_vert,
                                          color: myWhite,
                                          size: 50,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }
    return widgetList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Reiseprofile',
              style: TextStyle(color: myWhite, fontSize: 30),
            ),
            FlatButton(
              child: Icon(
                Icons.help,
                color: myWhite,
                size: 40,
              ),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return SimpleDialog(
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Reiseprofile:",
                            style: TextStyle(color: myDarkGrey, fontSize: 25),
                          ),
                          Container(
                            width: 50,
                            height: 50,
                            child: FloatingActionButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Icon(
                                Icons.close,
                                color: myWhite,
                                size: 40,
                              ),
                            ),
                          )
                        ],
                      ),
                      titleTextStyle:
                          TextStyle(color: myDarkGrey, fontSize: 25),
                      contentPadding: EdgeInsets.fromLTRB(10, 10, 30, 20),
                      children: [
                        Row(
                          children: [
                            Flexible(
                              child: Text(
                                "Reiseprofile ermöglichen eine personalisierte Routenfindung. Bei der Routeneingabe kann ein Reiseprofil ausgewählt werden, sodass eingestellte Präferenzen in der Routenberechnung berücksichtigt werden. \n\nWenn auf das Erstellen eines Reiseprofils verzichtet wird, ist keine personalisierte Routenfindung möglich.",
                                style: TextStyle(
                                  color: myDarkGrey,
                                  fontSize: 20,
                                ),
                              ),
                            ),
                          ],
                        )
                      ],
                    );
                  },
                );
              },
            )
          ],
        ),
        iconTheme: new IconThemeData(color: myWhite),
      ),
      drawer: DrawerHome(
        screen: "travelprofiles",
      ),
      body: Consumer<TravelProfileCollection>(
        builder: (context, travelProfileCollection, child) =>
            travelProfileCollection.travelProfileCollection.isEmpty
                ? TravelProfilesWelcome()
                : ListView(
                    children: printTravelProfiles(travelProfileCollection),
                  ),
      ),
      floatingActionButton: TravelProfileButton(),
    );
  }
}
