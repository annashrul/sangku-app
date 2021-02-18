// To parse this JSON data, do
//
//     final cekTagihanModel = cekTagihanModelFromJson(jsonString);

import 'dart:convert';

CekTagihanModel cekTagihanModelFromJson(String str) => CekTagihanModel.fromJson(json.decode(str));

String cekTagihanModelToJson(CekTagihanModel data) => json.encode(data.toJson());

class CekTagihanModel {
  CekTagihanModel({
    this.result,
    this.msg,
    this.status,
  });

  Result result;
  String msg;
  String status;

  factory CekTagihanModel.fromJson(Map<String, dynamic> json) => CekTagihanModel(
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
    this.kdTrx,
    this.target,
    this.noPelanggan,
    this.namaPalanggan,
    this.periode,
    this.produk,
    this.admin,
    this.tagihan,
    this.totalBayar,
  });

  String kdTrx;
  String target;
  String noPelanggan;
  String namaPalanggan;
  String periode;
  String produk;
  int admin;
  int tagihan;
  int totalBayar;

  factory Result.fromJson(Map<String, dynamic> json) => Result(
    kdTrx: json["kd_trx"],
    target: json["target"],
    noPelanggan: json["no_pelanggan"],
    namaPalanggan: json["nama_palanggan"],
    periode: json["periode"],
    produk: json["produk"],
    admin: json["admin"],
    tagihan: json["tagihan"],
    totalBayar: json["total_bayar"],
  );

  Map<String, dynamic> toJson() => {
    "kd_trx": kdTrx,
    "target": target,
    "no_pelanggan": noPelanggan,
    "nama_palanggan": namaPalanggan,
    "periode": periode,
    "produk": produk,
    "admin": admin,
    "tagihan": tagihan,
    "total_bayar": totalBayar,
  };
}
