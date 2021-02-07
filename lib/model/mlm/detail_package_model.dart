// To parse this JSON data, do
//
//     final detailPackageModel = detailPackageModelFromJson(jsonString);

import 'dart:convert';

DetailPackageModel detailPackageModelFromJson(String str) => DetailPackageModel.fromJson(json.decode(str));

String detailPackageModelToJson(DetailPackageModel data) => json.encode(data.toJson());

class DetailPackageModel {
  DetailPackageModel({
    this.result,
    this.msg,
    this.status,
  });

  Result result;
  String msg;
  String status;

  factory DetailPackageModel.fromJson(Map<String, dynamic> json) => DetailPackageModel(
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
    this.title,
    this.deskripsi,
    this.idKategori,
    this.kategori,
    this.badge,
    this.jumlahBarang,
    this.jumlahPin,
    this.status,
    this.pointVolume,
    this.type,
    this.level,
    this.berat,
    this.harga,
    this.stock,
    this.foto,
    this.createdAt,
    this.updatedAt,
    this.detail,
  });

  String totalrecords;
  String id;
  String title;
  String deskripsi;
  String idKategori;
  String kategori;
  String badge;
  String jumlahBarang;
  String jumlahPin;
  int status;
  int pointVolume;
  int type;
  int level;
  String berat;
  String harga;
  String stock;
  String foto;
  DateTime createdAt;
  DateTime updatedAt;
  List<Detail> detail;

  factory Result.fromJson(Map<String, dynamic> json) => Result(
    totalrecords: json["totalrecords"],
    id: json["id"],
    title: json["title"],
    deskripsi: json["deskripsi"],
    idKategori: json["id_kategori"],
    kategori: json["kategori"],
    badge: json["badge"],
    jumlahBarang: json["jumlah_barang"],
    jumlahPin: json["jumlah_pin"],
    status: json["status"],
    pointVolume: json["point_volume"],
    type: json["type"],
    level: json["level"],
    berat: json["berat"],
    harga: json["harga"],
    stock: json["stock"],
    foto: json["foto"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
    detail: List<Detail>.from(json["detail"].map((x) => Detail.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "totalrecords": totalrecords,
    "id": id,
    "title": title,
    "deskripsi": deskripsi,
    "id_kategori": idKategori,
    "kategori": kategori,
    "badge": badge,
    "jumlah_barang": jumlahBarang,
    "jumlah_pin": jumlahPin,
    "status": status,
    "point_volume": pointVolume,
    "type": type,
    "level": level,
    "berat": berat,
    "harga": harga,
    "stock": stock,
    "foto": foto,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
    "detail": List<dynamic>.from(detail.map((x) => x.toJson())),
  };
}

class Detail {
  Detail({
    this.id,
    this.idPaket,
    this.idBarang,
    this.barang,
    this.harga,
    this.ppn,
    this.satuan,
    this.qty,
    this.berat,
    this.isbonus,
    this.createdAt,
    this.updatedAt,
    this.stock,
    this.stockBarang,
  });

  String id;
  String idPaket;
  String idBarang;
  String barang;
  String harga;
  String ppn;
  String satuan;
  int qty;
  String berat;
  int isbonus;
  DateTime createdAt;
  DateTime updatedAt;
  String stock;
  String stockBarang;

  factory Detail.fromJson(Map<String, dynamic> json) => Detail(
    id: json["id"],
    idPaket: json["id_paket"],
    idBarang: json["id_barang"],
    barang: json["barang"],
    harga: json["harga"],
    ppn: json["ppn"],
    satuan: json["satuan"],
    qty: json["qty"],
    berat: json["berat"],
    isbonus: json["isbonus"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
    stock: json["stock"],
    stockBarang: json["stock_barang"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "id_paket": idPaket,
    "id_barang": idBarang,
    "barang": barang,
    "harga": harga,
    "ppn": ppn,
    "satuan": satuan,
    "qty": qty,
    "berat": berat,
    "isbonus": isbonus,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
    "stock": stock,
    "stock_barang": stockBarang,
  };
}
