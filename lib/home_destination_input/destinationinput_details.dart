import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:routenplaner/data/custom_colors.dart';
import 'package:routenplaner/home_destination_input/homeAutomationSegments.dart';
import 'package:routenplaner/provider_classes/addresses.dart';
import 'package:routenplaner/provider_classes/road_connections.dart';
import 'package:routenplaner/provider_classes/route_details.dart';
import 'package:routenplaner/provider_classes/travel_profiles_collection.dart';
import 'package:provider/provider.dart';
import 'package:routenplaner/overview/overview_route.dart';

class DestinationInputDetails extends StatefulWidget {
  final BuildContext context;
  DestinationInputDetails(this.context);
  @override
  _DestinationInputDetailsState createState() =>
      _DestinationInputDetailsState(context);
}

class _DestinationInputDetailsState extends State<DestinationInputDetails> {
  var date = DateTime.now();
  DateTime pickedDate;
  TimeOfDay pickedTime;
  String selectedTravelProfile;
  bool inputMissing = false;
  bool expanded = false;

  _DestinationInputDetailsState(BuildContext context) {
    pickedDate = DateTime.now();
    pickedTime = TimeOfDay.now();
  }
  // Date Picker
  _pickDate() async {
    DateTime date = await showDatePicker(
        context: context,
        locale: const Locale("de", "DE"),
        initialDate: DateTime.now(),
        firstDate: DateTime(DateTime.now().year - 5),
        lastDate: DateTime(DateTime.now().year + 10));
    if (date != null)
      setState(() {
        // Datum in Provider Einfügen
        Provider.of<RouteDetails>(context, listen: false)
            .setStartDate(date.year, date.month, date.day);
        pickedDate = date;
      });
  }

  // Time Picker
  _pickTime() async {
    TimeOfDay t =
        await showTimePicker(
          context: context, 
          cancelText: "ABBRECHEN",
          helpText: "ZEIT AUSWÄHLEN",
          initialTime: TimeOfDay.now()
          );
    if (t != null)
      setState(() {
        Provider.of<RouteDetails>(context, listen: false)
            .setStartTime(hour: t.hour, min: t.minute);
        pickedTime = t;
      });
  }

  String getSelectedTravelProfileName() {
    var profiles = Provider.of<TravelProfileCollection>(context, listen: false);
    if (profiles.selectedTravelProfile != null) {
      return profiles.selectedTravelProfile.name;
    }
    return null;
  }

  // Dropdown items
  List<DropdownMenuItem<String>> getDropDownItems(
      TravelProfileCollection profiles) {
    List<DropdownMenuItem<String>> widgetList =
        List<DropdownMenuItem<String>>();
    // Kurzes Überprüfen, ob denn überhaupt TravelProfiles da sind
    if (profiles.travelProfileCollection.isEmpty) {
      return null;
    }
    for (int i = 0; i < profiles.travelProfileCollection.length; i++) {
      widgetList.add(
        DropdownMenuItem(
          child: Text(
            profiles.travelProfileCollection[i].name,
            style: TextStyle(color: myDarkGrey),
          ),
          value: profiles.travelProfileCollection[i].name,
        ),
      );
    }

    return widgetList;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Bisschen abstand
          SizedBox(height: 20),
          // Erste Reihe mit Date und Time Picker
          // Überschrift
          Row(children: [
            Text(
              'Abfahrt ab',
              style: TextStyle(fontSize: 17, color: myDarkGrey),
            ),
            /*Text(
              ' / Ankunft bis',
              style: TextStyle(fontSize: 17, color: myMiddleGrey),
            ), */
          ]),
          SizedBox(
            height: 8,
          ),
          // Date Picker und Time Picker
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween, //spaceBetween
            children: [

              // Button für Date Picker
              Row(
                children: [
                  Icon(Icons.calendar_today, color: iconColor),
                  SizedBox(
                    width: 20,
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 5),
                    child: MaterialButton(
                      color: myMiddleTurquoise,
                      textColor: myWhite,
                      child: Text(
                        "${pickedDate.day.toString().padLeft(2, '0')}.${pickedDate.month.toString().padLeft(2, '0')}.${pickedDate.year.toString()}",
                      ),
                      onPressed: _pickDate,
                    ),
                  ),
                ],
              ),

              // Button für Time Picker
              Row(
                children: [
                  Padding(
                    padding: EdgeInsets.only(right: 5),
                    child: Icon(Icons.access_time, color: iconColor),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  MaterialButton(
                    color: myMiddleTurquoise,
                    textColor: myWhite,
                    child: Text(
                        "${pickedTime.hour.toString().padLeft(2, '0')}:${pickedTime.minute.toString().padLeft(2, '0')} Uhr"),
                    onPressed: _pickTime,
                  ),
                  SizedBox(
                    width: 3,
                  ),
                ],
              ),
            ],
          ),
              
              
              Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      SizedBox(
                        height: 20, //8
                      ),
                      // String "Reiseprofil"
                      Text(
                        'Reiseprofil',
                        style: TextStyle(fontSize: 17, color: myDarkGrey),
                      ),
                      SizedBox(
                        height: 5, //8
                      ),
                      // Reiseprofileingabe
                      Row(
                        children: [
                          Icon(
                            Icons.card_travel,
                            color: iconColor,
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          Consumer<TravelProfileCollection>(
                            builder: (context, travelProfiles, __) {
                              return DropdownButton<String>(
                                hint: Text("Reiseprofil"),
                                icon: Icon(
                                  Icons.arrow_drop_down,
                                  size: 40, //40
                                  color: myMiddleTurquoise,
                                ),
                                value: getSelectedTravelProfileName(),
                                underline: Container(
                                  height: 2, //2
                                  color: myMiddleGrey,
                                ),
                                onChanged: (String value) {
                                  // Setze ein Reiseprofil, auch in Provider
                                  selectedTravelProfile = value;
                                  travelProfiles.selectTravelProfile(
                                      name: value);
                                },
                                items: getDropDownItems(travelProfiles),
                              );
                            },
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 15, //30
                      ),
                      // String "Autom. Fahrsegment.."
                      Text(
                        'Automatisierte Fahrtabschnitte',
                        style: TextStyle(fontSize: 17, color: myDarkGrey),
                      ),
                      SizedBox(
                        height: 0, //10
                      ),
                      //// Hier die Automatisierten Segmente einfügen
                      HomeAutomationSegments(),
                      ///////////////
                      SizedBox(
                        height: 10, //8 Abstand nach unten (zum Button Los gehts)
                      ),
                    ],
                  ),


          //SizedBox(height: 10), //Abstand zum oberen Element
          
          /*
          // Expansion Panel zum Ausklappen
          ExpansionPanelList(
            expansionCallback: (int index, bool isExpanded) {
              setState(() {
                expanded = !isExpanded;
              });
            },
            children: <ExpansionPanel>[
              ExpansionPanel(
                // header
                headerBuilder: (BuildContext context, bool isExpanded) {
                  return Container(
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Weitere Optionen",
                        style: TextStyle(color: myDarkGrey, fontSize: 17),
                      ),
                    ),
                  );
                },
                body: Container(
                  margin: EdgeInsets.all(10), //Rückt Reiseprofile und autom. Abschnitte ein

                  // Hier den gesamten Komplex hinein, sollte alles wie bisher funktionieren
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      SizedBox(
                        height: 0, //8
                      ),
                      // String "Reiseprofil"
                      Text(
                        'Reiseprofil',
                        style: TextStyle(fontSize: 17, color: myDarkGrey),
                      ),
                      // Reiseprofileingabe
                      Row(
                        children: [
                          Icon(
                            Icons.card_travel,
                            color: iconColor,
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          Consumer<TravelProfileCollection>(
                            builder: (context, travelProfiles, __) {
                              return DropdownButton<String>(
                                hint: Text("Reiseprofil"),
                                icon: Icon(
                                  Icons.arrow_drop_down,
                                  size: 40, //40
                                  color: myMiddleTurquoise,
                                ),
                                value: getSelectedTravelProfileName(),
                                underline: Container(
                                  height: 2, //2
                                  color: myMiddleGrey,
                                ),
                                onChanged: (String value) {
                                  // Setze ein Reiseprofil, auch in Provider
                                  selectedTravelProfile = value;
                                  travelProfiles.selectTravelProfile(
                                      name: value);
                                },
                                items: getDropDownItems(travelProfiles),
                              );
                            },
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 15, //30
                      ),
                      // String "Autom. Fahrsegment.."
                      Text(
                        'Automatisierte Fahrtabschnitte',
                        style: TextStyle(fontSize: 17, color: myDarkGrey),
                      ),
                      SizedBox(
                        height: 0, //10
                      ),
                      //// Hier die Automatisierten Segmente einfügen
                      HomeAutomationSegments(),
                      ///////////////
                      SizedBox(
                        height: 0, //8 Abstand nach unten (zum Button Los gehts)
                      ),
                    ],
                  ),
                ),
                isExpanded: expanded,
              ),
            ],
          ),
*/

          SizedBox(
            height: 0, //Abstand nach oben (zum Abschnitt Automisierte Abschnitte)
          ),

          // Los gehts button
          MaterialButton(
            minWidth: 300,
            height: 40,
            color: myDarkTurquoise,
            textColor: myWhite,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(3)),
            child: Row(
              children: [
                Text(
                  "Los geht's!",
                  style: TextStyle(fontSize: 17),
                ),
                SizedBox(
                  width: 10,
                ),
                Icon(Icons.arrow_forward_ios)
              ],
            ),
            // Beim drücken, -> Overview
            onPressed: () async {
              // Überprüfe, ob die Eingaben gültig sind
              if (Provider.of<RouteDetails>(context, listen: false)
                  .validInputs()) {
                // Setze das ausgewählte TravelProfil
                Provider.of<TravelProfileCollection>(context, listen: false)
                    .selectTravelProfile(name: selectedTravelProfile);
                // hole die Start und Ziel Orte
                // Kann im Hintergrund ablaufen
                String start = Provider.of<RouteDetails>(context, listen: false)
                    .startingLocation;
                String destination =
                    Provider.of<RouteDetails>(context, listen: false)
                        .destinationLocation;
                // Füge die eigegebene Locations zu Address und RoadConnection hinzu
                await Provider.of<AddressCollection>(context, listen: false)
                    .addAddress(addressName: start, timeNow: DateTime.now());
                await Provider.of<AddressCollection>(context, listen: false)
                    .addAddress(
                        addressName: destination, timeNow: DateTime.now());
                await Provider.of<RoadConnections>(context, listen: false)
                    .addRoadConnection(
                        start: start,
                        destination: destination,
                        timeNow: DateTime.now());
                // Pushe zur nächsten seite
                Navigator.push<Widget>(
                  context,
                  MaterialPageRoute<Widget>(
                    builder: (BuildContext context) => Overview(),
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
