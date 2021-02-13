// To parse this JSON data, do
//
//     final availableMemberModel = availableMemberModelFromJson(jsonString);

import 'dart:convert';

AvailableMemberModel availableMemberModelFromJson(String str) => AvailableMemberModel.fromJson(json.decode(str));

String availableMemberModelToJson(AvailableMemberModel data) => json.encode(data.toJson());

class AvailableMemberModel {
  AvailableMemberModel({
    this.result,
    this.msg,
    this.status,
  });

  Result result;
  String msg;
  String status;

  factory AvailableMemberModel.fromJson(Map<String, dynamic> json) => AvailableMemberModel(
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
    this.fullName,
    this.referralCode,
    this.status,
    this.badge,
    this.picture,
    this.createdAt,
  });

  String id;
  String fullName;
  String referralCode;
  int status;
  String badge;
  String picture;
  DateTime createdAt;

  factory Result.fromJson(Map<String, dynamic> json) => Result(
    id: json["id"],
    fullName: json["full_name"],
    referralCode: json["referral_code"],
    status: json["status"],
    badge: json["badge"],
    picture: json["picture"],
    createdAt: DateTime.parse(json["created_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "full_name": fullName,
    "referral_code": referralCode,
    "status": status,
    "badge": badge,
    "picture": picture,
    "created_at": createdAt.toIso8601String(),
  };
}
