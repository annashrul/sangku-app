// To parse this JSON data, do
//
//     final historyPemberlianModel = historyPemberlianModelFromJson(jsonString);

import 'dart:convert';

HistoryPemberlianModel historyPemberlianModelFromJson(String str) => HistoryPemberlianModel.fromJson(json.decode(str));

String historyPemberlianModelToJson(HistoryPemberlianModel data) => json.encode(data.toJson());

class HistoryPemberlianModel {
  HistoryPemberlianModel({
    this.result,
    this.msg,
    this.status,
  });

  Result result;
  String msg;
  String status;

  factory HistoryPemberlianModel.fromJson(Map<String, dynamic> json) => HistoryPemberlianModel(
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
    this.id,
    this.kdTrx,
    this.idMember,
    this.fullName,
    this.deviceId,
    this.subtotal,
    this.ongkir,
    this.grandTotal,
    this.layananPengiriman,
    this.kurir,
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
  String kurir;
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

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["id"],
    kdTrx: json["kd_trx"],
    idMember: json["id_member"],
    fullName: json["full_name"],
    deviceId: json["device_id"],
    subtotal: json["subtotal"],
    ongkir: json["ongkir"],
    grandTotal: json["grand_total"],
    layananPengiriman: json["layanan_pengiriman"],
    kurir: json["kurir"],
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
    "kurir": kurir,
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
    this.type,
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
  int type;
  String price;
  int qty;
  int ppn;
  DateTime createdAt;
  DateTime updatedAt;
  String listPin;

  factory Detail.fromJson(Map<String, dynamic> json) => Detail(
    id: json["id"],
    kdTrx: json["kd_trx"],
    idMember: json["id_member"],
    idPaket: json["id_paket"],
    paket: json["paket"],
    foto: json["foto"],
    pointVolume: json["point_volume"],
    type: json["type"],
    price: json["price"],
    qty: json["qty"],
    ppn: json["ppn"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
    listPin: json["list_pin"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "kd_trx": kdTrx,
    "id_member": idMember,
    "id_paket": idPaket,
    "paket": paket,
    "foto": foto,
    "point_volume": pointVolume,
    "type": type,
    "price": price,
    "qty": qty,
    "ppn": ppn,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
    "list_pin": listPin,
  };
}
