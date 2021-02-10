// To parse this JSON data, do
//
//     final detailHistoryPembelianModel = detailHistoryPembelianModelFromJson(jsonString);

import 'dart:convert';

DetailHistoryPembelianModel detailHistoryPembelianModelFromJson(String str) => DetailHistoryPembelianModel.fromJson(json.decode(str));

String detailHistoryPembelianModelToJson(DetailHistoryPembelianModel data) => json.encode(data.toJson());

class DetailHistoryPembelianModel {
  DetailHistoryPembelianModel({
    this.result,
    this.msg,
    this.status,
  });

  Result result;
  String msg;
  String status;

  factory DetailHistoryPembelianModel.fromJson(Map<String, dynamic> json) => DetailHistoryPembelianModel(
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
    this.kdTrx,
    this.idMember,
    this.fullName,
    this.deviceId,
    this.subtotal,
    this.ongkir,
    this.grandTotal,
    this.layananPengiriman,
    this.type,
    this.status,
    this.metodePembayaran,
    this.alamat,
    this.title,
    this.penerima,
    this.mainAddress,
    this.noHp,
    this.resi,
    this.validResi,
    this.createResi,
    this.tglTerima,
    this.createdAt,
    this.updatedAt,
    this.detail,
  });

  String id;
  String kdTrx;
  String idMember;
  String fullName;
  String deviceId;
  String subtotal;
  String ongkir;
  String grandTotal;
  String layananPengiriman;
  int type;
  int status;
  String metodePembayaran;
  String alamat;
  String title;
  String penerima;
  String mainAddress;
  String noHp;
  String resi;
  int validResi;
  dynamic createResi;
  dynamic tglTerima;
  DateTime createdAt;
  DateTime updatedAt;
  List<Detail> detail;

  factory Result.fromJson(Map<String, dynamic> json) => Result(
    id: json["id"],
    kdTrx: json["kd_trx"],
    idMember: json["id_member"],
    fullName: json["full_name"],
    deviceId: json["device_id"],
    subtotal: json["subtotal"],
    ongkir: json["ongkir"],
    grandTotal: json["grand_total"],
    layananPengiriman: json["layanan_pengiriman"],
    type: json["type"],
    status: json["status"],
    metodePembayaran: json["metode_pembayaran"],
    alamat: json["alamat"],
    title: json["title"],
    penerima: json["penerima"],
    mainAddress: json["main_address"],
    noHp: json["no_hp"],
    resi: json["resi"],
    validResi: json["valid_resi"],
    createResi: json["create_resi"],
    tglTerima: json["tgl_terima"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
    detail: List<Detail>.from(json["detail"].map((x) => Detail.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "kd_trx": kdTrx,
    "id_member": idMember,
    "full_name": fullName,
    "device_id": deviceId,
    "subtotal": subtotal,
    "ongkir": ongkir,
    "grand_total": grandTotal,
    "layanan_pengiriman": layananPengiriman,
    "type": type,
    "status": status,
    "metode_pembayaran": metodePembayaran,
    "alamat": alamat,
    "title": title,
    "penerima": penerima,
    "main_address": mainAddress,
    "no_hp": noHp,
    "resi": resi,
    "valid_resi": validResi,
    "create_resi": createResi,
    "tgl_terima": tglTerima,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
    "detail": List<dynamic>.from(detail.map((x) => x.toJson())),
  };
}

class Detail {
  Detail({
    this.id,
    this.kdTrx,
    this.idMember,
    this.idPaket,
    this.paket,
    this.foto,
    this.pointVolume,
    this.price,
    this.qty,
    this.ppn,
    this.createdAt,
    this.updatedAt,
    this.listPin,
  });

  String id;
  String kdTrx;
  String idMember;
  String idPaket;
  String paket;
  String foto;
  int pointVolume;
  String price;
  int qty;
  int ppn;
  DateTime createdAt;
  DateTime updatedAt;
  List<ListPin> listPin;

  factory Detail.fromJson(Map<String, dynamic> json) => Detail(
    id: json["id"],
    kdTrx: json["kd_trx"],
    idMember: json["id_member"],
    idPaket: json["id_paket"],
    paket: json["paket"],
    foto: json["foto"],
    pointVolume: json["point_volume"],
    price: json["price"],
    qty: json["qty"],
    ppn: json["ppn"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
    listPin: List<ListPin>.from(json["list_pin"].map((x) => ListPin.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "kd_trx": kdTrx,
    "id_member": idMember,
    "id_paket": idPaket,
    "paket": paket,
    "foto": foto,
    "point_volume": pointVolume,
    "price": price,
    "qty": qty,
    "ppn": ppn,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
    "list_pin": List<dynamic>.from(listPin.map((x) => x.toJson())),
  };
}

class ListPin {
  ListPin({
    this.id,
    this.kode,
    this.idPaket,
    this.type,
    this.status,
    this.expDate,
    this.createdAt,
    this.updatedAt,
  });

  String id;
  String kode;
  String idPaket;
  int type;
  int status;
  DateTime expDate;
  DateTime createdAt;
  DateTime updatedAt;

  factory ListPin.fromJson(Map<String, dynamic> json) => ListPin(
    id: json["id"],
    kode: json["kode"],
    idPaket: json["id_paket"],
    type: json["type"],
    status: json["status"],
    expDate: DateTime.parse(json["exp_date"]),
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "kode": kode,
    "id_paket": idPaket,
    "type": type,
    "status": status,
    "exp_date": expDate.toIso8601String(),
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
  };
}
