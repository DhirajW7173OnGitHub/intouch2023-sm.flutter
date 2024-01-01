import 'dart:developer';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stock_management/Database/bloc.dart';
import 'package:stock_management/Database/storage_utils.dart';
import 'package:stock_management/Report/report_screen.dart';
import 'package:stock_management/Scanner/details_scanner.dart';
import 'package:stock_management/StockList/stock_list_screen.dart';
import 'package:stock_management/model/menu_list_model.dart';
import 'package:stock_management/userProfile/user_profile_screen.dart';
import 'package:stock_management/utils/local_storage.dart';
import 'package:stock_management/utils/session_manager.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() {
    return _HomeScreenState();
  }
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  List<MenuData> _menuList = [];

  var connectivityResult = ConnectivityResult.none;
  Future<void> checkConnectivity() async {
    connectivityResult = await Connectivity().checkConnectivity();
  }

  @override
  void initState() {
    super.initState();
    log('GetInstance : ${StorageUtil.getString(localStorageKey.ID!.toString())} ');

    sessionManager.updateLoggedInTimeAndLoggedStatus();

    globalBloc
        .getMenuListData(StorageUtil.getString(localStorageKey.ID!.toString()));
  }

  _profileIconClick() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const UserProfileScreen(),
      ),
    );
  }

  _selectedIconScreen(int index) {
    switch (index) {
      case 1:
        _profileIconClick();
        break;
    }
  }

  _organizationMenuClicked() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const ScannerDetailsScreen(),
      ),
    );
  }

  _listOfStockMenu() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const StackListScreen(),
      ),
    );
  }

  _repotsMenu() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const ReportScreen(),
      ),
    );
  }

  _menuNavigator(String menuId) {
    switch (menuId) {
      case "1":
        _organizationMenuClicked();
        break;
      case "2":
        _listOfStockMenu();
        break;

      case "3":
        _repotsMenu();
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[500], // Color.fromARGB(255, 26, 78, 247),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(250),
        child: Container(
          width: double.infinity,
          // decoration: const BoxDecoration(
          // gradient: LinearGradient(
          //   begin: Alignment.topLeft,
          //   colors: [
          //     Color.fromARGB(255, 3, 95, 170),
          //     Color.fromARGB(255, 33, 150, 243),
          //   ],
          // ),
          // /    ),
          child: Padding(
            padding: const EdgeInsets.only(top: 80, left: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Dashboard',
                  style: GoogleFonts.adamina(
                    textStyle: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                Row(
                  children: [
                    (connectivityResult == ConnectivityResult.mobile ||
                            connectivityResult == ConnectivityResult.wifi)
                        ? Stack(
                            children: [
                              ClipRRect(
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(35),
                                ),
                                child: Container(
                                  height: 70,
                                  width: 70,
                                  decoration: const BoxDecoration(
                                    image: DecorationImage(
                                        image:
                                            AssetImage('assets/icon/user.jpeg'),
                                        fit: BoxFit.cover),
                                  ),
                                ),
                              ),
                              Positioned(
                                top: 0,
                                right: 0,
                                child: ClipRRect(
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(35),
                                  ),
                                  child: Container(
                                    width: 16,
                                    height: 16,
                                    color:
                                        const Color.fromARGB(255, 243, 23, 7),
                                  ),
                                ),
                              ),
                            ],
                          )
                        : Stack(
                            children: [
                              ClipRRect(
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(35),
                                ),
                                child: Container(
                                  height: 70,
                                  width: 70,
                                  decoration: const BoxDecoration(
                                    image: DecorationImage(
                                      image:
                                          AssetImage('assets/icon/user.jpeg'),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                top: 0,
                                right: 0,
                                child: ClipRRect(
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(35),
                                  ),
                                  child: Container(
                                    width: 16,
                                    height: 16,
                                    color:
                                        const Color.fromARGB(255, 6, 238, 13),
                                  ),
                                ),
                              ),
                            ],
                          ),
                    const SizedBox(
                      width: 10,
                    ),
                    Text(
                      StorageUtil.getString(localStorageKey.NAME!),
                      style: GoogleFonts.adamina(
                        textStyle: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        onTap: (int index) {
          setState(() {
            _selectedIconScreen(index);
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.person,
            ),
            label: 'profile',
          ),
        ],
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey[600],
        backgroundColor: Colors.white,
        currentIndex: _selectedIndex,
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: StreamBuilder<MenuModel>(
                  stream: globalBloc.getMenuListForUser.stream,
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Container();
                    }
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }

                    _menuList = snapshot.data?.menu ?? [];
                    return Padding(
                      padding: const EdgeInsets.only(
                          left: 20.0, right: 20, top: 40, bottom: 8),
                      child: GridView.count(
                        crossAxisCount: 2,
                        childAspectRatio: 20 / 15,
                        mainAxisSpacing: 40,
                        crossAxisSpacing: 40,
                        children: List.generate(_menuList.length, (index) {
                          String? imageName = "assets/icon/organization.png";
                          Color splashColor = Colors.blue.withAlpha(30);
                          String menuTitle = _menuList[index].menuTitle!;

                          if (_menuList[index].id! == "1") {
                            imageName = "assets/icon/organization.png";
                          } else if (_menuList[index].id! == "2") {
                            imageName = "assets/icon/menu.png";
                          } else if (_menuList[index].id! == "3") {
                            imageName = "assets/icon/report.png";
                          }

                          return Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(color: Colors.black),
                              borderRadius: const BorderRadius.all(
                                Radius.circular(8),
                              ),
                            ),
                            child: InkWell(
                              onTap: () {
                                _menuNavigator(_menuList[index].id.toString());
                              },
                              splashColor: splashColor,
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    height: 80,
                                    width: 80,
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                        image: AssetImage(imageName.toString()),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  Align(
                                    alignment: Alignment.center,
                                    child: SizedBox(
                                      width: 150,
                                      child: Text(
                                        menuTitle,
                                        maxLines: 3,
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                          fontSize: 14.0,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.black,
                                          // fontWeight: FontWeight.bold
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }),
                      ),
                    );
                  }),
            ),
          ),
        ],
      ),
    );
  }
}
