// To parse this JSON data, do
//
//     final historyPpobModel = historyPpobModelFromJson(jsonString);

import 'dart:convert';

HistoryPpobModel historyPpobModelFromJson(String str) => HistoryPpobModel.fromJson(json.decode(str));

String historyPpobModelToJson(HistoryPpobModel data) => json.encode(data.toJson());

class HistoryPpobModel {
  HistoryPpobModel({
    this.result,
    this.msg,
    this.status,
  });

  Result result;
  String msg;
  String status;

  factory HistoryPpobModel.fromJson(Map<String, dynamic> json) => HistoryPpobModel(
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
    this.kdTrx,
    this.fullName,
    this.target,
    this.operators,
    this.produk,
    this.harga,
    this.status,
    this.tipe,
    this.kategori,
    this.createdAt,
    this.logo,
    this.icon,
  });

  String totalrecords;
  String id;
  String kdTrx;
  String fullName;
  String target;
  String operators;
  String produk;
  String harga;
  int status;
  int tipe;
  String kategori;
  DateTime createdAt;
  String logo;
  String icon;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    totalrecords: json["totalrecords"],
    id: json["id"],
    kdTrx: json["kd_trx"],
    fullName: json["full_name"],
    target: json["target"],
    operators: json["operators"],
    produk: json["produk"],
    harga: json["harga"],
    status: json["status"],
    tipe: json["tipe"],
    kategori: json["kategori"],
    createdAt: DateTime.parse(json["created_at"]),
    logo: json["logo"],
    icon: json["icon"],
  );

  Map<String, dynamic> toJson() => {
    "totalrecords": totalrecords,
    "id": id,
    "kd_trx": kdTrx,
    "full_name": fullName,
    "target": target,
    "operators": operators,
    "produk": produk,
    "harga": harga,
    "status": status,
    "tipe": tipe,
    "kategori": kategori,
    "created_at": createdAt.toIso8601String(),
    "logo": logo,
    "icon": icon,
  };
}
