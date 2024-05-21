import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:mobile_application_project/home_page.dart';
import 'package:mobile_application_project/login_page.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

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

  registration() async {
    showDialog(
      context: context,
      builder: (context) {
        return const Center(
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
            'bio': '',
            'photoUrl': null,
            'gender': '',
          });

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: LocaleText(
                'registered_successfully',
                style: TextStyle(fontSize: 20.0),
              ),
            ),
          );

          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const Home()),
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
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.orangeAccent,
            content: LocaleText(
              errorMessage,
              style: const TextStyle(fontSize: 18.0),
            ),
          ),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.orangeAccent,
            content: LocaleText(
              'error_creating_account',
              style: TextStyle(fontSize: 18.0),
            ),
          ),
        );
      }
    }
    Navigator.pop(context);
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
              const LocaleText(
                'sign_up',
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 30),
              TextFormField(
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return Locales.string(context, 'please_enter_username');
                  }
                  return null;
                },
                controller: userNameController,
                decoration: InputDecoration(
                  labelText: Locales.string(context, 'please_enter_username'),
                  border: const OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10.0),
              TextFormField(
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return Locales.string(context, 'please_enter_email');
                  }
                  if (!RegExp(r'\b[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Z|a-z]{2,}\b').hasMatch(value)) {
                    return Locales.string(context, 'invalid_email');
                  }
                  return null;
                },
                controller: emailController,
                obscureText: false,
                decoration: InputDecoration(
                  labelText: Locales.string(context, 'please_enter_email'),
                  border: const OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10.0),
              TextFormField(
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return Locales.string(context, 'please_enter_password');
                  }
                  return null;
                },
                controller: passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: Locales.string(context, 'please_enter_password'),
                  border: const OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10.0),
              TextFormField(
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return Locales.string(context, 'please_confirm_password');
                  }
                  return null;
                },
                controller: confirmPasswordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: Locales.string(context, 'please_confirm_password'),
                  border: const OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10.0),
              Container(
                width: 140,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                    color: Colors.deepPurpleAccent,
                    borderRadius: BorderRadius.circular(30)),
                child: GestureDetector(
                  onTap: registration,
                  child: const Center(
                    child: LocaleText(
                      'sign_up',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Already have an Account?",
                    style: TextStyle(
                      fontSize: 18.0,color: Colors.black,
                    ),
                  ),
                  const SizedBox(width: 5.0,),
                  GestureDetector(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>const LogInPage()));
                    },
                    child: const Text(
                      "Login",
                      style: TextStyle(
                        color: Colors.deepPurpleAccent,
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