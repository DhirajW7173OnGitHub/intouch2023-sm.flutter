import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:stock_management/Database/storage_utils.dart';
import 'package:stock_management/globalFile/custom_dialog.dart';
import 'package:stock_management/password_create_screen.dart';
import 'package:stock_management/sign_up_screen.dart';
import 'package:stock_management/utils/local_storage.dart';

class OTPCheckerScreen extends StatefulWidget {
  const OTPCheckerScreen({super.key});

  @override
  State<OTPCheckerScreen> createState() => _OTPCheckerScreenState();
}

class _OTPCheckerScreenState extends State<OTPCheckerScreen> {
  FocusNode pinFocusNode = FocusNode();
  TextEditingController textEditingController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  bool _otpVisible = false;

  // @override
  // void dispose() {
  //   // Dispose of the FocusNode when the widget is disposed
  //   pinFocusNode.dispose();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments as Map;
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        backgroundColor: Colors.blue[700],
        body: Container(
          alignment: Alignment.center,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 150,
                  height: 150,
                  alignment: Alignment.center,
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
                const SizedBox(
                  height: 28,
                ),
                Container(
                  padding: const EdgeInsets.all(8),
                  child: RichText(
                    text: TextSpan(
                      text: 'We have send OTP on +91-',
                      style: Theme.of(context)
                          .textTheme
                          .headlineLarge
                          ?.copyWith(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                      children: [
                        TextSpan(
                          text: '${args['phone']}',
                          style: Theme.of(context)
                              .textTheme
                              .headlineLarge
                              ?.copyWith(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                Form(
                  key: _formKey,
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 90),
                    child: PinCodeTextField(
                      obscureText: !_otpVisible,
                      appContext: context,
                      keyboardType: TextInputType.number,
                      controller: textEditingController,
                      textStyle: const TextStyle(color: Colors.white),
                      length: 4,
                      animationType: AnimationType.fade,
                      validator: (v) {
                        if (v!.length < 4) {
                          return "Enter Correct OTP";
                        } else {
                          return null;
                        }
                      },
                      focusNode: pinFocusNode,
                      blinkWhenObscuring: true,
                      pinTheme: PinTheme(
                        inactiveColor: Colors.white,
                        activeColor: Colors.blue[900],
                        selectedColor: Colors.blue[900],
                        shape: PinCodeFieldShape.box,
                        borderRadius: const BorderRadius.all(
                          Radius.circular(10),
                        ),
                        fieldHeight: 50,
                        fieldWidth: 40,
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.36,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const SignUpScreen(),
                            ),
                          );
                        },
                        child: Text('Back'.toUpperCase()),
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.36,
                      child: ElevatedButton(
                        onPressed: () async {
                          _formKey.currentState?.validate();
                          if (_formKey.currentState!.validate()) {
                            log('*************:${StorageUtil.getString(localStorageKey.OTP!.toString()) == textEditingController.text}');
                            if (StorageUtil.getString(
                                    localStorageKey.OTP!.toString()) ==
                                textEditingController.text) {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const PasswordCreateScreen(),
                                ),
                              );
                            } else {
                              globalUtils.showValidationError(
                                  "Please enter correct OTP.");
                            }
                          }
                        },
                        child: Text('Continue'.toUpperCase()),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
