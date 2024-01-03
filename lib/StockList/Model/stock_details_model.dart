// To parse this JSON data, do
//
//     final temperatures = temperaturesFromJson(jsonString);

import 'dart:convert';

StockDetailsModel stockDetailsModelFromJson(String str) =>
    StockDetailsModel.fromJson(json.decode(str));

String stockDetailsModelToJson(StockDetailsModel data) =>
    json.encode(data.toJson());

class StockDetailsModel {
  int errorcode;
  List<StockDatum> stockDetails;

  StockDetailsModel({
    required this.errorcode,
    required this.stockDetails,
  });

  factory StockDetailsModel.fromJson(Map<String, dynamic> json) =>
      StockDetailsModel(
        errorcode: json["errorcode"],
        stockDetails: List<StockDatum>.from(
            json["stockdiaries"].map((x) => StockDatum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "errorcode": errorcode,
        "stockdiaries": List<dynamic>.from(stockDetails.map((x) => x.toJson())),
      };
}

class StockDatum {
  int id;
  String name;
  int reqid;
  int qty;

  StockDatum({
    required this.id,
    required this.name,
    required this.reqid,
    required this.qty,
  });

  factory StockDatum.fromJson(Map<String, dynamic> json) => StockDatum(
        id: json["id"],
        name: (["", null, false, 0].contains(json["name"])) ? "" : json["name"],
        reqid:
            (["", null, false, 0].contains(json["reqid"])) ? "" : json["reqid"],
        qty: (["", null, false, 0].contains(json["qty"])) ? "" : json["qty"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "reqid": reqid,
        "qty": qty,
      };
}
