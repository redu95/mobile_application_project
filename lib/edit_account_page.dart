//edit_account_page

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';


class EditAccountPage extends StatefulWidget {
  final String userName;
  final String bio;
  final File? image;
  final void Function(String newName, String newBio, File? newImage) onSave;

  const EditAccountPage({
    Key? key,
    required this.userName,
    required this.bio,
    required this.onSave, this.image,
  }) : super(key: key);

  @override
  _EditAccountPageState createState() => _EditAccountPageState();
}

class _EditAccountPageState extends State<EditAccountPage> {
  String selectedGender = '';
  late String userName;
  late String bio;
  late File? _image;
  TextEditingController usernameController = TextEditingController();
  TextEditingController _bioController = TextEditingController();
  bool changesSaved = false;

  final picker = ImagePicker();

  Future getImage() async {
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
  void initState() {
    super.initState();
    userName = widget.userName;
    bio = widget.bio;
    usernameController.text = userName;
    _bioController.text = bio;
    _image = widget.image;
  }

  void _showAlertDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Changes Saved'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
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
        actions: [
          IconButton(
            onPressed: () {
              widget.onSave(
                usernameController.text,
                _bioController.text,
                _image,
              );
              Navigator.pop(context);
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
                getImage();
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
                      child: widget.image != null
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
            Text(
              'Username',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: usernameController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Change your username',
              ),
              onChanged: (value) {
                setState(() {
                  userName = value;
                });
              },
            ),
            SizedBox(height: 30),
            Text(
              'Bio (max 30 characters)',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            TextField(
              maxLength: 30,
              controller: _bioController,
              onChanged: (value) {
                setState(() {
                  bio = value;
                });
              },
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Write a short bio',
              ),
            ),
            SizedBox(height: 20),
            Text(
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
