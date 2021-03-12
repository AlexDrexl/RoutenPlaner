import 'package:flutter/material.dart';
import 'package:routenplaner/data/custom_colors.dart';
import 'package:provider/provider.dart';
import 'package:routenplaner/data_structures/TravelProfileData.dart';
import 'package:routenplaner/overview/overview_segment.dart';
import 'package:routenplaner/provider_classes/route_details.dart';
import 'package:routenplaner/provider_classes/travel_profiles_collection.dart';

// Callback ist notwendig, da ansonsten der FutureBuilder nicht neu gestartet werden kann
// Overview_route übergribt eine setstate FUnktion an diese Datei. Wenn diese
// datei die übergebene Funktion ausfruft, wird overview_route inklusive overview_route_builder
// aktualisiert
class OverviewRouteInput extends StatefulWidget {
  final BuildContext context;
  final Function _callback;
  OverviewRouteInput({@required void myCallback(), @required this.context})
      : _callback = myCallback;
  @override
  _OverviewRouteInputState createState() => _OverviewRouteInputState(context);
}

class _OverviewRouteInputState extends State<OverviewRouteInput> {
  // Flex Werte für die information Row
  int flexFirstColumn = 4;
  int flexSecondColumn = 1;
  int flexThirdColumn = 8;
  // merke den ausgewählten Profilnamen, um bei Nicht-Änderung keinen
  // Neustart der Route zu triggern
  String selectedProfileName;

  _OverviewRouteInputState(BuildContext context) {
    var travelProfiles =
        Provider.of<TravelProfileCollection>(context, listen: false);
    if (travelProfiles.selectedTravelProfile != null) {
      selectedProfileName = travelProfiles.selectedTravelProfile.name;
    }
  }

  // Modulare Widgets, die immer wieder benötigt werden
  Row informationRow(
      /*String firstElement,*/ String secondElement,
      IconData middleIcon) {
    return Row(
      children: <Widget>[
        /*
        Expanded(
          flex: flexFirstColumn,
          child: Text(
            firstElement,
            style: TextStyle(fontSize: 17, color: myDarkGrey),
          ),
        ),
        */
        Expanded(
          flex: flexSecondColumn,
          child: Icon(
            middleIcon,
            color: iconColor,
          ),
        ),
        Expanded(
          flex: flexThirdColumn,
          child: Padding(
            padding: EdgeInsets.only(left: 10),
            child: Text(
              secondElement,
              style: TextStyle(fontSize: 17, color: myDarkGrey),
            ),
          ),
        ),
      ],
    );
  }

  // Eigentliches Widget
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        // Alle information rows sind nur der obere Teil bis zu "Abfahrt ab:"
        Consumer<RouteDetails>(
          builder: (context, routeDetails, child) => Column(
            children: <Widget>[
              informationRow(
                  /* "Start", */ routeDetails.startingLocation,
                  Icons.place),
              SizedBox(height: 10),
              informationRow(
                  /*"Ziel", */ routeDetails.destinationLocation,
                  Icons.flag_rounded),
              SizedBox(height: 10),
              informationRow(
                  /*"Abfahrt ab",*/
                  routeDetails.weekDay() +
                      ", " +
                      "${routeDetails.startDateTime.day.toString().padLeft(2, '0')}.${routeDetails.startDateTime.month.toString().padLeft(2, '0')}.${routeDetails.startDateTime.year.toString()}",
                  Icons.calendar_today),
              SizedBox(height: 10),
              informationRow(
                  /*"", */
                  "${routeDetails.startDateTime.hour.toString().padLeft(2, '0')}:${routeDetails.startDateTime.minute.toString().padLeft(2, '0')} Uhr",
                  Icons.access_time),
              //SizedBox(height: 10),
            ],
          ),
        ),

        // Reiseprofil Eingabe
        Row(
          children: <Widget>[
            /*Expanded(
              flex: flexFirstColumn,
              child: Text(
                "Reiseprofil",
                style: TextStyle(fontSize: 17, color: myDarkGrey),
              ),
            ),
            */
            Expanded(
              flex: flexSecondColumn,
              child: Icon(
                Icons.card_travel,
                color: iconColor,
              ),
            ),
            // Expanded für das Dropdown Menü Reiseprofil
            Expanded(
              flex: flexThirdColumn,
              child: Container(
                margin: EdgeInsets.only(right: 50),
                padding: EdgeInsets.fromLTRB(
                    10, 0, 100, 0), //EdgeInsets.only(left: 10),
                child: Consumer<TravelProfileCollection>(
                  builder: (context, travelProfiles, _) =>
                      DropdownButton<String>(
                    isExpanded: true,
                    // Hint wird durch Provider Aktualisiert
                    icon: Icon(
                      Icons.arrow_drop_down,
                      size: 40,
                      color: myMiddleTurquoise,
                    ),
                    hint: Text(travelProfiles.selectedTravelProfile == null
                        ? "Reiseprofil"
                        : travelProfiles.selectedTravelProfile.name),
                    value: travelProfiles.selectedTravelProfile == null
                        ? "Reiseprofil"
                        : travelProfiles.selectedTravelProfile.name,
                    underline: Container(
                      height: 2,
                      color: myMiddleGrey,
                    ),
                    // Wenn Geärndert, dann ändere auch den Wert im Provider
                    onChanged: (String newTravelProfileName) {
                      // RoutenProfil ändern
                      travelProfiles.selectTravelProfile(
                          name: newTravelProfileName);
                      // Aktualisieung, wenn ein anderes Reiseprofil ausgewählt
                      // startet Routenberechnung erneut
                      if (newTravelProfileName != selectedProfileName) {
                        widget?._callback();
                      }
                      selectedProfileName = newTravelProfileName;
                    },
                    items: travelProfiles.travelProfileCollection
                        .map((TravelProfileData profile) {
                      return DropdownMenuItem<String>(
                        value: profile.name,
                        child: Text(
                          profile.name,
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
        SizedBox(
          height: 10, //20
        ),
        // Automatisierte Fahrsegmente einfügen
        OverviewSegments(
          myCallback: widget._callback,
        ),
      ],
    );
  }
}
