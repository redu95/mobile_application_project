
//import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile_application_project/auth_page.dart';
import 'package:mobile_application_project/login_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mobile_application_project/introduction_screen.dart';
import 'package:mobile_application_project/languageMenu.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:mobile_application_project/l10n/l10n.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'firebase_options.dart';
import 'package:mobile_application_project/theme_provider.dart';
import 'package:provider/provider.dart';

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();

  static void setLocale(BuildContext context, Locale newLocale) {
    _MyAppState? state = context.findAncestorStateOfType<_MyAppState>();
    state?.setLocale(newLocale);
  }

  static Future<void> saveLanguagePreference(String languageCode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('language_code', languageCode);
  }
}

class _MyAppState extends State<MyApp> {
  Locale? _locale;
  bool _isDarkModeEnabled = false;

  setLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
    MyApp.saveLanguagePreference(locale.languageCode);
  }


  @override
  void initState() {
    super.initState();
    _loadLanguagePreference();
  }

  _loadLanguagePreference() async {
    final prefs = await SharedPreferences.getInstance();
    final languageCode = prefs.getString('language_code');
    if (languageCode != null) {
      Locale newLocale = Locale(languageCode);
      setLocale(newLocale);
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return LocaleBuilder(
      builder: (locale) => ChangeNotifierProvider(
        create: (context) => ThemeSettings(), // Provide the initial dark mode value
        child: Consumer<ThemeSettings>(
          builder: (context, themeSettings, _) {
            return MaterialApp(
              title: 'Addis Stay',
              localizationsDelegates: AppLocalizations.localizationsDelegates,
              supportedLocales: AppLocalizations.supportedLocales,
              theme: themeSettings.currentTheme,
              locale: _locale,
              home: const AuthPage(),
              debugShowCheckedModeBanner: false,
            );
          },
        ),
      ),
    );
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await Locales.init(['en', 'am', 'ar', 'es']); // Initialize flutter_locales
  await addHotels();
  runApp(MyApp());
}

Future<void> addHotels() async {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseStorage storage = FirebaseStorage.instance;

  List<Map<String, dynamic>> hotels = [
    {
      'name': 'Capital Hotel and Spa',
      'location': {'city': 'Addis Ababa', 'country': 'Ethiopia', 'address': '22 Mazoria'},
      'rating': 4.5,
      'imgUrl': 'assets/images/hotels/Capital/capitalMain.jpg',  // Main image from assets
      'images': [  // Additional images from assets
        'assets/images/hotels/Capital/cap1.jpg',
        'assets/images/hotels/Capital/cap2.jpg',
        'assets/images/hotels/Capital/cap3.jpg',
        'assets/images/hotels/Capital/cap4.jpg',
        'assets/images/hotels/Capital/cap5.jpg',
        'assets/images/hotels/Capital/cap-6.jpg',
        'assets/images/hotels/Capital/cap-7.jpg',
      ],
      'description': 'A luxurious hotel in the heart of Addis Ababa.',
      'amenities': ['Free Wi-Fi', 'Swimming Pool', 'Gym', 'Spa'],
      'policies': {'checkIn': '12:00 PM', 'checkOut': '11:00 AM', 'cancellation': 'Free cancellation within 24 hours'},
      'roomTypes': [
        {
          'type': 'Standard King Room',
          'imgUrl': 'assets/images/hotels/Capital/cap-Satndard-King.jpg',  // Room type image from assets
          'pricePerNight': 15000,
          'rooms': [
            {'roomNumber': '1', 'availability': true},
            {'roomNumber': '2', 'availability': true},
          ],
        },
        {
          'type': 'Supreme King Room',
          'imgUrl': 'assets/images/hotels/Capital/cap-Sup-King.jpg',  // Room type image from assets
          'pricePerNight': 13000,
          'rooms': [
            {'roomNumber': '3', 'availability': true},
            {'roomNumber': '4', 'availability': true},
          ],
        },
        {
          'type': 'Tween Room',
          'imgUrl': 'assets/images/hotels/Capital/cap-Tween.jpg',  // Room type image from assets
          'pricePerNight': 12000,
          'rooms': [
            {'roomNumber': '3', 'availability': true},
            {'roomNumber': '4', 'availability': true},
          ],
        },
        {
          'type': 'Suit Room',
          'imgUrl': 'assets/images/hotels/Capital/cap-Suit.jpg',  // Room type image from assets
          'pricePerNight': 11000,
          'rooms': [
            {'roomNumber': '3', 'availability': true},
            {'roomNumber': '4', 'availability': true},
          ],
        },
        {
          'type': 'Studio Room',
          'imgUrl': 'assets/images/hotels/Capital/cap-Studio.jpg',  // Room type image from assets
          'pricePerNight': 10000,
          'rooms': [
            {'roomNumber': '3', 'availability': true},
            {'roomNumber': '4', 'availability': true},
          ],
        },
        {
          'type': 'Single Room',
          'imgUrl': 'assets/images/hotels/Capital/cap-single.jpg',  // Room type image from assets
          'pricePerNight': 10000,
          'rooms': [
            {'roomNumber': '3', 'availability': true},
            {'roomNumber': '4', 'availability': true},
          ],
        },
      ],
      'reviews': [
        {'userId': 'user_123', 'rating': 5, 'comment': 'Great place!', 'createdAt': FieldValue.serverTimestamp()},
      ],
    },
    // Add more hotels here...
  ];

  for (var hotel in hotels) {
    // Upload main image
    String mainImageUrl = await uploadImageAndGetUrl(storage, hotel['imgUrl']);

    // Upload additional images
    List<String> imageUrls = [];
    for (var imagePath in hotel['images']) {
      String imageUrl = await uploadImageAndGetUrl(storage, imagePath);
      imageUrls.add(imageUrl);
    }

    DocumentReference hotelRef = await firestore.collection('hotels').add({
      'name': hotel['name'],
      'location': hotel['location'],
      'rating': hotel['rating'],
      'imgUrl':mainImageUrl,
      'images': imageUrls,
      'description': hotel['description'],
      'amenities': hotel['amenities'],
      'policies': hotel['policies'],
    });

    for (var roomType in hotel['roomTypes']) {
      // Upload room type image
      String roomImageUrl = await uploadImageAndGetUrl(storage, roomType['imgUrl']);

      DocumentReference roomTypeRef = await hotelRef.collection('room_types').add({
        'type': roomType['type'],
        'imgUrl': roomType['imgUrl'],
        'pricePerNight': roomType['pricePerNight'],
      });

      for (var room in roomType['rooms']) {
        await roomTypeRef.collection('rooms').add({
          'roomNumber': room['roomNumber'],
          'availability': room['availability'],
        });
      }
    }

    for (var review in hotel['reviews']) {
      await hotelRef.collection('reviews').add({
        'userId': review['userId'],
        'rating': review['rating'],
        'comment': review['comment'],
        'createdAt': review['createdAt'],
      });
    }
  }

  print('Hotels added successfully');
}

Future<String> uploadImageAndGetUrl(FirebaseStorage storage, String assetPath) async {
  try {
    // Load image data as bytes
    final ByteData byteData = await rootBundle.load(assetPath);
    final Uint8List imageData = byteData.buffer.asUint8List();

    // Create a reference to the location where the image will be stored
    Reference ref = storage.ref().child('hotelImages/${assetPath.split('/').last}');

    // Upload the image data to Firebase Storage
    UploadTask uploadTask = ref.putData(imageData);

    // Wait until the upload completes
    TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() => {});

    // Get the download URL of the uploaded image
    String downloadUrl = await taskSnapshot.ref.getDownloadURL();

    return downloadUrl;
  } catch (e) {
    print('Error uploading image: $e');
    throw e;
  }
}


class WelcomePage extends StatefulWidget {
  const WelcomePage({Key? key}) : super(key: key);

  @override
  _WelcomePageState createState() => _WelcomePageState();

}

class _WelcomePageState extends State<WelcomePage> {
  // List of languages
  final List<String> _languages = ["English", "አማርኛ", "عربي", "español"];
  String? _selectedLanguage;

  // Function to set the locale based on the selected language
  void _changeLanguage(String? language) {
    if (language == null) return;
    Locale newLocale;
    switch (language) {
      case "አማርኛ":
        newLocale = Locale('am');
        break;
      case "عربي":
        newLocale = Locale('ar');
        break;
      case "español":
        newLocale = Locale('es');
        break;
      case "English":
      default:
        newLocale = Locale('en');
        break;
    }
    MyApp.setLocale(context, newLocale);
    setState(() {
      _selectedLanguage = language;
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeSettings>(context);
    return Scaffold(
      body: Stack(
        children: [
          // Background image
          Image.asset(
            'assets/images/landing_page_images/welcomePag_Image.jpg',
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
          // Dark overlay to make the image darker
          Container(
            color: Colors.black.withOpacity(0.65),
            width: double.infinity,
            height: double.infinity,
          ),
          // Language dropdown
          Positioned(
            top: 60,
            right: 20,
            child: Align(
              child: DropdownButton<String>(
                value: _selectedLanguage,
                dropdownColor: Colors.deepPurple,
                hint: const Text(
                  'Language',
                  style: TextStyle(color: Colors.white),
                ),
                onChanged: _changeLanguage,
                items: _languages.map((String language) {
                  return DropdownMenuItem<String>(
                    value: language,
                    child: Text(
                      language,
                      style: const TextStyle(color: Colors.white),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
          Positioned(
            left: 160,
            top: 220,
            child: Container(
              width: 50,
              height: 50,
              color: Colors.white,
              child: Icon(Icons.hotel, color: Colors.deepPurple),
            ),
          ),
          Positioned(
            left: 115,
            top: 300,
            child: Text(
              AppLocalizations.of(context)?.addis_stay ?? '',
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          Positioned(
            left: 80,
            top: 350,
            child: Text(
              AppLocalizations.of(context)?.best_app_to_book_hotels ?? '',
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          Positioned(
            left: 60,
            bottom: 150,
            child: Align(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => IntroScreenDemo()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  padding: EdgeInsets.symmetric(horizontal: 100, vertical: 16),
                ),
                child: Text(
                  AppLocalizations.of(context)?.get_started ?? '',
                  style: const TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            left: 90,
            bottom: 100,
            child: GestureDetector(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => LogInPage()));
              },
              child: Text(
                AppLocalizations.of(context)?.already_have_an_account ?? '',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}