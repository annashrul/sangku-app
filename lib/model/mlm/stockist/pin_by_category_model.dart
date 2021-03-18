// To parse this JSON data, do
//
//     final pinByCategoryModel = pinByCategoryModelFromJson(jsonString);

import 'dart:convert';

PinByCategoryModel pinByCategoryModelFromJson(String str) => PinByCategoryModel.fromJson(json.decode(str));

String pinByCategoryModelToJson(PinByCategoryModel data) => json.encode(data.toJson());

class PinByCategoryModel {
  PinByCategoryModel({
    this.result,
    this.msg,
    this.status,
  });

  Result result;
  String msg;
  String status;

  factory PinByCategoryModel.fromJson(Map<String, dynamic> json) => PinByCategoryModel(
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
    this.total,
    this.perPage,
    this.offset,
    this.to,
    this.lastPage,
    this.currentPage,
    this.from,
    this.data,
  });

  int total;
  int perPage;
  int offset;
  int to;
  int lastPage;
  int currentPage;
  int from;
  List<Datum> data;

  factory Result.fromJson(Map<String, dynamic> json) => Result(
    total: json["total"],
    perPage: json["per_page"],
    offset: json["offset"],
    to: json["to"],
    lastPage: json["last_page"],
    currentPage: json["current_page"],
    from: json["from"],
    data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "total": total,
    "per_page": perPage,
    "offset": offset,
    "to": to,
    "last_page": lastPage,
    "current_page": currentPage,
    "from": from,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class Datum {
  Datum({
    this.totalrecords,
    this.id,
    this.idMember,
    this.fullName,
    this.idPin,
    this.kode,
    this.paket,
    this.pointVolume,
    this.category,
    this.createdAt,
    this.updatedAt,
  });

  String totalrecords;
  String id;
  String idMember;
  String fullName;
  String idPin;
  String kode;
  String paket;
  int pointVolume;
  String category;
  DateTime createdAt;
  DateTime updatedAt;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    totalrecords: json["totalrecords"],
    id: json["id"],
    idMember: json["id_member"],
    fullName: json["full_name"],
    idPin: json["id_pin"],
    kode: json["kode"],
    paket: json["paket"],
    pointVolume: json["point_volume"],
    category: json["category"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "totalrecords": totalrecords,
    "id": id,
    "id_member": idMember,
    "full_name": fullName,
    "id_pin": idPin,
    "kode": kode,
    "paket": paket,
    "point_volume": pointVolume,
    "category": category,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
  };
}
