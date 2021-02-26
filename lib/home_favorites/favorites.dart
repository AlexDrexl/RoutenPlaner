import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:routenplaner/data/custom_colors.dart';
import 'package:provider/provider.dart';
import 'package:routenplaner/data/layoutData.dart';
import 'package:routenplaner/home_favorites/address_insert_dialog.dart';
import 'package:routenplaner/controller/addresses.dart';
import 'package:routenplaner/controller/route_details.dart';
import 'package:routenplaner/controller/road_connections.dart';
import 'package:google_maps_webservice/places.dart';

// Globale Variablen, für Google benötigt
final String apiKey = 'AIzaSyC0DgP0BdEXEybFlEReSj_ghex8jTDOeWE';
GoogleMapsPlaces _places = GoogleMapsPlaces(apiKey: apiKey);

class Favorites extends StatefulWidget {
  @override
  _FavoritesState createState() => _FavoritesState();
}

class _FavoritesState extends State<Favorites>
    with SingleTickerProviderStateMixin {
  // Tabcontroller, wird benötogt um Tabs anzeigen zu können
  TabController _controller;
  void initState() {
    super.initState();
    // Tab Bar, ADRESSE und VERBINDUNGEN
    _controller = new TabController(length: 2, vsync: this);
  }

  // eine Zeile mit Icon und String und Button
  Widget informationRowAddress({bool favourite, String addressName}) {
    return Column(
      children: [
        SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              flex: 1,
              child: Icon(
                favourite ? Icons.star : Icons.location_city_outlined,
                size: 30,
                color: iconColor,
              ),
            ),
            SizedBox(
              width: 10,
            ),
            Expanded(
              flex: 5,
              child: Text(
                addressName,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: myDarkGrey, fontSize: 15),
              ),
            ),
            Expanded(
              flex: 1,
              child: FlatButton(
                child: Icon(
                  Icons.forward,
                  color: myMiddleTurquoise,
                ),
                onPressed: () async {
                  // Wenn gedrückt, dann werden die Koordinaten basierend auf
                  // dem namen gesucht, nicht optimal, da es bei fehlender Internet verbindung fehl schlägt
                  bool start = await showDialog(
                    context: context,
                    builder: (context) {
                      return AddressInsertDialog(addressName);
                    },
                  );
                  // wenn nutzer abbrechen klickt, dann gibt das Popup null zurück
                  if (start == null) {
                    return;
                  }
                  // je nachdem was der Nutzer auswählt, speichere das Ergebnis in
                  // start oder ziel
                  if (start) {
                    Provider.of<RouteDetails>(context, listen: false)
                        .setStart(addressName);
                  }
                  if (!start) {
                    Provider.of<RouteDetails>(context, listen: false)
                        .setDestination(addressName);
                  }
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  // eine Zeile mit Icon String un Button für Verbindungen
  Widget informationRowConnection(
      {bool favourite, String start, String destination}) {
    return Column(
      children: [
        SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Icon(
              favourite ? Icons.star : Icons.location_city_outlined,
              size: 30,
              color: iconColor,
            ),
            SizedBox(
              width: 20,
            ),
            Expanded(
              child: Text(
                "$start > $destination",
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: myDarkGrey, fontSize: 15),
              ),
            ),
            FlatButton(
              child: Icon(
                Icons.forward,
                color: myMiddleTurquoise,
              ),
              onPressed: () async {
                Provider.of<RouteDetails>(context, listen: false)
                    .setStart(start);
                Provider.of<RouteDetails>(context, listen: false)
                    .setDestination(destination);
                var detailsStart = await _places.searchByText(start);
                var detailsDestination =
                    await _places.searchByText(destination);

                // Nehme das beste Ergebnis
                var latStart = detailsStart.results[0].geometry.location.lat;
                var lngStart = detailsStart.results[0].geometry.location.lng;
                var latDestination =
                    detailsDestination.results[0].geometry.location.lat;
                var lngDestination =
                    detailsDestination.results[0].geometry.location.lng;

                // Speichere in Provider
                Provider.of<RouteDetails>(context, listen: false)
                    .geoCoordStart = LatLng(latStart, lngStart);
                Provider.of<RouteDetails>(context, listen: false)
                        .geoCoordDestination =
                    LatLng(latDestination, lngDestination);
              },
            ),
          ],
        ),
      ],
    );
  }

  // AdressenKarte, die Überschrift, Icons und Texte enthält
  Widget customCardAddress(
      {List<String> entries, bool favorite, BuildContext context}) {
    return Card(
      margin: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Titel
          Text(
            favorite ? "FAVORITEN" : "LETZTE ZIELE",
            style: TextStyle(fontSize: 17, color: myDarkGrey),
          ),
          // Strich
          Divider(
            color: myMiddleGrey, //Colors.grey,
            thickness: 2,
          ),
          Column(
            children: entries.length > 0
                ? entries
                    .map((i) => informationRowAddress(
                        favourite: favorite, addressName: i))
                    .toList()
                : [Container()],
          )
        ],
      ),
    );
  }

  // Verbindungen Karte
  Widget customCardConnection(
      {List<List<String>> entries, bool favorite, BuildContext context}) {
    return Card(
      margin: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Titel
          Text(
            favorite ? "FAVORITEN" : "LETZTE VERBINDUNGEN",
            style: TextStyle(fontSize: 17, color: myDarkGrey),
          ),
          // Strich
          Divider(
            color: myMiddleGrey, //Colors.grey,
            thickness: 2,
          ),
          Column(
            children: entries.length > 0
                ? entries
                    .map((i) => informationRowConnection(
                        favourite: favorite, start: i[0], destination: i[1]))
                    .toList()
                : [Container()],
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Tab Bar,
        Container(
          margin:
              EdgeInsets.only(left: contentMarginLR, right: contentMarginLR),
          decoration: BoxDecoration(
            border: Border.all(width: 1, color: Colors.grey),
            color: myWhite,
            boxShadow: [
              BoxShadow(
                color: myMiddleGrey, //Colors.grey,
                blurRadius: 6,
              )
            ],
          ),
          // Tab Bar mit ADRESSE UND VERBINDUNGEN
          child: new TabBar(
            controller: _controller,
            indicatorColor: myMiddleTurquoise, //Colors.white,
            labelColor: myDarkGrey, //Colors.white,
            indicatorWeight: 5,
            tabs: [
              Tab(
                //icon: const Icon(Icons.flag),
                text: 'ADRESSE',
              ),
              Tab(
                //icon: const Icon(Icons.compare_arrows),
                text: 'VERBINDUNG',
              ),
            ],
          ),
        ),
        // Container für den Hintergund der TabBarView Inhalte
        Container(
          height: 540,
          margin: EdgeInsets.only(
              left: contentMarginLR,
              right: contentMarginLR,
              bottom: distanceBoxes),
          // Nur ein bisschen Kosmetik
          decoration: BoxDecoration(
            border: Border.all(width: 0, color: myMiddleGrey),
            color: myWhite, //Colors.white,
            boxShadow: [
              BoxShadow(
                color: myMiddleGrey, //Colors.grey,
                blurRadius: 4,
              )
            ],
          ),
          // inhalt der Tabs
          child: TabBarView(
            controller: _controller,
            children: [
              // Erster Tab, ADRESSEN
              Consumer<AddressCollection>(
                builder: (context, address, _) => Column(
                  children: [
                    // Card für die Favoriten Adressen
                    customCardAddress(
                        favorite: true,
                        entries: address.favoriteAddress,
                        context: context),
                    // Card für die letzten Adressen
                    customCardAddress(
                      favorite: false,
                      entries: address.lastAddress,
                      context: context,
                    ),
                  ],
                ),
              ),
              // Zweiter Tab, VERBINDUNGEN
              Consumer<RoadConnections>(
                builder: (context, roadConnections, _) => Column(
                  children: [
                    customCardConnection(
                        favorite: true,
                        entries: roadConnections.favoriteConnections,
                        context: context),
                    customCardConnection(
                      favorite: false,
                      entries: roadConnections.lastConnections,
                      context: context,
                    ),
                  ],
                ),
              )
            ],
          ),
        )
      ],
    );
  }
}
