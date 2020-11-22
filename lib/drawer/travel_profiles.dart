import 'package:flutter/material.dart';
import 'package:routenplaner/drawer/travel_detail.dart';
import 'package:routenplaner/drawer/travel_profile_addProfile.dart';
import 'package:routenplaner/provider_classes/travel_profiles_collection.dart';
import 'drawer_home.dart';
import '../footer.dart';
import '../data/custom_colors.dart';
import 'package:provider/provider.dart';

class TravelProfiles extends StatelessWidget {
  // Wenn ein Profile DELETED wird, dann MUSS danach der gesamte Widget neu
  // ausgebaurt werden, damit die Index wieder stimmen!!!
  List<Widget> printTravelProfiles(
      BuildContext context, TravelProfileCollection travelProfileCollection) {
    List<Widget> widgetList = List<Widget>();
    int length = travelProfileCollection.travelProfileCollection.length;
    for (int i = 0; i < length; i++) {
      widgetList.add(
        Column(
          children: [
            SizedBox(height: 30),
            // Container für die Karten
            Container(
              padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
              width: MediaQuery.of(context).size.width - 30,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: myWhite,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  width: 0,
                  color: myLightGrey,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 5,
                    blurRadius: 7,
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Expanded für den Auswahl Button bzw Icon und Text
                  Expanded(
                    child: MaterialButton(
                      // reihe mit Icon und Text
                      child: Row(
                        children: [
                          Icon(
                            Icons.wallet_travel,
                            color: myYellow,
                            size: 40,
                          ),
                          // Flexible für Bezeichnung
                          Expanded(
                            child: Center(
                              child: Text(
                                travelProfileCollection
                                    .travelProfileCollection[i].name,
                                style: TextStyle(
                                  fontSize: 20,
                                  color: myDarkGrey,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      // Wenn gedrückt dann Link zu neuen Seite, diese immer neu
                      // aufbauen, mit Hilfe eines übergebenen Routen objekts
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute<Widget>(
                            builder: (BuildContext context) =>
                                TravelDetail(indexProfile: i),
                          ),
                        );
                      },
                    ),
                  ),
                  // Weitere Reihe, um die Divider und Button aneinander zu
                  // bringen
                  Row(
                    children: [
                      // Flex für Divider
                      Container(
                        height: 50,
                        width: 3,
                        color: myLightGrey,
                      ),
                      SizedBox(width: 10),
                      // Flexible für Button
                      FloatingActionButton(
                        heroTag: null,
                        onPressed: () {
                          /*
                          showDialog(
                            context: context,
                            // Dialog Popup
                            builder: (context) => Builder(
                              builder: (BuildContext context) {
                                return Container(
                                  height: 20,
                                  width: 20,
                                  color: myDarkGrey,
                                );
                              },
                            ),
                          );
                          */
                          travelProfileCollection.deleteProfile(i);
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }
    return widgetList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: myWhite,
      appBar: AppBar(
        title: Text(
          'Reiseprofile',
          style: TextStyle(color: myWhite, fontSize: 30),
        ),
        iconTheme: new IconThemeData(color: myWhite),
      ),
      bottomNavigationBar: Footer(),
      drawer: DrawerHome(),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            colorFilter: new ColorFilter.mode(
                Colors.grey.withOpacity(0.15), BlendMode.dstATop),
            image: AssetImage("assets/images/citybackground.png"),
            fit: BoxFit.fitWidth,
          ),
        ),
        child: Consumer<TravelProfileCollection>(
          builder: (context, travelProfileCollection, child) => ListView(
            children: printTravelProfiles(context, travelProfileCollection),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: myMiddleTurquoise,
        // Eintrag Hinzufügen, noch implentieren
        // um aktualisierung gültig zu machen muss man WidgetList rebuilden
        // einfach
        onPressed: () {
          showDialog(
            context: context,
            // Dialog Popup
            builder: (context) => Builder(
              builder: (BuildContext context) {
                return AddProfileDialogue();
              },
            ),
          );
        },
        child: Icon(Icons.add, color: myWhite, size: 30),
      ),
    );
  }
}
