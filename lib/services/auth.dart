import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mobile_application_project/home_page.dart';
import 'package:mobile_application_project/services/database.dart';

class AuthMethods{
  final FirebaseAuth auth = FirebaseAuth.instance;

  get displayName => displayName;

  getCurrentUser()async{
    return await auth.currentUser;
  }

  signInWihGoogle(BuildContext context) async {
    final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    final GoogleSignIn googleSignIn = GoogleSignIn();

    final GoogleSignInAccount? googleSignInAccount = await googleSignIn.signIn();

    final GoogleSignInAuthentication? googleSignInAuthentication = await googleSignInAccount?.authentication;

    final AuthCredential credential = GoogleAuthProvider.credential(
      idToken: googleSignInAuthentication?.idToken,
      accessToken: googleSignInAuthentication?.accessToken
    );

    UserCredential result =await firebaseAuth.signInWithCredential(credential);

    User? userDetails = result.user;

    if(result!= null){
      Map<String,dynamic> userInfoMap = {
        "email":userDetails!.email,
        "name":userDetails.displayName,
        "imgUrl":userDetails.photoURL,
        "id":userDetails.uid
      };
      await DatabaseMethods().adduser(userDetails.uid, userInfoMap).then((value) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Home()),
        );
      });
    }
  }
}