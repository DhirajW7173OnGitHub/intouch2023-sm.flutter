import 'dart:developer';

import 'package:stock_management/Database/apiwrapper.dart';

class AuthApiCaller {
  //CheckOTP Data
  Future<Map<String, dynamic>> getOtpData(Map<String, dynamic> body) async {
    var endPoint = "verifyOtp";

    try {
      final res = await ApiWrapper.post(endPoint, body);
      return res;
    } catch (e) {
      log('CATCH API ERROR : $e');
      throw 'Something went wrong IngetOtpData :$e';
    }
  }

  //Create Password
  Future<Map<String, dynamic>> getCreatePass(Map<String, dynamic> body) async {
    var endPoint = "passwordUpdate?_method=PUT";

    try {
      final res = await ApiWrapper.post(endPoint, body);
      log("Password Created Response : $res");
      return res;
    } catch (e) {
      throw "Something went wrong in getCreatePass :$e";
    }
  }

  //update Password
  Future<Map<String, dynamic>> getUpdatePasswordOfUser(
      Map<String, dynamic> body) async {
    var endPoint = "Usrpassupdate";
    try {
      final res = await ApiWrapper.post(endPoint, body);
      print('doUpdatePasswordOfUser Response : $res');
      return res;
    } catch (e) {
      throw "In doUpdatePasswordOfUser Something went wrong :$e";
    }
  }
}
