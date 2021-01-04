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
  List<String> travelProfileNames = List<String>();
  bool inputMissing = false;
  bool expanded = false;

  _DestinationInputDetailsState(BuildContext context) {
    pickedDate = DateTime.now();
    pickedTime = TimeOfDay.now();
    setNameList(context);
  }
  // Date Picker
  _pickDate() async {
    DateTime date = await showDatePicker(
        context: context,
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
        await showTimePicker(context: context, initialTime: TimeOfDay.now());
    if (t != null)
      setState(() {
        Provider.of<RouteDetails>(context, listen: false)
            .setStartTime(hour: t.hour, min: t.minute);
        pickedTime = t;
      });
  }

  void initState() {
    // setNameList(context);
    super.initState();
  }

  void setNameList(BuildContext context) {
    travelProfileNames.clear();
    // Hole die Travel Profilnamen aus der TravelProfileCollection
    Provider.of<TravelProfileCollection>(context, listen: false)
        .getTravelProfileNames()
        .then(
          (val) => setState(
            () {
              if (val.length != 0) {
                travelProfileNames = val;
                selectedTravelProfile = val[0];
              }
            },
          ),
        );
  }

  List<DropdownMenuItem<String>> getDropDownItems(
      TravelProfileCollection profiles) {
    List<DropdownMenuItem<String>> widgetList =
        List<DropdownMenuItem<String>>();
    // Kurzes Überprüfen, ob denn überhaupt TravelProfiles da sind
    if (travelProfileNames == null) {
      return null;
    }
    for (int i = 0; i < travelProfileNames.length; i++) {
      widgetList.add(
        DropdownMenuItem(
          child: Text(
            travelProfileNames[i],
            style: TextStyle(color: myDarkGrey),
          ),
          value: travelProfileNames[i],
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
            Text(
              ' / Ankunft bis',
              style: TextStyle(fontSize: 17, color: myMiddleGrey),
            ),
          ]),
          SizedBox(
            height: 8,
          ),
          // Date Picker und Time Picker
          Row(
            children: [
              Icon(Icons.calendar_today, color: myYellow),
              //String convertedDateTime = "${now.year.toString()}-${now.month.toString().padLeft(2,'0')}-${now.day.toString().padLeft(2,'0')} ${now.hour.toString()}-${now.minute.toString()}";
              SizedBox(
                width: 18.0,
              ),
              // Button für DatePicker
              MaterialButton(
                color: myMiddleTurquoise,
                textColor: myWhite,
                child: Text(
                  "${pickedDate.day.toString().padLeft(2, '0')}.${pickedDate.month.toString().padLeft(2, '0')}.${pickedDate.year.toString()}",
                ),
                onPressed: _pickDate,
              ),
              SizedBox(
                width: 18,
              ),
              Icon(Icons.access_time, color: myYellow),
              SizedBox(
                width: 18,
              ),
              // Button für den TimePicker
              MaterialButton(
                color: myMiddleTurquoise,
                textColor: myWhite,
                child: Text(
                    "${pickedTime.hour.toString().padLeft(2, '0')}:${pickedTime.minute.toString().padLeft(2, '0')} Uhr"),
                onPressed: _pickTime,
              ),
            ],
          ),
          SizedBox(height: 20),
          // Expansion panel zum ausklappen
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
                      alignment: Alignment.center,
                      child: Text(
                        "Weitere Angaben",
                        style: TextStyle(color: myDarkGrey, fontSize: 17),
                      ),
                    ),
                  );
                },
                body: Container(
                  margin: EdgeInsets.all(10),
                  // Hier den gesamten Komplex hinein, sollte alles wie bisher funktionieren
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      SizedBox(
                        height: 8,
                      ),
                      // String "Reiseprofil"
                      Text(
                        'Reiseprofil',
                        style: TextStyle(fontSize: 17, color: myDarkGrey),
                      ),
                      // reiseprofileingabe
                      Row(
                        children: [
                          Icon(
                            Icons.card_travel,
                            color: myYellow,
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
                                  size: 40,
                                  color: myMiddleTurquoise,
                                ),
                                value: selectedTravelProfile == null
                                    ? null
                                    : selectedTravelProfile,
                                underline: Container(
                                  height: 2,
                                  color: myMiddleGrey,
                                ),
                                onChanged: (String value) {
                                  setState(() {
                                    // Setze ein Reiseprofil, auch in Provider
                                    selectedTravelProfile = value;
                                  });
                                },
                                items: getDropDownItems(travelProfiles),
                              );
                            },
                          ),
                        ],
                      ),
                      // String "Autom. Fahrsegment.."
                      Text(
                        'Autom. Fahrsegment hinzufügen',
                        style: TextStyle(fontSize: 17, color: myDarkGrey),
                      ),
                      //// Hier die Automatisierten Segmente einfügen
                      HomeAutomationSegments(),
                      ///////////////
                      SizedBox(
                        height: 8,
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      // Los gets Button, startet Routenberechnung
                    ],
                  ),
                ),
                isExpanded: expanded,
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            "Durch kurzfristige Änderungen bei Verkehr und Umgebungsbedingungen kann es zu Abweichungen von Planung und tatsächlichem Fahrtverlauf kommen",
            style: TextStyle(fontSize: 10, color: myDarkGrey),
          ),
          // Los gehts button
          MaterialButton(
            minWidth: 300,
            color: myDarkTurquoise,
            textColor: myWhite,
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
            // Beim drücke, -> Overview
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
                await Navigator.push<Widget>(
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

/*
                Navigator.push<Widget>(
                  context,
                  MaterialPageRoute<Widget>(
                    builder: (BuildContext context) => Overview(),
                  ),
                );
Icon(Icons.local_car_wash, color: myYellow),
                  SizedBox(
                    width: 20,
                  ),
                  CircleAvatar(
                    backgroundColor: myMiddleTurquoise,
                    radius: 21,
                    child: IconButton(
                      icon: Icon(
                        Icons.add,
                        color: myWhite,
                        size: 25,
                      ),
                      // Falls Button gedrückt -> Link RoutePlanning2
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute<Widget>(
                            builder: (BuildContext context) => RoutePlanning2(),
                          ),
                        );
                      },
                    ),
                  ),
*/
