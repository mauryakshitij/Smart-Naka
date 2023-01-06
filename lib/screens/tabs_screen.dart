import 'package:flutter/material.dart';
import 'package:smart_naka/screens/search_screen.dart';

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
          title: const Text('Smart Naka'),
          actions: [
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.logout_rounded),
            )
          ],
        ),
        body: [SearchPage()][selectedIndex],
        bottomNavigationBar: NavigationBar(
          animationDuration: const Duration(seconds: 1),
          backgroundColor: const Color(0xFFFDFDFD),
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.search_rounded),
              label: 'Search',
            ),
            NavigationDestination(
              icon: Icon(Icons.star_outline_rounded),
              label: 'Starred',
            ),
            NavigationDestination(
              icon: Icon(Icons.history_rounded),
              label: 'History',
            ),
            // NavigationDestination(
            //   icon: Icon(Icons.person_outline_rounded),
            //   label: 'Profile',
            // )
          ],
          selectedIndex: selectedIndex,
          onDestinationSelected: _onItemTapped,
        ));
  }
}
