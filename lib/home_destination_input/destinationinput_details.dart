import 'package:flutter/material.dart';
import 'package:routenplaner/data/custom_colors.dart';
import 'package:routenplaner/drawer/user_profiles.dart';
import 'package:routenplaner/provider_classes/route_details.dart';
import 'package:routenplaner/route_planning2.dart';
import 'package:routenplaner/drawer/travel_profiles.dart';
import 'package:provider/provider.dart';

import 'package:routenplaner/overview/overview_route.dart';

class DestinationInputDetails extends StatefulWidget {
  @override
  _DestinationInputDetailsState createState() =>
      _DestinationInputDetailsState();
}

class _DestinationInputDetailsState extends State<DestinationInputDetails> {
  var date = DateTime.now();
  DateTime selectedDate = DateTime.now();
  DateTime pickedDate;
  TimeOfDay time;

  // die ReiseProfile haben noch keine bedeutung, es sind einfach nur Strings
  String selectedTravelProfile = 'Arbeit';
  List<String> travel = ['Arbeit', 'Freizeit', 'Kinder'];

  // Date Picker
  _pickDate() {
    showDatePicker(
        context: context,
        initialDate: pickedDate,
        firstDate: DateTime(DateTime.now().year - 5),
        lastDate: DateTime(DateTime.now().year + 10));
    if (date != null)
      setState(() {
        // Datum in Provider Einfügen
        Provider.of<RouteDetails>(context, listen: false).startDate = date;
        pickedDate = date;
      });
  }

  _pickTime() async {
    TimeOfDay t = await showTimePicker(context: context, initialTime: time);
    if (t != null)
      setState(() {
        // StartZeit zu Provider hinzufügen
        DateTime locDateTime = DateTime(0, 0, 0, t.hour, t.minute);
        Provider.of<RouteDetails>(context, listen: false).startTime =
            locDateTime;
        time = t;
      });
  }

  void initState() {
    super.initState();
    pickedDate = DateTime.now();
    time = TimeOfDay.now();
  }

  @override
  // Eigentliches Widget
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Insgesamt eine Spalte
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              SizedBox(
                height: 15,
              ),
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
              // Erste Reihe mit Date und Time Picker
              Row(
                children: [
                  Icon(Icons.calendar_today, color: myYellow),
                  //Text("${selectedDate.toLocal()}".split(' ')[0]),
                  SizedBox(
                    width: 18.0,
                  ),
                  MaterialButton(
                    color: myMiddleTurquoise,
                    textColor: myWhite,
                    child: Text(
                        "${pickedDate.day}.${pickedDate.month}.${pickedDate.year}"),
                    onPressed: _pickDate,
                  ),
                  SizedBox(
                    width: 18,
                  ),
                  Icon(Icons.access_time, color: myYellow),
                  SizedBox(
                    width: 18,
                  ),
                  MaterialButton(
                    color: myMiddleTurquoise,
                    textColor: myWhite,
                    child: Text("${time.hour}:${time.minute} Uhr"),
                    onPressed: _pickTime,
                  ),
                ],
              ),
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
                  DropdownButton<String>(
                    hint: Text("Reiseprofil"),
                    icon: Icon(
                      Icons.arrow_drop_down,
                      size: 40,
                      color: myMiddleTurquoise,
                    ),
                    value: selectedTravelProfile,
                    underline: Container(
                      height: 2,
                      color: myMiddleGrey,
                    ),
                    onChanged: (String value) {
                      setState(() {
                        // Zu Provider hinzufügen
                        Provider.of<RouteDetails>(context, listen: false)
                            .routeProfile = value;
                        selectedTravelProfile = value;
                      });
                    },
                    items: travel.map((String travel) {
                      return DropdownMenuItem<String>(
                        value: travel,
                        child: Text(
                          travel,
                          style: TextStyle(color: myDarkGrey),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
              // String "Autom. Fahrsegment.."
              Text(
                'Autom. Fahrsegment hinzufügen',
                style: TextStyle(fontSize: 17, color: myDarkGrey),
              ),
              SizedBox(
                height: 8,
              ),
              // Fahrsegment hinzufügen
              Row(
                children: [
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
                ],
              ),
              SizedBox(
                width: 20,
              ),
              // String "Zwischenstopp hinzufügen"
              Text(
                'Zwischenstopp hinzufügen',
                style: TextStyle(fontSize: 17, color: myDarkGrey),
              ),
              SizedBox(
                height: 8,
              ),
              // Zwischenstopp hinzufügen
              Row(
                children: [
                  Icon(Icons.pin_drop, color: myYellow),
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
                      // Falls gedrückt -> Link zu RoutePlanning2
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
                ],
              ),
              SizedBox(
                height: 8,
              ),
              // Los gets Button, startet Routenberechnung
              MaterialButton(
                minWidth: 300,
                color: myDarkTurquoise,
                textColor: myWhite,
                child: Row(children: [
                  Text(
                    "Los geht's!",
                    style: TextStyle(fontSize: 17),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Icon(Icons.arrow_forward_ios)
                ]),
                // Beim drücke, -> Overview
                onPressed: () {
                  // Zuerst die Daten aus dem Provider route_details
                  // Auf der zweiten Seite Aktualisieren
                  // PROBLEM: Bis hierhin hat man zugriff auf provider aber nach dem Navigator push
                  // nicht mehr
                  Provider.of<RouteDetails>(context, listen: false).refresh();
                  Navigator.push(
                    context,
                    MaterialPageRoute<Widget>(
                      builder: (BuildContext context) => Overview(),
                    ),
                  );
                },
              ),
            ],
          ),
          /*Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                height: 80,
              ),
              FloatingActionButton(
                  backgroundColor: Hexcolor('48ACB8'),
                  child: Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.white,
                    size: 30,
                  ),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute<Widget>(
                            builder: (BuildContext context) =>
                                RoutePlanning2()));
                  })
            ],
          )*/
        ],
      ),
    );
  }
}
