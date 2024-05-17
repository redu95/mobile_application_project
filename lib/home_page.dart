import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobile_application_project/screens/menu-screen.dart';
import 'package:mobile_application_project/setting_page.dart';
import 'package:flutter/gestures.dart';

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
      const HomePage(),
      const Text('Search Page'),
      const SettingPage(),
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

enum MenuSelection {
  menu1,
  menu2,
  menu3,
  menu4,
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  MenuSelection? selectedOne;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
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
              padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: 320,
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: "Search for place",
                        prefixIcon: Icon(
                          Icons.search,
                          size: 35,
                          color: const Color(0xff3c4657),
                        ),
                        border: OutlineInputBorder(
                          borderSide: const BorderSide(width: 2.4, color: Color(0xff3c4657)),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(width: 2.4, color: Color(0xff3c4657)),
                        ),
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
                    child: const Icon(Icons.filter_alt, size: 35, color: Colors.white),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 70,
              width: double.infinity,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  InkWell(
                    onTap: () {
                      setState(() {
                        selectedOne = MenuSelection.menu1;
                      });
                    },
                    child: Menu_screen(
                      "Hotel",
                      selectedOne == MenuSelection.menu1
                          ? const Color(0xff3C4635)
                          : const Color(0xffF0F1F3),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      setState(() {
                        selectedOne = MenuSelection.menu2;
                      });
                    },
                    child: Menu_screen(
                      "Apartment",
                      selectedOne == MenuSelection.menu2
                          ? const Color(0xff3C4635)
                          : const Color(0xffF0F1F3),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      setState(() {
                        selectedOne = MenuSelection.menu3;
                      });
                    },
                    child: Menu_screen(
                      "Hostel",
                      selectedOne == MenuSelection.menu3
                          ? const Color(0xff3C4635)
                          : const Color(0xffF0F1F3),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      setState(() {
                        selectedOne = MenuSelection.menu4;
                      });
                    },
                    child: Menu_screen(
                      "Motel",
                      selectedOne == MenuSelection.menu4
                          ? const Color(0xff3C4635)
                          : const Color(0xffF0F1F3),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Menu_screen extends StatelessWidget {
  final String title;
  final Color color;

  const Menu_screen(this.title, this.color, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8.0),
      width: 100,
      height: 50,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Center(
        child: Text(
          title,
          style: const TextStyle(
            color: Color(0xff3c4657),
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}