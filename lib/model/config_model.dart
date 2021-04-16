// To parse this JSON data, do
//
//     final configModel = configModelFromJson(jsonString);

import 'dart:convert';

ConfigModel configModelFromJson(String str) => ConfigModel.fromJson(json.decode(str));

String configModelToJson(ConfigModel data) => json.encode(data.toJson());

class ConfigModel {
  ConfigModel({
    this.result,
    this.msg,
    this.status,
  });

  Result result;
  String msg;
  String status;

  factory ConfigModel.fromJson(Map<String, dynamic> json) => ConfigModel(
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
    this.type,
    this.typeOtp,
  });

  String type;
  String typeOtp;

  factory Result.fromJson(Map<String, dynamic> json) => Result(
    type: json["type"],
    typeOtp: json["type_otp"],
  );

  Map<String, dynamic> toJson() => {
    "type": type,
    "type_otp": typeOtp,
  };
}
