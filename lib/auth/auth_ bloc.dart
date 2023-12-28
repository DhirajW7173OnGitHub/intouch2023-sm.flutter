import 'dart:developer';

import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:rxdart/subjects.dart';
import 'package:stock_management/Database/storage_utils.dart';
import 'package:stock_management/auth/auth_apicaller.dart';
import 'package:stock_management/model/create_password_model.dart';
import 'package:stock_management/utils/local_storage.dart';

class AuthBloc {
  AuthApiCaller _apiCaller = AuthApiCaller();

  BehaviorSubject<CreatePasswordModel> get getCreatePassword =>
      _liveCreatePassword;
  final BehaviorSubject<CreatePasswordModel> _liveCreatePassword =
      BehaviorSubject<CreatePasswordModel>();

  // final BehaviorSubject<CheckOtpModel>

  Future<Map> doCheckOtp(String? mobileNu) async {
    EasyLoading.show(dismissOnTap: false);

    Map<String, dynamic> bodyData = {"phone": mobileNu};

    var res = await _apiCaller.getOtpData(bodyData);

    await StorageUtil.putString(localStorageKey.MOBILENU!, "${res["phone"]}");
    StorageUtil.putString(localStorageKey.OTP!.toString(), "${res["otp"]}");

    log('doCheckOtp BodyData : $bodyData -----Response :$res');

    EasyLoading.dismiss();
    return res;
  }

  Future<Map> doCreatePassword(
      {String? mobileNu, String? passW, String? otp}) async {
    EasyLoading.show(dismissOnTap: false);
    Map<String, dynamic> bodyData = {
      "phone": mobileNu,
      "password": passW,
      "otp": otp
    };
    var res = await _apiCaller.getCreatePass(bodyData);
    log('doCreatePassword BodyData : $bodyData -----Response :$res');
    var response = CreatePasswordModel.fromJson(res);
    EasyLoading.dismiss();
    _liveCreatePassword.add(response);
    return res;
  }
}

AuthBloc authBloc = AuthBloc();
