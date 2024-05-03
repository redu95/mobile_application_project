import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mobile_application_project/signup_page.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  String email = "";
  TextEditingController emailController = new TextEditingController();

  final _formKey = GlobalKey<FormState>();

  resetpassword() async{
    try{
      await FirebaseAuth.instance.sendPasswordResetEmail(email:email);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          backgroundColor: Colors.orangeAccent,
          content: Text(
            'Password Reset Email has been Sent',
            style: TextStyle(fontSize: 18.0),)));
    }on FirebaseAuthException catch (e){
      if(e.code=='user-not-found'){
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            backgroundColor: Colors.orangeAccent,
            content: Text(
              'No User Found for that Email',
              style: TextStyle(fontSize: 18.0),)));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [
          const SizedBox(
            height: 70.0,
          ),
          Container(
              alignment: Alignment.topCenter,
              child:const Text(
                  "Password Recovery",
                  style:TextStyle(
                      color:Colors.white,
                      fontSize:30.0,
                      fontWeight: FontWeight.bold,
                  )
              )
          ),
          const SizedBox(
            height: 10.0,
          ),
          const Text(
              "Enter Your Email",
            style: TextStyle(
              color: Colors.white,
              fontSize:20.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          Expanded(
            key: _formKey,
              child: Form(
                child: Padding(
                  padding: const EdgeInsets.only(left: 10.0),
                  child: ListView(
                    children: [
                      Container(
                        padding: const EdgeInsets.only(left: 10.0),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.white,width: 2.0),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: TextFormField(
                          controller: emailController,
                          style: const TextStyle(
                            color: Colors.white,
                          ),
                          decoration: const InputDecoration(
                            hintText: 'Email',
                            hintStyle: TextStyle(
                              fontSize: 18.0,
                              color: Colors.white
                            ),
                            prefixIcon: Icon(
                              Icons.person,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 40.0,
                      ),
                      GestureDetector(
                        onTap: (){
                          if(_formKey.currentState!.validate()){
                            setState(() {
                              email=emailController.text;
                            });
                          }
                          resetpassword();
                        },
                        child: Container(
                          width: 140,
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10)
                          ),
                          child: const Center(
                            child: Text(
                              "Send Email",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 50.0,),
                       Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Don't Have an Account?",
                            style: TextStyle(
                              fontSize: 18.0,color: Colors.white,
                            ),
                          ),
                          SizedBox(width: 5.0,),
                          GestureDetector(
                            onTap: (){
                              Navigator.push(context, MaterialPageRoute(builder: (context)=>SignUpPage()));
                            },
                            child: Text(
                              "Create",
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
              )
          )
        ],
      ),
    );
  }
}
