// To parse this JSON data, do
//
//     final temperatures = temperaturesFromJson(jsonString);

import 'dart:convert';

CreatePasswordModel createPasswordModelFromJson(String str) =>
    CreatePasswordModel.fromJson(json.decode(str));

String createPasswordModelToJson(CreatePasswordModel data) =>
    json.encode(data.toJson());

class CreatePasswordModel {
  int errorcode;
  String msg;

  CreatePasswordModel({
    required this.errorcode,
    required this.msg,
  });

  factory CreatePasswordModel.fromJson(Map<String, dynamic> json) =>
      CreatePasswordModel(
        errorcode: json["errorcode"],
        msg: (["", null, 0, false].contains(json["msg"])) ? "" : json["msg"],
      );

  Map<String, dynamic> toJson() => {
        "errorcode": errorcode,
        "msg": msg,
      };
}
