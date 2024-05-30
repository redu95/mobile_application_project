
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile_application_project/auth_page.dart';
import 'package:mobile_application_project/login_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mobile_application_project/introduction_screen.dart';
import 'package:flutter_locales/flutter_locales.dart';
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
  //await addHotels();
  runApp(MyApp());
}

Future<String> getDownloadUrl(String folder, String fileName) async {
  Reference ref = FirebaseStorage.instance.ref().child('$folder/$fileName');
  return await ref.getDownloadURL();
}

Future<void> addHotels() async {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  // Hotel data with file names
  List<Map<String, dynamic>> hotels = [
    // Add hotels here...
  ];

  for (var hotel in hotels) {
    // Get main image URL
    String mainImageUrl = await getDownloadUrl('hotelImages', hotel['mainImage']);

    // Get additional image URLs
    List<String> imageUrls = [];
    for (String imageName in hotel['images']) {
      String imageUrl = await getDownloadUrl('hotelImages', imageName);
      imageUrls.add(imageUrl);
    }

    DocumentReference hotelRef = await firestore.collection('hotels').add({
      'name': hotel['name'],
      'location': hotel['location'],
      'rating': hotel['rating'],
      'imgUrl': mainImageUrl,
      'images': imageUrls,
      'description': hotel['description'],
      'amenities': hotel['amenities'],
      'policies': hotel['policies'],
    });

    for (var roomType in hotel['roomTypes']) {
      String roomTypeImageUrl = await getDownloadUrl('hotelImages', roomType['image']);

      DocumentReference roomTypeRef = await hotelRef.collection('room_types').add({
        'type': roomType['type'],
        'imgUrl': roomTypeImageUrl,
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