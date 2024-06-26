import 'package:flutter/material.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:mobile_application_project/auth_page.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:mobile_application_project/login_page.dart';
import 'package:mobile_application_project/signup_page.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:mobile_application_project/colors.dart';

import 'colors.dart';

class IntroScreenDemo extends StatefulWidget {
  const IntroScreenDemo({super.key});

  @override
  State<IntroScreenDemo> createState() => _IntroScreenDemoState();
}

class _IntroScreenDemoState extends State<IntroScreenDemo> {
  final _introKey = GlobalKey<IntroductionScreenState>();

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // Navigate back to the previous screen (main.dart)
          },
        ),
      ),
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: IntroductionScreen(
          key: _introKey,
          pages: [
            PageViewModel(
              titleWidget: Text(AppLocalizations.of(context)?.addis_stay ?? '',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              bodyWidget: Text(AppLocalizations.of(context)?.welcome_description ?? '',
                style: TextStyle(fontSize: 16),
              ),
              image: const Center(
                child: Icon(Icons.waving_hand, size: 150.0, color: Color(0xFF0077B6)),
              ),
            ),
            PageViewModel(
              titleWidget: Text(AppLocalizations.of(context)?.hotel_search ?? '',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              bodyWidget: Text(AppLocalizations.of(context)?.hotel_search_description?? '',
                style: TextStyle(fontSize: 16),
              ),
              image: const Center(
                child: Icon(
                  Icons.location_searching,
                  size: 150.0,
                  color: Color(0xFF0077B6), // or primaryColor2, primaryColor3, etc.
                ),
              ),
            ),
            PageViewModel(
              titleWidget: Text(AppLocalizations.of(context)?.online_booking?? '',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              bodyWidget: Text(AppLocalizations.of(context)?.online_booking_description?? '',
                style: TextStyle(fontSize: 16),
              ),
              image: Image.asset("assets/images/landing_page_images/reception-desk.jpg"),
            ),
            PageViewModel(
              titleWidget: Text(AppLocalizations.of(context)?.hotel_details?? '',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              bodyWidget: Text(AppLocalizations.of(context)?.hotel_details_description?? '',
                style: TextStyle(fontSize: 16),
              ),
              image: Image.asset("assets/images/landing_page_images/receptionist-working-on-her-desk-with-laptop.png"),
            ),
            PageViewModel(
              titleWidget: Text(AppLocalizations.of(context)?.review_ratings?? '',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              bodyWidget: Column(
                children: [
                  Text(AppLocalizations.of(context)?.review_ratings_description?? '',
                    style: TextStyle(fontSize: 20.0),
                  ),
                  const SizedBox(height: 10.0),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => LogInPage()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor, // Set the background color to green
                      foregroundColor: Colors.white, // Set the text color to white

                    ),
                    child: Text(
                      AppLocalizations.of(context)?.log_in ?? '',
                      style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 10.0),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => SignUpPage()),

                      );

                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor, // Set the background color to green
                      foregroundColor: Colors.white, // Set the text color to white

                    ),
                    child: Text(AppLocalizations.of(context)?.sign_Up?? '',
                      style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                    ),
                  )
                ],
              ),
              image: Image.asset("assets/images/landing_page_images/waiter-holding-tray-in-restaurant.png"),
            ),
          ],
          skip: Text(AppLocalizations.of(context)?.skip?? '',),
          next: Text(AppLocalizations.of(context)?.next?? '',),
          showSkipButton: true,
          showNextButton: true,
          showDoneButton: false,
        ),
      ),
    );
  }
}

