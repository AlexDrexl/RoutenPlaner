import 'package:flutter/material.dart';
import 'package:routenplaner/data/custom_colors.dart';

// Hier der untere Teil des Hauptmenüs mit "ADRESSE" und "VERBINDUNGEN"
// alle Daten hardcoded.
class FavoriteRoutes extends StatefulWidget {
  @override
  _FavoriteRoutesState createState() => _FavoriteRoutesState();
}

class _FavoriteRoutesState extends State<FavoriteRoutes>
    with SingleTickerProviderStateMixin {
  TabController _controller;

  void initState() {
    super.initState();
    // Tab Bar, ADRESSE und VERBINDUNGEN
    _controller = new TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // COntainer für die TabBar
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
              ]),
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
        // Container für den gesamten Favoriten u Verbindung Komplex
        new Container(
          height:
              480.0, //sonst weißer Bildschirm, auch Flexible() und Expanded() hat nicht geklappt
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
          child: new TabBarView(
            controller: _controller,
            children: <Widget>[
              // ADRESSE Tab
              new Card(
                child: Column(
                  children: [
                    Container(
                      margin: EdgeInsets.only(left: 20, right: 20, top: 15),
                      decoration: BoxDecoration(
                        border: Border.all(width: 0, color: myMiddleGrey),
                        borderRadius: BorderRadius.all(Radius.circular(14)),
                        color: myWhite, //Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: myMiddleGrey, //Colors.grey,
                            blurRadius: 4,
                          )
                        ],
                      ),
                      // Gesamte Spalte Unter Adresse
                      child: Column(
                        children: [
                          // FAVOURITEN Überschrift
                          new Container(
                            padding: EdgeInsets.only(top: 5),
                            child: Text(
                              'FAVORITEN',
                              style: TextStyle(fontSize: 17, color: myDarkGrey),
                            ),
                          ),
                          // Devider um Überschrift vom Text zu trennen
                          new Divider(
                            color: myMiddleGrey, //Colors.grey,
                            thickness: 2,
                          ),
                          // Favorit "Zu Hause", noch hardgecoded!!
                          new ListTile(
                            leading: Icon(
                              Icons.star,
                              color: myYellow, //Hexcolor('FFCC80'),
                              size: 30,
                            ),
                            title: Text('Zu Hause',
                                style: TextStyle(color: myDarkGrey)),
                            trailing: new IconButton(
                                icon: const Icon(Icons.arrow_forward_ios),
                                onPressed: () {}),
                          ),
                          // Favorit "Oma und Opa", noch hardgecoded!!
                          new ListTile(
                            leading: Icon(
                              Icons.star,
                              color: myYellow, //Hexcolor('FFCC80'),
                              size: 30,
                            ),
                            title: Text('Oma und Opa',
                                style: TextStyle(color: myDarkGrey)),
                            trailing: new IconButton(
                                icon: const Icon(Icons.arrow_forward_ios),
                                onPressed: () {}),
                          ),
                          // Favorit "Grundschule", noch hardgecoded!!
                          new ListTile(
                            leading: Icon(
                              Icons.star,
                              color: myYellow, //Hexcolor('FFCC80'),
                              size: 30,
                            ),
                            title: Text('Grundschule',
                                style: TextStyle(color: myDarkGrey)),
                            trailing: new IconButton(
                                icon: const Icon(Icons.arrow_forward_ios),
                                onPressed: () {}),
                          ),
                        ],
                      ),
                    ),
                    // Container für gesamte LETZTE ZIELE Karte
                    Container(
                      margin: EdgeInsets.only(left: 20, right: 20, top: 20),
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
                      // Spalte für LETZTE ZIELE
                      child: Column(
                        children: [
                          // Überschrift "LETZTE ZIELE"
                          new Container(
                              padding: EdgeInsets.only(top: 5),
                              child: Text(
                                'LETZTE ZIELE',
                                style:
                                    TextStyle(fontSize: 17, color: myDarkGrey),
                              )),
                          // Devider um Überschrift von Liste zu trennen
                          new Divider(
                            color: myMiddleGrey,
                            thickness: 2,
                          ),
                          // Erstes letztes Ziel, noch hardgecoded!!
                          new ListTile(
                            leading: Icon(
                              Icons.place,
                              color: myYellow,
                              size: 30,
                            ),
                            title: Text('Garching, Boltzmannstr. 15',
                                style: TextStyle(color: myDarkGrey)),
                            trailing: new IconButton(
                                icon: const Icon(Icons.arrow_forward_ios),
                                onPressed: () {}),
                          ),
                          // zweites letztes Ziel, noch hardgecoded!!
                          new ListTile(
                            leading: Icon(
                              Icons.place,
                              color: myYellow,
                              size: 30,
                            ),
                            title: Text('München, Flughafen',
                                style: TextStyle(color: myDarkGrey)),
                            trailing: new IconButton(
                                icon: const Icon(Icons.arrow_forward_ios),
                                onPressed: () {}),
                          ),
                          // Drittes letztes Ziel, noch hardgecoded!!
                          new ListTile(
                            leading: Icon(
                              Icons.place,
                              color: myYellow,
                              size: 30,
                            ),
                            title: Text('München, Sonnenstr. 19',
                                style: TextStyle(color: myDarkGrey)),
                            trailing: new IconButton(
                                icon: const Icon(Icons.arrow_forward_ios),
                                onPressed: () {}),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              // Zweiter Tab
              new Card(
                child: Column(
                  children: [
                    Container(
                      margin: EdgeInsets.only(left: 20, right: 20, top: 15),
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
                      child: Column(
                        children: [
                          new Container(
                            padding: EdgeInsets.only(top: 5),
                            child: Text(
                              'FAVORITEN',
                              style: TextStyle(fontSize: 17, color: myDarkGrey),
                            ),
                          ),
                          new Divider(
                            color: myMiddleGrey,
                            thickness: 2,
                          ),
                          new ListTile(
                            leading: Icon(
                              Icons.star,
                              color: myYellow,
                              size: 30,
                            ),
                            title: Text('Zu Hause >\nArbeit',
                                style: TextStyle(color: myDarkGrey)),
                            trailing: new IconButton(
                                icon: const Icon(Icons.arrow_forward_ios),
                                onPressed: () {}),
                          ),
                          new ListTile(
                            leading: Icon(
                              Icons.star,
                              color: myYellow,
                              size: 30,
                            ),
                            title: Text('Zu Hause >\nSchule',
                                style: TextStyle(color: myDarkGrey)),
                            trailing: new IconButton(
                                icon: const Icon(Icons.arrow_forward_ios),
                                onPressed: () {}),
                          ),
                          new ListTile(
                            leading: Icon(
                              Icons.star,
                              color: myYellow,
                              size: 30,
                            ),
                            title: Text('Schule >\nArbeit',
                                style: TextStyle(color: myDarkGrey)),
                            trailing: new IconButton(
                                icon: const Icon(Icons.arrow_forward_ios),
                                onPressed: () {}),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 20, right: 20, top: 20),
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
                      child: Column(
                        children: [
                          new Container(
                              padding: EdgeInsets.only(top: 5),
                              child: Text(
                                'LETZTE VERBINDUNGEN',
                                style:
                                    TextStyle(color: myDarkGrey, fontSize: 17),
                              )),
                          new Divider(
                            color: myMiddleGrey,
                            thickness: 2,
                          ),
                          new ListTile(
                            leading: Icon(
                              Icons.place,
                              color: myYellow,
                              size: 30,
                            ),
                            title: Text('Garching >\nFlughafen',
                                style: TextStyle(color: myDarkGrey)),
                            trailing: new IconButton(
                                icon: const Icon(Icons.arrow_forward_ios),
                                onPressed: () {}),
                          ),
                          new ListTile(
                            leading: Icon(
                              Icons.place,
                              color: myYellow,
                              size: 30,
                            ),
                            title: Text(
                              'München >\nStarnberg',
                              style: TextStyle(color: myDarkGrey),
                            ),
                            trailing: new IconButton(
                                icon: const Icon(Icons.arrow_forward_ios),
                                onPressed: () {}),
                          ),
                          new ListTile(
                            leading: Icon(
                              Icons.place,
                              color: myYellow,
                              size: 30,
                            ),
                            title: Text('Zu Hause >\nStuttgart',
                                style: TextStyle(color: myDarkGrey)),
                            trailing: new IconButton(
                                icon: const Icon(Icons.arrow_forward_ios),
                                onPressed: () {}),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}
