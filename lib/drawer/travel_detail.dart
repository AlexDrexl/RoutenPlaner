import 'dart:math';
import 'package:flutter/material.dart';
import 'package:routenplaner/data/layoutData.dart';
import 'package:routenplaner/drawer/drawer_home.dart';
import 'package:routenplaner/drawer/input_triangle.dart';
import 'package:routenplaner/drawer/travel_profile_addTravelProfile.dart';
import 'package:routenplaner/drawer/travel_profiles.dart';
import 'package:routenplaner/drawer/triangle_help.dart';
import 'package:routenplaner/provider_classes/travel_profile_modifier.dart';
import 'package:routenplaner/provider_classes/travel_profiles_collection.dart';
import 'package:routenplaner/home/route_planning.dart';
import '../data/custom_colors.dart';
import 'package:provider/provider.dart';

class TravelDetail extends StatefulWidget {
  final int indexProfile;

  TravelDetail({@required this.indexProfile});

  @override
  _TravelDetailState createState() => _TravelDetailState(indexProfile);
}

class _TravelDetailState extends State<TravelDetail> {
  final ScrollController _scrollController = ScrollController();
  int indexProfile;
  bool homeButtonPressed = false;
  String newTravelProfileName = "";
  SliderThemeData sliderTheme = SliderThemeData();
  _TravelDetailState(this.indexProfile) {
    // Übergebe das Profi an den Modifier, als Startwert
  }

  // Popup Dialog für das Speichern
  Future<bool> safeChanges() {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                flex: 8, //6
                child: Text(
                  "Möchten Sie Ihre Änderungen speichern?",
                  overflow: TextOverflow.ellipsis,
                  maxLines: 3,
                ),
              ),
              /*Expanded(
                flex: 1,
                child: FloatingActionButton(
                  elevation: 00,
                  child: Icon(
                    Icons.close,
                    color: myWhite,
                    size: 20,
                  ),
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                ),
              ),*/
            ],
          ),
          content: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(3)),
                  //color: myLightGrey,
                ),
                child: FlatButton(
                  //MaterialButton
                  textColor: myMiddleTurquoise,
                  child: Text(
                    "Nicht Speichern",
                    style: TextStyle(
                      fontSize: 15,
                      //color: myDarkGrey,
                    ),
                  ),
                  onPressed: () {
                    if (homeButtonPressed) {
                      homeButtonPressed = false;
                      Navigator.push(
                        context,
                        MaterialPageRoute<Widget>(
                          builder: (BuildContext context) => RoutePlanning(),
                        ),
                      );
                    } else {
                      Navigator.push(
                        context,
                        MaterialPageRoute<Widget>(
                          builder: (BuildContext context) => TravelProfiles(),
                        ),
                      );
                    }
                  },
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(3)),
                  color: myMiddleTurquoise,
                ),
                child: MaterialButton(
                  child: Text(
                    "Speichern",
                    style: TextStyle(
                      fontSize: 15,
                      color: myWhite,
                    ),
                  ),
                  onPressed: () {
                    // Wenn gedrückt, dann sollen alle Daten auch wirklich in
                    // Travel Profile Collection gespeichert werden bzw in der
                    // Datenbank
                    Provider.of<TravelProfileDetailModifier>(context,
                            listen: false)
                        .safe(indexProfile, context);
                    if (homeButtonPressed) {
                      homeButtonPressed = false;
                      Navigator.push(
                        context,
                        MaterialPageRoute<Widget>(
                          builder: (BuildContext context) => RoutePlanning(),
                        ),
                      );
                    } else {
                      Navigator.push(
                        context,
                        MaterialPageRoute<Widget>(
                          builder: (BuildContext context) => TravelProfiles(),
                        ),
                      );
                    }
                  },
                ),
              )
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    Provider.of<TravelProfileDetailModifier>(context, listen: false)
        .initializeTravelProfile(indexProfile: indexProfile, context: context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Reiseprofile',
          style: TextStyle(fontSize: 30, color: myWhite),
        ),
        iconTheme: new IconThemeData(color: myWhite),
        //backgroundColor: Colors.transparent,
      ),
      drawer: DrawerHome(
        screen: "travelprofiledetails",
        indexTravelProfile: indexProfile,
      ),
      floatingActionButton: FloatingActionButton(
        //floatingActionButton: CircleAvatar
        //radius: 30,
        //heroTag: null,
        backgroundColor: myMiddleTurquoise,
        //child: IconButton(
        child: Icon(
          Icons.save,
          color: myWhite,
          size: 30,
        ),
        onPressed: () {
          Provider.of<TravelProfileDetailModifier>(context, listen: false)
              .safe(indexProfile, context);
          Navigator.push(
            context,
            MaterialPageRoute<Widget>(
              builder: (BuildContext context) => TravelProfiles(),
            ),
          );
        },
        //),
      ),
      // Eigentliches Reiseprofil
      body: WillPopScope(
        onWillPop: safeChanges,
        child: Scrollbar(
          controller: _scrollController,
          isAlwaysShown: false,
          child: SingleChildScrollView(
            controller: _scrollController,
            child: Container(
              margin: EdgeInsets.fromLTRB(contentMarginLR, contentMarginTB,
                  contentMarginLR, contentMarginTB),
              decoration: BoxDecoration(
                color: backgroundColor,
              ),
              child: Container(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    SizedBox(
                      height: distanceBoxes,
                    ),
                    // Container für Name des Reiseprofils und edit Reiseprofil
                    Container(
                      decoration: BoxDecoration(
                          border: Border.all(width: 0, color: myMiddleGrey),
                          color: myWhite,
                          boxShadow: [
                            BoxShadow(
                              color: myMiddleGrey,
                              blurRadius: 4,
                            )
                          ]),
                      child: ListTile(
                        leading:
                            Icon(Icons.card_travel, color: iconColor, size: 50),
                        title: Consumer<TravelProfileCollection>(
                          builder: (context, travelProfiles, _) => Container(
                            child: Text(
                              travelProfiles.travelProfileCollection.length >
                                      indexProfile
                                  ? travelProfiles
                                      .travelProfileCollection[indexProfile]
                                      .name
                                  : "",
                              style: TextStyle(
                                fontSize: 20,
                                color: myDarkGrey,
                              ),
                            ),
                          ),
                        ),
                        trailing: FlatButton(
                          //MaterialButton
                          splashColor: myWhite,
                          shape: CircleBorder(
                              side: BorderSide(color: myMiddleTurquoise)),

                          child: Icon(
                            Icons.edit,
                            color: myMiddleTurquoise,
                          ),
                          onPressed: () {
                            // Dialog für das ändern des Reiseprofilnamens
                            showDialog(
                              context: context,
                              // Dialog Popup
                              builder: (context) => Builder(
                                builder: (BuildContext context) {
                                  return AddTravelProfileDialogue(
                                    modifyMode: true,
                                    indexTravelProfile: indexProfile,
                                  );
                                },
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    SizedBox(
                      height: distanceBoxes, //distanceBoxes
                    ),
                    // Container für das Dreieck
                    Container(
                      padding: EdgeInsets.fromLTRB(contentPaddingLR,
                          contentPaddingTB, contentPaddingTB, contentPaddingTB),
                      decoration: BoxDecoration(
                        border: Border.all(width: 0, color: myMiddleGrey),
                        color: myWhite,
                        boxShadow: [
                          BoxShadow(
                            color: myMiddleGrey,
                            blurRadius: 4,
                          )
                        ],
                      ),
                      child: Column(
                        children: [
                          Container(
                            margin: EdgeInsets.only(left: 10, right: 10),
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: Container(),
                                ),
                                Expanded(
                                  flex: 6,
                                  child: Center(
                                    child: Text(
                                      'Max. Automationsdauer',
                                      style: TextStyle(fontSize: 17),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: FlatButton(
                                    //FloatingActionButton
                                    //elevation: 0.0,
                                    color: myMiddleTurquoise,
                                    shape: CircleBorder(
                                        side: BorderSide(
                                            color: myMiddleTurquoise)),
                                    child: Text(
                                      "i", //?
                                      style: TextStyle(
                                        color: myWhite,
                                        fontSize: 20,
                                      ),
                                    ),
                                    onPressed: () {
                                      print("helper");
                                      showDialog(
                                        context: context,
                                        // Dialog Popup, fragt den user nach bestätigung
                                        builder: (context) => Builder(
                                          builder: (BuildContext context) {
                                            return TriangleHelper();
                                          },
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // HIER DAS DREIECK
                          AspectRatio(
                            aspectRatio: 1 / (0.5 * sqrt(3)),
                            child: Container(
                              child: InputTriangle(
                                indexProfile: widget.indexProfile,
                              ),
                            ),
                          ),
                          // HIER DAS DREIECK
                          SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Min. Reisezeit',
                                style: TextStyle(fontSize: 17),
                              ),
                              Text(
                                'Wenig Wechsel', //'Wenig Wechsel\n        AD/MD
                                style: TextStyle(fontSize: 17),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: distanceBoxes,
                    ),
                    // Container für den ersten Slider
                    Container(
                      padding: EdgeInsets.fromLTRB(contentPaddingLR,
                          contentPaddingTB, contentPaddingLR, contentPaddingTB),
                      decoration: BoxDecoration(
                        border: Border.all(width: 0, color: myMiddleGrey),
                        color: myWhite,
                        boxShadow: [
                          BoxShadow(
                            color: myMiddleGrey,
                            blurRadius: 4,
                          )
                        ],
                      ),
                      // Max Umweg verglichen zur kürzesten Route
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            child: Text(
                              'Maximaler Umweg im Vergleich zur zeitlich kürzesten Route:',
                              style: TextStyle(fontSize: 17),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          // Anzeige des aktuellen Werts
                          Center(
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 10),
                              decoration: BoxDecoration(
                                color: myWhite,
                                border:
                                    Border.all(width: 0, color: myMiddleGrey),
                                boxShadow: [
                                  BoxShadow(
                                    color: myMiddleGrey,
                                    blurRadius: 0, //4
                                  )
                                ],
                              ),
                              child: Consumer<TravelProfileDetailModifier>(
                                builder: (context, modifier, __) => Text(
                                  // EINFÜGEN
                                  modifier.getMaxDetour().round().toString() +
                                      ' %',
                                  style: TextStyle(
                                    color: myDarkGrey,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          // Slider
                          Consumer<TravelProfileDetailModifier>(
                            builder: (context, modifier, __) => SliderTheme(
                              data: SliderThemeData(
                                  showValueIndicator: ShowValueIndicator.never),
                              child: Slider(
                                value: modifier
                                    .getMaxDetour()
                                    .toDouble(), // EINFÜGEN
                                min: 0,
                                max: 100,
                                divisions: 100,
                                activeColor: myMiddleTurquoise,
                                inactiveColor: myMiddleGrey,
                                label: "",
                                onChanged: (double value) {
                                  modifier.setMaxDetour(
                                    length: value.toInt(),
                                  );
                                },
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: distanceBoxes,
                    ),
                    // Container für den zweiten Slider
                    Container(
                      padding: EdgeInsets.fromLTRB(contentPaddingLR,
                          contentPaddingTB, contentPaddingLR, contentPaddingTB),
                      decoration: BoxDecoration(
                          border: Border.all(
                            width: 0,
                            color: myMiddleGrey,
                          ),
                          color: myWhite,
                          boxShadow: [
                            BoxShadow(
                              color: myMiddleGrey,
                              blurRadius: 4, //4
                            )
                          ]),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Auswahl einselner automatisierter Segmente
                          Container(
                            child: Text(
                              'Angestrebte Mindestdauer einzelner automatisierter Abschnitte:',
                              style: TextStyle(
                                fontSize: 17,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          // Anzeige des eingestellten Wertes
                          Center(
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 10),
                              decoration: BoxDecoration(
                                color: myWhite,
                                border:
                                    Border.all(width: 0, color: myMiddleGrey),
                                boxShadow: [
                                  BoxShadow(
                                    color: myMiddleGrey,
                                    blurRadius: 0, //4
                                  )
                                ],
                              ),
                              child: Consumer<TravelProfileDetailModifier>(
                                builder: (context, modifier, __) => Text(
                                  // EINFÜGEN
                                  modifier
                                          .getMinAutomLength()
                                          .round()
                                          .toString() + // EINFÜGEN
                                      ' min',
                                  style: TextStyle(
                                    color: myDarkGrey,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          // Slider
                          Consumer<TravelProfileDetailModifier>(
                            builder: (context, modifier, child) => SliderTheme(
                              data: SliderThemeData(
                                  showValueIndicator: ShowValueIndicator.never),
                              child: Slider(
                                value: modifier
                                    .getMinAutomLength()
                                    .toDouble(), // EINFÜGEN
                                min: 0,
                                max: 60,
                                divisions: 60,
                                activeColor: myMiddleTurquoise,
                                inactiveColor: myMiddleGrey,
                                label: "",
                                // Evtl ändern, falls Slider wirklich zu langsam
                                // onChangeEnd: (double value) {},
                                onChanged: (double value) {
                                  modifier.setMinAutomLength(
                                    length: value.toInt(),
                                  );
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 80,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
