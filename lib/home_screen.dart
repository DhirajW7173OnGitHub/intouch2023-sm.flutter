import 'dart:convert';
import 'dart:developer';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stock_management/Database/bloc.dart';
import 'package:stock_management/Database/storage_utils.dart';
import 'package:stock_management/Report/report_screen.dart';
import 'package:stock_management/Scanner/details_scanner.dart';
import 'package:stock_management/StockList/stock_list_screen.dart';
import 'package:stock_management/globalFile/global_style_editor.dart';
import 'package:stock_management/login_screen.dart';
import 'package:stock_management/model/menu_list_model.dart';
import 'package:stock_management/model/user_login_data_model.dart';
import 'package:stock_management/splash_screen.dart';
import 'package:stock_management/userProfile/Model/user_profile_details_model.dart';
import 'package:stock_management/userProfile/change_password_screen.dart';
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

    globalBloc.doFetchUserProfileDetails(
      userId: StorageUtil.getString(localStorageKey.ID!.toString()),
    );

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

  _showDialogForPhoto(String base64ImageData) {
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
            child: Image.memory(
              base64Decode(base64ImageData.split(',').last),
              fit: BoxFit.cover,
            ),
          ),
        );
      },
    );
  }

  Widget? userPhotoAndName() {
    setState(() {
      checkConnectivity();
    });
    return Row(
      children: [
        StreamBuilder<UserProfileDetailsModel>(
          stream: globalBloc.getUserProfileDetails.stream,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            if (!snapshot.hasData ||
                snapshot.data!.users.profileImage.isEmpty ||
                snapshot.data!.users.profileImage == "") {
              return (connectivityResult == ConnectivityResult.mobile ||
                      connectivityResult == ConnectivityResult.wifi)
                  ? Stack(
                      children: [
                        ClipRRect(
                          borderRadius: const BorderRadius.all(
                            Radius.circular(40),
                          ),
                          child: Container(
                            height: 80,
                            width: 80,
                            decoration: const BoxDecoration(
                              image: DecorationImage(
                                  image: AssetImage('assets/icon/user.jpeg'),
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
                              color: Colors.green,
                            ),
                          ),
                        ),
                      ],
                    )
                  : Stack(
                      children: [
                        ClipRRect(
                          borderRadius: const BorderRadius.all(
                            Radius.circular(40),
                          ),
                          child: Container(
                            height: 80,
                            width: 80,
                            decoration: const BoxDecoration(
                              image: DecorationImage(
                                  image: AssetImage('assets/icon/user.jpeg'),
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
                              color: Colors.red,
                            ),
                          ),
                        ),
                      ],
                    );
            } else {
              final base64Image = snapshot.data!.users.profileImage;
              return GestureDetector(
                onTap: () {
                  _showDialogForPhoto(base64Image);
                },
                child: (connectivityResult == ConnectivityResult.mobile ||
                        connectivityResult == ConnectivityResult.wifi)
                    ? Stack(
                        children: [
                          ClipRRect(
                            borderRadius: const BorderRadius.all(
                              Radius.circular(40),
                            ),
                            child: Container(
                              height: 80,
                              width: 80,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                              ),
                              child: Image.memory(
                                base64Decode(base64Image.split(",").last),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Positioned(
                            right: 0,
                            top: 0,
                            child: ClipRRect(
                              borderRadius: const BorderRadius.all(
                                Radius.circular(
                                  35,
                                ),
                              ),
                              child: Container(
                                height: 16,
                                width: 16,
                                padding: EdgeInsets.all(2),
                                color: Colors.green,
                              ),
                            ),
                          ),
                        ],
                      )
                    : Stack(
                        children: [
                          ClipRRect(
                            borderRadius: const BorderRadius.all(
                              Radius.circular(40),
                            ),
                            child: Container(
                              height: 80,
                              width: 80,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                              ),
                              child: Image.memory(
                                base64Decode(base64Image.split(",").last),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Positioned(
                            right: 0,
                            top: 0,
                            child: ClipRRect(
                              borderRadius: const BorderRadius.all(
                                Radius.circular(
                                  35,
                                ),
                              ),
                              child: Container(
                                height: 16,
                                width: 16,
                                padding: const EdgeInsets.all(2),
                                color: Colors.red,
                              ),
                            ),
                          ),
                        ],
                      ),
              );
            }
          },
        ),
        const SizedBox(
          width: 10,
        ),
        Text(
          "${StorageUtil.getString(localStorageKey.NAME!)} ( ${StorageUtil.getString(localStorageKey.ID!.toString())} )",
          style: GoogleFonts.adamina(
            textStyle: const TextStyle(
              color: Colors.white,
              fontSize: 24,
            ),
          ),
        ),
      ],
    );
  }

  Future<bool> _clickOnLogOut() async {
    return (await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            //  title: const Text('Are you sure?'),
            content: Text(
              'Do you want to Logout from the App',
              style: Theme.of(context)
                  .textTheme
                  .bodyLarge!
                  .copyWith(color: Colors.black),
            ),
            actions: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    child: const Text('No'),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      //  / await StorageUtil.putString(localStorageKey.ISLOGGEDIN!, "");

                      var sharedPreference =
                          await SharedPreferences.getInstance();

                      sharedPreference.setBool(KEYLOGIN, false);

                      Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(
                              builder: (context) => const LoginScreen()),
                          (Route<dynamic> route) => false);
                    },
                    child: const Text('Yes'),
                  ),
                ],
              ),
            ],
          ),
        )) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red, // Color.fromARGB(255, 26, 78, 247),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(250),
        child: AppBar(
          // backgroundColor: Colors.transparent,
          elevation: 8,
          title: Text(
            'Dashboard',
            style: GoogleFonts.adamina(
              textStyle: const TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ),
          flexibleSpace: SizedBox(
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.only(top: 80, left: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 30,
                  ),
                  userPhotoAndName()!,
                ],
              ),
            ),
          ),
        ),
      ),
      drawer: Drawer(
        // Add your drawer content here
        child: Column(
          children: [
            Container(
              color: Colors.red,
              height: 250,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: const Icon(
                            Icons.arrow_back_ios,
                            color: Colors.white,
                          )),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      _drawerBar()!,
                    ],
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Text(
                    "${StorageUtil.getString(localStorageKey.NAME!)} ( ${StorageUtil.getString(localStorageKey.ID!.toString())} )",
                    style: GoogleFonts.adamina(
                      textStyle: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    ),
                  ),
                  Text(
                    "${StorageUtil.getString(localStorageKey.EMAIL!)}",
                    style: GoogleFonts.adamina(
                      textStyle: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const UserProfileScreen(),
                  ),
                );
              },
              child: ListTile(
                leading: const Icon(
                  Icons.person_2_outlined,
                ),
                title: Text(
                  'Account',
                  style: GoogleFonts.adamina(),
                ),
              ),
            ),
            // InkWell(
            //   onTap: () {
            //     Navigator.pop(context);
            //   },
            //   child: ListTile(
            //     leading: const Icon(
            //       Icons.home,
            //     ),
            //     title: Text(
            //       'Home',
            //       style: GoogleFonts.adamina(),
            //     ),
            //   ),
            // ),
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ChangePasswordScreen(),
                  ),
                );
              },
              child: ListTile(
                leading: const Icon(Icons.lock_reset_sharp),
                title: Text(
                  'Change Password',
                  style: GoogleFonts.adamina(),
                ),
              ),
            ),
            InkWell(
              onTap: () {
                Navigator.pop(context);
                _clickOnLogOut();
              },
              child: ListTile(
                leading: const Icon(Icons.logout_outlined),
                title: Text(
                  'Log Out',
                  style: GoogleFonts.adamina(),
                ),
              ),
            ),
          ],
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
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(35),
                  topRight: Radius.circular(35),
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
                          Color splashColor = Colors.red.withAlpha(30);
                          String menuTitle = _menuList[index].menuTitle!;

                          if (_menuList[index].id! == "1") {
                            imageName = "assets/icon/organization.png";
                          } else if (_menuList[index].id! == "2") {
                            imageName = "assets/icon/report.png";
                          } else if (_menuList[index].id! == "3") {
                            imageName = "assets/icon/menu.png";
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

  Widget? _drawerBar() {
    setState(() {
      checkConnectivity();
    });
    return Row(
      children: [
        StreamBuilder<UserProfileDetailsModel>(
          stream: globalBloc.getUserProfileDetails.stream,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            if (!snapshot.hasData ||
                snapshot.data!.users.profileImage.isEmpty ||
                snapshot.data!.users.profileImage == "") {
              return (connectivityResult == ConnectivityResult.mobile ||
                      connectivityResult == ConnectivityResult.wifi)
                  ? ClipRRect(
                      borderRadius: const BorderRadius.all(
                        Radius.circular(50),
                      ),
                      child: Container(
                        height: 80,
                        width: 80,
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage('assets/icon/user.jpeg'),
                              fit: BoxFit.cover),
                        ),
                      ),
                    )
                  : ClipRRect(
                      borderRadius: const BorderRadius.all(
                        Radius.circular(50),
                      ),
                      child: Container(
                        height: 80,
                        width: 80,
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage('assets/icon/user.jpeg'),
                              fit: BoxFit.cover),
                        ),
                      ),
                    );
            } else {
              final base64Image = snapshot.data!.users.profileImage;
              return (connectivityResult == ConnectivityResult.mobile ||
                      connectivityResult == ConnectivityResult.wifi)
                  ? ClipRRect(
                      borderRadius: const BorderRadius.all(
                        Radius.circular(40),
                      ),
                      child: Container(
                        height: 80,
                        width: 80,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                        ),
                        child: Image.memory(
                          base64Decode(base64Image.split(",").last),
                          fit: BoxFit.cover,
                        ),
                      ),
                    )
                  : ClipRRect(
                      borderRadius: const BorderRadius.all(
                        Radius.circular(40),
                      ),
                      child: Container(
                        height: 80,
                        width: 80,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                        ),
                        child: Image.memory(
                          base64Decode(base64Image.split(",").last),
                          fit: BoxFit.cover,
                        ),
                      ),
                    );
            }
          },
        ),
      ],
    );
  }
}
