import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:routenplaner/data/custom_colors.dart';
import 'package:provider/provider.dart';
import 'package:routenplaner/provider_classes/route_details.dart';
import 'package:google_maps_webservice/places.dart';

// Globale Variablen, für Google benötigt
final String apiKey = 'AIzaSyC0DgP0BdEXEybFlEReSj_ghex8jTDOeWE';
GoogleMapsPlaces _places = GoogleMapsPlaces(apiKey: apiKey);

// Popup, das anhand der Adresse in den Adressen/verbindung Komplex die zugehörigen
// Koordinaten sucht und den Nutzer befragt, ob eine Adresse als Start oder Ziel eingefügt werden soll
// Popup gibt bool start zurück, je nach auswahl des Nutzers
class AddressInsertDialog extends StatefulWidget {
  final String addressName;
  AddressInsertDialog(this.addressName);

  @override
  _AddressInsertDialogState createState() =>
      _AddressInsertDialogState(addressName);
}

class _AddressInsertDialogState extends State<AddressInsertDialog> {
  _AddressInsertDialogState(this.addressName);
  String addressName;
  bool startFutureBuilder = false;
  bool geoCoordStart = false;
  Future<LatLng> getGeoCoord(String addressName) async {
    var details = await _places.searchByText(addressName);
    var lat = details.results[0].geometry.location.lat;
    var lng = details.results[0].geometry.location.lng;
    return LatLng(lat, lng);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        margin: EdgeInsets.fromLTRB(20, 20, 20, 20),
        width: MediaQuery.of(context).size.width - 50,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 5,
                  child: Text(
                    widget.addressName + "\neinfügen als:",
                    style: TextStyle(fontSize: 20, color: myDarkGrey),
                  ),
                ),
                // X Button fürs schließen
                Expanded(
                  flex: 1,
                  child: Container(
                    height: 40,
                    width: 40,
                    child: FloatingActionButton(
                      child: Icon(
                        Icons.close,
                        size: 30,
                        color: myWhite,
                      ),
                      onPressed: () {
                        Navigator.of(context).pop(null);
                      },
                    ),
                  ),
                )
              ],
            ),
            SizedBox(
              height: 30,
            ),
            // Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.max,
              children: [
                // erste Button "START"
                Expanded(
                  flex: 1,
                  child: Container(
                    decoration: BoxDecoration(
                      color: myMiddleTurquoise,
                      border: Border.all(width: 0, color: myDarkGrey),
                      borderRadius: BorderRadius.all(
                        Radius.circular(10),
                      ),
                    ),
                    child: FlatButton(
                      child: Text(
                        "Start",
                        style: TextStyle(fontSize: 15, color: myWhite),
                      ),
                      onPressed: () async {
                        setState(() {
                          startFutureBuilder = true;
                          geoCoordStart = true;
                        });
                      },
                    ),
                  ),
                ),
                // Future Builder, wird nur gezeigt, wenn ein Button gedrückt wurde
                Expanded(
                  flex: 1,
                  child: Center(
                    child: startFutureBuilder
                        ? FutureBuilder<LatLng>(
                            future: getGeoCoord(addressName),
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                print("ADDRESS FOUND");
                                // Je nachdem ob start oder ziel, werden die Koordinaten
                                // in start oder ziel gespeichert
                                if (geoCoordStart) {
                                  Provider.of<RouteDetails>(context,
                                          listen: false)
                                      .geoCoordStart = snapshot.data;
                                } else {
                                  Provider.of<RouteDetails>(context,
                                          listen: false)
                                      .geoCoordDestination = snapshot.data;
                                }
                                Navigator.of(context).pop(geoCoordStart);
                                return Container();
                              } else if (snapshot.hasError) {
                                print("ADDRESS NOT FOUND");
                                return Text(
                                  "Kein\nInternet",
                                  style: TextStyle(
                                      color: myDarkGrey, fontSize: 15),
                                );
                              } else {
                                print("SEARCHING FOR ADDRESS");
                                return Container(
                                  height: 30,
                                  width: 30,
                                  child: CircularProgressIndicator(),
                                );
                              }
                            },
                          )
                        : Container(),
                  ),
                ),
                // Zweiter Button "Ziel"
                Expanded(
                  flex: 1,
                  child: Container(
                    decoration: BoxDecoration(
                      color: myMiddleTurquoise,
                      border: Border.all(width: 0, color: myDarkGrey),
                      borderRadius: BorderRadius.all(
                        Radius.circular(10),
                      ),
                    ),
                    child: FlatButton(
                      child: Text(
                        "Ziel",
                        style: TextStyle(fontSize: 15, color: myWhite),
                      ),
                      onPressed: () async {
                        setState(() {
                          startFutureBuilder = true;
                          geoCoordStart = false;
                        });
                      },
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
