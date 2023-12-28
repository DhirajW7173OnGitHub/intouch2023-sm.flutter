import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:stock_management/Database/storage_utils.dart';
import 'package:stock_management/utils/local_storage.dart';

class ProfileImageWidget extends StatelessWidget {
  const ProfileImageWidget(
      {super.key,
      this.file,
      this.image,
      this.leftPosition = 0,
      this.onTap,
      this.rightPosition = 0,
      this.editIcon,
      this.defaultWidget});

  final File? file;
  final ImagePicker? image;
  final Function()? onTap;
  final double rightPosition;
  final double leftPosition;
  final Widget? editIcon;
  final Widget? defaultWidget;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          InkWell(
            onTap: onTap!,
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.all(
                    Radius.circular(35),
                  ),
                  child: Container(
                    height: 80,
                    width: 80,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      // image: DecorationImage(
                      //   image: AssetImage("assets/icon/user.jpeg"),
                      // ),
                    ),
                    child: file == null
                        ? defaultWidget ??
                            const Icon(
                              Icons.image,
                              size: 32,
                              color: Colors.white,
                              // fill: 1,
                            )
                        : Image.file(
                            file!,
                            fit: BoxFit.cover,
                          ),
                  ),
                ),
                Positioned(
                  right: rightPosition,
                  top: leftPosition,
                  child: editIcon!,
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 20,
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
    );
  }
}
