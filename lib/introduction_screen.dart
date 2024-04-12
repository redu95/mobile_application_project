import 'package:flutter/material.dart';
import 'package:mobile_application_project/login_page.dart';
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
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // Navigate back to the previous screen (main.dart)
          },
        ),
      ),
      body:  IntroductionScreen(
          key: _introKey,
          pages: [
            PageViewModel(
              title: "Hotel Search",
              image: Image.asset("assets/images/landing_page_images/hotel-location.png"),
              bodyWidget: Column(
                children: [
                  const Text('Finding Best Hotels in Addis Abeba.'),
                  ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => LogInPage()),
                        );
                      },
                      child: const Text('Log In')
                  ),
                  ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => SignUpPage()),
                        );
                      },
                      child: const Text('Sign Up')
                  )
                ],
              ),
            ),
            PageViewModel(
              title: "Online Booking",
              image: Image.asset("assets/images/landing_page_images/reception-desk.jpg"),
              bodyWidget: Column(
                children: [
                  const Text('Booking Online From any part of the World!'),
                  ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => LogInPage()),
                        );
                      },
                      child: const Text('Log In')
                  ),
                  ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => SignUpPage()),
                        );
                      },
                      child: const Text('Sign Up')
                  )
                ],
              ),
            ),
            PageViewModel(
              title: "Hotel Details",
              image: Image.asset("assets/images/landing_page_images/receptionist-working-on-her-desk-with-laptop.png"),
              bodyWidget: Column(
                children: [
                  const Text('Having all Information About Selected Hotels their Service!'),
                  ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => LogInPage()),
                        );
                      },
                      child: const Text('Log In')
                  ),
                  ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => SignUpPage()),
                        );
                      },
                      child: const Text('Sign Up')
                  )
                ],
              ),
            ),
            PageViewModel(
              title: "Map View",
              image: Image.asset("assets/images/landing_page_images/hotel-location.png"),
              bodyWidget: Column(
                children: [
                  const Text('Getting the Exact Location of the Hotels in Map!'),
                  ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => LogInPage()),
                        );
                      },
                      child: const Text('Log In')
                  ),
                  ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => SignUpPage()),
                        );
                      },
                      child: const Text('Sign Up')
                  )
                ],
              ),
            ),
            PageViewModel(
              title: "Review and Ratings",
              image: Image.asset("assets/images/landing_page_images/waiter-holding-tray-in-restaurant.png"),
              bodyWidget: Column(
                children: [
                  const Text('Display accurate star ratings for each hotel, providing users with valuable insights into the quality and service!'),
                  ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => LogInPage()),
                        );
                      },
                      child: const Text('Log In')
                  ),
                  ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => SignUpPage()),
                        );
                      },
                      child: const Text('Sign Up')
                  )

                ],
              ),
            ),
          ],
          showNextButton: false,
          showDoneButton: false,
        ),
    );
  }
}

