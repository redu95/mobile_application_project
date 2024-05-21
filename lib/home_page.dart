
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:mobile_application_project/setting_page.dart';
import 'package:mobile_application_project/homeScreen.dart';
import 'package:mobile_application_project/data_home.dart';
import 'package:mobile_application_project/detail_screen.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

enum MenuSelection {
  menu1,
  menu2,
  menu3,
  menu4,
}

class _HomeState extends State<Home> {
  final User user = FirebaseAuth.instance.currentUser!;
  int _selectedIndex = 0;
  late List<Widget> _widgetOptions;

  @override
  void initState() {
    super.initState();
    _widgetOptions = <Widget>[
      const HomePage(),
      Container( // Wrapping Text widget inside Container
        alignment: Alignment.center,
        child: const Text('Search Page'),
      ),
      SettingPage(
        userName: user.displayName ?? '',
        email: user.email ?? 'Add your email',
        photoUrl: user.photoURL,
      ),
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.purple,
        onTap: _onItemTapped,
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});



  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  MenuSelection selectedOne = MenuSelection.menu1;
  DataHome object=DataHome();

  String userName ='';
  String email ="";
  String? photoUrl; // Add this variable to hold profile picture URL
  late User user; // Add this variable to hold the authenticated user
  bool isLoading = true; // Track loading state

  @override
  // initializing the states
  void initState() {
    super.initState();
    user = FirebaseAuth.instance.currentUser!;
    loadUserInfo(user.uid);
  }

  //
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

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(scaffoldBackgroundColor: const Color(0xffF8FCFF),primaryColor:const Color(0xffF8FCFF) ),
      home: Scaffold(
        body:SafeArea(
          child:SingleChildScrollView(
        child:Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 2,
                vertical: 15,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  // const Icon(Icons.menu_rounded, size: 40,color: Colors.purple,),
                  CircleAvatar(
                    radius: 30,
                    backgroundImage: photoUrl != null ? NetworkImage(photoUrl!) : const NetworkImage('https://static.vecteezy.com/system/resources/previews/004/026/956/non_2x/person-avatar-icon-free-vector.jpg'),
                  ),
                  const Icon(
                    Ionicons.location,
                    size: 30,
                    color: Colors.purple,
                  ),
                  const Text(
                    "Addis Abeba Ethiopia",
                    style: TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 18,
                      color: Colors.purpleAccent,
                    ),
                  ),
                  const Icon(
                    Ionicons.notifications,
                    size: 30,
                    color: Colors.purple,
                  ),
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 2, vertical: 5),
              child: Text(
                "Where Would You Like To Go?",
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 30,
                  color: Color(0xff3c4657),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 2,
                vertical: 12,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: 320,
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: "Search for place",
                        prefixIcon: const Icon(
                          Icons.search,
                          size: 35,
                          color: Color(0xff3c4657),
                        ),
                        border: OutlineInputBorder(
                          borderSide: const BorderSide(
                              width: 2.4,
                              color: Colors.purple),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        enabledBorder: const OutlineInputBorder(
                          borderSide: BorderSide(
                              width: 2.4, color: Color(0xff3c4657)),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.purple,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    height: 50,
                    width: 50,
                    child: const Icon(
                        Icons.filter_alt, size: 35, color: Colors.white),
                  ),
                ],
              ),
            ),
            Container(
              height: 70,
              width: double.infinity,
              margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  InkWell(
                    onTap: () {
                      setState(() {
                        selectedOne = MenuSelection.menu1;
                      });
                    },
                    child: MenuScreen(
                      "Dining",
                      selectedOne == MenuSelection.menu1
                          ? Colors.purple : const Color(0xffF0F1F3),
                      selectedOne == MenuSelection.menu1
                          ? Colors.white: Colors.grey,
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      setState(() {
                        selectedOne = MenuSelection.menu2;
                      });
                    },
                    child: MenuScreen(
                      "Accommodations",
                      selectedOne == MenuSelection.menu2
                          ? Colors.purple : const Color(0xffF0F1F3),
                      selectedOne == MenuSelection.menu2
                          ? Colors.white: Colors.grey,
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      setState(() {
                        selectedOne = MenuSelection.menu3;
                      });
                    },
                    child: MenuScreen(
                      "Room Servicel",
                      selectedOne == MenuSelection.menu3
                          ? Colors.purple : const Color(0xffF0F1F3),
                      selectedOne == MenuSelection.menu3
                          ? Colors.white: Colors.grey,
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      setState(() {
                        selectedOne = MenuSelection.menu4;
                      });
                    },
                    child: MenuScreen(
                      "Accommodations",
                      selectedOne == MenuSelection.menu4
                          ? Colors.purple : const Color(0xffF0F1F3),
                      selectedOne == MenuSelection.menu4
                          ? Colors.white: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
      const SizedBox(
            height:15
      ),
      Container(
        margin:const EdgeInsets.symmetric(horizontal:4,vertical:12),
        height: 270,
        width: double.infinity,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: object.getData.length,
          itemBuilder: (context, index){
            return InkWell(
              onTap: (){
                Navigator.push(context,MaterialPageRoute(builder: (context)=> Detail(
                    object.getData[index].imageurl,
                    object.getData[index].name,
                    object.getData[index].location)
                )
                );
              },
              child: Container(height: 200,
                margin:const EdgeInsets.symmetric(horizontal:8),
                width: 250,
                decoration: BoxDecoration(
                  borderRadius:BorderRadius.circular(12),
                  image: DecorationImage(
                      image: AssetImage(
                          object.getData[index].imageurl),


                      fit:BoxFit.cover),

                ),
                child: Stack(
                  children: [
                    Positioned(
                      right: 0,
                      child: IconButton(
                        onPressed: (){},
                        icon:const Icon(Icons.favorite_border,color: Colors.purple,),
                      ),

                    ),
                    Positioned(
                        bottom:10,
                        left:10,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              object.getData[index].name,
                              style: const TextStyle(
                                  fontSize:
                                  22,color:Colors.white ,
                                  fontWeight:FontWeight.w600),
                            ),
                            const SizedBox(height: 8,),
                            Row(
                              children: [
                                const Icon(Icons.location_on,
                                  size:30,
                                  color: Colors.white,),
                                Text(
                                  object.getData[index].location,
                                  style: const TextStyle(
                                      fontSize: 22,
                                      color:Colors.white,
                                      fontWeight:FontWeight.w600
                                  )
                                  ,
                                )

                              ],
                            )
                          ],
                        )
                    )

                  ],
                ),


              ),
            );

          },
        ),),
            const Padding(padding: EdgeInsets.only(left:12.0 ,top: 12),
            child:Text("Popular Hotels",style: TextStyle(
                fontSize: 24,
            color:Color(0xff3c4657),
            fontWeight:FontWeight.w500,),
           )),
            const SizedBox(height: 10,),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 8,vertical: 12),
              height: 220,
              width: double.infinity,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: object.getAnotherData.length,
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: (){
                      Navigator.push(context,MaterialPageRoute(builder: (context)=> Detail(
                          object.getAnotherData[index].imageurl,
                          object.getAnotherData[index].name,
                          object.getAnotherData[index].location)
                      )
                      );
                    },
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      height: 220,
                      width: 200,
                      decoration: BoxDecoration(
                          image:DecorationImage(image:AssetImage(object.getAnotherData[index].imageurl)
                          ,fit:BoxFit.cover),
                          borderRadius:BorderRadius.circular(12)
                      ),
                      child: Stack(children: [
                        Positioned(
                            bottom:10,
                            left:10,
                    
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  object.getAnotherData[index].name,
                                  style: const TextStyle(
                                      fontSize:22
                                      ,color:Colors.white ,
                                      fontWeight:FontWeight.w600),
                                ),
                                const SizedBox(height: 8,),
                                Row(
                                  children: [
                                    const Icon(Icons.location_on,
                                      size:30,
                                      color: Colors.white,),
                                    Text(
                                      object.getAnotherData[index].location,
                                      style: const TextStyle(
                                          fontSize: 18,
                                          color:Colors.white,
                                          fontWeight:FontWeight.w600
                                      )
                                      ,
                                    )
                    
                                  ],
                                )
                              ],
                            )
                        )
                      ],),
                    
                    ),
                  );
                },
              ),
            ),
           const  SizedBox(height: 20,)

          ],
        ),
      ),

    )));

  }
}
