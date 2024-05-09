
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobile_application_project/home_page.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  String email = "",password = "",name = "";
  TextEditingController nameController = new TextEditingController();
  TextEditingController emailController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();

  final _formKey = GlobalKey<FormState>();

  registration() async {
    if (_formKey.currentState!.validate()) {
      try {
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
            email: emailController.text,
            password: passwordController.text);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Registered Successfully',
              style: TextStyle(fontSize: 20.0),
            )));
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => Home()));
      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            backgroundColor: Colors.orangeAccent,
            content: Text(
              'Password provided is too weak',
              style: TextStyle(fontSize: 18.0),
            ),
          ));
        } else if (e.code == 'email-already-in-use') {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            backgroundColor: Colors.orangeAccent,
            content: Text(
              'Account already exists',
              style: TextStyle(fontSize: 18.0),
            ),
          ));
        }
      }
    }
  }



  @override
  Widget build(BuildContext context) {
    return  Scaffold(
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
              const Text(
                'Sign Up',
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 50),
              ElevatedButton(
                onPressed: () {
                  // Add Google login functionality here
                },
                child:  const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                     //Image.asset(
                       //'assets/Icons/google-logo.svg',
                       //height: 2.0,
                       //width: 2.0,
                     //),
                    SizedBox(width: 10.0),
                    Text('Sign Up with Google'),
                  ],
                ),
              ),
              SizedBox(height: 70),
              const Text('Enter your Name',
              ),
              TextFormField(
                validator: (value){
                  if(value ==null||value.isEmpty){
                    return 'Please Enter Name';
                  }
                  return null;
                },
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Name',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10.0),
              const Text('Enter your Email'),
              TextFormField(
                validator: (value){
                  if(value ==null||value.isEmpty){
                    return 'Please Enter Email';
                  }
                  return null;
                },
                controller: emailController,
                obscureText: false,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10.0),
              const Text('Enter your Password'),
              TextFormField(
                validator: (value){
                  if(value ==null||value.isEmpty){
                    return 'Please Enter Password';
                  }
                  return null;
                },
                controller: passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10.0),
              GestureDetector(
                onTap: (){
                  if(_formKey.currentState!.validate()){
                    setState(() {
                      email=emailController.text;
                      name = nameController.text;
                      password = passwordController.text;
                    });
                  }
                  registration();
                },
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Sign Up')
                  ],
                ),
              ),
              const SizedBox(height: 20.0),
            ],
          ),
        ),
      ),
    );
  }
}
