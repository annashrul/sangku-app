// To parse this JSON data, do
//
//     final dataBankModel = dataBankModelFromJson(jsonString);

import 'dart:convert';

DataBankModel dataBankModelFromJson(String str) => DataBankModel.fromJson(json.decode(str));

String dataBankModelToJson(DataBankModel data) => json.encode(data.toJson());

class DataBankModel {
  DataBankModel({
    this.result,
    this.msg,
    this.status,
  });

  List<Result> result;
  String msg;
  String status;

  factory DataBankModel.fromJson(Map<String, dynamic> json) => DataBankModel(
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
    this.name,
    this.code,
  });

  String id;
  String name;
  String code;

  factory Result.fromJson(Map<String, dynamic> json) => Result(
    id: json["id"],
    name: json["name"],
    code: json["code"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "code": code,
  };
}
