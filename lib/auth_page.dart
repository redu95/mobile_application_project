import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mobile_application_project/main.dart';



import 'home_page.dart';
import 'login_page.dart';class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder:(context, snapshot){
          //user is loged  in
          if(snapshot.hasData){
            return Home();
          }

          //user is NOT log in
          else{
            return const WelcomePage();
          }
        },
      ),
    );
  }
}
