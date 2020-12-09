import 'package:flutter/material.dart';
import 'package:routenplaner/data/custom_colors.dart';
import 'package:provider/provider.dart';
import 'package:routenplaner/provider_classes/addresses.dart';
import 'package:routenplaner/provider_classes/road_connections.dart';

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

  // eine Zeile mit Icon und String
  Widget informationRow({bool favourite, String text}) {
    return Column(
      children: [
        SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Icon(
              favourite ? Icons.star : Icons.location_city_outlined,
              size: 30,
              color: myYellow,
            ),
            SizedBox(
              width: 20,
            ),
            Expanded(
              child: Text(
                text,
                style: TextStyle(color: myDarkGrey, fontSize: 15),
              ),
            ),
            Icon(
              Icons.forward,
              color: myDarkGrey,
            ),
          ],
        ),
      ],
    );
  }

  // Karte, die Überschrift, Icons und Texte enthält
  Widget customCard(
      {String title,
      List<String> entries,
      bool favorite,
      BuildContext context}) {
    return Card(
      margin: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Titel
          Text(
            title,
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
                    .map((i) => informationRow(favourite: favorite, text: i))
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
          margin: EdgeInsets.only(left: 25, right: 25),
          decoration: BoxDecoration(
            border: Border.all(width: 1, color: Colors.grey),
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(14), topLeft: Radius.circular(14)),
            color: myMiddleTurquoise, // Hexcolor('48ACB8'),
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
            indicatorColor: myWhite, //Colors.white,
            labelColor: myWhite, //Colors.white,
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
          height: 480,
          margin: EdgeInsets.only(left: 25, right: 25, bottom: 25),
          // Nur ein bisschen Kosmetik
          decoration: BoxDecoration(
            border: Border.all(width: 0, color: myMiddleGrey),
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(14),
                bottomRight: Radius.circular(14)),
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
                    customCard(
                        title: "FAVORITEN",
                        favorite: true,
                        entries: address.favoriteAddress,
                        context: context),
                    // Card für die letzten Adressen
                    customCard(
                      title: "LETZTE ZIELE",
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
                    customCard(
                        title: "FAVORITEN",
                        favorite: true,
                        entries: roadConnections.favoriteConnections,
                        context: context),
                    customCard(
                      title: "LETZTE VERBINDUNGEN",
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
