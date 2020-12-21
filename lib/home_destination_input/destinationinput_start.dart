import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'dart:async';
import 'package:routenplaner/data/custom_colors.dart';
import 'package:routenplaner/provider_classes/route_details.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:flutter_google_places/flutter_google_places.dart';

// Globale Variablen, für Google benötigt
final String apiKey = 'AIzaSyC0DgP0BdEXEybFlEReSj_ghex8jTDOeWE';
GoogleMapsPlaces _places = GoogleMapsPlaces(apiKey: apiKey);

class DestinationinputStart extends StatefulWidget {
  @override
  _DestinationinputStartState createState() => _DestinationinputStartState();
}

// Hier befindet sich das erste Textfeld, in dem der Start eingegeben wird
// Der Wert wird einfach in einem Lokalen String gespeichert
class _DestinationinputStartState extends State<DestinationinputStart> {
  // Versuche mit Google Places vorschläge zu einegegeben Strings zu erreichen
  // Funktionen, benötigt um den Place Completer zu erstellen
  // WICHTIG, falls Suche fehlschlägt
  void onError(PlacesAutocompleteResponse response) {
    print("PLACE SEARCH FAILED");
  }

  // WICHTIG: eigentlicher autocomplete algorythmus
  Future<void> showPlacesPicker(BuildContext context) async {
    print("SHOW PLACE PICKER");
    // show input autocomplete with selected mode
    // then get the Prediction selected
    Prediction p = await PlacesAutocomplete.show(
      hint: "Start:",
      context: context,
      apiKey: apiKey,
      onError: onError,
      mode: Mode.overlay,
      language: "de",
      components: [Component(Component.country, "de")],
    );

    // Eingaben verarbeiten
    if (p != null) {
      PlacesDetailsResponse detail =
          await _places.getDetailsByPlaceId(p.placeId);
      final lat = detail.result.geometry.location.lat;
      final lng = detail.result.geometry.location.lng;

      // Füge Provider hinzu
      Provider.of<RouteDetails>(context, listen: false).geoCoordStart =
          LatLng(lat, lng);
      Provider.of<RouteDetails>(context, listen: false).setStart(p.description);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Consumer<RouteDetails>(
        builder: (context, routeDetails, _) => TextField(
          maxLines: 1,
          // Input noch nicht in lokale Variable gespeichert
          readOnly: true,
          onTap: () => showPlacesPicker(context),
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            icon: Icon(
              Icons.place,
              color: myYellow,
            ),
            hintText: routeDetails.hintTextStart,
            hintStyle: TextStyle(color: routeDetails.hintColorStart),
          ),
        ),
      ),
    );
  }
}
