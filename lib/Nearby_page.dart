import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class NearbyPage extends StatefulWidget {
  NearbyPage({Key? key}) : super(key: key);
  @override
  _NearbyPageState createState() => _NearbyPageState();
}

class _NearbyPageState extends State<NearbyPage> {
  Completer<GoogleMapController> _controller = Completer();

static final CameraPosition _kAddisAbaba = CameraPosition(
  target: LatLng(9.03, 38.74), // Coordinates for Addis Ababa, Ethiopia
  zoom: 14.4746,
);


  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
        body: SingleChildScrollView(
            child: Column(children: [
      Stack(children: [
        Container(
            height: screenHeight,
            width: screenWidth,
            child: GoogleMap(
              mapType: MapType.normal,
              // markers: _markers,
              // polylines: _polylines,
              // circles: _circles,
              initialCameraPosition: _kAddisAbaba,
              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);
              },
            ))
      ])
    ])));
  }
}
