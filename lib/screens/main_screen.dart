import 'package:flutter/material.dart';
import '/screens/history_screen.dart';
import '/screens/home_screen.dart';
import '/screens/items_screen.dart';
import '/screens/settings_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: TabBarView(
        controller: _tabController,
        children: [
          HomeScreen(),
          ItemsScreen(),
          HistoryScreen(),
          SettingsScreen(),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: Colors.blue[900],
        child: RotatedBox(
          quarterTurns: 1,
          child: Icon(Icons.sync_alt_outlined),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        onTap: (index) {
          if (index == 3) {
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (_) => SettingsScreen()))
                .then((value) => _tabController.index = 0);
          }
          setState(() {
            _tabController.index = index;
          });
        },
        currentIndex: _tabController.index,
        type: BottomNavigationBarType.fixed,
        selectedIconTheme: IconThemeData(color: Colors.blue[900]),
        unselectedIconTheme: IconThemeData(color: Colors.black),
        selectedLabelStyle: TextStyle(color: Colors.blue[900]),
        unselectedLabelStyle: TextStyle(color: Colors.black),
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.shopping_bag_outlined,
            ),
            label: 'Items',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: 'History'),
          BottomNavigationBarItem(
              icon: Icon(Icons.settings_outlined), label: 'Settings'),
        ],
      ),
    );
  }
}
