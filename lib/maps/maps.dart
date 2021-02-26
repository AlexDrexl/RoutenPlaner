import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:routenplaner/controller/final_routes.dart';
import 'package:provider/provider.dart';
import 'package:routenplaner/controller/route_details.dart';

class Maps extends StatefulWidget {
  @override
  _MapsState createState() => _MapsState();
}

class _MapsState extends State<Maps> {
  GoogleMapController mapController;

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Maps'),
          backgroundColor: Colors.green[700],
        ),
        body: GoogleMap(
          onMapCreated: _onMapCreated,
          initialCameraPosition: CameraPosition(
            target:
                Provider.of<RouteDetails>(context, listen: false).geoCoordStart,
            zoom: 8,
          ),
          myLocationEnabled: true,
          tiltGesturesEnabled: true,
          compassEnabled: true,
          scrollGesturesEnabled: true,
          zoomGesturesEnabled: true,
          mapType: MapType.normal,
          markers: Set<Marker>.of(
            Provider.of<FinalRoutes>(context, listen: false).markers.values,
          ),
          polylines: Set<Polyline>.of(
              Provider.of<FinalRoutes>(context, listen: false)
                  .polylines
                  .values),
        ),
      ),
    );
  }
}
