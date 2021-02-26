import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:routenplaner/controller/addresses.dart';
import 'package:routenplaner/controller/desired_Autom_Sections.dart';
import 'package:routenplaner/controller/final_routes.dart';
import 'package:routenplaner/controller/road_connections.dart';
import 'package:routenplaner/controller/travel_profiles_collection.dart';
import 'package:routenplaner/controller/travel_profile_modifier.dart';
import 'package:routenplaner/controller/user_profile_collection.dart';
import 'data/custom_colors.dart';
import 'controller/route_details.dart';
import 'home/route_planning.dart';

void main() => runApp(RoutePlaner());

class RoutePlaner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AddressCollection>(
          create: (_) => AddressCollection(),
        ),
        ChangeNotifierProvider<RoadConnections>(
          create: (_) => RoadConnections(),
        ),
        ChangeNotifierProvider<RouteDetails>(
          create: (_) => RouteDetails(),
        ),
        ChangeNotifierProvider<DesiredAutomSections>(
          create: (_) => DesiredAutomSections(),
        ),
        ChangeNotifierProvider<TravelProfileCollection>(
          create: (_) => TravelProfileCollection(),
        ),
        ChangeNotifierProvider<UserProfileCollection>(
          create: (context) => UserProfileCollection(context),
        ),
        ChangeNotifierProvider<TravelProfileDetailModifier>(
          create: (_) => TravelProfileDetailModifier(),
        ),
        // Sammlung RoutenDaten
        ChangeNotifierProvider<FinalRoutes>(
          create: (context) => FinalRoutes(),
        )
      ],
      child: MaterialApp(
        //home = Scaffold
        home: RoutePlanning(), //entweder home: ... oder '/': ...
        theme: ThemeData(
          // Define the default brightness and colors.
          brightness: Brightness.light,
          primaryColor: myMiddleTurquoise,
          accentColor: myMiddleTurquoise,
          splashColor: myMiddleTurquoise,
          fontFamily: 'Tahoma',

          // Define the default TextTheme. Use this to specify the default
          // text styling for headlines, titles, bodies of text, and more.
          textTheme: TextTheme(
            headline1: TextStyle(
                fontSize: 30.0, color: myWhite), //fontWeight: FontWeight.bold),
            headline6: TextStyle(
                fontSize: 20.0,
                color: myDarkGrey), //fontStyle: FontStyle.italic),
            bodyText2: TextStyle(
              fontSize: 14.0,
            ), //fontFamily: 'Hind'),
          ),
        ),
      ),
    );
  }
}
