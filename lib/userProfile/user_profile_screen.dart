import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stock_management/Database/apicaller.dart';
import 'package:stock_management/Database/bloc.dart';
import 'package:stock_management/Database/storage_utils.dart';
import 'package:stock_management/globalFile/custom_dialog.dart';
import 'package:stock_management/home_screen.dart';
import 'package:stock_management/login_screen.dart';
import 'package:stock_management/userProfile/Model/user_profile_details_model.dart';
import 'package:stock_management/userProfile/change_password_screen.dart';
import 'package:stock_management/userProfile/widget/profile_details_widget.dart';
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
  ApiCaller _apiCaller = ApiCaller();

  File? file;
  String notificationCount = '';

  ImagePicker image = ImagePicker();
  ImageCropper cropImage = ImageCropper();

  @override
  void initState() {
    super.initState();

    sessionManager.updateLoggedInTimeAndLoggedStatus();

    globalBloc.doFetchUserProfileDetails(
      userId: StorageUtil.getString(localStorageKey.ID!.toString()),
    );
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

          EasyLoading.show(dismissOnTap: false);

          _apiCaller
              .uploadProfilePicture(
            userId: StorageUtil.getString(localStorageKey.ID!.toString()),
            profilePicture: file,
          )
              .then((res) {
            if (res['msg'] == "Profile updated successfully") {
              print('Profile updated successfully');
            } else {
              print('Profile not updated successfully : ${res['msg']}');
            }
          }).catchError((onError) {
            print('Error: $onError');
          }).whenComplete(() {
            setState(() {
              globalBloc.doFetchUserProfileDetails(
                userId: StorageUtil.getString(localStorageKey.ID!.toString()),
              );
            });
          });
        });
      } else {
        globalUtils.showValidationError('File not found');
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
        setState(
          () {
            file = File(imageCropper.path);
            log('Cropped Image : $file');

            EasyLoading.show(dismissOnTap: false);

            _apiCaller
                .uploadProfilePicture(
              userId: StorageUtil.getString(localStorageKey.ID!.toString()),
              profilePicture: file,
            )
                .then(
              (res) {
                if (res['msg'] == 'Profile updated successfully') {
                  print('Profile updated successfully');
                } else {
                  print('Profile update failed with response: ${res['msg']}');
                }
              },
            ).catchError((onError) {
              print('Error: $onError');
            }).whenComplete(() {
              setState(() {
                globalBloc.doFetchUserProfileDetails(
                  userId: StorageUtil.getString(localStorageKey.ID!.toString()),
                );
              });
            });
          },
        );
      } else {
        globalUtils.showValidationError('File not found');
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

  _clickOnChangePass() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const ChangePasswordScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        backgroundColor: Colors.red,
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
                          Future.delayed(
                            Duration.zero,
                            () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const HomeScreen(),
                                ),
                              );
                            },
                          );
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
        body: StreamBuilder<UserProfileDetailsModel>(
          stream: globalBloc.getUserProfileDetails.stream,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const SizedBox(
                child: Center(
                  child: Text('No data'),
                ),
              );
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            return UserProfileDetailsWidget(
              onTap: _clickOnChangePass,
              email: snapshot.data!.users.email,
              id: snapshot.data!.users.id,
              name: snapshot.data!.users.name,
              phone: snapshot.data!.users.phone,
              rollName: snapshot.data!.users.roleName,
            );
          },
        ),
      ),
    );
  }
}
