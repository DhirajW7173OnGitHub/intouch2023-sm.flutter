import 'package:flutter/material.dart';
import 'package:stock_management/Database/storage_utils.dart';
import 'package:stock_management/auth/auth_%20bloc.dart';
import 'package:stock_management/globalFile/custom_dialog.dart';
import 'package:stock_management/globalFile/global_style_editor.dart';
import 'package:stock_management/login_screen.dart';
import 'package:stock_management/utils/check_internet.dart';
import 'package:stock_management/utils/local_storage.dart';
import 'package:stock_management/utils/session_manager.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  int _selectBottomBarIndex = 1;

  TextEditingController newPasswordController = TextEditingController();
  TextEditingController currentPasswordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    sessionManager.updateLoggedInTimeAndLoggedStatus();
  }

  _clickONChangePass() async {
    String pattern =
        r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';
    RegExp regExp = RegExp(pattern);
    if (currentPasswordController.text.isEmpty) {
      globalUtils.showNegativeSnackBar(
          context: context, message: 'Enter Current Password');
    } else if (newPasswordController.text.isEmpty) {
      globalUtils.showNegativeSnackBar(
          context: context, message: 'Enter New Password');
    } else if (confirmPasswordController.text.isEmpty) {
      globalUtils.showNegativeSnackBar(
          context: context, message: 'Enter Comfirm Password');
    } else if (newPasswordController.text != confirmPasswordController.text) {
      globalUtils.showNegativeSnackBar(
          context: context,
          message: 'New Password and Confirm Password not matched.');
    } else if (!regExp.hasMatch(newPasswordController.text)) {
      globalUtils.showNegativeSnackBar(
          context: context,
          message:
              "Must have Lenght 8, 1 Number, 1 Lowercase, 1 Uppercase, 1 Special Character.");
      // globalUtils.showValidationError(
      //     'Must have Lenght 8, 1 Number, 1 Lowercase, 1 Uppercase, 1 Special Character.');
    } else {
      CheckInternetConnection conn = CheckInternetConnection();
      conn.checkInternet().then(
        (internetConn) async {
          if (internetConn) {
            var res = await authBloc.doChangeOldPassword(
              userId: StorageUtil.getString(localStorageKey.ID!.toString()),
              currentPass: currentPasswordController.text,
              newPass: newPasswordController.text,
            );

            if (res["errorcode"] == 0) {
              print('${res['msg']}');
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) => const LoginScreen(),
                ),
                (Route<dynamic> route) => false,
              );
            } else {
              print('Message :${res["msg"]}');
              globalUtils.showValidationError('${res['msg']}');
            }
          } else {
            globalUtils.showValidationError('Please, Connect Internet');
          }
        },
      );
    }
  }

  _selectBottomBar(int index) {
    switch (index) {
      case 0:
        CommonCall.homeIconCall(context);
        break;
      case 2:
        CommonCall.personIconCall(context);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Change Password'),
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectBottomBarIndex,
          onTap: (value) {
            _selectBottomBar(value);
          },
          backgroundColor: Colors.white,
          selectedItemColor: CommonColor.BOTTOM_SELECT_COLOR,
          unselectedItemColor: CommonColor.BOTTOM_UNSELECT_COLOR,
          items: const [
            BottomNavigationBarItem(
              label: 'Home',
              icon: Icon(Icons.home),
            ),
            BottomNavigationBarItem(
              label: "Change password",
              icon: Icon(Icons.password),
            ),
            // BottomNavigationBarItem(
            //   label: "Profile",
            //   icon: Icon(Icons.person),
            // ),
          ],
        ),
        body: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/icon/phoenix-logo.png'),
              fit: BoxFit.fill,
              opacity: 0.2,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                const Padding(
                  padding: EdgeInsets.all(8),
                  child: Text(
                    'Change Password',
                    style: TextStyle(
                      fontSize: 20.0,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Container(
                  height: 50,
                  margin: const EdgeInsets.only(left: 10, right: 10),
                  child: TextField(
                    controller: currentPasswordController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Current Password',
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  margin: const EdgeInsets.only(left: 10, right: 10),
                  height: 50,
                  child: TextField(
                    controller: newPasswordController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Enter new Password',
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  margin: const EdgeInsets.only(left: 10, right: 10),
                  height: 50,
                  child: TextField(
                    controller: confirmPasswordController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Confirm Password',
                    ),
                  ),
                ),
                const SizedBox(
                  height: 18,
                ),
                ElevatedButton(
                  onPressed: () {
                    _clickONChangePass();
                  },
                  child: Text(
                    'Change Password',
                    style: gse.elevationButtonTextStyle,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
