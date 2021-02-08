// To parse this JSON data, do
//
//     final cartModel = cartModelFromJson(jsonString);

import 'dart:convert';

CartModel cartModelFromJson(String str) => CartModel.fromJson(json.decode(str));

String cartModelToJson(CartModel data) => json.encode(data.toJson());

class CartModel {
  CartModel({
    this.result,
    this.msg,
    this.status,
  });

  List<Result> result;
  String msg;
  String status;

  factory CartModel.fromJson(Map<String, dynamic> json) => CartModel(
    result: List<Result>.from(json["result"].map((x) => Result.fromJson(x))),
    msg: json["msg"],
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "result": List<dynamic>.from(result.map((x) => x.toJson())),
    "msg": msg,
    "status": status,
  };
}

class Result {
  Result({
    this.id,
    this.idMember,
    this.fullName,
    this.title,
    this.foto,
    this.kategori,
    this.pointVolume,
    this.harga,
    this.berat,
    this.type,
    this.qty,
    this.createdAt,
    this.updatedAt,
    this.idPaket,
    this.bobot,
    this.saldo,
  });

  String id;
  String idMember;
  String fullName;
  String title;
  String foto;
  String kategori;
  int pointVolume;
  String harga;
  int berat;
  int type;
  int qty;
  DateTime createdAt;
  DateTime updatedAt;
  String idPaket;
  int bobot;
  String saldo;

  factory Result.fromJson(Map<String, dynamic> json) => Result(
    id: json["id"],
    idMember: json["id_member"],
    fullName: json["full_name"],
    title: json["title"],
    foto: json["foto"],
    kategori: json["kategori"],
    pointVolume: json["point_volume"],
    harga: json["harga"],
    berat: json["berat"],
    type: json["type"],
    qty: json["qty"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
    idPaket: json["id_paket"],
    bobot: json["bobot"],
    saldo: json["saldo"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "id_member": idMember,
    "full_name": fullName,
    "title": title,
    "foto": foto,
    "kategori": kategori,
    "point_volume": pointVolume,
    "harga": harga,
    "berat": berat,
    "type": type,
    "qty": qty,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
    "id_paket": idPaket,
    "bobot": bobot,
    "saldo": saldo,
  };
}
