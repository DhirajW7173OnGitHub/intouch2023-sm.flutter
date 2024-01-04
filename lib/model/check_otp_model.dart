// To parse this JSON data, do
//
//     final temperatures = temperaturesFromJson(jsonString);

import 'dart:convert';

CheckOtpModel checkOtpModelFromJson(String str) =>
    CheckOtpModel.fromJson(json.decode(str));

String checkOtpModelToJson(CheckOtpModel data) => json.encode(data.toJson());

class CheckOtpModel {
  String phone;
  int errorCode;
  String msg;
  int otp;

  CheckOtpModel({
    required this.phone,
    required this.otp,
    required this.errorCode,
    required this.msg,
  });

  factory CheckOtpModel.fromJson(Map<String, dynamic> json) => CheckOtpModel(
        phone:
            (["", null, 0, false].contains(json["phone"])) ? "" : json["phone"],
        otp:
            (json["otp"] is int) ? json["otp"] : int.tryParse(json["otp"]) ?? 0,
        errorCode: json["errorcode"],
        msg: (["", null, 0, false].contains(json["msg"])) ? "" : json["msg"],
      );

  Map<String, dynamic> toJson() => {
        "phone": phone,
        "otp": otp,
        "errorcode": errorCode,
        "msg": msg,
      };
}
