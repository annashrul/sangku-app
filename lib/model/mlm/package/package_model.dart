// To parse this JSON data, do
//
//     final packageModel = packageModelFromJson(jsonString);

import 'dart:convert';

PackageModel packageModelFromJson(String str) => PackageModel.fromJson(json.decode(str));

String packageModelToJson(PackageModel data) => json.encode(data.toJson());

class PackageModel {
  PackageModel({
    this.result,
    this.msg,
    this.status,
  });

  Result result;
  String msg;
  String status;

  factory PackageModel.fromJson(Map<String, dynamic> json) => PackageModel(
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
    this.title,
    this.deskripsi,
    this.idKategori,
    this.kategori,
    this.harga,
    this.ppn,
    this.badge,
    this.jumlahBarang,
    this.jumlahPin,
    this.status,
    this.pointVolume,
    this.type,
    this.berat,
    this.stock,
    this.foto,
    this.createdAt,
    this.updatedAt,
  });

  String totalrecords;
  String id;
  String title;
  String deskripsi;
  String idKategori;
  String kategori;
  String harga;
  String ppn;
  String badge;
  String jumlahBarang;
  String jumlahPin;
  var status;
  var pointVolume;
  String type;
  String berat;
  String stock;
  String foto;
  DateTime createdAt;
  DateTime updatedAt;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    totalrecords: json["totalrecords"],
    id: json["id"],
    title: json["title"],
    deskripsi: json["deskripsi"],
    idKategori: json["id_kategori"],
    kategori: json["kategori"],
    harga: json["harga"],
    ppn: json["ppn"],
    badge: json["badge"],
    jumlahBarang: json["jumlah_barang"],
    jumlahPin: json["jumlah_pin"],
    status: json["status"],
    pointVolume: json["point_volume"],
    type: json["type"],
    berat: json["berat"],
    stock: json["stock"],
    foto: json["foto"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "totalrecords": totalrecords,
    "id": id,
    "title": title,
    "deskripsi": deskripsi,
    "id_kategori": idKategori,
    "kategori": kategori,
    "harga": harga,
    "ppn": ppn,
    "badge": badge,
    "jumlah_barang": jumlahBarang,
    "jumlah_pin": jumlahPin,
    "status": status,
    "point_volume": pointVolume,
    "type": type,
    "berat": berat,
    "stock": stock,
    "foto": foto,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
  };
}
