import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:stock_management/Database/storage_utils.dart';
import 'package:stock_management/auth/auth_%20bloc.dart';
import 'package:stock_management/auth/mixins.dart';
import 'package:stock_management/globalFile/custom_dialog.dart';
import 'package:stock_management/login_screen.dart';
import 'package:stock_management/utils/local_storage.dart';
import 'package:stock_management/widget/common_ipn_widget.dart';

class PasswordCreateScreen extends StatefulWidget {
  const PasswordCreateScreen({super.key});

  @override
  State<PasswordCreateScreen> createState() => _PasswordCreateScreenState();
}

class _PasswordCreateScreenState extends State<PasswordCreateScreen>
    with ValidationMixin {
  final _formKey = GlobalKey<FormState>();
  TextEditingController passwordController = TextEditingController();
  TextEditingController passCofirmController = TextEditingController();

  FocusNode password = FocusNode();
  FocusNode confirmPass = FocusNode();
  bool _passVisible = false;
  bool _confirmPassVisible = false;
  bool checkInternet = false;

  _clickOnSavePass() async {
    checkInternet = await InternetConnectionChecker().hasConnection;
    print("Check Internet : $checkInternet");

    if (!checkInternet) {
      globalUtils.showValidationError("Please, Check Internet Connection");
    } else if (checkInternet && _formKey.currentState!.validate()) {
      var res = await authBloc.doCreatePassword(
        mobileNu: StorageUtil.getString(localStorageKey.MOBILENU!),
        passW: passCofirmController.text,
        otp: StorageUtil.getString(localStorageKey.OTP!.toString()),
      );
      if (res["errorcode"] == 0) {
        globalUtils.showValidationError(res['msg']);

        Future.delayed(const Duration(microseconds: 2000), () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const LoginScreen(),
            ),
          );
        });
      } else {
        globalUtils.showValidationError(res['msg']);
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
        //  backgroundColor: Colors.blue[700],
        bottomNavigationBar: Material(
          shadowColor: Colors.black,
          elevation: 20,
          child: SizedBox(
            child: Padding(
              padding: const EdgeInsets.only(
                  left: 20, right: 20, top: 10, bottom: 10),
              child: ElevatedButton(
                onPressed: passCofirmController.text.length > 0 &&
                        passCofirmController.text == passwordController.text &&
                        _formKey.currentState!.validate()
                    ? () {
                        _clickOnSavePass();
                      }
                    : null,
                child: const Text('SAVE PASSWORD'),
              ),
            ),
          ),
        ),
        body: Container(
          height: double.infinity,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/icon/phoenix-logo.png'),
              fit: BoxFit.fill,
              opacity: 0.2,
            ),
          ),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 30),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(
                      height: 180,
                    ),
                    const CommonIPNWidget(),
                    const SizedBox(
                      height: 20,
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: Text(
                        'Create your Password',
                        style: Theme.of(context)
                            .textTheme
                            .headline1!
                            .copyWith(fontSize: 16, color: Colors.red),
                      ),
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    TextFormField(
                      controller: passwordController,
                      obscureText: !_passVisible,
                      obscuringCharacter: '*',
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.text,
                      autocorrect: false,
                      validator: validateLoginPassword,
                      onChanged: (value) {
                        _formKey.currentState!.validate();

                        setState(() {
                          debugPrint(value);
                        });
                      },
                      focusNode: password,
                      decoration: InputDecoration(
                        suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              _passVisible = !_passVisible;
                            });
                          },
                          icon: _passVisible
                              ? const Icon(
                                  Icons.visibility,
                                  color: Colors.red,
                                )
                              : const Icon(Icons.visibility_off,
                                  color: Colors.red),
                        ),
                        errorStyle: const TextStyle(color: Colors.red),
                        border: const OutlineInputBorder(),
                        focusedBorder: const OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.red)),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 10),
                        labelText: "Password",
                        labelStyle: const TextStyle(color: Colors.red),
                        hintText: 'A-z,0-9,!@#\$&*~',
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      obscureText: !_confirmPassVisible,
                      obscuringCharacter: "*",
                      controller: passCofirmController,
                      autocorrect: false,
                      textInputAction: TextInputAction.done,
                      keyboardType: TextInputType.text,
                      validator: (value) {
                        if (value!.isEmpty) return "";
                        if (value != passwordController.text)
                          return "Not Match";
                        return null;
                      },
                      onChanged: (value) {
                        _formKey.currentState!.validate();
                        setState(() {
                          debugPrint(value);
                        });
                      },
                      focusNode: confirmPass,
                      decoration: InputDecoration(
                        suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              _confirmPassVisible = !_confirmPassVisible;
                            });
                          },
                          icon: _confirmPassVisible
                              ? const Icon(
                                  Icons.visibility,
                                  color: Colors.red,
                                )
                              : const Icon(Icons.visibility_off,
                                  color: Colors.red),
                        ),
                        errorStyle: const TextStyle(color: Colors.red),
                        border: const OutlineInputBorder(),
                        focusedBorder: const OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.red)),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 10),
                        labelText: "Confirmed Password",
                        labelStyle: const TextStyle(color: Colors.red),
                        hintText: "Confirmed Password",
                        hintStyle: const TextStyle(color: Colors.red),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
