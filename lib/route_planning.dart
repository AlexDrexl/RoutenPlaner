import 'package:flutter/material.dart';
import 'package:routenplaner/home_favorites/favorites.dart';
import 'package:routenplaner/provider_classes/addresses.dart';
import 'package:routenplaner/provider_classes/road_connections.dart';
import 'package:routenplaner/provider_classes/travel_profiles_collection.dart';
import 'data/custom_colors.dart';
import 'package:provider/provider.dart';
import 'drawer/drawer_home.dart';
import 'home_favorites/favorite_routes.dart';
import "package:routenplaner/home_destination_input/destinationinput.dart";

// Startseite mit zwei großen Elementen: Zieleingabe und Favoriten ROuten
class RoutePlanning extends StatefulWidget {
  @override
  _RoutePlanningState createState() => _RoutePlanningState();
}

class _RoutePlanningState extends State<RoutePlanning> {
  final _scrollController = ScrollController();

  void initializeApp() async {
    /*
    Provider.of<TravelProfileCollection>(context, listen: false)
        .setTravelProfiles();
    Provider.of<AddressCollection>(context, listen: false).setAddresses();
    Provider.of<RoadConnections>(context, listen: false).setRoadConnections();
    */
  }

  @override
  void initState() {
    // TODO: EVTL FUTURE BUILDER. Als future dann die initializeApp funktion
    super.initState();
    print("INITIALIZE");
    initializeApp();
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
      drawer: DrawerHome(), // Drawer in externer Klasse
      body: Scrollbar(
        controller: _scrollController,
        isAlwaysShown: true,
        child: SingleChildScrollView(
          controller: _scrollController,
          child: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                colorFilter: new ColorFilter.mode(
                    Colors.grey.withOpacity(0.15), BlendMode.dstATop),
                image: AssetImage("assets/images/citybackground.png"),
                fit: BoxFit.fitWidth,
              ),
            ),
            // Nach dem Hintergrund wird darauf ein Column gesetzt mit den
            // beiden Fenstern Zieleingabe und Favoriten Routen
            child: Column(children: [
              // Hier der eigentliche Seiteninhalt
              Destinationinput(), // Gesamte Zieleingabe
              // FavoriteRoutes(), // Favoriten, alt
              Favorites(),
            ]),
          ),
        ),
      ),
    );
  }
}
