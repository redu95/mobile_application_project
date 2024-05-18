import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:ionicons/ionicons.dart';
import 'package:mobile_application_project/edit_account_page.dart';
import 'package:path/path.dart';
import 'package:mobile_application_project/languageMenu.dart';

import 'login_page.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({Key? key}) : super(key: key);

  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  late String userName;
  late String bio = "Add your bio";
  String? photoUrl;
  late User user;
  bool isLoading = true;
  TextEditingController userNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    user = FirebaseAuth.instance.currentUser!;
    loadUserInfo(user.uid);
  }

  Future<void> loadUserInfo(String uid) async {
    try {
      DocumentSnapshot userDoc =
      await FirebaseFirestore.instance.collection('users').doc(uid).get();
      if (userDoc.exists) {
        setState(() {
          userName = userDoc.get('userName');
          bio = userDoc.get('bio') ?? "Add your bio";
          photoUrl = userDoc.get('photoUrl');
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
        print("Document does not exist");
      }
    } catch (e) {
      print("Error loading user info: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> saveUserInfo(String uid, String name, String bio, String? photoUrl) async {
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

  Future<void> logOut(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    setState(() {
      userName = '';
      bio = '';
      photoUrl = null;
    });
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LogInPage()),
    );
  }

  Future<void> refreshUserData() async {
    setState(() {
      isLoading = true;
    });
    await loadUserInfo(user.uid);
    setState(() {
      isLoading = false;
    });
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
              setState(() {
                isLoading = true;
              });
              loadUserInfo(user.uid);
            },
            icon: Icon(Icons.refresh),
          ),
        ],
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            LocaleText(
              "Settings",
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 30),
            LocaleText(
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
                      image: null,
                      onSave: (String newName, String newBio, File? newImage) async {
                        String? newPhotoUrl = photoUrl;
                        if (newImage != null) {
                          newPhotoUrl = await uploadImage(newImage);
                        }
                        await saveUserInfo(user.uid, newName, newBio, newPhotoUrl);
                        refreshUserData();
                      },
                    ),
                  ),
                );
              },
            ),
            SizedBox(height: 40),
            LocaleText(
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
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LanguageMenuDemo()),
                );
              },
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
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: LocaleText("Log Out"),
                      content: LocaleText("Do you really want to log out?"),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: LocaleText("Cancel"),
                        ),
                        TextButton(
                          onPressed: () async {
                            await logOut(context);
                          },
                          child: LocaleText("Log Out"),
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
            CircleAvatar(
              radius: 30,
              backgroundImage: image,
              child: image == null && icon != null
                  ? Icon(
                icon,
                size: 30,
                color: Colors.white,
              )
                  : null,
            ),
            SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  LocaleText(
                    title,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  if (subtitle != null) SizedBox(height: 4),
                  if (subtitle != null)
                    LocaleText(
                      subtitle,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                ],
              ),
            ),
            if (isDarkMode)
              Switch(
                value: false,
                onChanged: (value) {},
                activeColor: Colors.purple,
              )
            else
              Icon(
                Icons.chevron_right,
                size: 30,
                color: Colors.purple,
              ),
          ],
        ),
      ),
    );
  }
}
