import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stock_management/home_screen.dart';
import 'package:stock_management/userProfile/user_profile_screen.dart';

class GlobalStyleEditor {
  TextStyle newProfileTextStyle = GoogleFonts.aclonica(
      textStyle: const TextStyle(
    color: Colors.black,
    fontSize: 16,
    fontWeight: FontWeight.w500,
  ));

  TextStyle menuIconTextStyle = GoogleFonts.aclonica(
    textStyle: const TextStyle(
      color: Colors.black,
      fontWeight: FontWeight.bold,
    ),
  );

  TextStyle elevationButtonTextStyle = const TextStyle(
    color: Colors.white,
    fontSize: 16,
    fontWeight: FontWeight.w500,
  );

  TextStyle textStyle = const TextStyle(
    color: Colors.black,
    fontSize: 16,
    fontWeight: FontWeight.w400,
  );
}

GlobalStyleEditor gse = GlobalStyleEditor();

class CommonColor {
  static const CARD_COLOR = Colors.white;
  static const CONTAINER_COLOR = Color.fromARGB(255, 230, 227, 227);
  static const BOTTOM_UNSELECT_COLOR = Color(0xFF757575);
  static const BOTTOM_SELECT_COLOR = Colors.red;
}

class CommonCall {
  static personIconCall(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const UserProfileScreen(),
      ),
    );
  }

  static homeIconCall(BuildContext context) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (ctx) => const HomeScreen(),
      ),
      (route) => false,
    );
  }
}
