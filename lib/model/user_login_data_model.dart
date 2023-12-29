// To parse this JSON data, do
//
//     final temperatures = temperaturesFromJson(jsonString);

import 'dart:convert';

UserDataModel userDataModelFromJson(String str) => UserDataModel.fromJson(
      json.decode(str),
    );

String userDataModelToJson(UserDataModel data) => json.encode(
      data.toJson(),
    );

class UserDataModel {
  int errorcode;
  String msg;
  User user;
  String token;

  UserDataModel({
    required this.errorcode,
    required this.msg,
    required this.user,
    required this.token,
  });

  factory UserDataModel.fromJson(Map<String, dynamic> json) => UserDataModel(
        errorcode: json["errorcode"],
        msg: json["msg"],
        user: User.fromJson(json["user"]),
        token: json["token"],
      );

  Map<String, dynamic> toJson() => {
        "errorcode": errorcode,
        "msg": msg,
        "user": user.toJson(),
        "token": token,
      };
}

class User {
  int id;
  String name;
  String email;
  String mallIds;
  int roleId;
  String emailVerifiedAt;
  String picture;
  dynamic location;
  String phone;
  String createdAt;
  String updatedAt;
  int inactive;
  int appUser;
  String otp;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.mallIds,
    required this.roleId,
    required this.emailVerifiedAt,
    required this.picture,
    required this.location,
    required this.phone,
    required this.createdAt,
    required this.updatedAt,
    required this.inactive,
    required this.appUser,
    required this.otp,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"],
        name: (["", null, false, 0].contains(json["name"])) ? "" : json["name"],
        email:
            (["", null, false, 0].contains(json["email"])) ? "" : json["email"],
        mallIds: (["", null, false, 0].contains(json["mall_ids"]))
            ? ""
            : json["mall_ids"],
        roleId: json["role_id"],
        emailVerifiedAt:
            (["", null, false, 0].contains(json["email_verified_at"]))
                ? ""
                : json["email_verified_at"],
        picture: json["picture"],
        location: json["location"],
        phone:
            (["", null, false, 0].contains(json["phone"])) ? "" : json["phone"],
        createdAt: (["", null, false, 0].contains(json["created_at"]))
            ? ""
            : json["created_at"],
        updatedAt: (["", null, false, 0].contains(json["updated_at"]))
            ? ""
            : json["updated_at"],
        inactive: json["inactive"],
        appUser: json["app_user"],
        otp: json["otp"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "email": email,
        "mall_ids": mallIds,
        "role_id": roleId,
        "email_verified_at": emailVerifiedAt,
        "picture": picture,
        "location": location,
        "phone": phone,
        "created_at": createdAt,
        "updated_at": updatedAt,
        "inactive": inactive,
        "app_user": appUser,
        "otp": otp,
      };
}


// import 'dart:convert';

// UserDataModel userDataModelFromJson(String str) =>
//     UserDataModel.fromJson(json.decode(str));

// String userDataModelToJson(UserDataModel data) => json.encode(data.toJson());

// class UserDataModel {
//   int errorcode;
//   String msg;
//   User user;
//   Token token;

//   UserDataModel({
//     required this.errorcode,
//     required this.msg,
//     required this.user,
//     required this.token,
//   });

//   factory UserDataModel.fromJson(Map<String, dynamic> json) => UserDataModel(
//         errorcode: json["errorcode"],
//         msg: json["msg"],
//         user: User.fromJson(json["user"]),
//         token: Token.fromJson(json["token"]),
//       );

//   Map<String, dynamic> toJson() => {
//         "errorcode": errorcode,
//         "msg": msg,
//         "user": user.toJson(),
//         "token": token.toJson(),
//       };
// }

// class Token {
//   String name;
//   List<String> abilities;
//   int tokenableId;
//   String tokenableType;
//   String updatedAt;
//   String createdAt;
//   int id;

//   Token({
//     required this.name,
//     required this.abilities,
//     required this.tokenableId,
//     required this.tokenableType,
//     required this.updatedAt,
//     required this.createdAt,
//     required this.id,
//   });

//   factory Token.fromJson(Map<String, dynamic> json) => Token(
//         name: (["", null, false, 0].contains(json["name"])) ? "" : json["name"],
//         abilities: List<String>.from(json["abilities"].map((x) => x)),
//         tokenableId: json["tokenable_id"],
//         tokenableType: (["", null, false, 0].contains(json["tokenable_type"]))
//             ? ""
//             : json["tokenable_type"],
//         updatedAt: (["", null, false, 0].contains(json["updated_at"]))
//             ? ""
//             : json["updated_at"],
//         createdAt: (["", null, false, 0].contains(json["created_at"]))
//             ? ""
//             : json["created_at"],
//         id: json["id"],
//       );

//   Map<String, dynamic> toJson() => {
//         "name": name,
//         "abilities": List<dynamic>.from(abilities.map((x) => x)),
//         "tokenable_id": tokenableId,
//         "tokenable_type": tokenableType,
//         "updated_at": updatedAt,
//         "created_at": createdAt,
//         "id": id,
//       };
// }

// class User {
//   int id;
//   String name;
//   String email;
//   String mallIds;
//   int roleId;
//   String emailVerifiedAt;
//   String picture;
//   dynamic location;
//   String phone;
//   String createdAt;
//   String updatedAt;
//   int inactive;
//   int appUser;
//   String otp;

//   User({
//     required this.id,
//     required this.name,
//     required this.email,
//     required this.mallIds,
//     required this.roleId,
//     required this.emailVerifiedAt,
//     required this.picture,
//     required this.location,
//     required this.phone,
//     required this.createdAt,
//     required this.updatedAt,
//     required this.inactive,
//     required this.appUser,
//     required this.otp,
//   });

//   factory User.fromJson(Map<String, dynamic> json) => User(
//         id: json["id"],
//         name: (["", null, false, 0].contains(json["name"])) ? "" : json["name"],
//         email:
//             (["", null, false, 0].contains(json["email"])) ? "" : json["email"],
//         mallIds: (["", null, false, 0].contains(json["mall_ids"]))
//             ? ""
//             : json["mall_ids"],
//         roleId: json["role_id"],
//         emailVerifiedAt:
//             (["", null, false, 0].contains(json["email_verified_at"]))
//                 ? ""
//                 : json["email_verified_at"],
//         picture: (["", null, false, 0].contains(json["picture"]))
//             ? ""
//             : json["picture"],
//         location: (["", null, false, 0].contains(json["location"]))
//             ? ""
//             : json["location"],
//         phone:
//             (["", null, false, 0].contains(json["phone"])) ? "" : json["phone"],
//         createdAt: (["", null, false, 0].contains(json["created_at"]))
//             ? ""
//             : json["created_at"],
//         updatedAt: (["", null, false, 0].contains(json["updated_at"]))
//             ? ""
//             : json["updated_at"],
//         inactive: json["inactive"],
//         appUser: json["app_user"],
//         otp: (["", null, false, 0].contains(json["otp"])) ? "" : json["otp"],
//       );

//   Map<String, dynamic> toJson() => {
//         "id": id,
//         "name": name,
//         "email": email,
//         "mall_ids": mallIds,
//         "role_id": roleId,
//         "email_verified_at": emailVerifiedAt,
//         "picture": picture,
//         "location": location,
//         "phone": phone,
//         "created_at": createdAt,
//         "updated_at": updatedAt,
//         "inactive": inactive,
//         "app_user": appUser,
//         "otp": otp,
//       };
// }



















