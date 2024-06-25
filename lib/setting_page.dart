import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:path/path.dart';
import 'package:mobile_application_project/edit_account_page.dart';
import 'package:mobile_application_project/l10n/l10n.dart';
import 'package:mobile_application_project/languageMenu.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:mobile_application_project/languagerelatedclass/language_constants.dart';
import 'package:provider/provider.dart';
import 'colors.dart';
import 'home_page.dart';
import 'login_page.dart';
import 'package:mobile_application_project/theme_provider.dart';
import 'package:mobile_application_project/help.dart';
import 'package:mobile_application_project/Privacy.dart';

import 'my_bookings.dart';
import 'my_favorites.dart';

class SettingPage extends StatefulWidget {
  final String userName;
  final String email;
  final String? photoUrl;

  const SettingPage({
    Key? key,
    required this.userName,
    required this.email,
    this.photoUrl,
  }) : super(key: key);

  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  bool _isDarkModeEnabled = true;
  String userName = '';
  late String email = "";

  String? photoUrl;
  late User user;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    user = FirebaseAuth.instance.currentUser!;
    loadUserInfo(user.uid);
    //_isDarkModeEnabled = Provider.of<ThemeSettings>(context as BuildContext, listen: false).isDarkModeEnabled;
  }

  Future<void> loadUserInfo(String uid) async {
    try {
      DocumentSnapshot userDoc =
      await FirebaseFirestore.instance.collection('users').doc(uid).get();
      if (userDoc.exists) {
        setState(() {
          userName = userDoc.get('userName');
          email = userDoc.get('email') ?? "Add your email";
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

  Future<void> saveUserInfo(
      String uid, String name, String email, String? photoUrl) async {
    await FirebaseFirestore.instance.collection('users').doc(uid).set({
      'name': name,
      'email': email,
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
      email = '';
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
    final themeProvider = Provider.of<ThemeSettings>(context); // Access the theme provider

    return Scaffold(
      backgroundColor: themeProvider.isDarkModeEnabled ? Colors.black : Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => Home()), // Navigate to your bookings page
            );
          },
        ),
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                isLoading = true;
              });
              loadUserInfo(user.uid); // Reload user info
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
                  Text(
                    AppLocalizations.of(context)!.settings ?? '',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 30),
                  Text(
                    AppLocalizations.of(context)!.account ?? '',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  buildAccount(
                    title: userName,
                    subtitle: email,
                    image: NetworkImage(photoUrl ??
                        'https://static.vecteezy.com/system/resources/previews/004/026/956/non_2x/person-avatar-icon-free-vector.jpg'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EditAccountPage(
                            userName: userName,
                            email: email,
                            onSave: (String newName, String newEmail,
                                File? newImage, String newGender) async {
                              try {
                                await FirebaseFirestore.instance
                                    .collection('users')
                                    .doc(user.uid)
                                    .update({
                                  'userName': newName,
                                  'email': newEmail,
                                  if (newImage != null)
                                    'photoUrl': await uploadImage(newImage),
                                  'gender': newGender,
                                });
                                await loadUserInfo(user.uid);
                                Navigator.pop(context);
                              } catch (e) {
                                print("Error updating user info: $e");
                              }
                            },
                          ),
                        ),
                      );
                    },
                  ),
                  SizedBox(height: 40),
                  Text(
                    AppLocalizations.of(context)!.settings ?? '',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 30),
                  ListTile( // Bookings
                    leading: CircleAvatar(
                      radius: 30,
                      backgroundColor: accentColorShade,
                      child: Icon(
                        Ionicons.calendar,
                        size: 30,
                        color: primaryColor,
                      ),
                    ),
                    onTap: (){
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MyBookingsPage(),
                        ),
                      );
                    },
                    title: Text(
                      AppLocalizations.of(context)!.bookings ?? '',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  ListTile( // Favorites
                    leading: CircleAvatar(
                      radius: 30,
                      backgroundColor: accentColorShade,
                      child: Icon(
                        Ionicons.heart,
                        size: 30,
                        color: primaryColor,
                      ),
                    ),
                    onTap: (){
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MyFavorites(),
                        ),
                      );
                    },
                    title: Text(
                      AppLocalizations.of(context)!.favorites ?? '',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    AppLocalizations.of(context)!.appearances ?? '',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                  SizedBox(height: 30),
                  ListTile(
                    leading: CircleAvatar(
                      radius: 30,
                      backgroundColor: accentColorShade,
                      child: Icon(
                        Ionicons.language_outline,
                        size: 30,
                        color: primaryColor,
                      ),
                    ),
                    title: Text(
                      AppLocalizations.of(context)!.language ?? '',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const LanguageMenuDemo()),
                      );
                    },
                  ),
                  SizedBox(height: 20),
                  ListTile( // Dark Mode
                    leading: CircleAvatar(
                      radius: 30,
                      backgroundColor: accentColorShade,
                      child: Icon(
                        Ionicons.moon_outline,
                        size: 30,
                        color: primaryColor,
                      ),
                    ),
                    title: Text(
                      AppLocalizations.of(context)!.dark_mode ?? '',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    trailing: Switch(
                      value: themeProvider.isDarkModeEnabled,
                      onChanged: (value) {
                        themeProvider.setThemeMode(value, user.uid);
                      },
                      activeColor: accentColor,
                    ),
                  ),
                  SizedBox(height: 30),
                  Text(
                    AppLocalizations.of(context)!.help_and_support ?? '',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                  SizedBox(height: 30),
                  ListTile(
                    leading: CircleAvatar(
                      radius: 30,
                      backgroundColor: accentColorShade,
                      child: Icon(
                        Ionicons.help,
                        size: 30,
                        color: primaryColor,
                      ),
                    ),
                    title: Text(
                      AppLocalizations.of(context)!.help ?? '',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    onTap: () {
                        {
                          Navigator.push(
                            context, MaterialPageRoute(builder: (context) => const HelpDemo()),//redirect to help page
                          );
                        };
                     },
                  ),
                  SizedBox(height: 20),
                  ListTile(
                    leading: CircleAvatar(
                      radius: 30,
                      backgroundColor: accentColorShade,
                      child: Icon(
                        Ionicons.shield,
                        size: 30,
                        color: primaryColor,
                      ),
                    ),
                    title: Text(
                      AppLocalizations.of(context)!.privacy ?? '',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    onTap: () {
                      {
                        Navigator.push(
                          context, MaterialPageRoute(builder: (context) => const PrivacyDemo()),//redirect to help page
                        );
                      };
                    },
                  ),
                  SizedBox(height: 20),
                  ListTile(
                    leading: CircleAvatar(
                      radius: 30,
                      backgroundColor: accentColorShade,
                      child: Icon(
                        Ionicons.log_out_outline,
                        size: 30,
                        color: primaryColor,
                      ),
                    ),
                    title: Text(
                      AppLocalizations.of(context)!.log_out ?? '',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text(
                                AppLocalizations.of(context)!.log_out ?? ''),
                            content: Text("Do you really want to log out?"),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child:
                                Text(AppLocalizations.of(context)!.cancel ??
                                    ''),
                              ),
                              TextButton(
                                onPressed: () async {
                                  await logOut(context);
                                  await refreshUserData();
                                },
                                child: Text(
                                    AppLocalizations.of(context)!.log_out ??
                                        "Log Out"),
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

  Widget buildAccount({
    required String title,
    required VoidCallback onTap,
    String? subtitle,
    ImageProvider? image,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          children: [
            CircleAvatar(
              radius: 30,
              backgroundImage: photoUrl != null
                  ? NetworkImage(photoUrl!)
                  : NetworkImage(
                  'https://static.vecteezy.com/system/resources/previews/004/026/956/non_2x/person-avatar-icon-free-vector.jpg'),
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
             Icon(
              Icons.settings,
              size: 30,
              color: primaryColor,
            )
          ],
        ),
      ),
    );
  }
}
