import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

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
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.orangeAccent,
          content: Text(
            'Password Reset Email has been Sent',
            style: TextStyle(fontSize: 18.0),)));
    }on FirebaseAuthException catch (e){
      if(e.code=='user-not-found'){
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
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
      body: Container(
        child:  Column(
          children: [
            SizedBox(
              height: 70.0,
            ),
            Container(
                alignment: Alignment.topCenter,
                child:Text(
                    "Password Recovery",
                    style:TextStyle(
                        color:Colors.white,
                        fontSize:30.0,
                        fontWeight: FontWeight.bold,
                    )
                )
            ),
            SizedBox(
              height: 10.0,
            ),
            Text(
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
                    padding: EdgeInsets.only(left: 10.0),
                    child: ListView(
                      children: [
                        Container(
                          padding: EdgeInsets.only(left: 10.0),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.white70,width: 30.0),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: TextFormField(
                            controller: emailController,
                            style: TextStyle(
                              color: Colors.white,
                            ),
                            decoration: InputDecoration(
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
                        SizedBox(
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
                            child: Center(
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
                        )
                      ],
                    ),
                  ),
                )
            )
          ],
        ),
      ),
    );
  }
}
