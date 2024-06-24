import 'dart:async';

import 'package:fab_circular_menu/fab_circular_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:mobile_application_project/auto_complete_result.dart';
import 'package:mobile_application_project/search_map_places.dart';
import 'package:mobile_application_project/map_services.dart';
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

//Markers set
  Set<Marker> _markers = Set<Marker>();
  Set<Marker> _markersDupe = Set<Marker>();

  Set<Polyline> _polylines = Set<Polyline>();
  int markerIdCounter = 1;
  int polylineIdCounter = 1;

  var radiusValue = 3000.0;

  var tappedPoint;

  List allFavoritePlaces = [];

  String tokenKey = '';

//Text Editing Controllers
  TextEditingController searchController = TextEditingController();
  // TextEditingController _originController = TextEditingController();
  // TextEditingController _destinationController = TextEditingController();

//Initial map position on load
  static final CameraPosition _kAddisAbaba = CameraPosition(
    target: LatLng(9.03, 38.74), // Coordinates for Addis Ababa, Ethiopia
    zoom: 14.4746,
  );

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

       //Providers
    final allSearchResults = ref.watch(placeResultsProvider);
    final searchFlag = ref.watch(searchToggleProvider);

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
              )),
          searchToggle
              ? Padding(
                  padding: EdgeInsets.fromLTRB(15.0, 40.0, 15.0, 5.0),
                  child: Column(children: [
                    Container(
                      height: 50.0,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        color: Colors.white,
                      ),
                      child: TextFormField(
                        controller: searchController,
                        decoration: InputDecoration(
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 20.0, vertical: 15.0),
                            border: InputBorder.none,
                            hintText: 'Search',
                            suffixIcon: IconButton(
                                onPressed: () {
                                  setState(() {
                                    searchToggle = false;

                                    searchController.text = '';
                                    _markers = {};
                                    if (searchFlag.searchToggle)
                                      searchFlag.toggleSearch();
                                  });
                                },
                                icon: Icon(Icons.close))),
                        onChanged: (value) {
                          if (_debounce?.isActive ?? false) _debounce?.cancel();
                          _debounce =
                              Timer(Duration(milliseconds: 700), () async {
                            if (value.length > 2) {
                              if (!searchFlag.searchToggle) {
                                searchFlag.toggleSearch();
                                _markers = {};
                              }

                              List<AutoCompleteResult> searchResults =
                                  await MapServices().searchPlaces(value);

                              allSearchResults.setResults(searchResults);
                            } else {
                              List<AutoCompleteResult> emptyList = [];
                              allSearchResults.setResults(emptyList);
                            }
                          });
                        },
                      ),
                    )
                  ]),
                )
              : Container(),
        ])
      ])),
      floatingActionButton: FabCircularMenu(
          alignment: Alignment.bottomLeft,
          fabColor: Colors.blue.shade50,
          fabOpenColor: Colors.red.shade100,
          ringDiameter: 250.0,
          ringWidth: 60.0,
          ringColor: Colors.blue.shade50,
          fabSize: 60.0,
          children: [
            IconButton(
                onPressed: () {
                  setState(() {
                    searchToggle = true;
                    radiusSlider = false;
                    pressedNear = false;
                    cardTapped = false;
                    getDirections = false;
                  });
                },
                icon: Icon(Icons.search)),
            IconButton(
                onPressed: () {
                  setState(() {
                    searchToggle = false;
                    radiusSlider = false;
                    pressedNear = false;
                    cardTapped = false;
                    getDirections = true;
                  });
                },
                icon: Icon(Icons.navigation))
          ]),
    );
  }
}
