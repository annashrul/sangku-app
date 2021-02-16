// To parse this JSON data, do
//
//     final detailHistoryPpobModel = detailHistoryPpobModelFromJson(jsonString);

import 'dart:convert';

DetailHistoryPpobModel detailHistoryPpobModelFromJson(String str) => DetailHistoryPpobModel.fromJson(json.decode(str));

String detailHistoryPpobModelToJson(DetailHistoryPpobModel data) => json.encode(data.toJson());

class DetailHistoryPpobModel {
  DetailHistoryPpobModel({
    this.result,
    this.msg,
    this.status,
  });

  Result result;
  String msg;
  String status;

  factory DetailHistoryPpobModel.fromJson(Map<String, dynamic> json) => DetailHistoryPpobModel(
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
    this.logo,
    this.icon,
    this.mtrPln,
    this.note,
    this.token,
    this.tagihan,
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
  String logo;
  String icon;
  String mtrPln;
  String note;
  dynamic token;
  Tagihan tagihan;

  factory Result.fromJson(Map<String, dynamic> json) => Result(
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
    logo: json["logo"],
    icon: json["icon"],
    mtrPln: json["mtr_pln"],
    note: json["note"],
    token: json["token"],
    tagihan: Tagihan.fromJson(json["tagihan"]),
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
    "logo": logo,
    "icon": icon,
    "mtr_pln": mtrPln,
    "note": note,
    "token": token,
    "tagihan": tagihan.toJson(),
  };
}

class Tagihan {
  Tagihan({
    this.noPelanggan,
    this.namaPalanggan,
    this.periode,
    this.admin,
    this.tagihan,
    this.totalBayar,
  });

  String noPelanggan;
  String namaPalanggan;
  String periode;
  int admin;
  int tagihan;
  int totalBayar;

  factory Tagihan.fromJson(Map<String, dynamic> json) => Tagihan(
    noPelanggan: json["no_pelanggan"],
    namaPalanggan: json["nama_palanggan"],
    periode: json["periode"],
    admin: json["admin"],
    tagihan: json["tagihan"],
    totalBayar: json["total_bayar"],
  );

  Map<String, dynamic> toJson() => {
    "no_pelanggan": noPelanggan,
    "nama_palanggan": namaPalanggan,
    "periode": periode,
    "admin": admin,
    "tagihan": tagihan,
    "total_bayar": totalBayar,
  };
}
