import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CommonIPNWidget extends StatelessWidget {
  const CommonIPNWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 150,
        height: 150,
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(
            Radius.circular(20),
          ),
          border: Border.all(
            color: Colors.red,
            width: 5,
          ),
        ),
        child: Center(
          child: Text(
            "IPN", //besley
            style: GoogleFonts.anticDidone(
              textStyle: const TextStyle(
                color: Colors.red,
                fontSize: 42,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
