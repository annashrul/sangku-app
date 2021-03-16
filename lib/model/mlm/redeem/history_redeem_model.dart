// To parse this JSON data, do
//
//     final historyRedeemModel = historyRedeemModelFromJson(jsonString);

import 'dart:convert';

HistoryRedeemModel historyRedeemModelFromJson(String str) => HistoryRedeemModel.fromJson(json.decode(str));

String historyRedeemModelToJson(HistoryRedeemModel data) => json.encode(data.toJson());

class HistoryRedeemModel {
  HistoryRedeemModel({
    this.result,
    this.msg,
    this.status,
  });

  Result result;
  String msg;
  String status;

  factory HistoryRedeemModel.fromJson(Map<String, dynamic> json) => HistoryRedeemModel(
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
    this.idMember,
    this.fullName,
    this.subtotal,
    this.ongkir,
    this.layananPengiriman,
    this.title,
    this.gambar,
    this.status,
    this.alamat,
    this.mainAddress,
    this.penerima,
    this.idBarang,
    this.resi,
    this.validResi,
    this.createResi,
    this.tglTerima,
    this.createdAt,
  });

  String totalrecords;
  String id;
  String kdTrx;
  String idMember;
  String fullName;
  String subtotal;
  String ongkir;
  String layananPengiriman;
  String title;
  String gambar;
  int status;
  String alamat;
  String mainAddress;
  String penerima;
  String idBarang;
  String resi;
  int validResi;
  dynamic createResi;
  dynamic tglTerima;
  DateTime createdAt;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    totalrecords: json["totalrecords"],
    id: json["id"],
    kdTrx: json["kd_trx"],
    idMember: json["id_member"],
    fullName: json["full_name"],
    subtotal: json["subtotal"],
    ongkir: json["ongkir"],
    layananPengiriman: json["layanan_pengiriman"],
    title: json["title"],
    gambar: json["gambar"],
    status: json["status"],
    alamat: json["alamat"],
    mainAddress: json["main_address"],
    penerima: json["penerima"],
    idBarang: json["id_barang"],
    resi: json["resi"],
    validResi: json["valid_resi"],
    createResi: json["create_resi"],
    tglTerima: json["tgl_terima"],
    createdAt: DateTime.parse(json["created_at"]),
  );

  Map<String, dynamic> toJson() => {
    "totalrecords": totalrecords,
    "id": id,
    "kd_trx": kdTrx,
    "id_member": idMember,
    "full_name": fullName,
    "subtotal": subtotal,
    "ongkir": ongkir,
    "layanan_pengiriman": layananPengiriman,
    "title": title,
    "gambar": gambar,
    "status": status,
    "alamat": alamat,
    "main_address": mainAddress,
    "penerima": penerima,
    "id_barang": idBarang,
    "resi": resi,
    "valid_resi": validResi,
    "create_resi": createResi,
    "tgl_terima": tglTerima,
    "created_at": createdAt.toIso8601String(),
  };
}
