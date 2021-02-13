// To parse this JSON data, do
//
//     final pinModel = pinModelFromJson(jsonString);

import 'dart:convert';

PinModel pinModelFromJson(String str) => PinModel.fromJson(json.decode(str));

String pinModelToJson(PinModel data) => json.encode(data.toJson());

class PinModel {
  PinModel({
    this.result,
    this.msg,
    this.status,
  });

  Result result;
  String msg;
  String status;

  factory PinModel.fromJson(Map<String, dynamic> json) => PinModel(
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
    this.category,
    this.statusRaw,
    this.status,
    this.keterangan,
    this.createdAt,
    this.updatedAt,
    this.type,
  });

  String totalrecords;
  String id;
  String idMember;
  String fullName;
  String idPin;
  String kode;
  dynamic category;
  int statusRaw;
  String status;
  String keterangan;
  DateTime createdAt;
  DateTime updatedAt;
  int type;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    totalrecords: json["totalrecords"],
    id: json["id"],
    idMember: json["id_member"],
    fullName: json["full_name"],
    idPin: json["id_pin"],
    kode: json["kode"],
    category: json["category"],
    statusRaw: json["status_raw"],
    status: json["status"],
    keterangan: json["keterangan"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
    type: json["type"],
  );

  Map<String, dynamic> toJson() => {
    "totalrecords": totalrecords,
    "id": id,
    "id_member": idMember,
    "full_name": fullName,
    "id_pin": idPin,
    "kode": kode,
    "category": category,
    "status_raw": statusRaw,
    "status": status,
    "keterangan": keterangan,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
    "type": type,
  };
}
