import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:async';
import 'package:routenplaner/data/custom_colors.dart';
import 'package:routenplaner/provider_classes/route_details.dart';
import 'package:provider/provider.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:flutter_google_places/flutter_google_places.dart';

final String apiKey = 'AIzaSyC0DgP0BdEXEybFlEReSj_ghex8jTDOeWE';
GoogleMapsPlaces _places = GoogleMapsPlaces(apiKey: apiKey);

class DestinationinputDestination extends StatefulWidget {
  @override
  _DestinationinputDestinationState createState() =>
      _DestinationinputDestinationState();
}

class _DestinationinputDestinationState
    extends State<DestinationinputDestination> {
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
      hint: "Ziel:",
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
      Provider.of<RouteDetails>(context, listen: false).geoCoordDestination =
          LatLng(lat, lng);
      Provider.of<RouteDetails>(context, listen: false)
          .setDestination(p.description);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Consumer<RouteDetails>(
        builder: (context, routeDetails, _) => TextField(
          maxLines: 1,
          readOnly: true,
          onTap: () => showPlacesPicker(context),
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            icon: Icon(
              Icons.flag,
              color: myYellow,
            ),
            hintText: routeDetails.hintTextDestination,
            hintStyle: TextStyle(color: routeDetails.hintColorDestination),
          ),
        ),
      ),
    );
  }
}
