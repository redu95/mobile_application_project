// setting_page.dart
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:mobile_application_project/edit_account_page.dart';
import 'package:path/path.dart';

import 'login_page.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({Key? key}) : super(key: key);

  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  String userName = '';
  String bio = '';
  String? photoUrl; // Add this variable to hold profile picture URL
  late User user; // Add this variable to hold the authenticated user

  @override
  void initState() {
    super.initState();
    user = FirebaseAuth.instance.currentUser!;
    loadUserInfo(user.uid);
  }
  Future<void> loadUserInfo(String uid) async {
    DocumentSnapshot userDoc =
    await FirebaseFirestore.instance.collection('users').doc(uid).get();
    setState(() {
      userName = userDoc['name'];
      bio = userDoc['bio'];
      photoUrl = userDoc['photoUrl'];
    });
  }

  Future<void> saveUserInfo(
      String uid, String name, String bio, String? photoUrl) async {
    await FirebaseFirestore.instance.collection('users').doc(uid).set({
      'name': name,
      'bio': bio,
      'photoUrl': photoUrl,
    });
  }

  Future<String> uploadImage(File image) async {
    String fileName = basename(image.path);
    Reference storageReference =
    FirebaseStorage.instance.ref().child('profilePictures/$fileName');
    UploadTask uploadTask = storageReference.putFile(image);
    TaskSnapshot snapshot = await uploadTask;
    return await snapshot.ref.getDownloadURL();
  }

  // Function to log out
  Future<void> logOut(BuildContext context) async {
    // Sign out user
    await FirebaseAuth.instance.signOut();

    // Clear user data
    setState(() {
      userName = '';
      bio = '';
      photoUrl = null;
    });

    // Navigate back to login page
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LogInPage()),
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
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Settings",
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 30),
            Text(
              "Account",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w500,
              ),
            ),
            buildSettingItem(
              title: userName,
              subtitle: bio,
              icon: photoUrl != null ? null : Icons.person,
              image: photoUrl != null ? NetworkImage(photoUrl!) : null,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EditAccountPage(
                      userName: userName,
                      bio: bio,
                      image: null, // Pass null for now, update it with actual image when implemented
                      onSave: (String newName, String newBio, File? newImage) async {
                        // Update user information in Firebase
                         await FirebaseFirestore.instance.collection('users').doc(user.uid).update({
                           'name': newName,
                           'bio': newBio,
                           'photoUrl': newImage != null ? await uploadImage(newImage) : null,
                         });
                      },
                    ),
                  ),
                );
              },
            ),
            SizedBox(height: 40),
            const Text(
              "Settings",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 20),
            buildSettingItem(
              title: "Language",
              icon: Ionicons.language_outline,
              onTap: () {},
            ),
            SizedBox(height: 20),
            buildSettingItem(
              title: "Notifications",
              icon: Ionicons.notifications_outline,
              onTap: () {},
            ),
            SizedBox(height: 20),
            buildSettingItem(
              title: "Dark Mode",
              icon: Ionicons.moon_outline,
              isDarkMode: true,
              onTap: () {},
            ),
            SizedBox(height: 20),
            buildSettingItem(
              title: "Help",
              icon: Ionicons.help_outline,
              onTap: () {},
            ),
            SizedBox(height: 20),
            buildSettingItem(
              title: "Log Out",
              icon: Ionicons.log_out_outline,
              onTap: () {
                // Show an alert dialog to confirm logout
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text("Log Out"),
                      content: Text("Do you really want to log out?"),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop(); // Close the dialog
                          },
                          child: Text("Cancel"),
                        ),
                        TextButton(
                          onPressed: () {
                            logOut(context); // Log out function
                          },
                          child: Text("Log Out"),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget buildSettingItem({
    required String title,
    IconData? icon,
    required VoidCallback onTap,
    String? subtitle,
    ImageProvider? image,
    bool isDarkMode = false,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          children: [
            if (image != null)
              CircleAvatar(
                radius: 30,
                backgroundImage: image,
              ),
            if (image == null && icon != null)
              Icon(
                icon,
                size: 30,
                color: Colors.purple,
              ),
            SizedBox(width: 20),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                if (subtitle != null) SizedBox(height: 4),
                if (subtitle != null)
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
              ],
            ),
            Spacer(),
            if (isDarkMode)
              Switch(
                value: false, // Replace true with your dark mode state
                onChanged: (value) {}, // Implement dark mode toggling
                activeColor: Colors.purple,
              )
            else
              const Icon(
                Icons.chevron_right,
                size: 30,
                color: Colors.purple,
            )
          ],
        ),
      ),
    );
  }
}
