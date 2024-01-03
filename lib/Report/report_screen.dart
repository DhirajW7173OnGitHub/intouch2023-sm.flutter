import 'package:flutter/material.dart';
import 'package:stock_management/home_screen.dart';
import 'package:stock_management/userProfile/user_profile_screen.dart';
import 'package:stock_management/utils/session_manager.dart';

class ReportScreen extends StatefulWidget {
  const ReportScreen({super.key});

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  int _selectedIndexForBottomBar = 1;
  @override
  void initState() {
    super.initState();
    sessionManager.updateLoggedInTimeAndLoggedStatus();
  }

  _selecctBottomNavigationBar(int index) {
    switch (index) {
      case 0:
        _homeBottomBarIconClick();
        break;
      case 2:
        _personBottomBarIconClick();
        break;
    }
  }

  _homeBottomBarIconClick() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (ctx) => const HomeScreen(),
      ),
    );
  }

  _personBottomBarIconClick() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (ctx) => const UserProfileScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Stock Report'),
      ),
      bottomNavigationBar: BottomNavigationBar(
        onTap: (int index) {
          setState(() {
            _selecctBottomNavigationBar(index);
          });
        },
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        backgroundColor: Colors.white,
        currentIndex: _selectedIndexForBottomBar!,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'Stock Report',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Person',
          ),
        ],
      ),
    );
  }
}
