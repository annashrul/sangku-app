// To parse this JSON data, do
//
//     final sitePackageModel = sitePackageModelFromJson(jsonString);

import 'dart:convert';

SitePackageModel sitePackageModelFromJson(String str) => SitePackageModel.fromJson(json.decode(str));

String sitePackageModelToJson(SitePackageModel data) => json.encode(data.toJson());

class SitePackageModel {
  SitePackageModel({
    this.result,
    this.msg,
    this.status,
  });

  List<Result> result;
  String msg;
  String status;

  factory SitePackageModel.fromJson(Map<String, dynamic> json) => SitePackageModel(
    result: List<Result>.from(json["result"].map((x) => Result.fromJson(x))),
    msg: json["msg"],
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "result": List<dynamic>.from(result.map((x) => x.toJson())),
    "msg": msg,
    "status": status,
  };
}

class Result {
  Result({
    this.id,
    this.title,
    this.deskripsi,
    this.concat,
    this.price,
  });

  String id;
  String title;
  String deskripsi;
  String concat;
  String price;

  factory Result.fromJson(Map<String, dynamic> json) => Result(
    id: json["id"],
    title: json["title"],
    deskripsi: json["deskripsi"],
    concat: json["concat"],
    price: json["price"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "deskripsi": deskripsi,
    "concat": concat,
    "price": price,
  };
}
