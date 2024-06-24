import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:mobile_application_project/colors.dart';
import 'package:mobile_application_project/home_page.dart';
import 'package:mobile_application_project/login_page.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  String email = "", password = "", userName = "";
  TextEditingController userNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  bool passwordConfirmed() {
    return passwordController.text.trim() == confirmPasswordController.text.trim();
  }

  void registration() async {
    // Check for internet connection
    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      // Show a dialog indicating no internet connection
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(
              'No Internet Connection',
              style: TextStyle(fontSize: 18.0),
            ),
            content: Text(
              'Please check your internet connection and try again.',
              style: TextStyle(fontSize: 16.0),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
      return; // Exit the registration method
    }

    // Show progress indicator while registering
    showDialog(
      context: context,
      builder: (context) {
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );

    if (_formKey.currentState!.validate()) {
      try {
        if (passwordConfirmed()) {
          final UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
            email: emailController.text.trim(),
            password: passwordController.text.trim(),
          );

          await FirebaseFirestore.instance.collection('users').doc(userCredential.user!.uid).set({
            'userName': userNameController.text.trim(),
            'email': emailController.text.trim(),
            'isDarkModeEnabled': false,
            'photoUrl': null,
          });

          Navigator.pop(context); // Dismiss the progress indicator

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                AppLocalizations.of(context)!.registered_Successfully ?? '',
                style: const TextStyle(fontSize: 20.0),
              ),
            ),
          );

          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Home()),
          );
        }
      } on FirebaseAuthException catch (e) {
        String errorMessage;
        if (e.code == 'weak-password') {
          errorMessage = 'weak_password';
        } else if (e.code == 'email-already-in-use') {
          errorMessage = 'email_already_in_use';
        } else {
          errorMessage = 'error_creating_account';
        }
        Navigator.pop(context); // Dismiss the progress indicator
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.orangeAccent,
            content: Text(
              errorMessage,
              style: const TextStyle(fontSize: 18.0),
            ),
          ),
        );
      } catch (e) {
        Navigator.pop(context); // Dismiss the progress indicator
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.orangeAccent,
            content: Text(
              AppLocalizations.of(context)!.error_Creating_Account ?? '',
              style: const TextStyle(fontSize: 18.0),
            ),
          ),
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
      body:SingleChildScrollView(
      child:Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                AppLocalizations.of(context)!.sign_Up ?? '',
                style: const TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 30),
              TextFormField(
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return AppLocalizations.of(context)!.please_Enter_User_Name ?? '';
                  }
                  return null;
                },
                controller: userNameController,
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!.please_Enter_User_Name ?? '',
                  border: const OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10.0),
              TextFormField(
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return AppLocalizations.of(context)!.please_Enter_Email_Address ?? '';
                  }
                  if (!RegExp(r'\b[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Z|a-z]{2,}\b').hasMatch(value)) {
                    return Locales.string(context, 'invalid_email');
                  }
                  return null;
                },
                controller: emailController,
                obscureText: false,
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!.please_Enter_Email_Address ?? '',
                  border: const OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10.0),
              TextFormField(
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return AppLocalizations.of(context)!.please_Enter_Password ?? '';
                  }
                  return null;
                },
                controller: passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!.please_Enter_Password ?? '',
                  border: const OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10.0),
              TextFormField(
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return AppLocalizations.of(context)!.please_Confirm_Password ?? '';
                  }
                  return null;
                },
                controller: confirmPasswordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!.please_Confirm_Password ?? '',
                  border: const OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10.0),
              Container(
                width: 140,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: primaryColor,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: GestureDetector(
                  onTap: registration,
                  child: Center(
                    child: Text(
                      AppLocalizations.of(context)!.sign_Up ?? '',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    AppLocalizations.of(context)!.already_have_an_account ?? '',
                    style: TextStyle(
                      fontSize: 18.0,
                      //color: Colors.black,
                    ),
                  ),
                  SizedBox(width: 5.0),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => LogInPage()));
                    },
                    child: Text(
                      AppLocalizations.of(context)!.log_in ?? '',
                      style: TextStyle(
                        color: accentColor,
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
      )
    );
  }
}