import 'dart:ui';

import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobile_application_project/auth_page.dart';
import 'package:mobile_application_project/introduction_screen.dart';
import 'package:mobile_application_project/languageMenu.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:mobile_application_project/l10n/l10n.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'firebase_options.dart';

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();

  static void setLocale(BuildContext context, Locale newLocale) {
    _MyAppState? state = context.findAncestorStateOfType<_MyAppState>();
    state?.setLocale(newLocale);
  }
}

class _MyAppState extends State<MyApp> {
  Locale? _locale;

  setLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Localization',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,

      locale: _locale,
      home: const WelcomePage(),
    );
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await FirebaseAppCheck.instance.activate();
  runApp(MyApp());
}

class WelcomePage extends StatefulWidget {
  const WelcomePage({Key? key}) : super(key: key);

  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  // List of languages
  final List<String> _languages = ["English", "Amharic", "Arabic", "Spanish"];
  String? _selectedLanguage;

  // Function to set the locale based on the selected language
  void _changeLanguage(String? language) {
    if (language == null) return;
    Locale newLocale;
    switch (language) {
      case "Amharic":
        newLocale = Locale('am');
        break;
      case "Arabic":
        newLocale = Locale('ar');
        break;
      case "Spanish":
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
          // Other widgets...
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
                Navigator.push(context, MaterialPageRoute(builder: (context) => AuthPage()));
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
