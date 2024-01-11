import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:stock_management/Database/bloc.dart';
import 'package:stock_management/userProfile/Model/user_profile_details_model.dart';

class ProfileImageWidget extends StatelessWidget {
  const ProfileImageWidget({
    super.key,
    this.file,
    this.image,
    this.leftPosition = 0,
    this.onTap,
    this.rightPosition = 0,
    this.editIcon,
    //  this.defaultWidget,
  });

  final File? file;
  final ImagePicker? image;
  final Function()? onTap;
  final double rightPosition;
  final double leftPosition;
  final Widget? editIcon;
  // final Widget? defaultWidget;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<UserProfileDetailsModel>(
      stream: globalBloc.getUserProfileDetails.stream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        }
        if (!snapshot.hasData ||
            snapshot.data!.users.profileImage.isEmpty ||
            snapshot.data!.users.profileImage == "") {
          return Column(
            children: [
              InkWell(
                onTap: () {},
                child: Stack(
                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.all(
                        Radius.circular(
                          35,
                        ),
                      ),
                      child: Container(
                        height: 64,
                        width: 64,
                        decoration: const BoxDecoration(
                          // color: Color.fromARGB(255, 243, 101, 101),
                          shape: BoxShape.circle,
                        ),
                        child: (file == null)
                            ? Image.asset(
                                'assets/icon/user.jpeg',
                                fit: BoxFit.cover,
                              )
                            //  defaultWidget ??
                            //     const Icon(
                            //       Icons.image,
                            //       size: 32,
                            //       color: Colors.white,
                            //       // fill: 1,
                            //     )
                            : Image.file(
                                file!,
                                fit: BoxFit.cover,
                              ),
                      ),
                    ),
                    Positioned(right: 0, top: 1, child: editIcon!),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              const Text(""),
              const Text("")
            ],
          );
        } else {
          final base64Image = snapshot.data!.users.profileImage;
          return Column(
            children: [
              InkWell(
                onTap: onTap,
                child: Stack(
                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.all(
                        Radius.circular(60),
                      ),
                      child: Container(
                        height: 80,
                        width: 80,
                        decoration: const BoxDecoration(
                          //color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                        child: Image.memory(
                          base64Decode(base64Image.split(',').last),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Positioned(right: 0, top: 1, child: editIcon!),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Text(
                snapshot.data!.users.user.name,
                style: GoogleFonts.adamina(
                  textStyle: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                  ),
                ),
              ),
              Text(
                "[${snapshot.data!.users.user.roleName}]",
                style: GoogleFonts.adamina(
                  textStyle: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
            ],
          );
        }
      },
    );

    //   Center(
    //     child: Column(
    //       children: [
    //         InkWell(
    //           onTap: onTap!,
    //           child: Stack(
    //             children: [
    //               ClipRRect(
    //                 borderRadius: const BorderRadius.all(
    //                   Radius.circular(35),
    //                 ),
    //                 child: Container(
    //                   height: 80,
    //                   width: 80,
    //                   decoration: const BoxDecoration(
    //                     shape: BoxShape.circle,
    //                     // image: DecorationImage(
    //                     //   image: AssetImage("assets/icon/user.jpeg"),
    //                     // ),
    //                   ),
    //                   child: file == null
    //                       ? const CircleAvatar(
    //                           backgroundImage:
    //                               AssetImage('assets/icon/user.jpeg'),
    //                         )

    //                       // defaultWidget ??
    //                       //     const Icon(
    //                       //       Icons.image,
    //                       //       size: 32,
    //                       //       color: Colors.white,
    //                       //       // fill: 1,
    //                       //     )
    //                       : Image.file(
    //                           file!,
    //                           fit: BoxFit.cover,
    //                         ),
    //                 ),
    //               ),
    //               Positioned(
    //                 right: rightPosition,
    //                 top: leftPosition,
    //                 child: editIcon!,
    //               ),
    //             ],
    //           ),
    //         ),
    //         const SizedBox(
    //           height: 20,
    //         ),
    //         Text(
    //           StorageUtil.getString(localStorageKey.NAME!),
    //           style: GoogleFonts.adamina(
    //             textStyle: const TextStyle(
    //               color: Colors.white,
    //               fontSize: 20,
    //             ),
    //           ),
    //         ),
    //       ],
    //     ),
    //   );
  }
}
