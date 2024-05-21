
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:mobile_application_project/auth_page.dart';
import 'package:mobile_application_project/introduction_screen.dart';
import 'package:flutter_localizations/flutter_localizations.dart';


import 'package:mobile_application_project/languageMenu.dart';
import 'package:flutter_locales/flutter_locales.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  //await FirebaseAppCheck.instance.activate();
  await Locales.init(['en','es', 'am', 'ar']); // Initialize locales
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return LocaleBuilder(
      builder: (locale) => MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Locales',
        localizationsDelegates: const [
          Locales.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: Locales.supportedLocales,
        locale: locale,
        home: const WelcomePage(),
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
      ),
    );
  }
}

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

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
// Language button
          Positioned(
            top: 60,
            right: 20,
            child: Align(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const LanguageMenuDemo()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 16),
                ),
                child: const LocaleText(
                  'language',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
// Icon in square
          Positioned(
            left: 160,
            top: 220,
            child: Container(
              width: 50,
              height: 50,
              color: Colors.white,
              child: const Icon(Icons.hotel, color: Colors.deepPurple),
            ),
          ),
// Welcome text and icon
          const Positioned(
            left: 115,
            top: 300,
            child: LocaleText(
              'addis_stay',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          const Positioned(
            left: 80,
            top: 350,
            child: LocaleText(
              'best_app_to_book_hotels',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
// Get Started button
          Positioned(
            left: 60,
            bottom: 150,
            child: Align(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const IntroScreenDemo()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  padding: const EdgeInsets.symmetric(horizontal: 100, vertical: 16),
                ),
                child: const LocaleText(
                  'get_started',
                  style: TextStyle(
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
                Navigator.push(context, MaterialPageRoute(builder: (context) => const AuthPage()));
              },
              child: const LocaleText(
                'already_have_an_account',
                style: TextStyle(
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