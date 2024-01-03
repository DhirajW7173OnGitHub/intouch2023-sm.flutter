// To parse this JSON data, do
//
//     final temperatures = temperaturesFromJson(jsonString);

import 'dart:convert';

StockListModel stockListModelFromJson(String str) =>
    StockListModel.fromJson(json.decode(str));

String stockListModelToJson(StockListModel data) => json.encode(data.toJson());

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
  String transType;
  int userid;
  String createdAt;

  Stockdiary({
    required this.id,
    required this.transType,
    required this.userid,
    required this.createdAt,
  });

  factory Stockdiary.fromJson(Map<String, dynamic> json) => Stockdiary(
        id: json["id"],
        transType: (["", null, false, 0].contains(json["transaction_type"]))
            ? ""
            : json["transaction_type"],
        userid: (["", null, false, 0].contains(json["userid"]))
            ? ""
            : json["userid"],
        createdAt: (["", null, false, 0].contains(json["created_at"]))
            ? ""
            : json["created_at"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "transaction_type": transType,
        "userid": userid,
        "created_at": createdAt,
      };
}
