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
import 'package:mobile_application_project/colors.dart';
import 'package:mobile_application_project/search_map_places.dart';
import 'package:mobile_application_project/map_services.dart';

import 'dart:ui' as ui;

class NearbyPage extends ConsumerStatefulWidget {
  const NearbyPage({Key? key}) : super(key: key);


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

  //Page controller for the nice pageview
  late PageController _pageController;
  int prevPage = 0;
  var tappedPlaceDetail;

  final key = 'AIzaSyAJm-6i5bDguI4y73g8AQYYGmo2nrs19gY';

  var selectedPlaceDetails;

//Circle

  Set<Circle> _circles = Set<Circle>();

//Text Editing Controllers
  TextEditingController searchController = TextEditingController();
  TextEditingController _originController = TextEditingController();
  TextEditingController _destinationController = TextEditingController();

// Initial map position on load
  static final CameraPosition _kGooglePlex = CameraPosition(

    target: LatLng(9.030856, 38.761612),

    zoom: 14.4746,
  );

  void _setMarker(point) {
    var counter = markerIdCounter++;

    final Marker marker = Marker(
        markerId: MarkerId('marker_$counter'),
        position: point,
        onTap: () {},
        icon: BitmapDescriptor.defaultMarker);

    setState(() {
      _markers.add(marker);
    });
  }

  void _setPolyline(List<PointLatLng> points) {
    final String polylineIdVal = 'polyline_$polylineIdCounter';

    polylineIdCounter++;

    _polylines.add(Polyline(
        polylineId: PolylineId(polylineIdVal),
        width: 2,
        color: Colors.blue,
        points: points.map((e) => LatLng(e.latitude, e.longitude)).toList()));
  }

  void _setCircle(LatLng point) async {
    final GoogleMapController controller = await _controller.future;

    controller.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(target: point, zoom: 12)));
    setState(() {
      _circles.add(Circle(
          circleId: CircleId('raj'),
          center: point,
          fillColor: Colors.blue.withOpacity(0.1),
          radius: radiusValue,
          strokeColor: Colors.blue,
          strokeWidth: 1));
      getDirections = false;
      searchToggle = false;
      radiusSlider = true;
    });
  }



  Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);

    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
        .buffer
        .asUint8List();
  }


  @override
  void initState() {
    // TODO: implement initState
    _pageController = PageController(initialPage: 1, viewportFraction: 0.85)
      ..addListener(_onScroll);
    super.initState();
  }

  void _onScroll() {
    if (_pageController.page!.toInt() != prevPage) {
      prevPage = _pageController.page!.toInt();
      cardTapped = false;
      goToTappedPlace();

    }
  }


  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    //Providers
    final allSearchResults = ref.watch(placeResultsProvider);
    final searchFlag = ref.watch(searchToggleProvider);

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                Container(
                  height: screenHeight,
                  width: screenWidth,
                  child: GoogleMap(
                    mapType: MapType.normal,
                    markers: _markers,
                    polylines: _polylines,
                    circles: _circles,
                    initialCameraPosition: _kGooglePlex,
                    onMapCreated: (GoogleMapController controller) {
                      _controller.complete(controller);
                    },
                    onTap: (point) {
                      tappedPoint = point;
                      _setCircle(point);
                    },
                  ),
                )
              ],
            ),
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
                            if (_debounce?.isActive ?? false)
                              _debounce?.cancel();
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
          ],
        ),
      ),
      floatingActionButton: FabCircularMenu(
          alignment: Alignment.bottomLeft,
          fabColor: complementaryColor1,
          fabOpenColor: primaryColor,
          ringDiameter: 250.0,
          ringWidth: 60.0,
          ringColor: complementaryColor1,
          child: Column(children: [
        Stack(children: [
          Container(
              height: screenHeight,
              width: screenWidth,
              child: GoogleMap(
                mapType: MapType.normal,
                markers: _markers,
                polylines: _polylines,
                circles: _circles,
                initialCameraPosition: _kGooglePlex,
                onMapCreated: (GoogleMapController controller) {
                  _controller.complete(controller);
                },
                onTap: (point) {
                  tappedPoint = point;
                  _setCircle(point);
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
          searchFlag.searchToggle
              ? allSearchResults.allReturnedResults.length != 0
                  ? Positioned(
                      top: 100.0,
                      left: 15.0,
                      child: Container(
                        height: 200.0,
                        width: screenWidth - 30.0,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          color: Colors.white.withOpacity(0.7),
                        ),
                        child: ListView(
                          children: [
                            ...allSearchResults.allReturnedResults
                                .map((e) => buildListItem(e, searchFlag))
                          ],
                        ),
                      ))
                  : Positioned(
                      top: 100.0,
                      left: 15.0,
                      child: Container(
                        height: 200.0,
                        width: screenWidth - 30.0,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          color: Colors.white.withOpacity(0.7),
                        ),
                        child: Center(
                          child: Column(children: [
                            Text('No results to show',
                                style: TextStyle(
                                    fontFamily: 'WorkSans',
                                    fontWeight: FontWeight.w400)),
                            SizedBox(height: 5.0),
                            Container(
                              width: 125.0,
                              child: ElevatedButton(
                                onPressed: () {
                                  searchFlag.toggleSearch();
                                },
                                child: Center(
                                  child: Text(
                                    'Close this',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontFamily: 'WorkSans',
                                        fontWeight: FontWeight.w300),
                                  ),
                                ),
                              ),
                            )
                          ]),
                        ),
                      ))
              : Container(),
          getDirections
              ? Padding(
                  padding: EdgeInsets.fromLTRB(15.0, 40.0, 15.0, 5),
                  child: Column(children: [
                    Container(
                      height: 50.0,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        color: Colors.white,
                      ),
                      child: TextFormField(
                        controller: _originController,
                        decoration: InputDecoration(
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 20.0, vertical: 15.0),
                            border: InputBorder.none,
                            hintText: 'Origin'),
                      ),
                    ),
                    SizedBox(height: 3.0),
                    Container(
                      height: 50.0,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        color: Colors.white,
                      ),
                      child: TextFormField(
                        controller: _destinationController,
                        decoration: InputDecoration(
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 20.0, vertical: 15.0),
                            border: InputBorder.none,
                            hintText: 'Destination',
                            suffixIcon: Container(
                                width: 96.0,
                                child: Row(
                                  children: [
                                    IconButton(
                                        onPressed: () async {
                                          var directions = await MapServices()
                                              .getDirections(
                                                  _originController.text,
                                                  _destinationController.text);
                                          _markers = {};
                                          _polylines = {};
                                          _setPolyline(
                                              directions['polyline_decoded']);
                                        },
                                        icon: Icon(Icons.search)),
                                    IconButton(
                                        onPressed: () {
                                          setState(() {
                                            getDirections = false;
                                            _originController.text = '';
                                            _destinationController.text = '';
                                            _markers = {};
                                            _polylines = {};
                                          });
                                        },
                                        icon: Icon(Icons.close))
                                  ],
                                ))),
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
          fabOpenColor: primaryColor,
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

  Future<void> goToTappedPlace() async {
    final GoogleMapController controller = await _controller.future;

    _markers = {};

    var selectedPlace = allFavoritePlaces[_pageController.page!.toInt()];

  }

  Future<void> gotoSearchedPlace(double lat, double lng) async {
    final GoogleMapController controller = await _controller.future;

    controller.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(target: LatLng(lat, lng), zoom: 12)));

    _setMarker(LatLng(lat, lng));
  }

  Widget buildListItem(AutoCompleteResult placeItem, searchFlag) {
    return Padding(
      padding: EdgeInsets.all(5.0),
      child: GestureDetector(
        onTapDown: (_) {
          FocusManager.instance.primaryFocus?.unfocus();
        },
        onTap: () async {
          var place = await MapServices().getPlace(placeItem.placeId);
          gotoSearchedPlace(place['geometry']['location']['lat'],
              place['geometry']['location']['lng']);
          searchFlag.toggleSearch();
        },
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(Icons.location_on, color: Colors.green, size: 25.0),
            SizedBox(width: 4.0),
            Container(
              height: 40.0,
              width: MediaQuery.of(context).size.width - 75.0,
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(placeItem.description ?? ''),
              ),
            )
          ],
        ),
      ),
    );
  }

}
