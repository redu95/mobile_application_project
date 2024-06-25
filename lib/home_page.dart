import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ionicons/ionicons.dart';
import 'package:mobile_application_project/search_page.dart';
import 'package:mobile_application_project/setting_page.dart';
import 'package:mobile_application_project/detail_screen.dart';
import 'package:mobile_application_project/theme_provider.dart';
import 'package:provider/provider.dart';
import 'Nearby_page.dart';
import 'colors.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:badges/badges.dart' as badges;

import 'my_bookings.dart';



class Home extends StatefulWidget {
  @override
  State<Home> createState() => _HomeState();
}

enum MenuSelection {
  menu1,
  menu2,
  menu3,
  menu4,
}

class _HomeState extends State<Home> {
  final User user = FirebaseAuth.instance.currentUser!;
  int _selectedIndex = 0;
  late List<Widget> _widgetOptions;
  bool isConnected = true;
  late StreamSubscription<ConnectivityResult> connectivitySubscription;


  @override
  void initState() {
    super.initState();
    _widgetOptions = <Widget>[
      HomePage(),
      SearchPage(),
      NearbyPage(),
      SettingPage(
        userName: user.displayName ?? '',
        email: user.email ?? 'Add your email',
        photoUrl: user.photoURL,
      ),
    ];
    // Initial check
    checkConnection();
    // // Listen for connectivity changes
    // connectivitySubscription = Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
    //   checkConnection();
    // });
  }

  @override
  void dispose() {
    connectivitySubscription.cancel();
    super.dispose();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Future<void> checkConnection() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    setState(() {
      isConnected = connectivityResult != ConnectivityResult.none;
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Center(
            child: _widgetOptions.elementAt(_selectedIndex),
          ),
          if (!isConnected)
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Container(
                color: Colors.red,
                padding: EdgeInsets.all(8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.warning, color: Colors.white),
                    SizedBox(width: 8),
                    Text(
                      AppLocalizations.of(context)!.no_internet_connection,
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: AppLocalizations.of(context)!.home,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: AppLocalizations.of(context)!.search,
          ),
          BottomNavigationBarItem(
            icon: Icon(FontAwesomeIcons.locationDot),
            label: AppLocalizations.of(context)!.nearby,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: AppLocalizations.of(context)!.profile,
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: primaryColor,
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
      ),
    );
  }

}

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  MenuSelection selectedOne = MenuSelection.menu1;
  String userName = '';
  String email = "";
  String? photoUrl; // Add this variable to hold profile picture URL
  late User user; // Add this variable to hold the authenticated user
  bool isLoading = true; // Track loading state
  List<Map<String, dynamic>> hotels = []; // To store fetched hotel data
  List<String> favoriteHotelIds = [];
  bool isConnected = true;
  int notificationCount = 0;



  @override
  // initializing the states
  void initState() {
    super.initState();
    user = FirebaseAuth.instance.currentUser!;
    loadUserInfo(user.uid);
    fetchHotelData();
    fetchFavorites();
    checkConnection();
    fetchNotificationCount();
  }
  Future<void> checkConnection() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    // showNoInternetSnackBar();
    setState(() {
      isConnected = connectivityResult != ConnectivityResult.none;
    });
    if (connectivityResult == ConnectivityResult.none){
      // Delay showing the SnackBar slightly to ensure the UI updates are processed
      Future.delayed(Duration(milliseconds: 500), () {
        showNoInternetSnackBar();
      }); // Show snackbar if no internet
    }
  }

  void showNoInternetSnackBar() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(AppLocalizations.of(context)!.no_internet_connection),
        duration: Duration(seconds: 5), // Adjust the duration as desired
      ),
    );
  }

  Future<void> fetchNotificationCount() async {
    int count = await fetchNotifications();
    setState(() {
      notificationCount = count;
    });
  }
  Future<int> fetchNotifications() async {
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('bookings')
          .where('user_id', isEqualTo: user.uid)
          .where('status', isEqualTo: 'booked')
          .get();


      return snapshot.docs.length;
    } catch (e) {
      print("Error fetching notifications: $e");
      return 0;
    }
  }


  // Fetch Hotels Function
  Future<List<Map<String, dynamic>>> fetchHotels() async {
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('hotels').get();
      return snapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id; // Add the document ID to the map
        return data;
      }).toList();
    } catch (e) {
      print("Error fetching hotels: $e");
      return [];
    }
  }

  Future<void> fetchHotelData() async {
    if (!isConnected) {
      return;
    }
    List<Map<String, dynamic>> fetchedHotels = await fetchHotels();
    setState(() {
      hotels = fetchedHotels;
    });
  }


  //Load User Info Function
  Future<void> loadUserInfo(String uid) async {
    if (!isConnected) {
      setState(() {
        isLoading = false;
      });
      return;
    }
    try {
      DocumentSnapshot userDoc =
      await FirebaseFirestore.instance.collection('users').doc(uid).get();
      if (userDoc.exists) {
        setState(() {
          userName = userDoc.get('userName');
          email = userDoc.get('email') ?? "Add your email";
          photoUrl = userDoc.get('photoUrl');
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
        print("Document does not exist");
      }
    } catch (e) {
      print("Error loading user info: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> fetchFavorites() async {
    if (!isConnected) {
      return;
    }
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('favorites')
          .where('userId', isEqualTo: user.uid)
          .get();

      setState(() {
        favoriteHotelIds = snapshot.docs.map((doc) => doc['hotelId'] as String).toList();
      });
    } catch (e) {
      print("Error fetching favorites: $e");
    }
  }

  Future<void> addFavorite(String hotelId) async {
    if (!isConnected) {
      return;
    }
    try {
      await FirebaseFirestore.instance.collection('favorites').add({
        'userId': user.uid,
        'hotelId': hotelId,
        'createdAt': Timestamp.now(),
      });

      setState(() {
        favoriteHotelIds.add(hotelId);
      });
    } catch (e) {
      print("Error adding favorite: $e");
    }
  }

  Future<void> removeFavorite(String hotelId) async {
    if (!isConnected) {
      return;
    }
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('favorites')
          .where('userId', isEqualTo: user.uid)
          .where('hotelId', isEqualTo: hotelId)
          .get();

      for (var doc in snapshot.docs) {
        await doc.reference.delete();
      }

      setState(() {
        favoriteHotelIds.remove(hotelId);
      });
    } catch (e) {
      print("Error removing favorite: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeSettings = Provider.of<ThemeSettings>(context);
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: themeSettings.currentTheme,
        home: Scaffold(
            body: SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 2,
                        vertical: 15,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          CircleAvatar(
                            radius: 30,
                            backgroundImage: photoUrl != null
                                ? NetworkImage(photoUrl!)
                                : NetworkImage(
                                'https://static.vecteezy.com/system/resources/previews/004/026/956/non_2x/person-avatar-icon-free-vector.jpg'),
                          ),

                          Icon(
                            Ionicons.location,
                            size: 30,
                            color: primaryColor,
                          ),
                          Text(
                            "Addis Ababa"
                                " ,Ethiopia",
                            style: TextStyle(
                              fontWeight: FontWeight.w800,
                              fontSize: 18,
                              color: primaryColor,
                            ),
                          ),
                          Stack(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => MyBookingsPage()), // Navigate to your bookings page
                                  );
                                },
                                child: Icon(
                                  Ionicons.notifications,
                                  size: 30,
                                  color: primaryColor,
                                ),
                              ),
                              if (notificationCount > 0)
                                Positioned(
                                  right: 0,
                                  child: Container(
                                    padding: EdgeInsets.all(2),
                                    decoration: BoxDecoration(
                                      color: Colors.red,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    constraints: BoxConstraints(
                                      minWidth: 16,
                                      minHeight: 16,
                                    ),
                                    child: Text(
                                      '$notificationCount',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                            ],
                          ),

                        ],
                      ),
                    ),
                    Text(
                      'Welcome, $userName!', // Replace $userName with the actual username variable
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                        fontFamily: 'Dancing Script',
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 2, vertical: 5),
                      child: SizedBox(
                        height: 120,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          children: [
                            _buildCategory(
                              context,
                              'Best Likes',
                              'assets/images/hotel_im/hiltonb.jpg',
                                  () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => SearchPage()),
                                    );
                              },
                            ),
                            SizedBox(width: 20),
                            _buildCategory(
                              context,
                              'Most Views',
                              'assets/images/hotel_im/sheratonb.jpg',
                                  () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => SearchPage()),
                                    );
                              },
                            ),
                            SizedBox(width: 20),
                            _buildCategory(
                              context,
                              'Top Rated',
                              'assets/images/hotel_im/skyb.jpg',
                                  () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => SearchPage()),
                                    );
                              },
                            ),
                            SizedBox(width: 20),
                            _buildCategory(
                              context,
                              'Most Popular',
                              'assets/images/hotel_im/capitalb.jpg',
                                  () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => SearchPage()),
                                    );
                              },
                            ),
                            SizedBox(width: 20),
                            _buildCategory(
                              context,
                              'Newest',
                              'assets/images/hotel_im/harmony.jpeg',
                                  () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => SearchPage()),
                                    );
                              },
                            ),
                            SizedBox(width: 20),
                            _buildCategory(
                              context,
                              'Luxury',
                              'assets/images/hotel_im/skycityb.jpg',
                                  () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => SearchPage()),
                                    );
                              },
                            ),
                            SizedBox(width: 20),
                            _buildCategory(
                              context,
                              'Budget Friendly',
                              'assets/images/hotel_im/Ililib.jpeg',
                                  () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => SearchPage()),
                                    );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    SizedBox(height: 15),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 4, vertical: 12),
                      height: 300,
                      width: double.infinity,
                      child: hotels.isEmpty ? Center(child: CircularProgressIndicator()) : ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: hotels.length,
                        itemBuilder: (context, index) {
                          var hotel = hotels[index];
                          bool isFavorite = favoriteHotelIds.contains(hotel['id']);
                          return InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => Detail(hotelId: hotel['id']),
                                ),
                              );
                            },
                            child: Container(
                              height: 240,
                              margin: EdgeInsets.symmetric(horizontal: 8),
                              width: 280,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: primaryColor,
                                  width: 1.5,
                                ),
                              ),
                              child: Stack(
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: Container(
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(12),
                                              topRight: Radius.circular(12),
                                            ),
                                            image: DecorationImage(
                                              image: NetworkImage(hotel['imgUrl']),
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        padding: EdgeInsets.all(8),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              hotel['name'],
                                              style: TextStyle(
                                                fontSize: 24,
                                                //fontFamily: ,  // font family!!!!
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                            SizedBox(height: 4),
                                            Row(
                                              children: [
                                                Icon(
                                                  Icons.location_on,
                                                  size: 20,
                                                  color: primaryColor,
                                                ),
                                                SizedBox(width: 4),
                                                Text(
                                                  hotel['location']['address'] +hotel['location']['city'],
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    // color: Colors.black,
                                                    fontWeight: FontWeight.w400,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                Row(
                                                  children: List.generate(
                                                    5,
                                                        (starIndex) => Icon(
                                                      Icons.star,
                                                      color: accentColor,
                                                      size: 20,
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(width: 4),
                                                Text(
                                                  '${hotel['rating']} Reviews',
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                    color: primaryColor,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  Positioned(
                                    top: 250,
                                    right: 8,
                                    child: GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          isFavorite = !isFavorite;
                                        });
                                        if (isFavorite) {
                                          addFavorite(hotel['id']);
                                        } else {
                                          removeFavorite(hotel['id']);
                                        }
                                      },
                                      child: Icon(
                                        isFavorite ? Icons.favorite : Icons.favorite_border,
                                        size: 30,
                                        color: isFavorite ? Colors.red  : Colors.grey,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),

                    //POPULAR HOTELS

                    const Padding(
                        padding: const EdgeInsets.only(left: 12.0, top: 12),
                        child: Text(
                          "Popular Hotels",
                          style: TextStyle(
                            fontSize: 24,
                            color: Color(0xff3c4657),
                            fontWeight: FontWeight.w500,
                          ),
                        )),
                    const SizedBox(height: 10),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 4, vertical: 12),
                      height: 160, // Adjust the height to your desired value
                      width: double.infinity,
                      child: hotels.isEmpty ? Center(child: CircularProgressIndicator()) : ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: hotels.length,
                        itemBuilder: (context, index) {
                          var hotel = hotels[index];
                          bool isFavorite = favoriteHotelIds.contains(hotel['id']);

                          return InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => Detail(hotelId: hotel['id']),
                                ),
                              );
                            },
                            onTapDown: (_) {
                              setState(() {
                                isFavorite = true;
                              });
                            },
                            onTapCancel: () {
                              setState(() {
                                isFavorite = false;
                              });
                            },
                            child: Container(
                              height: 140, // Adjust the height to your desired value
                              margin: EdgeInsets.symmetric(horizontal: 8),
                              width: 350,//adjust the width to your desired value
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: primaryColor ,
                                  width: 1.5,
                                ),
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    width: 80, // Adjust the width to your desired value
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(12),
                                        bottomLeft: Radius.circular(12),
                                      ),
                                      image: DecorationImage(
                                        image: NetworkImage(hotel['imgUrl']),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Container(
                                      padding: EdgeInsets.all(8),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        children: [
                                          Text(
                                            hotel['name'],
                                            style: TextStyle(
                                              fontSize: 16,
                                              //color: Colors.black,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          SizedBox(height: 4),
                                          Row(
                                            children: [
                                              Icon(
                                                Icons.location_on,
                                                size: 14,
                                                color: primaryColor,
                                              ),
                                              SizedBox(width: 4),
                                              Text(
                                                hotel['location']['address'] +hotel['location']['city'],
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  //color: Colors.black,
                                                  fontWeight: FontWeight.w400,
                                                ),
                                              ),
                                            ],
                                          ),
                                          Text(
                                            "Experience luxury!",
                                            style: TextStyle(
                                              fontSize: 12,
                                              // color: Colors.black,
                                              fontWeight: FontWeight.w300,
                                            ),
                                          ),
                                          Row(
                                            children: [
                                              Row(
                                                children: List.generate(
                                                  5,
                                                      (starIndex) => Icon(
                                                    Icons.star,
                                                    color: accentColor,
                                                    size: 20,
                                                  ),
                                                ),
                                              ),
                                              SizedBox(width: 4),
                                              Text(
                                                '${hotel['rating']} Reviews',
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  color: primaryColor,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Container(
                                    alignment: Alignment.bottomRight,
                                    padding: EdgeInsets.all(8),
                                    child: Icon(
                                      isFavorite ? Icons.favorite : Icons.favorite_border,
                                      size: 24,
                                      color: isFavorite ? Colors.red : Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 20)
                  ],
                ),
              ),
            )));
  }
  Widget _buildCategory(BuildContext context, String label, String imagePath, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          CircleAvatar(
            backgroundImage: AssetImage(imagePath),
            radius: 40,
          ),
          SizedBox(height: 5),
          Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
          SizedBox(width: 10),
        ],
      ),
    );
  }
}
