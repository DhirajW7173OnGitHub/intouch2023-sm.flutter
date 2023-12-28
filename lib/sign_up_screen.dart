import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:stock_management/auth/auth_%20bloc.dart';
import 'package:stock_management/auth/mixins.dart';
import 'package:stock_management/globalFile/custom_dialog.dart';
import 'package:stock_management/login_screen.dart';
import 'package:stock_management/otp_checker_screen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});
  @override
  State<SignUpScreen> createState() {
    return _SignUpScreenState();
  }
} /*  */

class _SignUpScreenState extends State<SignUpScreen> with ValidationMixin {
  final _formKey = GlobalKey<FormState>();

  TextEditingController mobileController = TextEditingController();

  final FocusNode _phoneFocus = FocusNode();
  bool checkInternet = false;

  @override
  void initState() {
    super.initState();
  }

  // @override
  // void dispose() {
  //   // Dispose of the FocusNode when the widget is disposed
  //   _phoneFocus.dispose();
  //   super.dispose();
  // }

  willPopUp() {
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
        (route) => false);
  }

  _sendOtp() async {
    checkInternet = await InternetConnectionChecker().hasConnection;
    print('Check Internet : $checkInternet');

    if (!checkInternet) {
      globalUtils.showValidationError('Please, Check Internet Connection');
    } else // if (_formKey.currentState!.validate() && checkInternet) {
    {
      var condition = await authBloc.doCheckOtp(mobileController.text);
      if (condition['msg'] == "Success") {
        Future.delayed(const Duration(microseconds: 2000), () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const OTPCheckerScreen(),
              settings: RouteSettings(arguments: {
                'phone': mobileController.text,
              }),
            ),
          );
        });
      } else {
        globalUtils.showValidationError(condition['msg']);
        // ScaffoldMessenger.of(context).showSnackBar(
        //   SnackBar(
        //     content: Text(condition['msg']),
        //     backgroundColor: Colors.red,
        //     duration: const Duration(seconds: 2),
        //   ),
        // );
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
        backgroundColor: Colors.blue[700],
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 280),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Center(
                        child: Container(
                          width: 150,
                          height: 150,
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.all(
                              Radius.circular(20),
                            ),
                            border: Border.all(
                              color: Colors.white,
                              width: 5,
                            ),
                          ),
                          child: Center(
                            child: Text(
                              "IPN", //besley
                              style: GoogleFonts.anticDidone(
                                textStyle: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 42,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: Text(
                          'Enter valide Mobile Number',
                          style: Theme.of(context)
                              .textTheme
                              .headline1!
                              .copyWith(fontSize: 16, color: Colors.white),
                        ),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      TextFormField(
                        controller: mobileController,
                        textInputAction: TextInputAction.done,
                        style: const TextStyle(color: Colors.white),
                        keyboardType: TextInputType.phone,
                        validator: validatePhoneNumber,
                        onChanged: (value) {
                          _formKey.currentState!.validate();
                          setState(() {
                            debugPrint(value);
                          });
                        },
                        focusNode: _phoneFocus,
                        decoration: const InputDecoration(
                          errorStyle: TextStyle(color: Colors.white),
                          contentPadding: EdgeInsets.symmetric(
                            vertical: 10,
                            horizontal: 10,
                          ),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.white)),
                          border: OutlineInputBorder(),
                          labelText: "Mobile Number",
                          labelStyle: TextStyle(color: Colors.white),
                          hintText: "Enter mobile number",
                          hintStyle: TextStyle(color: Colors.white),
                        ),
                        // validator: validatePhoneNumber(),
                      ),
                      const SizedBox(height: 30),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.36,
                            child: ElevatedButton(
                              onPressed: willPopUp,
                              child: const Text(
                                'BACK',
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.36,
                            child: ElevatedButton(
                              onPressed: _sendOtp,
                              child: Text(
                                'Continue'.toUpperCase(),
                                style: const TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
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
