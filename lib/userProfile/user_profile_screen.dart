import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stock_management/Database/storage_utils.dart';
import 'package:stock_management/login_screen.dart';
import 'package:stock_management/userProfile/change_password_screen.dart';
import 'package:stock_management/userProfile/widget/profile_image_widget.dart';
import 'package:stock_management/utils/local_storage.dart';
import 'package:stock_management/utils/session_manager.dart';

import '../splash_screen.dart';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({super.key});

  @override
  State<UserProfileScreen> createState() {
    return _UserProfileScreenState();
  }
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  File? file;
  String notificationCount = '';

  ImagePicker image = ImagePicker();
  ImageCropper cropImage = ImageCropper();

  @override
  void initState() {
    super.initState();

    sessionManager.updateLoggedInTimeAndLoggedStatus();
  }

  getImage() {
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 200,
          //height: MediaQuery.of(context).size.height * 0.2,
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Choose an image from...',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  TextButton.icon(
                    onPressed: () {
                      getImageFromGallery();
                      Navigator.pop(context);
                    },
                    label: const Text('Gallery'),
                    icon: const Icon(
                      Icons.image,
                      size: 40,
                    ),
                  ),
                  const SizedBox(width: 12),
                  TextButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                      getImageFromCam();
                    },
                    label: const Text('Camera'),
                    icon: const Icon(
                      Icons.camera,
                      size: 40,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> getImageFromCam() async {
    var img = await ImagePicker().pickImage(source: ImageSource.camera);

    if (img!.path != null) {
      CroppedFile? imageCropper = await cropImage.cropImage(
        sourcePath: img.path,
        aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
        maxWidth: 512,
        maxHeight: 512,
      );

      if (imageCropper != null) {
        setState(() {
          file = File(imageCropper.path);
          log('Cropped Image : $file');
        });
        //    setState(() {
        //   file = File(img.path);
        // });
      }
    }
  }

  getImageFromGallery() async {
    //pick from gallery
    var img = await image.pickImage(source: ImageSource.gallery);

    if (img!.path != null) {
      log('Selected Image Path : ${img.path}');
      // setState(() {
      //   file = File(img.path);
      // });
      CroppedFile? imageCropper = await cropImage.cropImage(
        sourcePath: img.path,
        aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
        maxWidth: 512,
        maxHeight: 512,
      );

      if (imageCropper != null) {
        setState(() {
          file = File(imageCropper.path);
          log('Cropped Image : $file');
        });
      }
    }
  }

  profileAppBar({
    Function()? onPressBackButton,
    Function()? onPressLogOut,
  }) {
    return Column(
      children: [
        const SizedBox(
          height: 30,
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Row(
                children: [
                  GestureDetector(
                    onTap: onPressBackButton,
                    child: const Icon(
                      Icons.arrow_back,
                      size: 22,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(
                    width: 12,
                  ),
                  Text(
                    'profile',
                    style: GoogleFonts.adamina(
                      textStyle: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                      ),
                    ),
                  ),
                ],
              ),
              const Spacer(),
              // IconButton(
              //   onPressed: () {
              //     // Navigator.push(context, MaterialPageRoute(builder: (context)=>,),);
              //   },
              //   icon: const Icon(
              //     Icons.notifications,
              //     size: 22,
              //     color: Colors.white,
              //   ),
              // ),
              const SizedBox(
                width: 30,
              ),
              GestureDetector(
                onTap: onPressLogOut,
                child: const Icon(
                  Icons.logout,
                  size: 22,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Future<bool> _clickOnLogOut() async {
    return (await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Are you sure?'),
            content: const Text('Do you want to Logout from the App'),
            actions: <Widget>[
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('No'),
              ),
              ElevatedButton(
                onPressed: () async {
                  //  / await StorageUtil.putString(localStorageKey.ISLOGGEDIN!, "");

                  var sharedPreference = await SharedPreferences.getInstance();

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
        )) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        backgroundColor: Colors.blue[500],
        appBar: PreferredSize(
          preferredSize:
              Size.fromHeight(MediaQuery.of(context).size.height * 0.28),
          child: Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
              // gradient: LinearGradient(
              //   begin: Alignment.topCenter,
              //   colors: [
              //     Color.fromARGB(255, 3, 95, 170),
              //     Color.fromARGB(255, 33, 150, 243),
              //   ],
              // ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 20, left: 10),
                  child: Column(
                    // crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      profileAppBar(
                        onPressBackButton: () {
                          Navigator.pop(context);
                        },
                        onPressLogOut: () {
                          _clickOnLogOut();
                        },
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      ProfileImageWidget(
                        file: file,
                        onTap: getImage,
                        editIcon: ClipRRect(
                          borderRadius: const BorderRadius.all(
                            Radius.circular(
                              60,
                            ),
                          ),
                          child: Container(
                            padding: const EdgeInsets.all(2),
                            color: const Color.fromARGB(255, 31, 28, 28),
                            child: const Icon(
                              Icons.edit,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white, //CommonColor.CONTAINER_COLOR,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Column(
                      children: [
                        buildUserProfileField(
                          context,
                          icon: const Icon(Icons.person),
                          label: 'Name',
                          value:
                              '${StorageUtil.getString(localStorageKey.NAME!)}',
                        ),
                        buildUserProfileField(
                          context,
                          icon: const Icon(Icons.email),
                          label: 'Email',
                          value:
                              '${StorageUtil.getString(localStorageKey.EMAIL!)}',
                        ),
                        buildUserProfileField(
                          context,
                          icon: const Icon(Icons.mobile_friendly_outlined),
                          label: 'Mobile Number',
                          value:
                              '${StorageUtil.getString(localStorageKey.PHONE!)}',
                        ),
                        buildUserProfileField(
                          context,
                          icon: const Icon(Icons.location_city),
                          label: 'Organisation',
                          value: 'In-Touch Consumer Care Solution pvt ltd',
                        ),
                        buildUserProfileField(
                          context,
                          icon: const Icon(Icons.shop_2_outlined),
                          label: 'Shop Name',
                          value: 'XYZ',
                        ),
                        buildUserProfileField(
                          context,
                          icon: const Icon(Icons.shop),
                          label: 'Shop code',
                          value: '12345',
                        ),
                        buildUserProfileField(
                          context,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const ChangePasswordScreen(),
                              ),
                            );
                          },
                          icon: const Icon(Icons.password),
                          label: 'Password',
                          isEditable: true,
                          value: '****',
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildUserProfileField(
    BuildContext context, {
    required String label,
    required String value,
    Widget? icon,
    bool isEditable = false,
    Function()? onTap,
  }) {
    return Card(
      color: Colors.white,
      elevation: 2,
      shape: const UnderlineInputBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(8),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (icon != null)
                  Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: icon,
                  ),
                const SizedBox(
                  width: 10,
                ),
                SizedBox(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        label,
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Row(
                        children: [
                          Text(
                            value,
                            maxLines: 2,
                            textAlign: TextAlign.justify,
                            overflow: TextOverflow.visible,
                            style: const TextStyle(
                              color: Colors.black87,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          if (isEditable == true)
                            InkWell(
                              onTap: onTap,
                              child: Wrap(
                                children: [
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width *
                                        0.60,
                                  ),
                                  isEditable
                                      ? const Icon(Icons.edit)
                                      : Container(),
                                ],
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
