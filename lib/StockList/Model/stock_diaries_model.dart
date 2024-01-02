// To parse this JSON data, do
//
//     final temperatures = temperaturesFromJson(jsonString);

import 'dart:convert';

StockListModel stockListModelFromJson(String str) => StockListModel.fromJson(
      json.decode(str),
    );

String stockListModelToJson(StockListModel data) => json.encode(
      data.toJson(),
    );

class StockListModel {
  int errorcode;
  List<Stockdiary> stockdiaries;

  StockListModel({
    required this.errorcode,
    required this.stockdiaries,
  });

  factory StockListModel.fromJson(Map<String, dynamic> json) => StockListModel(
        errorcode: json["errorcode"],
        stockdiaries: List<Stockdiary>.from(
            json["stockdiaries"].map((x) => Stockdiary.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "errorcode": errorcode,
        "stockdiaries": List<dynamic>.from(stockdiaries.map((x) => x.toJson())),
      };
}

class Stockdiary {
  int id;
  String name;
  int reqid;
  int qty;

  Stockdiary({
    required this.id,
    required this.name,
    required this.reqid,
    required this.qty,
  });

  factory Stockdiary.fromJson(Map<String, dynamic> json) => Stockdiary(
        id: json["id"],
        name: (["", null, 0, false].contains(json["name"])) ? "" : json["name"],
        reqid:
            (["", null, 0, false].contains(json["reqid"])) ? "" : json["reqid"],
        qty: (["", null, 0, false].contains(json["qty"])) ? "" : json["qty"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "reqid": reqid,
        "qty": qty,
      };
}
