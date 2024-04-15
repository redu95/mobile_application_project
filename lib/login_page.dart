//import 'dart:js_interop';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:mobile_application_project/home_page.dart';

import 'forgot_password.dart';



class LogInPage extends StatefulWidget {
  const LogInPage({super.key});

  @override
  State<LogInPage> createState() => _LogInPageState();
}

class _LogInPageState extends State<LogInPage> {

  String email = "",password = "";
  TextEditingController emailController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();

  final _formKey = GlobalKey<FormState>();

  userLogin() async{
    try{
      // Logging the email and password before signing in
      print('Email: $email');
      print('Password: $password');
      //
      await FirebaseAuth.instance.signInWithEmailAndPassword(email:email,password: password);
      Navigator.push(context, MaterialPageRoute(builder: (context)=>Home()));
    }on FirebaseAuthException catch (e){
      if(e.code == 'user-not-found'){
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            backgroundColor: Colors.orangeAccent,
            content: Text(
              'No User Found for that Email',
              style: TextStyle(fontSize: 18.0),)));
      }
      else if(e.code=='wrong-password'){
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            backgroundColor: Colors.orangeAccent,
            content: Text(
              'Wrong Password Provided by the user',
              style: TextStyle(fontSize: 18.0),)));
      }

    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Login',
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: () {
                  // Add Google login functionality here
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Image.asset(
                    //   'assets/Icons/google-logo.png',
                    //   height: 20.0,
                    //   width: 20.0,
                    // ),
                    SizedBox(width: 10.0),
                    Text('Login with Google'),
                  ],
                ),
              ),
              SizedBox(height: 30.0),
              TextFormField(
                validator: (value){
                  if(value ==null || value.isEmpty){
                    return 'Please Enter Email';
                  }
                  // Check if the email is in the correct format
                  if (!RegExp(r'\b[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Z|a-z]{2,}\b').hasMatch(value)) {
                    return 'Invalid email address';
                  }
                  return null;
                },
                controller: emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 10.0),
              TextFormField(
                validator: (value){
                  if(value ==null||value.isEmpty){
                    return 'Please Enter Password';
                  }
                  return null;
                },
                controller: passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 10.0),
              GestureDetector(
                onTap: (){
                  if(_formKey.currentState!.validate()){
                    setState(() {
                      email=emailController.text;
                      password = passwordController.text;
                    });
                    userLogin();
                  }
                },
                child:const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Log In')
                  ],
                ),
              ),
              SizedBox(height: 10.0),
              GestureDetector(
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context)=> ForgotPassword()));
                },
                child:Text('Forgot Your Password?'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


