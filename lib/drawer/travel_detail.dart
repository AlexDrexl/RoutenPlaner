import 'dart:math';

import 'package:flutter/material.dart';
import 'package:routenplaner/drawer/drawer_home.dart';
import 'package:routenplaner/drawer/input_triangle.dart';
import 'package:routenplaner/provider_classes/travel_profile_modifier.dart';
import 'package:routenplaner/provider_classes/travel_profiles_collection.dart';
import '../data/custom_colors.dart';
import 'package:provider/provider.dart';
import '../footer.dart';

class TravelDetail extends StatelessWidget {
  final ScrollController _scrollController = ScrollController();
  // indexProfile of selected Travel_profiles_data
  final int indexProfile;
  TravelDetail({@required this.indexProfile});
  /////
  @override
  Widget build(BuildContext context) {
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
      bottomNavigationBar: Footer(),
      body: Scrollbar(
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
              //padding: EdgeInsets.symmetric(vertical: 70),
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
                        // Provider Daten aus travelProfileCollection holen
                        Provider.of<TravelProfileCollection>(context,
                                listen: false)
                            .travelProfileCollection[indexProfile]
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
                          margin:
                              EdgeInsets.only(left: 25, right: 25, bottom: 25),
                          padding: EdgeInsets.only(
                              left: 25, right: 25, top: 25, bottom: 25),
                          decoration: BoxDecoration(
                              border: Border.all(width: 0, color: myMiddleGrey),
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
                                  indexProfile: indexProfile,
                                ),
                              ),
                            ),
                            // HIER DAS DREIECK
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                          margin:
                              EdgeInsets.only(left: 25, right: 25, bottom: 25),
                          padding: EdgeInsets.only(
                              left: 25, right: 25, top: 25, bottom: 25),
                          decoration: BoxDecoration(
                              border: Border.all(width: 0, color: myMiddleGrey),
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
                                      .getMaxDetour(indexProfile: indexProfile)
                                      .toDouble(), // EINFÜGEN
                                  min: 0,
                                  max: 100,
                                  divisions: 100,
                                  activeColor: myMiddleTurquoise,
                                  inactiveColor: myMiddleGrey,
                                  label: modifier
                                          .getMaxDetour(
                                              indexProfile: indexProfile)
                                          .round()
                                          .toString() + // EINFÜGEN
                                      ' %',
                                  onChanged: (double value) {
                                    modifier.setMaxDetour(
                                      indexProfile: indexProfile,
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
                          margin:
                              EdgeInsets.only(left: 25, right: 25, bottom: 25),
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
                                      .getMinAutomLength(
                                          indexProfile: indexProfile)
                                      .toDouble(), // EINFÜGEN
                                  min: 0,
                                  max: 60,
                                  divisions: 60,
                                  activeColor: myMiddleTurquoise,
                                  inactiveColor: myMiddleGrey,
                                  label: modifier
                                          .getMinAutomLength(
                                              indexProfile: indexProfile)
                                          .round()
                                          .toString() + // EINFÜGEN
                                      ' min',
                                  // Evtl ändern, falls Slider wirklich zu langsam
                                  // onChangeEnd: (double value) {},
                                  onChanged: (double value) {
                                    modifier.setMinAutomLength(
                                      indexProfile: indexProfile,
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
    );
  }
}
