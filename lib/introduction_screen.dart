import 'package:flutter/material.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:mobile_application_project/auth_page.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:mobile_application_project/signup_page.dart';

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
          icon: const Icon(Icons.arrow_back),
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
              titleWidget: LocaleText(
                'addis_stay',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              bodyWidget: LocaleText(
                'welcome_description',
                style: TextStyle(fontSize: 16),
              ),
              image: const Center(
                child: Icon(Icons.waving_hand, size: 150.0, color: Colors.deepPurple),
              ),
            ),
            PageViewModel(
              titleWidget: LocaleText(
                'hotel_search',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              bodyWidget: LocaleText(
                'hotel_search_description',
                style: TextStyle(fontSize: 16),
              ),
              image: const Center(
                child: Icon(Icons.location_searching, size: 150.0, color: Colors.deepPurple),
              ),
            ),
            PageViewModel(
              titleWidget: LocaleText(
                'online_booking',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              bodyWidget: LocaleText(
                'online_booking_description',
                style: TextStyle(fontSize: 16),
              ),
              image: Image.asset("assets/images/landing_page_images/reception-desk.jpg"),
            ),
            PageViewModel(
              titleWidget: LocaleText(
                'hotel_details',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              bodyWidget: LocaleText(
                'hotel_details_description',
                style: TextStyle(fontSize: 16),
              ),
              image: Image.asset("assets/images/landing_page_images/receptionist-working-on-her-desk-with-laptop.png"),
            ),
            PageViewModel(
              titleWidget: LocaleText(
                'review_ratings',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              bodyWidget: Column(
                children: [
                  LocaleText(
                    'review_ratings_description',
                    style: TextStyle(color: Colors.deepPurple, fontSize: 20.0),
                  ),
                  const SizedBox(height: 10.0),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => AuthPage()),
                      );
                    },
                    child: LocaleText(
                      'log_in',
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
                    child: LocaleText(
                      'sign_up',
                      style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                    ),
                  )
                ],
              ),
              image: Image.asset("assets/images/landing_page_images/waiter-holding-tray-in-restaurant.png"),
            ),
          ],
          skip: LocaleText('skip'),
          next: LocaleText('next'),
          showSkipButton: true,
          showNextButton: true,
          showDoneButton: false,
        ),
      ),
    );
  }
}
