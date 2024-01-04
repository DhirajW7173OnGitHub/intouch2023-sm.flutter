// To parse this JSON data, do
//
//     final temperatures = temperaturesFromJson(jsonString);

import 'dart:convert';

ProductListModel productListModelFromJson(String str) =>
    ProductListModel.fromJson(json.decode(str));

String productListModelToJson(ProductListModel data) =>
    json.encode(data.toJson());

class ProductListModel {
  List<Product> products;

  ProductListModel({
    required this.products,
  });

  factory ProductListModel.fromJson(Map<String, dynamic> json) =>
      ProductListModel(
        products: List<Product>.from(
          json["Products"].map(
            (x) => Product.fromJson(x),
          ),
        ),
      );

  Map<String, dynamic> toJson() => {
        "Products": List<dynamic>.from(
          products.map(
            (x) => x.toJson(),
          ),
        ),
      };
}

class Product {
  int id;
  String code;
  String name;
  int ctgId;
  String hsnCode;
  int mrp;
  int sellPrice;

  Product({
    required this.id,
    required this.code,
    required this.name,
    required this.ctgId,
    required this.hsnCode,
    required this.mrp,
    required this.sellPrice,
  });

  factory Product.fromJson(Map<String, dynamic> json) => Product(
        id: json["id"],
        code: (["", null, false, 0].contains(json["code"])) ? "" : json["code"],
        name: (["", null, false, 0].contains(json["name"])) ? "" : json["name"],
        ctgId: (["", null, false, 0].contains(json["ctg_id"]))
            ? ""
            : json["ctg_id"],
        hsnCode: (["", null, false, 0].contains(json["hsn_code"]))
            ? ""
            : json["hsn_code"],
        mrp: json["mrp"],
        //  (json["mrp"] is int) ? json["mrp"] : int.tryParse(json["mrp"]) ?? 0,
        sellPrice: json["sell_price"],
        //  (json["sell_price"] is int)
        //     ? json["sell_price"]
        //     : int.tryParse(json["sell_price"]) ?? 0,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "code": code,
        "name": name,
        "ctg_id": ctgId,
        "hsn_code": hsnCode,
        "mrp": mrp,
        "sell_price": sellPrice,
      };
}
