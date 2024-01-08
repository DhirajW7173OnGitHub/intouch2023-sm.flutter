import 'package:regexpattern/regexpattern.dart';

mixin ValidationMixin {
  String? validatePhoneNumber(String? value) {
    if (value!.length != 10 || value == null) {
      return 'Please, Enter 10 digit mobile number';
    } else {
      return null;
    }
  }

  String? validateLoginPassword(String? value) {
    if (!value!.isPasswordEasy() || value == null) {
      return 'Password must contains 8 \nor above characters without any space.\nAtleast use a upercase,lowercase,\nnumber and special character.';
    }
    return null;
  }

  String validateEmail(String value) {
    if (!value.isEmail()) {
      return 'Please, Enter valid Email';
    }
    return '';
  }

  String validateOtp(String value) {
    if (value.length < 4) {
      return 'Please, Enter valid OTP';
    }
    return '';
  }
}
