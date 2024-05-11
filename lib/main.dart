import 'dart:ui';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobile_application_project/introduction_screen.dart';
import 'package:mobile_application_project/login_page.dart';
// import 'package:firebase_app_check/firebase _app_check.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  //await FirebaseAppCheck.instance.activate();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Addis Stay',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home:  WelcomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class WelcomePage extends StatelessWidget {
  const WelcomePage({Key? key}) : super(key: key);

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
            color: Colors.black.withOpacity(0.65), // Adjust opacity as needed
            width: double.infinity,
            height: double.infinity,
          ),
          //Icon in square
          Positioned(
            left: 160,
            top: 220,
            child: Container(
              width: 50,
              height: 50,
              color: Colors.white,
              child: Icon(Icons.hotel, color: Colors.deepPurple), // Later be Changed
            ),
          ),
          // Welcome text and icon
          const Positioned(
            left: 115,
            top: 300,
            child: Text(
              'Addis Stay',
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
            child: Text(
              'Best App to Book Hotels in Addis Ababa!',
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
              //alignment: Alignment.bottomCenter,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => IntroScreenDemo()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple, //  fill color
                  padding: EdgeInsets.symmetric(horizontal: 100, vertical: 16), // Adjust button size here
                ),
                child: const Text(
                    'Get Started',
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
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context)=> LogInPage()));
                },
                child:const Text(
                    'Already Have an Account? Log in',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
          )

        ],
      ),
    );
  }
}