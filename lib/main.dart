import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:routenplaner/drawer/drawer_home.dart';
import 'package:routenplaner/drawer/travel_detail.dart';
import 'package:routenplaner/drawer/travel_profiles.dart';
import 'package:routenplaner/drawer/user_profiles.dart';
import 'package:routenplaner/provider_classes/addresses.dart';
import 'package:routenplaner/provider_classes/desired_Autom_Sections.dart';
import 'package:routenplaner/provider_classes/final_routes.dart';
import 'package:routenplaner/provider_classes/overview_change.dart';
import 'package:routenplaner/provider_classes/road_connections.dart';
import 'package:routenplaner/provider_classes/travel_profiles_collection.dart';
import 'package:routenplaner/provider_classes/travel_profile_modifier.dart';
import 'package:routenplaner/provider_classes/user_profile_collection.dart';
import 'footer.dart';
import 'data/custom_colors.dart';
import 'package:provider/provider.dart';
import 'provider_classes/route_details.dart';
import 'route_planning.dart';

void main() => runApp(RoutePlaner());

class RoutePlaner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // objekt, das zugriff auf die Farben gibt
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AddressCollection>(
          create: (_) => AddressCollection(),
        ),
        ChangeNotifierProvider<OverviewChange>(
          create: (_) => OverviewChange(),
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
          create: (context) => FinalRoutes(
              Provider.of<RouteDetails>(context, listen: false),
              Provider.of<DesiredAutomSections>(context, listen: false)),
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
          //cardColor: Hexcolor('48ACB8'),
          //highlightColor: Hexcolor('48ACB8'),
          //timePickerTheme: null
          // Define the default font family.
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
