import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:smart_naka/screens/history_screen.dart';
import 'package:smart_naka/screens/search_screen.dart';
import 'package:smart_naka/screens/starred_screen.dart';

import 'account_info.dart';

class TabsScreen extends StatefulWidget {
  const TabsScreen({Key? key}) : super(key: key);

  @override
  State<TabsScreen> createState() => _TabsScreenState();
}

class _TabsScreenState extends State<TabsScreen> {
  int selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AccountInfo()),
                );
              },
              icon: const Icon(Icons.account_circle_rounded)),
          title: const Text('Smart Naka'),
          centerTitle: true,
        ),
        body: const [
          SearchPage(),
          StarredScreen(),
          HistoryScreen()
        ][selectedIndex],
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                blurRadius: 20,
                color: Colors.black.withOpacity(.1),
              )
            ],
          ),
          child: SafeArea(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
              child: GNav(
                  selectedIndex: selectedIndex,
                  onTabChange: _onItemTapped,
                  tabBackgroundGradient: LinearGradient(
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                    colors: [Colors.lightBlue[100]!, Colors.cyan],
                  ),
                  gap: 8,
                  tabBorderRadius: 15,
                  color: Colors.grey[600],
                  activeColor: Colors.white,
                  iconSize: 24,
                  textStyle: const TextStyle(fontSize: 14, color: Colors.white),
                  tabBackgroundColor: Colors.grey[800]!,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16.5),
                  duration: const Duration(milliseconds: 500),
                  tabs: const [
                    GButton(
                      icon: Icons.search_rounded,
                      text: 'Search',
                      iconColor: Colors.black87,
                    ),
                    GButton(
                      icon: Icons.star_outline_rounded,
                      text: 'Starred',
                      iconColor: Colors.black87,
                    ),
                    GButton(
                      icon: Icons.history_rounded,
                      text: 'History',
                      iconColor: Colors.black87,
                    )
                  ]),
            ),
          ),
        ));
  }
}
