import 'package:flutter/material.dart';
import 'package:routenplaner/drawer/user_profiles.dart';
import 'drawer/travel_profiles.dart';
import 'drawer/user_profiles.dart';
import 'dart:async';
import 'drawer/drawer_home.dart';
import 'footer.dart';
import 'home_favorites/favorite_destination.dart';
import 'home_favorites/favorite_destination_item.dart';
import 'home_favorites/favorite_routes.dart';
import 'home_button.dart';

// Noch nichts implementiert. hier gehts weiter, wenn der User noch einen
// zwischenstopp einlegen möchte, oder ein Autom. Fahrsegment
class RoutePlanning2 extends StatefulWidget {
  @override
  _RoutePlanning2State createState() => _RoutePlanning2State();
}

class _RoutePlanning2State extends State<RoutePlanning2> {
  final _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
          title: Text(
            'uPlan',
            style: TextStyle(color: Colors.white, fontSize: 30),
          ),
          iconTheme: new IconThemeData(color: Colors.white)
          //backgroundColor: Hexcolor("#48ACB8"),
          ),
      bottomNavigationBar: Footer(),
      drawer: DrawerHome(),
      body: Scrollbar(
        controller: _scrollController,
        isAlwaysShown: true,
        child: SingleChildScrollView(
          controller: _scrollController,
          child: Column(children: [
            Text('Hier gehts weiter'),
          ]),
        ),
      ),
    );
  }
}
