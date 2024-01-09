import 'dart:developer';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stock_management/Database/bloc.dart';
import 'package:stock_management/Database/storage_utils.dart';
import 'package:stock_management/Report/report_screen.dart';
import 'package:stock_management/Scanner/details_scanner.dart';
import 'package:stock_management/StockList/stock_list_screen.dart';
import 'package:stock_management/globalFile/global_style_editor.dart';
import 'package:stock_management/model/menu_list_model.dart';
import 'package:stock_management/model/user_login_data_model.dart';
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

  User? user;

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

  _selectedIconScreen(int index) {
    switch (index) {
      case 1:
        CommonCall.personIconCall(context);
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
        settings: const RouteSettings(arguments: {'userSelectedIndex': 0}),
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

  _showDialogForPhoto() {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          child: Container(
            width: 200,
            height: 400,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              // boxShadow: const [
              //   BoxShadow(
              //     color: Colors.grey,
              //     blurRadius: 5,
              //     offset: Offset(0, 2),
              //   ),
              // ],
            ),
            child: Image.asset(
              'assets/icon/user.jpeg',
              fit: BoxFit.cover,
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[500], // Color.fromARGB(255, 26, 78, 247),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(250),
        child: SizedBox(
          width: double.infinity,
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
                              GestureDetector(
                                onTap: _showDialogForPhoto,
                                child: ClipRRect(
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(35),
                                  ),
                                  child: Container(
                                    height: 70,
                                    width: 70,
                                    decoration: const BoxDecoration(
                                      image: DecorationImage(
                                          image: AssetImage(
                                              'assets/icon/user.jpeg'),
                                          fit: BoxFit.cover),
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
                                        const Color.fromARGB(255, 243, 23, 7),
                                  ),
                                ),
                              ),
                            ],
                          )
                        : Stack(
                            children: [
                              GestureDetector(
                                onTap: _showDialogForPhoto,
                                child: ClipRRect(
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
        selectedItemColor: CommonColor.BOTTOM_SELECT_COLOR,
        unselectedItemColor: CommonColor.BOTTOM_UNSELECT_COLOR,
        backgroundColor: Colors.white,
        currentIndex: _selectedIndex,
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: CommonColor.CONTAINER_COLOR,
                borderRadius: BorderRadius.only(
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
                  return TweenAnimationBuilder(
                    duration: const Duration(seconds: 1),
                    tween: Tween<double>(begin: 0, end: 1),
                    builder: (context, double value, Widget? child) {
                      return Opacity(
                        opacity: value,
                        child: Padding(
                          padding: EdgeInsets.only(top: value * 20),
                          child: child,
                        ),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: 20.0, right: 20, top: 40, bottom: 8),
                      child: GridView.count(
                        crossAxisCount: 2,
                        childAspectRatio: 12 / 9,
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

                          return Card(
                            shadowColor: Colors.grey[900],
                            elevation: 12,
                            child: Container(
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
                                  _menuNavigator(
                                      _menuList[index].id.toString());
                                },
                                splashColor: splashColor,
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      height: 50,
                                      width: 50,
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                          image:
                                              AssetImage(imageName.toString()),
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
                            ),
                          );
                        }),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
      // extendBody: true,
    );
  }
}
