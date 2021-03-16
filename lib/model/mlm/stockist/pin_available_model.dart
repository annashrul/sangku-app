// To parse this JSON data, do
//
//     final pinAvailableModel = pinAvailableModelFromJson(jsonString);

import 'dart:convert';

PinAvailableModel pinAvailableModelFromJson(String str) => PinAvailableModel.fromJson(json.decode(str));

String pinAvailableModelToJson(PinAvailableModel data) => json.encode(data.toJson());

class PinAvailableModel {
  PinAvailableModel({
    this.result,
    this.msg,
    this.status,
  });

  List<Result> result;
  String msg;
  String status;

  factory PinAvailableModel.fromJson(Map<String, dynamic> json) => PinAvailableModel(
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
    this.badge,
    this.jumlah,
  });

  String id;
  String title;
  String badge;
  String jumlah;

  factory Result.fromJson(Map<String, dynamic> json) => Result(
    id: json["id"],
    title: json["title"],
    badge: json["badge"],
    jumlah: json["jumlah"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "badge": badge,
    "jumlah": jumlah,
  };
}
