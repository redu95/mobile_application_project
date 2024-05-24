// setting_page.dart
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:mobile_application_project/edit_account_page.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';
import 'login_page.dart';
import 'package:mobile_application_project/theme_provider.dart';



class SettingPage extends StatefulWidget {

  const SettingPage({Key? key}) : super(key: key);

  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  bool _isDarkModeEnabled = false;
  late String userName;
  late String bio ="Add your bio";
  String? photoUrl; // Add this variable to hold profile picture URL
  late User user; // Add this variable to hold the authenticated user
  bool isLoading = true; // Track loading state
  TextEditingController userNameController =  TextEditingController();
  TextEditingController emailController =  TextEditingController();
  TextEditingController passwordController = new TextEditingController();

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

  // Method to refresh user data
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

    // if (isLoading) {
    //   // Show loading indicator while data is being loaded
    //   return Scaffold(
    //     body: Center(
    //       child: CircularProgressIndicator(),
    //     ),
    //   );
    // }
    return Scaffold (
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
                loadUserInfo(user.uid); // Reload user info
              },
              icon: Icon(Icons.refresh),
            ),
          ],
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
                      builder: (context) =>  EditAccountPage(
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
                onTap: () {
                  setState(() {
                    _isDarkModeEnabled = !_isDarkModeEnabled; // Toggle the state of _isDarkModeEnabled
                    if (_isDarkModeEnabled) {
                      themeProvider.setThemeMode(ThemeMode.dark); // Set the dark theme
                    } else {
                      themeProvider.setThemeMode(ThemeMode.light); // Set the light theme
                    }
                  });
                },
                trailing: Switch(
                  value: _isDarkModeEnabled,
                  onChanged: (newValue) {
                    setState(() {
                      _isDarkModeEnabled = newValue; // Update the state of _isDarkModeEnabled
                      if (_isDarkModeEnabled) {
                        themeProvider.setThemeMode(ThemeMode.dark); // Set the dark theme
                      } else {
                        themeProvider.setThemeMode(ThemeMode.light); // Set the light theme
                      }
                    });
                  },
                  activeColor: Colors.purple,
                ),
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
                            onPressed: () async {
                              logOut(context); // Log out function
                              await refreshUserData(); // Refresh user data after logout
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
    Widget? trailing, // Added trailing parameter for the switch widget
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          children: [
            CircleAvatar(
              radius: 30,
              backgroundImage: photoUrl != null ? NetworkImage(photoUrl!) : null,
              child: photoUrl == null && icon != null
                  ? Icon(
                icon,
                size: 30,
                color: Colors.white,
              )
                  : null,
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
                value: _isDarkModeEnabled, // Replace true with your dark mode state
                onChanged: (newValue) {
                  setState(() {
                    _isDarkModeEnabled = newValue;
                  });

                }, // Implement dark mode toggling
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
