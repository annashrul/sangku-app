// To parse this JSON data, do
//
//     final rekapitulasiModel = rekapitulasiModelFromJson(jsonString);

import 'dart:convert';

RekapitulasiModel rekapitulasiModelFromJson(String str) => RekapitulasiModel.fromJson(json.decode(str));

String rekapitulasiModelToJson(RekapitulasiModel data) => json.encode(data.toJson());

class RekapitulasiModel {
  RekapitulasiModel({
    this.result,
    this.msg,
    this.status,
  });

  Result result;
  String msg;
  String status;

  factory RekapitulasiModel.fromJson(Map<String, dynamic> json) => RekapitulasiModel(
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
    this.tabunganKiri,
    this.tabunganKanan,
    this.pertumbuhanKiri,
    this.pertumbuhanKanan,
    this.balanceKanan,
    this.balanceKiri,
    this.nominalBonus,
    this.hakBonus,
    this.pairingBonus,
    this.sisaPlafon,
    this.membership,
    this.badge,
  });

  int tabunganKiri;
  int tabunganKanan;
  int pertumbuhanKiri;
  int pertumbuhanKanan;
  int balanceKanan;
  int balanceKiri;
  int nominalBonus;
  int hakBonus;
  int pairingBonus;
  int sisaPlafon;
  String membership;
  String badge;

  factory Result.fromJson(Map<String, dynamic> json) => Result(
    tabunganKiri: json["tabungan_kiri"],
    tabunganKanan: json["tabungan_kanan"],
    pertumbuhanKiri: json["pertumbuhan_kiri"],
    pertumbuhanKanan: json["pertumbuhan_kanan"],
    balanceKanan: json["balance_kanan"],
    balanceKiri: json["balance_kiri"],
    nominalBonus: json["nominal_bonus"],
    hakBonus: json["hak_bonus"],
    pairingBonus: json["pairing_bonus"],
    sisaPlafon: json["sisa_plafon"],
    membership: json["membership"],
    badge: json["badge"],
  );

  Map<String, dynamic> toJson() => {
    "tabungan_kiri": tabunganKiri,
    "tabungan_kanan": tabunganKanan,
    "pertumbuhan_kiri": pertumbuhanKiri,
    "pertumbuhan_kanan": pertumbuhanKanan,
    "balance_kanan": balanceKanan,
    "balance_kiri": balanceKiri,
    "nominal_bonus": nominalBonus,
    "hak_bonus": hakBonus,
    "pairing_bonus": pairingBonus,
    "sisa_plafon": sisaPlafon,
    "membership": membership,
    "badge": badge,
  };
}
