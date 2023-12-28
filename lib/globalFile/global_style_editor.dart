import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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
}

GlobalStyleEditor gse = GlobalStyleEditor();
