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

  Result result;
  String msg;
  String status;

  factory PinAvailableModel.fromJson(Map<String, dynamic> json) => PinAvailableModel(
    result: Result.fromJson(json["result"]),
    msg: json["msg"],
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "result": result.toJson(),
    "msg": msg,
    "status": status,
  };
}

class Result {
  Result({
    this.data,
    this.totalPin,
  });

  List<Datum> data;
  String totalPin;

  factory Result.fromJson(Map<String, dynamic> json) => Result(
    data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
    totalPin: json["total_pin"],
  );

  Map<String, dynamic> toJson() => {
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
    "total_pin": totalPin,
  };
}

class Datum {
  Datum({
    this.id,
    this.title,
    this.badge,
    this.jumlah,
  });

  String id;
  String title;
  String badge;
  int jumlah;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
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
