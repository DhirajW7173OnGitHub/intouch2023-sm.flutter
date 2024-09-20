import 'dart:async';

import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:stock_management/InitialPages/home_screen.dart';
import 'package:stock_management/InitialPages/login_screen.dart';
import 'package:stock_management/utils/local_storage.dart';

import '../Database/storage_utils.dart';

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

  String? version;

  @override
  void initState() {
    super.initState();
    _loadScreen();
  }

  _loadScreen() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    setState(() {
      version = packageInfo.version;
    });
    var duration = Duration(seconds: splashDelay);
    return Timer(duration, navigateToScreen);
  }

  navigateToScreen() {
    final loggedIn = StorageUtil.getString(localStorageKey.ISLOGGEDIN) != "";
    final lastLoginTime =
        StorageUtil.getString(localStorageKey.LASTLOGGEDINTIME);

    if (loggedIn) {
      if (lastLoginTime != null) {
        final lastLoginDateTime = DateTime.parse(lastLoginTime);
        final timeDifference = DateTime.now().difference(lastLoginDateTime);

        // Check if the last login time is within the last 24 hours
        if (timeDifference.inHours <= 24) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const HomeScreen(),
            ),
          );

          return;
        }
      }
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const LoginScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Future.delayed(
        const Duration(
          seconds: 6,
        ),
        () {});
    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/icon/phoenix-logo.png'),
                fit: BoxFit.fill,
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Text(
              version ?? "",
              style: Theme.of(context)
                  .textTheme
                  .bodyLarge!
                  .copyWith(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
