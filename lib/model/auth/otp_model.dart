// To parse this JSON data, do
//
//     final otpModel = otpModelFromJson(jsonString);

import 'dart:convert';

OtpModel otpModelFromJson(String str) => OtpModel.fromJson(json.decode(str));

String otpModelToJson(OtpModel data) => json.encode(data.toJson());

class OtpModel {
  OtpModel({
    this.result,
    this.msg,
    this.status,
  });

  Result result;
  String msg;
  String status;

  factory OtpModel.fromJson(Map<String, dynamic> json) => OtpModel(
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
    this.senderId,
    this.transactionToken,
    this.note,
    this.otpAnying,
  });

  String id;
  String senderId;
  String transactionToken;
  String note;
  String otpAnying;

  factory Result.fromJson(Map<String, dynamic> json) => Result(
    id: json["_id"],
    senderId: json["sender_id"],
    transactionToken: json["transaction_token"],
    note: json["note"],
    otpAnying: json["otp_anying"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "sender_id": senderId,
    "transaction_token": transactionToken,
    "note": note,
    "otp_anying": otpAnying,
  };
}
