// To parse this JSON data, do
//
//     final temperatures = temperaturesFromJson(jsonString);

// To parse this JSON data, do
//
//     final temperatures = temperaturesFromJson(jsonString);

import 'dart:convert';

MenuModel menuModelFromJson(String str) => MenuModel.fromJson(json.decode(str));

String menuModelToJson(MenuModel data) => json.encode(data.toJson());

class MenuModel {
  List<MenuData> menu;

  MenuModel({
    required this.menu,
  });

  factory MenuModel.fromJson(Map<String, dynamic> json) => MenuModel(
        menu:
            List<MenuData>.from(json["menu"].map((x) => MenuData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "menu": List<dynamic>.from(menu.map((x) => x.toJson())),
      };
}

class MenuData {
  String? menuTitle;
  String? id;

  MenuData({
    this.menuTitle,
    this.id,
  });

  factory MenuData.fromJson(Map<String, dynamic> json) => MenuData(
        menuTitle: (["", null, 0, false].contains(json["menu_title"]))
            ? ""
            : json["menu_title"],
        id: json["id"],
      );

  Map<String, dynamic> toJson() => {
        "menu_title": menuTitle,
        "id": id,
      };
}
