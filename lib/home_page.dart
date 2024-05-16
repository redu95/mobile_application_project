import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobile_application_project/setting_page.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _selectedIndex = 0;
  late List<Widget> _widgetOptions;

  @override
  void initState() {
    super.initState();
    _widgetOptions = <Widget>[
      HomePage(),
      Text('Search Page'),
      SettingPage(),
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

class HomePage extends StatelessWidget {
  HomePage({super.key});

  final user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          body: Column(children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              const Icon(Icons.menu_rounded, size: 40),
              ClipRRect(
                borderRadius: BorderRadius.circular(22),
                child: const Image(
                  height: 60,
                  width: 60,
                  fit: BoxFit.fill,
                  image: AssetImage('assets/images/icon_imgg/user_im.jpg'),
                ),
              )
            ],
          ),
        ),
        const Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 12),
            child: Text("Where Would You Like To Go?",
                style: TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 30,
                    color: Color(0xff3c4657)))),
        SizedBox(
          height: 20,

        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 320,
                child: TextField(
                  decoration: InputDecoration(
                    hintText: "Search for place",
                    prefixIcon:
                        Icon(Icons.search, size: 35, color: Color(0xff3c4657)),
                    border: OutlineInputBorder(
                        borderSide:
                            BorderSide(width: 2.4, color: Color(0xff3c4657)),
                        borderRadius: BorderRadius.circular(12)),
                    enabledBorder: OutlineInputBorder(
                      borderSide:
                        const BorderSide(width: 2.4,color: Color(0xff3c4657))
                    )
                  ),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xff3c4657),
                  borderRadius: BorderRadius.circular(8),
                ),
                height: 50,
                width: 50,
                child:const  Icon(Icons.filter_alt, size: 35, color: Colors.white),
              ),
            ],
          ),
        ),
            Container(
              height: 70,
              width: double.infinity,

              child:ListView(
                scrollDirection: Axis.horizontal,
                children: [
                Container(
                    height:60,
                    width: 100,
                  margin: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 12),

                  decoration: BoxDecoration(
                    color:Color(0xffF0F1F3),
                    borderRadius: BorderRadius.circular(12),
                  ),
                    child:const Center(
                        child:Text("Hotel", style:TextStyle(fontSize: 26),)
                )
                ),
                  Container(
                      height:60,
                      width: 120,
                      margin: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 12),

                      decoration: BoxDecoration(
                        color:Color(0xffF0F1F3),
                        borderRadius: BorderRadius.circular(12),
                      ),
                    child:const Center(
                  child:Text("Apartment", style:TextStyle(fontSize: 22),)
            )),
                  Container(
                      height:60,
                      width: 100,
                      margin: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 12),

                      decoration: BoxDecoration(
                        color:Color(0xffF0F1F3),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child:const Center(
                          child:Text("Motel", style:TextStyle(fontSize: 22),)
                      )
                  ),
                  Container(
                      height:60,
                      width: 100,
                      margin: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 12),

                      decoration: BoxDecoration(
                        color:Color(0xffF0F1F3),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child:const Center(
                          child:Text("Hotel", style:TextStyle(fontSize: 26),)
                      )
                  ),
                  Container(
                      height:60,
                      width: 120,
                      margin: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 12),

                      decoration: BoxDecoration(
                        color:Color(0xffF0F1F3),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child:const Center(
                          child:Text("Apartment", style:TextStyle(fontSize: 22),)
                      )),
                  Container(
                      height:60,
                      width: 100,
                      margin: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 12),


                      decoration: BoxDecoration(
                        color:Color(0xffF0F1F3),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child:const Center(
                          child:Text("Motel", style:TextStyle(fontSize: 22),)
                      )
                  ),

                ]
                )

              ,
            )
      ]
          )
      ),
    );
  }
}
