import 'package:flutter/material.dart';
import 'package:routenplaner/data/custom_colors.dart';
import 'package:provider/provider.dart';

import 'package:routenplaner/overview/overview_segment.dart';
import 'package:routenplaner/provider_classes/route_details.dart';
import 'package:routenplaner/provider_classes/travel_profiles_collection.dart';

class OverviewRouteInput extends StatefulWidget {
  @override
  _OverviewRouteInputState createState() => _OverviewRouteInputState();
}

class _OverviewRouteInputState extends State<OverviewRouteInput> {
  // Variablen, aus Laufzeit Datenbank
  List<String> travelProfilenames = List<String>();
  String selectedAutomationLength;

  int flexFirstColumn = 5;
  int flexSecondColumn = 2;
  int flexThirdColumn = 8;

  // setze die Travel ProfilNamen in ein Lokales Objekt
  void setTravelProfiles(BuildContext context) {
    travelProfilenames.clear();
    var travelProfiles =
        Provider.of<TravelProfileCollection>(context, listen: false)
            .travelProfileCollection;
    for (int i = 0; i < travelProfiles.length; i++) {
      travelProfilenames.add(
        travelProfiles[i].name,
      );
    }
  }

  // Modulare Widgets, die immer wieder benötigt werden
  Row informationRow(
      String firstElement, String secondElement, IconData middleIcon) {
    return Row(
      children: <Widget>[
        Expanded(
          flex: flexFirstColumn,
          child: Text(
            firstElement,
            style: TextStyle(fontSize: 17, color: myDarkGrey),
          ),
        ),
        Expanded(
          flex: flexSecondColumn,
          child: Icon(
            middleIcon,
            color: myYellow,
          ),
        ),
        Expanded(
          flex: flexThirdColumn,
          child: Text(
            secondElement,
            style: TextStyle(fontSize: 17, color: myDarkGrey),
          ),
        ),
      ],
    );
  }

  // Eigentliches Widget
  @override
  Widget build(BuildContext context) {
    // Zuerst die TravelProfile Setzen
    setTravelProfiles(context);
    print("BUILD");
    // PROVIDER FÜR PUPUP UND OVERVIEW SEGMENT
    return Column(
      children: <Widget>[
        // Alle information rows sind nur der obere Teil bis zu "Abfahrt ab:"
        Consumer<RouteDetails>(
          builder: (context, routeDetails, child) => Column(
            children: <Widget>[
              informationRow(
                  "Start:", routeDetails.startingLocation, Icons.place),
              SizedBox(height: 10),
              informationRow("Ziel:", routeDetails.destinationLocation,
                  Icons.flag_rounded),
              SizedBox(height: 10),
              informationRow(
                  "Abfahrt ab:",
                  routeDetails.weekDay() +
                      ", " +
                      "${routeDetails.startDateTime.day.toString().padLeft(2, '0')}.${routeDetails.startDateTime.month.toString().padLeft(2, '0')}.${routeDetails.startDateTime.year.toString()}",
                  Icons.calendar_today),
              SizedBox(height: 10),
              informationRow(
                  "",
                  "${routeDetails.startDateTime.hour.toString().padLeft(2, '0')}:${routeDetails.startDateTime.minute.toString().padLeft(2, '0')} Uhr",
                  Icons.access_time),
              SizedBox(height: 10),
            ],
          ),
        ),

        // Reiseprofil Eingabe
        Row(
          children: <Widget>[
            Expanded(
              flex: flexFirstColumn,
              child: Text(
                "Reisprofil",
                style: TextStyle(fontSize: 17, color: myDarkGrey),
              ),
            ),
            Expanded(
              flex: flexSecondColumn,
              child: Icon(
                Icons.time_to_leave,
                color: myYellow,
              ),
            ),
            // Expanded für das Dropdown Menü Reiseprofil
            Expanded(
              flex: flexThirdColumn,
              child: Container(
                margin: EdgeInsets.only(right: 50),
                child: Consumer<RouteDetails>(
                  builder: (context, routeDetails, _) => DropdownButton<String>(
                    // Hint wird durch Provider Aktualisiert
                    icon: Icon(
                      Icons.arrow_drop_down,
                      size: 40,
                      color: myMiddleTurquoise,
                    ),
                    hint: Text(routeDetails.selectedTravelProfile.name == null
                        ? "Reiseprofil"
                        : routeDetails.selectedTravelProfile.name),
                    value: routeDetails.selectedTravelProfile.name == null
                        ? "Reiseprofil"
                        : routeDetails.selectedTravelProfile.name,
                    underline: Container(
                      height: 2,
                      color: myMiddleGrey,
                    ),
                    // Wenn Geärndert, dann ändere auch den Wert im Provider
                    onChanged: (String travelProfileName) {
                      // RoutenProfil ändern
                      Provider.of<RouteDetails>(context, listen: false)
                          .setTravelProfile(
                              travelProfileName: travelProfileName,
                              context: context);
                      // Aktualisieren
                    },
                    items: travelProfilenames.map((String i) {
                      return DropdownMenuItem<String>(
                        value: i,
                        child: Text(
                          i,
                          style: TextStyle(color: myDarkGrey),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ),
          ],
        ),
        // Min. Automationszeit
        /*
        Row(
          children: <Widget>[
            Expanded(
              flex: flexFirstColumn + flexSecondColumn,
              child: Text(
                "Min. Automationszeit",
                style: TextStyle(fontSize: 17, color: myDarkGrey),
              ),
            ),
            // Expanded für das Dropdown menü min autom. Reisezeit
            Expanded(
              flex: flexThirdColumn,
              child: Container(
                margin: EdgeInsets.only(right: 70),
                child: DropdownButton<String>(
                  hint: Text("0 min"),
                  icon: Icon(
                    Icons.arrow_drop_down,
                    size: 40,
                    color: myMiddleTurquoise,
                  ),
                  value: selectedAutomationLength,
                  underline: Container(
                    height: 2,
                    color: myMiddleGrey,
                    width: 4,
                  ),
                  onChanged: (String timeValue) {
                    setState(() {
                      selectedAutomationLength = timeValue;
                    });
                  },
                  // Mappe durch alle elemente, dann wieder zu Liste
                  items: minAutomationLength.map((String i) {
                    return DropdownMenuItem<String>(
                      value: i,
                      child: Text(
                        i + " min",
                        style: TextStyle(color: myDarkGrey),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
          ],
        ),
        */
        // Automatisierte Fahrsegmente einfügen
        OverviewSegments(),
      ],
    );
  }
}
