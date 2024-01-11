// To parse this JSON data, do
//
//     final temperatures = temperaturesFromJson(jsonString);

import 'dart:convert';

UserProfileDetailsModel temperaturesFromJson(String str) =>
    UserProfileDetailsModel.fromJson(json.decode(str));

String temperaturesToJson(UserProfileDetailsModel data) =>
    json.encode(data.toJson());

class UserProfileDetailsModel {
  int errorcode;
  UsersProfile users;

  UserProfileDetailsModel({
    required this.errorcode,
    required this.users,
  });

  factory UserProfileDetailsModel.fromJson(Map<String, dynamic> json) =>
      UserProfileDetailsModel(
        errorcode: json["errorcode"],
        users: UsersProfile.fromJson(json["users"]),
      );

  Map<String, dynamic> toJson() => {
        "errorcode": errorcode,
        "users": users.toJson(),
      };
}

class UsersProfile {
  UserInfo user;
  String profileImage;

  UsersProfile({
    required this.user,
    required this.profileImage,
  });

  factory UsersProfile.fromJson(Map<String, dynamic> json) => UsersProfile(
        user: UserInfo.fromJson(json["user"]),
        profileImage: json["profile_image"],
      );

  Map<String, dynamic> toJson() => {
        "user": user.toJson(),
        "profile_image": profileImage,
      };
}

class UserInfo {
  int id;
  String name;
  String email;
  String phone;
  int roleId;
  String roleName;

  UserInfo({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.roleId,
    required this.roleName,
  });

  factory UserInfo.fromJson(Map<String, dynamic> json) => UserInfo(
        id: json["id"],
        name: (["", null, false, 0].contains(json["name"])) ? "" : json["name"],
        email:
            (["", null, false, 0].contains(json["email"])) ? "" : json["email"],
        phone:
            (["", null, false, 0].contains(json["phone"])) ? "" : json["phone"],
        roleId: json["role_id"],
        roleName: (["", null, false, 0].contains(json["role_name"]))
            ? ""
            : json["role_name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "email": email,
        "phone": phone,
        "role_id": roleId,
        "role_name": roleName,
      };
}
