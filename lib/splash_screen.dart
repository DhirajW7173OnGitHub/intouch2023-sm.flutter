import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stock_management/model/user_login_data_model.dart';
import 'package:stock_management/utils/local_storage.dart';

import 'Database/storage_utils.dart';
import 'home_screen.dart';
import 'login_screen.dart';

const String KEYLOGIN = "userMobNu";
const String KEYLOGINTIME = "loginTime";

class NewSplashScreen extends StatefulWidget {
  const NewSplashScreen({
    super.key,
  });

  @override
  State<NewSplashScreen> createState() => _NewSplashScreenState();
}

class _NewSplashScreenState extends State<NewSplashScreen>
    with SingleTickerProviderStateMixin {
  final splashDelay = 6;

  late AnimationController _controller;
  late Animation<double> _opacity;
  Animation? _colorAnimation;

  User? user;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    );

    _colorAnimation =
        ColorTween(begin: const Color(0xFFF7EAE9), end: Colors.white)
            .animate(_controller);
    _opacity = Tween<double>(begin: 0.0, end: 1.0).animate(_controller);

    _controller.forward();

    // _controller.addListener(() {
    //   setState(() {});
    //   print(_controller.value);
    //   print(_colorAnimation!.value);
    // });

    _loadScreen();
  }

  _loadScreen() async {
    var _duration = Duration(
      seconds: splashDelay,
    );
    return Timer(_duration, navigateToScreen);
  }

  // navigateToScreen() async {
  //   final loggedIn = user != null &&
  //       StorageUtil.getString(localStorageKey.ISLOGGEDIN!) != "";
  //   log('@@@@@@@:$loggedIn');
  //   final lastLoginTime =
  //       StorageUtil.getString(localStorageKey.LASTLOGGEDINTIME!);
  //   log('**********:$lastLoginTime');
  //   if (loggedIn) {
  //     final currentTime = DateTime.now();

  //     if (lastLoginTime != null) {
  //       final lastLoginDate = DateTime.parse(lastLoginTime);
  //       final difference = currentTime.difference(lastLoginDate);

  //       if (difference.inHours <= 24) {
  //         Navigator.pushReplacement(
  //           context,
  //           MaterialPageRoute(
  //             builder: (context) => const HomeScreen(),
  //           ),
  //         );
  //         return;
  //       }
  //     }
  //   }
  //   Navigator.pushReplacement(
  //     context,
  //     MaterialPageRoute(
  //       builder: (context) => const LoginScreen(),
  //     ),
  //   );
  // }
  navigateToScreen() async {
    //Instance of Shared preference create for Session Storage
    var sharedPreference = await SharedPreferences.getInstance();

    final lastLoginTime =
        StorageUtil.getString(localStorageKey.LASTLOGGEDINTIME!);

    var isLogin = sharedPreference.getBool(KEYLOGIN);
    log("UserLogin Session in bool :$isLogin");

    if (isLogin != null) {
      if (isLogin) {
        final currentTime = DateTime.now();
        final lastLoggedTime = DateTime.parse(lastLoginTime);

        final differenceTime = currentTime.difference(lastLoggedTime);
        log("Time of login Session : ${differenceTime.inHours}");
        if (differenceTime.inHours <= 24) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const HomeScreen(),
            ),
          );
        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const LoginScreen(),
            ),
          );
        }
        //   return;
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const LoginScreen(),
          ),
        );
      }
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const LoginScreen(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    Future.delayed(
        const Duration(
          seconds: 6,
        ),
        () {});
    return Scaffold(
      // backgroundColor: Color(0xFFFA2B1C),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/icon/phoenix-logo.png'),
            fit: BoxFit.fill,
            // opacity: 0.8,
          ),
        ),
        child: Center(
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return Opacity(
                opacity: _opacity.value,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 150,
                      height: 150,
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.all(
                          Radius.circular(20),
                        ),
                        border: Border.all(
                          color: _colorAnimation!.value,
                          width: 5,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          "IPN", //besley
                          style: GoogleFonts.anticDidone(
                            textStyle: TextStyle(
                              color: _colorAnimation!.value,
                              fontSize: 42,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
