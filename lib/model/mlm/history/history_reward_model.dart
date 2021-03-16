// To parse this JSON data, do
//
//     final historyRewardModel = historyRewardModelFromJson(jsonString);

import 'dart:convert';

HistoryRewardModel historyRewardModelFromJson(String str) => HistoryRewardModel.fromJson(json.decode(str));

String historyRewardModelToJson(HistoryRewardModel data) => json.encode(data.toJson());

class HistoryRewardModel {
  HistoryRewardModel({
    this.result,
    this.msg,
    this.status,
  });

  Result result;
  String msg;
  String status;

  factory HistoryRewardModel.fromJson(Map<String, dynamic> json) => HistoryRewardModel(
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
    this.karir,
    this.status,
    this.alamat,
    this.resi,
    this.tglTerima,
    this.createdAt,
    this.reward,
    this.gambar,
    this.penerima,
    this.mainAddress,
    this.noHp,
  });

  String totalrecords;
  String id;
  String kdTrx;
  String idMember;
  String karir;
  int status;
  String alamat;
  String resi;
  dynamic tglTerima;
  DateTime createdAt;
  String reward;
  String gambar;
  String penerima;
  String mainAddress;
  String noHp;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    totalrecords: json["totalrecords"],
    id: json["id"],
    kdTrx: json["kd_trx"],
    idMember: json["id_member"],
    karir: json["karir"],
    status: json["status"],
    alamat: json["alamat"],
    resi: json["resi"],
    tglTerima: json["tgl_terima"],
    createdAt: DateTime.parse(json["created_at"]),
    reward: json["reward"],
    gambar: json["gambar"],
    penerima: json["penerima"],
    mainAddress: json["main_address"],
    noHp: json["no_hp"],
  );

  Map<String, dynamic> toJson() => {
    "totalrecords": totalrecords,
    "id": id,
    "kd_trx": kdTrx,
    "id_member": idMember,
    "karir": karir,
    "status": status,
    "alamat": alamat,
    "resi": resi,
    "tgl_terima": tglTerima,
    "created_at": createdAt.toIso8601String(),
    "reward": reward,
    "gambar": gambar,
    "penerima": penerima,
    "main_address": mainAddress,
    "no_hp": noHp,
  };
}
