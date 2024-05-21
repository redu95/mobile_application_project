import 'package:flutter/material.dart';

import 'homeScreen.dart';
import 'home_page.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  MenuSelection selectedOne = MenuSelection.menu1;
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        title: Text(
            'Explore',
          style: TextStyle(
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Row(
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
            Container(
              height: 40,
              width: double.infinity,
              margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 7),
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
          ],
        ),
      ),
    );
  }
}
