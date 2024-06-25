import 'dart:async';
import 'dart:ffi';
import 'dart:typed_data';

import 'package:fab_circular_menu/fab_circular_menu.dart';
import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:flutter_rating_stars/flutter_rating_stars.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mobile_application_project/auto_complete_result.dart';
import 'package:mobile_application_project/search_map_places.dart';
import 'package:mobile_application_project/map_services.dart';

import 'dart:ui' as ui;

class NearbyPage extends ConsumerStatefulWidget {
  NearbyPage({Key? key}) : super(key: key);

  @override
  _NearbyPageState createState() => _NearbyPageState();
}

class _NearbyPageState extends ConsumerState<NearbyPage> {
  Completer<GoogleMapController> _controller = Completer();

//Debounce to throttle async calls during search
  Timer? _debounce;

//Toggling UI as we need;
  bool searchToggle = false;
  bool radiusSlider = false;
  bool cardTapped = false;
  bool pressedNear = false;
  bool getDirections = false;

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
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
              initialCameraPosition: _kGooglePlex,
              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);
              },
            ))
      ])
    ])));
  }
}
