 // // setting_page.dart
 // import 'dart:io';
 // import 'package:cloud_firestore/cloud_firestore.dart';
 // import 'package:firebase_auth/firebase_auth.dart';
 // import 'package:firebase_storage/firebase_storage.dart';
 // import 'package:flutter/material.dart';
 // import 'package:flutter_locales/flutter_locales.dart';
 // import 'package:ionicons/ionicons.dart';
 // import 'package:mobile_application_project/edit_account_page.dart';
 // import 'package:path/path.dart';
 // import 'package:mobile_application_project/languageMenu.dart';
 //
 // import 'login_page.dart';
 // class SettingPage extends StatefulWidget {
 //
 //   const SettingPage({Key? key}) : super(key: key);
 //
 //   final String userName;
 //   final String email;
 //   final String? photoUrl;
 //
 //   const SettingPage({
 //     Key? key,
 //     required this.userName,
 //     required this.email,
 //     this.photoUrl,
 //   }) : super(key: key);
 //
 //
 //   @override
 //   _SettingPageState createState() => _SettingPageState();
 // }
 //
 // class _SettingPageState extends State<SettingPage> {
 //
 //   late String userName;
 //   late String bio = "Add your bio";
 //   String? photoUrl;
 //   late User user;
 //   bool isLoading = true;
 //   TextEditingController userNameController = TextEditingController();
 //   TextEditingController emailController = TextEditingController();
 //   TextEditingController passwordController = TextEditingController();
 //
 //   bool _switchValue = false;  // Setting initial value of the switch to true (on state)
 //   ThemeData _lightTheme = ThemeData(brightness: Brightness.light, primaryColor: Colors.white); // Theme data for light mode with white as the primary color
 //   ThemeData _darkTheme = ThemeData(brightness: Brightness.dark, primaryColor: Colors.black); // Theme data for dark mode with black as the primary color
 //
 //   String userName ='';
 //   late String email ="Add your email";
 //   String? photoUrl; // Add this variable to hold profile picture URL
 //   late User user; // Add this variable to hold the authenticated user
 //   bool isLoading = true; // Track loading state
 //   TextEditingController userNameController =  TextEditingController();
 //   TextEditingController emailController =  TextEditingController();
 //   TextEditingController passwordController = new TextEditingController();
 //
 //
 //   @override
 //   void initState() {
 //     super.initState();
 //     user = FirebaseAuth.instance.currentUser!;
 //     loadUserInfo(user.uid);
 //   }
 //
 //   Future<void> loadUserInfo(String uid) async {
 //     try {
 //       DocumentSnapshot userDoc =
 //       await FirebaseFirestore.instance.collection('users').doc(uid).get();
 //       if (userDoc.exists) {
 //         setState(() {
 //           userName = userDoc.get('userName');
 //           email = userDoc.get('email') ?? "Add your email";
 //           photoUrl = userDoc.get('photoUrl');
 //           isLoading = false;
 //         });
 //       } else {
 //         setState(() {
 //           isLoading = false;
 //         });
 //         print("Document does not exist");
 //       }
 //     } catch (e) {
 //       print("Error loading user info: $e");
 //       setState(() {
 //         isLoading = false;
 //       });
 //
 //
 //
 //       Future<void> saveUserInfo(
 //           String uid, String name, String email, String? photoUrl) async {
 //         await FirebaseFirestore.instance.collection('users').doc(uid).set({
 //           'name': name,
 //           'email': email,
 //           'photoUrl': photoUrl,
 //         });
 //       }
 //
 //       Future<String> uploadImage(File image) async {
 //         String fileName = basename(image.path);
 //         Reference storageReference =
 //         FirebaseStorage.instance.ref().child('profilePictures/$fileName');
 //         UploadTask uploadTask = storageReference.putFile(image);
 //         TaskSnapshot snapshot = await uploadTask;
 //         return await snapshot.ref.getDownloadURL();
 //       }
 //
 //       Future<void> logOut(BuildContext context) async {
 //         await FirebaseAuth.instance.signOut();
 //         setState(() {
 //           userName = '';
 //           email = '';
 //           photoUrl = null;
 //         });
 //         Navigator.pushReplacement(
 //           context,
 //           MaterialPageRoute(builder: (context) => LogInPage()),
 //         );
 //       }
 //
 //       Future<void> refreshUserData() async {
 //         setState(() {
 //           isLoading = true;
 //         });
 //         await loadUserInfo(user.uid);
 //         setState(() {
 //           isLoading = false;
 //         });
 //       }
 //
 //       @override
 //       Widget build(BuildContext context) {
 //         return MaterialApp(
 //             theme: _switchValue ? _darkTheme : _lightTheme,// Set the theme based on the value of _switchValue
 //             home: Scaffold (
 //               backgroundColor: _switchValue ? Colors.black : Colors.white,// Set the background color based on the value of _switchValue
 //               appBar: AppBar(
 //                 leading: IconButton(
 //                   icon: Icon(Icons.arrow_back),
 //                   onPressed: () {
 //
 //                     Navigator.pop(context);
 //                   },
 //                 ),
 //                 actions: [
 //                   IconButton(
 //                     onPressed: () {
 //                       setState(() {
 //                         isLoading = true;
 //                         });
 //                       loadUserInfo(user.uid); // Reload user info
 //                     },
 //                     icon: Icon(Icons.refresh),
 //                   ),
 //                 ],
 //                 body: SingleChildScrollView(
 //                     padding: EdgeInsets.all(20),
 //                     child: Column(
 //                       crossAxisAlignment: CrossAxisAlignment.start,
 //                       children: [
 //                         LocaleText(
 //                           "Settings",
 //                           style: TextStyle(
 //                             fontSize: 32,
 //                             fontWeight: FontWeight.bold,
 //                           ),
 //                         ),
 //                         SizedBox(height: 30),
 //                         LocaleText(
 //                           "Account",
 //                           style: TextStyle(
 //                             fontSize: 24,
 //                             fontWeight: FontWeight.w500,
 //                           ),
 //                         ),
 //                         buildAccount(
 //                           title: userName,
 //                           subtitle: email,
 //                           image:  NetworkImage('https://static.vecteezy.com/system/resources/previews/004/026/956/non_2x/person-avatar-icon-free-vector.jpg'),
 //                           onTap: () {
 //                             Navigator.push(
 //                               context,
 //                               MaterialPageRoute(
 //                                 builder: (context) =>EditAccountPage(
 //                                 userName: userName,
 //                                 email: email,
 //                                 onSave: (String newName, String newemail, File? newImage, String newGender)async{
 //                                   // Update user information in Firebase
 //                                   await FirebaseFirestore.instance.collection('users').doc(user.uid).update({
 //                                     'userName': newName,
 //                                     'email': newemail,
 //                                     'photoUrl': newImage != null ? await uploadImage(newImage) : null,
 //                                     'gender':newGender,
 //                                   });
 //                                   // Navigate back to SettingPage after saving changes
 //                                   await loadUserInfo(user.uid);
 //                                   Navigator.pop(context);
 //                                 }
 //
 //                                )
 //                               )
 //                             );
 //                           }
 //                         ),
 //                         SizedBox(height: 40),
 //                         LocaleText(
 //                         "Settings",
 //                         style: TextStyle(
 //                         fontSize: 24,
 //                         fontWeight: FontWeight.w500,
 //                         ),
 //                         ),
 //                         SizedBox(height: 20),
 //                         buildSettingItem(
 //                         title: "Bookings",
 //                         icon: Ionicons.calendar,
 //                         onTap: () {},
 //                         ),
 //                         SizedBox(height: 20),
 //                         buildSettingItem(
 //                         title: "Favorites",
 //                         icon: Ionicons.heart,
 //                         onTap: () {},
 //                         ),
 //                         SizedBox(height: 20,),
 //                         const Text(
 //                         "  Appearances",
 //                         style: TextStyle(
 //                         fontSize: 18,
 //                         fontWeight: FontWeight.w300,
 //                         ),
 //                         ),
 //                         SizedBox(height: 20),
 //                         buildSettingItem(
 //                         title: "Language",
 //                         icon: Ionicons.language_outline,
 //                         onTap: () {
 //                         Navigator.push(
 //                         context,
 //                         MaterialPageRoute(builder: (context) => LanguageMenuDemo()),
 //                         );
 //                         },
 //                         ),
 //                         SizedBox(height: 20),
 //                         buildSettingItem(
 //                         title: "Dark Mode",
 //                         icon: Ionicons.moon_outline,
 //                         isDarkMode: true,
 //                         onTap: () {},
 //                         ),
 //                         SizedBox(height: 20),
 //                         const Text(
 //                         "  Help and Support",
 //                         style: TextStyle(
 //                         fontSize: 18,
 //                         fontWeight: FontWeight.w300,
 //                         ),
 //                         ),
 //                         SizedBox(height: 20),
 //                         buildSettingItem(
 //                         title: "Help",
 //                         icon: Ionicons.help_outline,
 //                         onTap: () {},
 //                         ),
 //                         SizedBox(height: 20),
 //                         buildSettingItem(
 //                         title: "Privacy",
 //                         icon: Ionicons.shield,
 //                         onTap: () {},
 //                         ),
 //                         SizedBox(height: 20),
 //                         buildSettingItem(
 //                         title: "Log Out",
 //                         icon: Ionicons.log_out_outline,
 //                         onTap: () {
 //                         // Show an alert dialog to confirm logout
 //                         showDialog(
 //                         context: context,
 //                         builder: (BuildContext context) {
 //                         return AlertDialog(
 //                         title: LocaleText("Log Out"),
 //                         content: LocaleText("Do you really want to log out?"),
 //                         actions: [
 //                         TextButton(
 //                         onPressed: () {
 //                         Navigator.of(context).pop(); // Close the dialog
 //                         },
 //                         child: LocaleText("Cancel"),
 //                         ),
 //                         TextButton(
 //                         onPressed: () async {
 //                         logOut(context); // Log out function
 //                         await refreshUserData(); // Refresh user data after logout
 //                         },
 //                         child: LocaleText("Log Out"),
 //                         ),
 //                         ],
 //                         );
 //                         },
 //                         );
 //                         },// on tap
 //                         ),
 //                         ],
 //                         ),
 //                         ),
 //                         ),
 //                         );
 //                       }
 //
 //
 //
 //
 //
 //
 //
 //       Widget buildAccount({
 //         required String title,
 //         required VoidCallback onTap,
 //         String? subtitle,
 //         ImageProvider? image,
 //       }) {
 //         return InkWell(
 //           onTap: onTap,
 //           child: Padding(
 //             padding: const EdgeInsets.symmetric(vertical: 12),
 //             child: Row(
 //               children: [
 //                 CircleAvatar(
 //                   radius: 30,
 //                   backgroundImage: photoUrl != null ? NetworkImage(photoUrl!) : NetworkImage('https://static.vecteezy.com/system/resources/previews/004/026/956/non_2x/person-avatar-icon-free-vector.jpg'),
 //                 ),
 //                 SizedBox(width: 20),
 //                 Column(
 //                   crossAxisAlignment: CrossAxisAlignment.start,
 //                   children: [
 //                     Text(
 //                       title,
 //                       style: TextStyle(
 //                         fontSize: 18,
 //                         fontWeight: FontWeight.w500,
 //                       ),
 //                     ),
 //                     if (subtitle != null) SizedBox(height: 4),
 //                     if (subtitle != null)
 //                       Text(
 //                         subtitle,
 //                         style: TextStyle(
 //                           fontSize: 14,
 //                           color: Colors.grey,
 //                         ),
 //                       ),
 //                   ],
 //                 ),
 //                 Spacer(),
 //                 const Icon(
 //                   Icons.settings,
 //                   size: 30,
 //                   color: Colors.purple,
 //                 )
 //               ],
 //             ),
 //           ),
 //         );
 //       }
 //
 //
 //       Widget buildSettingItem({
 //         required String title,
 //         IconData? icon,
 //         required VoidCallback onTap,
 //         String? subtitle,
 //         ImageProvider? image,
 //         bool isDarkMode = false,
 //       }) {
 //         return InkWell(
 //           onTap: onTap,
 //           child: Padding(
 //             padding: const EdgeInsets.symmetric(vertical: 10),
 //             child: Row(
 //               children: [
 //                 CircleAvatar(
 //                   radius: 30,
 //                   backgroundColor: Colors.purple.shade50,
 //                   backgroundImage: photoUrl != null ? NetworkImage(photoUrl!) : null,
 //                   child: photoUrl == null && icon != null
 //                       ? Icon(
 //                     icon,
 //                     size: 30,
 //                     color: Colors.deepPurple,
 //                   )
 //                       : null,
 //                 ),
 //                 SizedBox(width: 20),
 //                 Expanded(
 //                   child: Column(
 //                     crossAxisAlignment: CrossAxisAlignment.start,
 //                     children: [
 //                       LocaleText(
 //                         title,
 //                         style: TextStyle(
 //                           fontSize: 18,
 //                           fontWeight: FontWeight.w500,
 //                         ),
 //                       ),
 //                       if (subtitle != null) SizedBox(height: 4),
 //                       if (subtitle != null)
 //                         LocaleText(
 //                           subtitle,
 //                           style: TextStyle(
 //                             fontSize: 14,
 //                             color: Colors.grey,
 //                           ),
 //                         ),
 //                     ],
 //                   ),
 //                 ),
 //                 if (isDarkMode)
 //                   Switch(
 //                     value: _switchValue, // Replace true with your dark mode state
 //                     onChanged: (newValue) {
 //                       setState(() {
 //                         _switchValue = newValue; // Update the value of _switchValue with the new value
 //                       });
 //                     },
 //                     activeColor: Colors.purple,
 //                   )
 //                 else
 //                   const Icon(
 //                     Icons.chevron_left,
 //                     size: 30,
 //                     color: Colors.purple,
 //                   ),
 //               ],
 //             ),
 //           ),
 //         );
 //       }
 //     }

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
  bool _switchValue = false;  // Setting initial value of the switch to true (on state)
  ThemeData _lightTheme = ThemeData(brightness: Brightness.light, primaryColor: Colors.white); // Theme data for light mode with white as the primary color
  ThemeData _darkTheme = ThemeData(brightness: Brightness.dark, primaryColor: Colors.black); // Theme data for dark mode with black as the primary color

  String userName ='';
  late String email ="Add your email";
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

  // Function to log out
  Future<void> logOut(BuildContext context) async {
    // Sign out user
    await FirebaseAuth.instance.signOut();

    // Clear user data
    setState(() {
      userName = '';
      email = '';
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
    return MaterialApp(
      theme: _switchValue ? _darkTheme : _lightTheme,// Set the theme based on the value of _switchValue
      home: Scaffold (
        backgroundColor: _switchValue ? Colors.black : Colors.white,// Set the background color based on the value of _switchValue
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
              const LocaleText(
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
              buildAccount(
                title: userName,
                subtitle: email,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>EditAccountPage(
                      userName: userName,
                      email: email,
                        onSave: (String newName, String newEmail, File? newImage, String newGender) async {
                          try {
                            // Update user information in Firebase Firestore
                            await FirebaseFirestore.instance.collection('users').doc(user.uid).update({
                              'userName': newName,
                              'email': newEmail,
                              if (newImage != null) 'photoUrl': await uploadImage(newImage),
                              'gender': newGender,
                            });

                            // Reload user info after saving changes
                            await loadUserInfo(user.uid);

                            // Navigate back to SettingPage
                            Navigator.pop(context);
                          } catch (e) {
                            print("Error updating user info: $e");
                            // Handle error
                          }
                        },


                      )
                    )
                  );
                }
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
                title: "Bookings",
                icon: Ionicons.calendar,
                onTap: () {},
              ),
              SizedBox(height: 20),
              buildSettingItem(
                title: "Favorites",
                icon: Ionicons.heart,
                onTap: () {},
              ),
              SizedBox(height: 20,),
              const Text(
                "  Appearances",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w300,
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
                title: "Dark Mode",
                icon: Ionicons.moon_outline,
                isDarkMode: true,
                onTap: () {},
              ),
              SizedBox(height: 20),
              const Text(
                "  Help and Support",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w300,
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
                title: "Privacy",
                icon: Ionicons.shield,
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
                        title: LocaleText("Log Out"),
                        content: LocaleText("Do you really want to log out?"),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop(); // Close the dialog
                            },
                            child: LocaleText("Cancel"),
                          ),
                          TextButton(
                            onPressed: () async {
                              logOut(context); // Log out function
                              await refreshUserData(); // Refresh user data after logout
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
              backgroundImage: photoUrl != null ? NetworkImage(photoUrl!) : NetworkImage('https://static.vecteezy.com/system/resources/previews/004/026/956/non_2x/person-avatar-icon-free-vector.jpg'),
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
            const Icon(
              Icons.settings,
              size: 30,
              color: Colors.purple,
            )
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
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          children: [
            CircleAvatar(
              radius: 30,
              backgroundColor: Colors.purple.shade50,
              backgroundImage: photoUrl != null ? NetworkImage(photoUrl!) : null,
              child: photoUrl == null && icon != null
                  ? Icon(
                icon,
                size: 30,
                color: Colors.deepPurple,
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
                value: _switchValue, // Replace true with your dark mode state
                onChanged: (newValue) {
                  setState(() {
                    _switchValue = newValue; // Update the value of _switchValue with the new value
                  });
                  },
                activeColor: Colors.purple,
              )
            else
              const Icon(
                Icons.chevron_left,
                size: 30,
                color: Colors.purple,
            )
          ],
        ),
      ),
    );
  }
}
