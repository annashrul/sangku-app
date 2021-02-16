// To parse this JSON data, do
//
//     final menuPpobModel = menuPpobModelFromJson(jsonString);

import 'dart:convert';

MenuPpobModel menuPpobModelFromJson(String str) => MenuPpobModel.fromJson(json.decode(str));

String menuPpobModelToJson(MenuPpobModel data) => json.encode(data.toJson());

class MenuPpobModel {
  MenuPpobModel({
    this.result,
    this.msg,
    this.status,
  });

  Result result;
  String msg;
  String status;

  factory MenuPpobModel.fromJson(Map<String, dynamic> json) => MenuPpobModel(
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
    this.lain,
    this.topup,
    this.tagihan,
  });

  List<Lain> lain;
  List<Lain> topup;
  List<Lain> tagihan;

  factory Result.fromJson(Map<String, dynamic> json) => Result(
    lain: List<Lain>.from(json["LAIN"].map((x) => Lain.fromJson(x))),
    topup: List<Lain>.from(json["TOPUP"].map((x) => Lain.fromJson(x))),
    tagihan: List<Lain>.from(json["TAGIHAN"].map((x) => Lain.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "LAIN": List<dynamic>.from(lain.map((x) => x.toJson())),
    "TOPUP": List<dynamic>.from(topup.map((x) => x.toJson())),
    "TAGIHAN": List<dynamic>.from(tagihan.map((x) => x.toJson())),
  };
}

class Lain {
  Lain({
    this.totalrecords,
    this.id,
    this.code,
    this.title,
    this.type,
    this.status,
    this.logo,
    this.kategori,
  });

  String totalrecords;
  String id;
  int code;
  String title;
  String type;
  int status;
  String logo;
  int kategori;

  factory Lain.fromJson(Map<String, dynamic> json) => Lain(
    totalrecords: json["totalrecords"],
    id: json["id"],
    code: json["code"],
    title: json["title"],
    type: json["type"],
    status: json["status"],
    logo: json["logo"],
    kategori: json["kategori"],
  );

  Map<String, dynamic> toJson() => {
    "totalrecords": totalrecords,
    "id": id,
    "code": code,
    "title": title,
    "type": type,
    "status": status,
    "logo": logo,
    "kategori": kategori,
  };
}
