import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stock_management/Database/apicaller.dart';
import 'package:stock_management/Database/bloc.dart';
import 'package:stock_management/Database/storage_utils.dart';
import 'package:stock_management/globalFile/custom_dialog.dart';
import 'package:stock_management/home_screen.dart';
import 'package:stock_management/sign_up_screen.dart';
import 'package:stock_management/splash_screen.dart';
import 'package:stock_management/utils/check_internet.dart';
import 'package:stock_management/utils/local_storage.dart';
import 'package:stock_management/utils/session_manager.dart';

import 'auth/mixins.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() {
    return _LoginScreenState();
  }
}

class _LoginScreenState extends State<LoginScreen> with ValidationMixin {
  final _formKey = GlobalKey<FormState>();

  String userName = "";
  String phone = "";

  ApiCaller _apiCaller = ApiCaller();

  // final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  final FocusNode _phoneFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();
  TextEditingController mobileController = TextEditingController();
  TextEditingController passController = TextEditingController();

  bool passVisible = false;

  bool checkInternet = false;

  @override
  void initState() {
    super.initState();
    sessionManager.updateLoggedInTimeAndLoggedStatus();
  }

  // _continueKeyPress() {
  //   Navigator.pushReplacement(
  //     context,
  //     MaterialPageRoute(
  //       builder: (context) => const HomeScreen(),
  //     ),
  //   );
  // }

  _SignUpKeyPress() {
    print('Sign UP pressed'.toUpperCase());
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const SignUpScreen(),
      ),
    );
  }

  forgatePasswordDialog(BuildContext context) {
    CheckInternetConnection connection = CheckInternetConnection();
    connection.checkInternet().then((intenetValue) async {
      if (intenetValue) {
        Widget cancelButton = ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text("NO"),
        );
        Widget continueButton = ElevatedButton(
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const SignUpScreen(),
              ),
            );
          },
          child: const Text('YES'),
        );

        //Set Alert Dialog
        AlertDialog alert = AlertDialog(
          title: const Text("Confirm!"),
          content: Text("Are you sure you want to reset your password?",
              style: Theme.of(context).textTheme.bodyLarge),
          actions: [
            cancelButton,
            continueButton,
          ],
        );

        //set the Dialog
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return StatefulBuilder(builder: (context, setState) {
                return alert;
              });
            });
      } else {
        globalUtils.showValidationError('No Internet Connection');
      }
    });
  }

  void login() async {
    if (mobileController.text.isEmpty) {
      globalUtils.showValidationError('Please, Enter correct Mobile Number');
      return;
    }
    if (passController.text.isEmpty) {
      globalUtils.showValidationError('Please, Enter correct Password');
      return;
    }
    checkInternet = await InternetConnectionChecker().hasConnection;
    print('Check Internet : $checkInternet');
    print("Validator From Key :${_formKey.currentState!.validate()}");
    if (!checkInternet) {
      globalUtils.showValidationError('Please, Check Internet Connection');
    } else {
      try {
        Map body = {
          "password": passController.text,
          "phone": mobileController.text,
        };
        final res = await _apiCaller.getUserLoginData(body);
        if (res != null) {
          if (res["errorcode"] == 1) {
            globalUtils.showValidationError(res["msg"]);
          } else {
            await globalBloc.doFetchUserLoginData(
                mobileNu: mobileController.text, password: passController.text);

            var sharedPreference = await SharedPreferences.getInstance();

            sharedPreference.setBool(KEYLOGIN, true);

            Future.delayed(
              const Duration(microseconds: 000),
              () => Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const HomeScreen(),
                ),
              ),
            );
          }
        }
      } catch (e) {
        globalUtils.showValidationError('An unexpected error occurred.');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        //backgroundColor: Colors.red[600],
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 40,
              vertical: 60,
            ),
            child: Form(
              key: _formKey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: 180,
                  ),
                  Container(
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
                    child: const Center(
                      child: Text(
                        'IPN',
                        style: TextStyle(
                          fontSize: 60,
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'LOGIN',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.red,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    controller: mobileController,
                    validator: validatePhoneNumber,
                    textInputAction: TextInputAction.next,
                    style: const TextStyle(color: Colors.red),
                    keyboardType: TextInputType.phone,
                    onChanged: (value) {
                      _formKey.currentState!.validate();
                      setState(() {
                        debugPrint(value);
                      });
                    },
                    focusNode: _phoneFocus,
                    decoration: const InputDecoration(
                      errorStyle: TextStyle(color: Colors.red),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.red)),
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                      border: OutlineInputBorder(),
                      labelText: "Mobile Number",
                      labelStyle: TextStyle(color: Colors.red),
                      hintText: "Enter mobile number",
                      hintStyle: TextStyle(color: Colors.red),
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: passController,
                    validator: validateLoginPassword,
                    textInputAction: TextInputAction.done,
                    style: const TextStyle(color: Colors.red),
                    obscureText: !passVisible,
                    keyboardType: TextInputType.text,
                    onChanged: (value) {
                      _formKey.currentState!.validate();
                      setState(() {
                        debugPrint(value);
                      });
                    },
                    focusNode: _passwordFocus,
                    decoration: InputDecoration(
                      errorStyle: const TextStyle(color: Colors.red),
                      focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.red)),
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 10),
                      border: const OutlineInputBorder(),
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            passVisible = !passVisible;
                          });
                        },
                        icon: Icon(
                            passVisible
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined,
                            color: Colors.red),
                      ),
                      labelText: 'Password',
                      labelStyle: const TextStyle(color: Colors.red),
                      hintText: 'Enter Password',
                      hintStyle: const TextStyle(color: Colors.red),
                    ),
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  Row(
                    mainAxisAlignment:
                        StorageUtil.getString(localStorageKey.ID!.toString())
                                .isEmpty
                            ? MainAxisAlignment.spaceBetween
                            : MainAxisAlignment.center,
                    children: [
                      if (StorageUtil.getString(localStorageKey.ID!.toString())
                          .isEmpty)
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.36,
                          child: ElevatedButton(
                            onPressed: _SignUpKeyPress,
                            child: const Text(
                              'SING-UP',
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.36,
                        child: ElevatedButton(
                          onPressed: login,
                          child: const Text(
                            'CONTINUE',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  if (StorageUtil.getString(localStorageKey.ID!.toString())
                      .isNotEmpty)
                    TextButton(
                      onPressed: () {
                        forgatePasswordDialog(context);
                      },
                      child: const Text(
                        'Forgot Password?',
                        style: TextStyle(fontSize: 16.0, color: Colors.red),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
