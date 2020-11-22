import 'package:flutter/material.dart';
import 'package:routenplaner/drawer/user_profiles.dart';

import 'travel_profiles.dart';
import 'user_profiles.dart';
import '../data/custom_colors.dart';

// Drawer an der Seite, link zu den weiteren Seiten wie Nutzerprofile,
// Reiseprofile, Meine Karten, Einstellungen
class DrawerHome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: <Widget>[
          // Überschrift mit Nutzername und email
          // Noch ändern, wenn Nutzerprofil geändert
          UserAccountsDrawerHeader(
            accountName: Text('Steffi',
                style: TextStyle(color: Colors.white, fontSize: 20)),
            accountEmail: Text('testemail@test.com',
                style: TextStyle(color: Colors.white, fontSize: 20)),
            currentAccountPicture: CircleAvatar(),
          ),
          // Listenzeile Nutzerprofile
          ListTile(
            leading: Icon(Icons.person, color: myYellow, size: 50),
            title: Text(
              'Nutzerprofile',
              style: TextStyle(
                fontSize: 20,
                color: myDarkGrey, //#707070
              ),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute<Widget>(
                  builder: (BuildContext context) => UserProfiles(),
                ),
              );
            },
          ),
          Divider(
            thickness: 1,
          ),
          // Listenzeile Reiseprofile
          ListTile(
            leading: Icon(Icons.card_travel, color: myYellow, size: 50),
            title: Text(
              'Reiseprofile',
              style: TextStyle(
                fontSize: 20,
                color: myDarkGrey, //#707070
              ),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute<Widget>(
                  builder: (BuildContext context) => TravelProfiles(),
                ),
              );
            },
          ),
          Divider(
            thickness: 1,
          ),
          // Listenzeile Meine Karten, kein Link
          ListTile(
            leading: Icon(Icons.map, color: myYellow, size: 50),
            title: Text(
              'Meine Karten',
              style: TextStyle(
                fontSize: 20,
                color: myDarkGrey, //#707070
              ),
            ),
            /*onTap: () {
                  Navigator.push(context, MaterialPageRoute<Widget>(
                      builder: (BuildContext context) => TravelProfiles())
                  );
                },*/
          ),
          Divider(
            thickness: 1,
          ),
          // Listenzeile Einstellungen, kein Link
          ListTile(
            leading: Icon(Icons.settings, color: myYellow, size: 50),
            title: Text('Einstellungen',
                style: TextStyle(
                  fontSize: 20,
                  color: myDarkGrey, //#707070
                )),
            /*onTap: () {
                  Navigator.push(context, MaterialPageRoute<Widget>(
                      builder: (BuildContext context) => TravelProfiles())
                  );
                },*/
          ),
          Divider(
            thickness: 1,
          ),
        ],
      ),
    );
  }
}
