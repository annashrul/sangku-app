// To parse this JSON data, do
//
//     final configWalletModel = configWalletModelFromJson(jsonString);

import 'dart:convert';

ConfigWalletModel configWalletModelFromJson(String str) => ConfigWalletModel.fromJson(json.decode(str));

String configWalletModelToJson(ConfigWalletModel data) => json.encode(data.toJson());

class ConfigWalletModel {
  ConfigWalletModel({
    this.result,
    this.msg,
    this.status,
  });

  Result result;
  String msg;
  String status;

  factory ConfigWalletModel.fromJson(Map<String, dynamic> json) => ConfigWalletModel(
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
    this.wdCharge,
    this.tfCharge,
    this.dpMin,
    this.wdMin,
    this.tfMin,
    this.saldo,
    this.trxWd,
    this.trxDp,
    this.isHaveKtp,
  });

  String wdCharge;
  String tfCharge;
  String dpMin;
  String wdMin;
  String tfMin;
  String saldo;
  String trxWd;
  String trxDp;
  bool isHaveKtp;

  factory Result.fromJson(Map<String, dynamic> json) => Result(
    wdCharge: json["wd_charge"],
    tfCharge: json["tf_charge"],
    dpMin: json["dp_min"],
    wdMin: json["wd_min"],
    tfMin: json["tf_min"],
    saldo: json["saldo"],
    trxWd: json["trx_wd"],
    trxDp: json["trx_dp"],
    isHaveKtp: json["is_have_ktp"],
  );

  Map<String, dynamic> toJson() => {
    "wd_charge": wdCharge,
    "tf_charge": tfCharge,
    "dp_min": dpMin,
    "wd_min": wdMin,
    "tf_min": tfMin,
    "saldo": saldo,
    "trx_wd": trxWd,
    "trx_dp": trxDp,
    "is_have_ktp": isHaveKtp,
  };
}
