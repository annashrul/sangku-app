// To parse this JSON data, do
//
//     final getVoucherModel = getVoucherModelFromJson(jsonString);

import 'dart:convert';

GetVoucherModel getVoucherModelFromJson(String str) => GetVoucherModel.fromJson(json.decode(str));

String getVoucherModelToJson(GetVoucherModel data) => json.encode(data.toJson());

class GetVoucherModel {
  GetVoucherModel({
    this.result,
    this.msg,
    this.status,
  });

  Result result;
  String msg;
  String status;

  factory GetVoucherModel.fromJson(Map<String, dynamic> json) => GetVoucherModel(
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
    this.id,
    this.title,
    this.deskripsi,
    this.kode,
    this.maxUses,
    this.maxUsesUser,
    this.disc,
    this.isFixed,
    this.periodeStart,
    this.periodeEnd,
    this.status,
    this.createdAt,
    this.updatedAt,
  });

  String id;
  String title;
  String deskripsi;
  String kode;
  int maxUses;
  int maxUsesUser;
  int disc;
  int isFixed;
  DateTime periodeStart;
  DateTime periodeEnd;
  int status;
  DateTime createdAt;
  DateTime updatedAt;

  factory Result.fromJson(Map<String, dynamic> json) => Result(
    id: json["id"],
    title: json["title"],
    deskripsi: json["deskripsi"],
    kode: json["kode"],
    maxUses: json["max_uses"],
    maxUsesUser: json["max_uses_user"],
    disc: json["disc"],
    isFixed: json["is_fixed"],
    periodeStart: DateTime.parse(json["periode_start"]),
    periodeEnd: DateTime.parse(json["periode_end"]),
    status: json["status"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "deskripsi": deskripsi,
    "kode": kode,
    "max_uses": maxUses,
    "max_uses_user": maxUsesUser,
    "disc": disc,
    "is_fixed": isFixed,
    "periode_start": periodeStart.toIso8601String(),
    "periode_end": periodeEnd.toIso8601String(),
    "status": status,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
  };
}
