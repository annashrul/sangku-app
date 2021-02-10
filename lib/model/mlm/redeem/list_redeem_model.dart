// To parse this JSON data, do
//
//     final listRedeemModel = listRedeemModelFromJson(jsonString);

import 'dart:convert';

ListRedeemModel listRedeemModelFromJson(String str) => ListRedeemModel.fromJson(json.decode(str));

String listRedeemModelToJson(ListRedeemModel data) => json.encode(data.toJson());

class ListRedeemModel {
  ListRedeemModel({
    this.result,
    this.msg,
    this.status,
  });

  Result result;
  String msg;
  String status;

  factory ListRedeemModel.fromJson(Map<String, dynamic> json) => ListRedeemModel(
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
    this.saldo,
  });

  int total;
  int perPage;
  int offset;
  int to;
  int lastPage;
  int currentPage;
  int from;
  List<Datum> data;
  String saldo;

  factory Result.fromJson(Map<String, dynamic> json) => Result(
    total: json["total"],
    perPage: json["per_page"],
    offset: json["offset"],
    to: json["to"],
    lastPage: json["last_page"],
    currentPage: json["current_page"],
    from: json["from"],
    data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
    saldo: json["saldo"],
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
    "saldo": saldo,
  };
}

class Datum {
  Datum({
    this.totalrecords,
    this.id,
    this.title,
    this.deskripsi,
    this.gambar,
    this.stock,
    this.harga,
    this.berat,
  });

  String totalrecords;
  String id;
  String title;
  String deskripsi;
  String gambar;
  String stock;
  String harga;
  int berat;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    totalrecords: json["totalrecords"],
    id: json["id"],
    title: json["title"],
    deskripsi: json["deskripsi"],
    gambar: json["gambar"],
    stock: json["stock"],
    harga: json["harga"],
    berat: json["berat"],
  );

  Map<String, dynamic> toJson() => {
    "totalrecords": totalrecords,
    "id": id,
    "title": title,
    "deskripsi": deskripsi,
    "gambar": gambar,
    "stock": stock,
    "harga": harga,
    "berat": berat,
  };
}
