import 'dart:math';
import 'package:flutter/material.dart';
import 'package:routenplaner/drawer/drawer_home.dart';
import 'package:routenplaner/drawer/input_triangle.dart';
import 'package:routenplaner/drawer/travel_profiles.dart';
import 'package:routenplaner/provider_classes/travel_profile_modifier.dart';
import 'package:routenplaner/provider_classes/travel_profiles_collection.dart';
import 'package:routenplaner/route_planning.dart';
import 'package:routenplaner/route_planning2.dart';
import '../data/custom_colors.dart';
import 'package:provider/provider.dart';
import '../footer.dart';

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
  _TravelDetailState(this.indexProfile) {
    // Übergebe das Profi an den Modifier, als Startwert
  }

  Future<bool> safeChanges() {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                flex: 6,
                child: Text(
                  "Möchten Sie die Änderungen speichern?",
                  overflow: TextOverflow.ellipsis,
                  maxLines: 3,
                ),
              ),
              Expanded(
                flex: 1,
                child: FloatingActionButton(
                  child: Icon(
                    Icons.close,
                    color: myWhite,
                    size: 40,
                  ),
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                ),
              ),
            ],
          ),
          content: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(14)),
                  color: myLightGrey,
                ),
                child: MaterialButton(
                  child: Text(
                    "Nicht Speichern",
                    style: TextStyle(
                      fontSize: 15,
                      color: myDarkGrey,
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
                  borderRadius: BorderRadius.all(Radius.circular(14)),
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

  /////
  @override
  Widget build(BuildContext context) {
    Provider.of<TravelProfileDetailModifier>(context, listen: false)
        .init(indexProfile: indexProfile, context: context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Reiseprofile',
          style: TextStyle(fontSize: 30, color: myWhite),
        ),
        iconTheme: new IconThemeData(color: myWhite),
        //backgroundColor: Colors.transparent,
      ),
      drawer: DrawerHome(),
      bottomNavigationBar: Stack(
        children: [
          // Home Button
          BottomAppBar(
            color: Colors.white.withOpacity(0),
            child: Container(
              padding: EdgeInsets.only(top: 5, bottom: 5, left: 5, right: 5),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.white.withOpacity(0.1),
                    Colors.white.withOpacity(0.9),
                  ],
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    decoration: BoxDecoration(
                        color: myMiddleTurquoise,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                              blurRadius: 10, color: myWhite, spreadRadius: 5),
                        ]),
                    child: CircleAvatar(
                      radius: 30,
                      backgroundColor: myMiddleTurquoise,
                      child: IconButton(
                        icon: Icon(Icons.home, color: myWhite, size: 30),
                        onPressed: () async {
                          homeButtonPressed = true;
                          safeChanges();
                          // Navigator.pushReplacementNamed(context, '/');
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            // Mit margin hindeichseln
            children: [
              Container(
                margin: EdgeInsets.only(top: 5, bottom: 5, left: 5, right: 50),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(blurRadius: 10, color: myWhite, spreadRadius: 5),
                  ],
                ),
                child: CircleAvatar(
                  radius: 30,
                  backgroundColor: myMiddleTurquoise,
                  child: IconButton(
                    icon: Icon(
                      Icons.save,
                      color: myWhite,
                      size: 30,
                    ),
                    onPressed: () {
                      Provider.of<TravelProfileDetailModifier>(context,
                              listen: false)
                          .safe(indexProfile, context);
                      Navigator.push(
                        context,
                        MaterialPageRoute<Widget>(
                          builder: (BuildContext context) => TravelProfiles(),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          )
        ],
      ),
      body: WillPopScope(
        onWillPop: safeChanges,
        child: Scrollbar(
          controller: _scrollController,
          isAlwaysShown: true,
          child: SingleChildScrollView(
            controller: _scrollController,
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  colorFilter: new ColorFilter.mode(
                      Colors.grey.withOpacity(0.15), BlendMode.dstATop),
                  image: AssetImage("assets/images/citybackground.png"),
                  fit: BoxFit.fitWidth,
                ),
              ),
              child: Container(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(
                          left: 25, right: 25, top: 25, bottom: 25),
                      padding: EdgeInsets.only(left: 10, right: 10),
                      decoration: BoxDecoration(
                          border: Border.all(width: 0, color: myMiddleGrey),
                          borderRadius: BorderRadius.all(Radius.circular(14)),
                          color: myWhite,
                          boxShadow: [
                            BoxShadow(
                              color: myMiddleGrey,
                              blurRadius: 4,
                            )
                          ]),
                      child: ListTile(
                        contentPadding: EdgeInsets.only(
                            left: 15, right: 15, top: 8, bottom: 8),
                        leading:
                            Icon(Icons.card_travel, color: myYellow, size: 50),
                        title: Text(
                          // Überschrift aus dem Provider Objekt mit index holen
                          Provider.of<TravelProfileCollection>(context,
                                  listen: false)
                              .travelProfileCollection[widget.indexProfile]
                              .name,
                          style: TextStyle(
                            fontSize: 20,
                            color: myDarkGrey,
                          ),
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            margin: EdgeInsets.only(
                                left: 25, right: 25, bottom: 25),
                            padding: EdgeInsets.only(
                                left: 25, right: 25, top: 25, bottom: 25),
                            decoration: BoxDecoration(
                                border:
                                    Border.all(width: 0, color: myMiddleGrey),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(14)),
                                color: myWhite,
                                boxShadow: [
                                  BoxShadow(
                                    color: myMiddleGrey,
                                    blurRadius: 4,
                                  )
                                ]),
                            child: Column(children: [
                              Text(
                                'Max. Automationsdauer',
                                style: TextStyle(fontSize: 17),
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
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Min. Reisezeit',
                                    style: TextStyle(fontSize: 17),
                                  ),
                                  Text(
                                    'Wenig Wechsel\n        AD/MD',
                                    style: TextStyle(fontSize: 17),
                                  ),
                                ],
                              ),
                            ]),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            margin: EdgeInsets.only(
                                left: 25, right: 25, bottom: 25),
                            padding: EdgeInsets.only(
                                left: 25, right: 25, top: 25, bottom: 25),
                            decoration: BoxDecoration(
                                border:
                                    Border.all(width: 0, color: myMiddleGrey),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(14)),
                                color: myWhite,
                                boxShadow: [
                                  BoxShadow(
                                    color: myMiddleGrey,
                                    blurRadius: 4,
                                  )
                                ]),
                            // Max Umweg verglichen zur kürzesten Route
                            child: Column(
                              children: [
                                Container(
                                  child: Text(
                                    'Max. Umweg im Vergleich zur kürzesten Route',
                                    style: TextStyle(fontSize: 17),
                                  ),
                                ),
                                // Max detour
                                Consumer<TravelProfileDetailModifier>(
                                  builder: (context, modifier, __) => Slider(
                                    value: modifier
                                        .getMaxDetour()
                                        .toDouble(), // EINFÜGEN
                                    min: 0,
                                    max: 100,
                                    divisions: 100,
                                    activeColor: myMiddleTurquoise,
                                    inactiveColor: myMiddleGrey,
                                    label: modifier
                                            .getMaxDetour()
                                            .round()
                                            .toString() + // EINFÜGEN
                                        ' %',
                                    onChanged: (double value) {
                                      modifier.setMaxDetour(
                                        length: value.toInt(),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            margin: EdgeInsets.only(
                                left: 25, right: 25, bottom: 25),
                            padding: EdgeInsets.only(
                                left: 25, right: 25, top: 25, bottom: 25),
                            decoration: BoxDecoration(
                                border: Border.all(
                                  width: 0,
                                  color: myMiddleGrey,
                                ),
                                borderRadius: BorderRadius.all(
                                  Radius.circular(14),
                                ),
                                color: myWhite,
                                boxShadow: [
                                  BoxShadow(
                                    color: myMiddleGrey,
                                    blurRadius: 4,
                                  )
                                ]),
                            child: Column(
                              children: [
                                // Auswahl einselner automatisierter Segmente
                                Container(
                                    child: Text(
                                        'Min. Dauer einzelner automatisierter Segmente',
                                        style: TextStyle(fontSize: 17))),
                                Consumer<TravelProfileDetailModifier>(
                                  builder: (context, modifier, child) => Slider(
                                    value: modifier
                                        .getMinAutomLength()
                                        .toDouble(), // EINFÜGEN
                                    min: 0,
                                    max: 60,
                                    divisions: 60,
                                    activeColor: myMiddleTurquoise,
                                    inactiveColor: myMiddleGrey,
                                    label: modifier
                                            .getMinAutomLength()
                                            .round()
                                            .toString() + // EINFÜGEN
                                        ' min',
                                    // Evtl ändern, falls Slider wirklich zu langsam
                                    // onChangeEnd: (double value) {},
                                    onChanged: (double value) {
                                      modifier.setMinAutomLength(
                                        length: value.toInt(),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
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
