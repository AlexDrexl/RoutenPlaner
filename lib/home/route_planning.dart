import 'package:flutter/material.dart';
import 'package:routenplaner/home_favorites/favorites.dart';
import '../data/custom_colors.dart';
import '../drawer/drawer_home.dart';
import "package:routenplaner/home_destination_input/destinationinput.dart";

// Startseite mit zwei großen Elementen: Zieleingabe und Favoriten Ruuten
class RoutePlanning extends StatefulWidget {
  @override
  _RoutePlanningState createState() => _RoutePlanningState();
}

class _RoutePlanningState extends State<RoutePlanning> {
  final _scrollController = ScrollController();

  // Funktion, die das Scrollable wieder zum Start zurückversetzt
  void goToTop() {
    setState(() {
      _scrollController.animateTo(
        0.0,
        curve: Curves.easeOut,
        duration: const Duration(milliseconds: 300),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(
            'uPlan',
            style: TextStyle(color: myWhite, fontSize: 30),
          ),
          iconTheme: IconThemeData(color: myWhite)),
      drawer: DrawerHome(
        screen: "home",
      ), // Drawer in externer Klasse
      body: Scrollbar(
        controller: _scrollController,
        child: SingleChildScrollView(
          controller: _scrollController,
          child: Container(
            color: backgroundColor,
            child: Column(children: [
              Destinationinput(),
              Favorites(
                goToTopCallback: goToTop,
              ),
            ]),
          ),
        ),
      ),
    );
  }
}
