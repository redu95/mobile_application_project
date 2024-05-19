//edit_account_page

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';


class EditAccountPage extends StatefulWidget {
  final String userName;
  final String email;
  final File? image;
  final void Function(String newName, String newemail, File? newImage,String newGender) onSave;

  const EditAccountPage({
    Key? key,
    required this.userName,
    required this.email,
    required this.onSave,
    this.image,
  }) : super(key: key);

  @override
  _EditAccountPageState createState() => _EditAccountPageState();
}

class _EditAccountPageState extends State<EditAccountPage> {
  String selectedGender ='' ;
  late String userName;
  late String email;
  late File? _image;
  TextEditingController usernameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  bool changesSaved = false;

  final picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    userName = widget.userName;
    email = widget.email;
    usernameController.text = userName;
    _emailController.text = email;
    _image = widget.image;
  }



  Future<void> _showConfirmationDialog(BuildContext context) async {
    await showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Save Changes'),
          content: Text('Do you want to save changes?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Dismiss the dialog
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                // Call onSave function to save changes
                widget.onSave(userName, email, _image, selectedGender);
                // Simulate a delay for a more natural loading effect
                await Future.delayed(Duration(seconds: 1));

                // Navigate back after the delay
                Navigator.pop(context);


              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }


  // Method to update the selected image and show preview
  Future<void> _getImageAndPreview() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }


  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          // Show confirmation dialog when back button is pressed
          await _showConfirmationDialog(context);
          // Return false to prevent default back navigation behavior
          return false;
        },
        child: Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            actions: [
              IconButton(
                onPressed: () async {
                  // Show confirmation dialog before saving changes
                  await _showConfirmationDialog(context);
                },
                icon: Icon(Icons.check),
              ),
            ],
          ),
          body: SingleChildScrollView(
            padding: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Account",
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  "Change Profile Picture",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 20),
                GestureDetector(
                  onTap: () {
                    _getImageAndPreview(); // Call method to select image and show preview
                  },
                  child: Center(
                    child: Stack(
                      children: [
                        Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.grey, width: 2),
                          ),
                          child: _image != null
                              ? CircleAvatar(
                            backgroundImage: FileImage(_image!),
                          )
                              : widget.image != null
                              ? CircleAvatar(
                            backgroundImage: FileImage(widget.image!),
                          )
                              : Icon(
                                  Icons.person,
                                  size: 80,
                                  color: Colors.purple,
                                ),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: CircleAvatar(
                            backgroundColor: Colors.purple.shade500,
                            radius: 18,
                            child: Icon(Icons.camera_alt, color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 30),
                const Text(
                  'Username',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10),
                TextField(
                  controller: usernameController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Change your Username',
                  ),
                  onChanged: (value) {
                    setState(() {
                      userName = value;
                    });
                  },
                ),
                SizedBox(height: 30),
                Text(
                  'Email',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10),
                TextField(
                  maxLength: 30,
                  controller: _emailController,
                  onChanged: (value) {
                    setState(() {
                      email = value;
                    });
                  },
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 20),
                const Text(
                  'Gender',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10),
                Row(
                  children: [
                    buildGenderButton('Male'),
                    SizedBox(width: 10),
                    buildGenderButton('Female'),
                  ],
                ),
              ],
            ),
          ),
        )
    );

  }

  Widget buildGenderButton(String gender) {
    return ElevatedButton(
      onPressed: () {
        setState(() {
          selectedGender = gender;
        });
      },
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(
          selectedGender == gender ? Colors.purple : Colors.grey,
        ),
      ),
      child: Text(
        gender,
        style: TextStyle(color: Colors.white),
      ),
    );
  }
}
