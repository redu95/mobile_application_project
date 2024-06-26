// login_page.dart

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mobile_application_project/colors.dart';
import 'package:mobile_application_project/home_page.dart';
import 'package:mobile_application_project/forgot_password.dart';
import 'package:mobile_application_project/signup_page.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


class LogInPage extends StatefulWidget {
   const LogInPage({super.key});

  @override
  State<LogInPage> createState() => _LogInPageState();
}

class _LogInPageState extends State<LogInPage> {
  late String email;
  late String password;
  final _formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  void signIn() async {
    // Validate form before proceeding
    if (!_formKey.currentState!.validate()) {
      return; // Form is not valid, do not proceed
    }

    // Check for internet connection
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      // Show a dialog indicating no internet connection
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            titlePadding: EdgeInsets.zero, // Remove default padding
            contentPadding: const EdgeInsets.all(16.0), // Adjust content padding
            title: Container(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    AppLocalizations.of(context)!.no_internet_connection
                    ,
                    style: TextStyle(fontSize: 18.0),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
            content:  Text(AppLocalizations.of(context)!.please_check_your_internet_connection_and_try_again
             ,
              style: TextStyle(fontSize: 16.0),
            ),
          );
        },
      );
      return; // Exit the signIn method
    }

    //show loading Circle
    showDialog(
        context: context,
        builder: (context){
         return const Center(
           child: CircularProgressIndicator() ,
         );
        },
    );
    //try to sign in
    try{
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text,
      );
      // If successful, navigate to home page
      Navigator.pop(context); // Dismiss the loading indicator
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) =>  Home()),
      );
    } on FirebaseAuthException catch (e){
      if(e.code == 'user-not-found'){
        showDialog(
          context: context,
          builder: (context){
            return const AlertDialog(
              title: Text(
                'No User Found for that Email',
                style: TextStyle(fontSize: 18.0),),
            );
          },
        );
      }
      else if(e.code=='wrong-password'){
        showDialog(
          context: context,

          builder: (context){
            return const AlertDialog(
              title: Text(
                'Wrong Password Provided by the user',
                style: TextStyle(fontSize: 18.0),),
            );
          },
        );
      }else if (e.code == 'network-request-failed') {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) {
            return AlertDialog(
              titlePadding: EdgeInsets.zero, // Remove default padding
              contentPadding: const EdgeInsets.all(5.0), // Adjust content padding
              title: Container(
                padding: const EdgeInsets.all(5.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'No Internet Connection',
                      style: TextStyle(fontSize: 18.0),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () {
                        Navigator.of(context).pop();
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                ),
              ),
              content: const Text(
                'Please check your internet connection and try again.',
                style: TextStyle(fontSize: 16.0),
              ),
            );
          },
        );
      }
    }
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(AppLocalizations.of(context)!.log_in
                ,
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20.0),
              TextFormField(
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please Enter Email';
                  }
                  // Check if the email is in the correct format
                  if (!RegExp(
                      r'\b[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Z|a-z]{2,}\b')
                      .hasMatch(value)) {
                    return 'Invalid email address';
                  }
                  return null;
                },
                onChanged: (value) {
                  setState(() {
                    email = value.trim();
                  });
                },
                controller: emailController,
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!.email,
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10.0),
              TextFormField(
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please Enter Password';
                  }
                  return null;
                },
                onChanged: (value) {
                  setState(() {
                    password = value;
                  });
                },
                controller: passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!.password,
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10.0),
              Container(
                width: 140,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                    color: primaryColor,
                    borderRadius: BorderRadius.circular(30)),
                child: GestureDetector(
                  onTap: signIn,
                  child: Center(
                    child: Text(
                      AppLocalizations.of(context)!.log_in,
                      style: TextStyle(
                        //color: Colors.white,
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10.0),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const ForgotPassword()),
                  );
                },
                child:  Text(AppLocalizations.of(context)!.forgot_Your_Password),
              ),
              const SizedBox(height: 10.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                   Text(AppLocalizations.of(context)!.dont_have_an_account
                    ,
                    style: TextStyle(
                      fontSize: 18.0,//color: Colors.black,
                    ),
                  ),
                  const SizedBox(width: 5.0,),
                  GestureDetector(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>const SignUpPage()));
                    },
                    child: Text(AppLocalizations.of(context)!.create
                      ,
                      style: TextStyle(
                        color: Color(0xFFFF9900),
                        fontSize: 20.0,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
