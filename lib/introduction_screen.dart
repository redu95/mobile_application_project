import 'package:flutter/material.dart';
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
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // Navigate back to the previous screen (main.dart)
          },
        ),
      ),
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        child:  IntroductionScreen(
          key: _introKey,
          pages: [
            PageViewModel(
              title: "Addis Stay",
              body: "Welcome to the app! This is a description of how it works.",
              image: const Center(
                child: Icon(Icons.waving_hand, size: 150.0,color: Colors.deepPurple,),
              ),
            ),
            PageViewModel(
              title: "Hotel Search",
              image: const Center(
                child: Icon(Icons.location_searching, size: 150.0,color: Colors.deepPurple,),
              ),
              body:'Finding Best Hotels in Addis Abeba.',
            ),
            PageViewModel(
              title: "Online Booking",
              image: Image.asset("assets/images/landing_page_images/reception-desk.jpg"),
              body:'Booking Online From any part of the World!',
            ),
            PageViewModel(
              title: "Hotel Details",
              image: Image.asset("assets/images/landing_page_images/receptionist-working-on-her-desk-with-laptop.png"),
              body:'Having all Information About Selected Hotels their Service!',
            ),
            PageViewModel(
              title: "Review and Ratings",
              image: Image.asset("assets/images/landing_page_images/waiter-holding-tray-in-restaurant.png"),
              bodyWidget: Column(
                children: [
                  const Text(
                    'Display accurate star ratings for each hotel, providing users with valuable insights into the quality and service!',
                    style: TextStyle(
                      color: Colors.deepPurple,fontSize: 20.0,
                    ),
                  ),
                  const SizedBox(height: 10.0),
                  ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => AuthPage()),
                        );
                      },
                      child: const Text('                Log In                ',style: TextStyle(fontSize: 20.0,fontWeight: FontWeight.bold),)
                  ),
                  const SizedBox(height: 10.0),
                  ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => SignUpPage()),
                        );
                      },
                      child: const Text('                Sign Up                ',style: TextStyle(fontSize: 20.0,fontWeight: FontWeight.bold),)
                  )

                ],
              ),
            ),
          ],
          skip: const Text("Skip"),
          next: const Text("Next"),
          showSkipButton: true,
          showNextButton: true,
          showDoneButton: false,
        ),
      ),
    );
  }
}

