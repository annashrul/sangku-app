// To parse this JSON data, do
//
//     final loginModel = loginModelFromJson(jsonString);

import 'dart:convert';

LoginModel loginModelFromJson(String str) => LoginModel.fromJson(json.decode(str));

String loginModelToJson(LoginModel data) => json.encode(data.toJson());

class LoginModel {
  LoginModel({
    this.result,
    this.msg,
    this.status,
  });

  Result result;
  String msg;
  String status;

  factory LoginModel.fromJson(Map<String, dynamic> json) => LoginModel(
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
    this.token,
    this.fullName,
    this.mobileNo,
    this.membership,
    this.referralCode,
    this.deviceId,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.picture,
    this.otp,
    this.msgOtp,
  });

  String id;
  String token;
  String fullName;
  String mobileNo;
  String membership;
  String referralCode;
  String deviceId;
  int status;
  DateTime createdAt;
  DateTime updatedAt;
  String picture;
  String otp;
  String msgOtp;

  factory Result.fromJson(Map<String, dynamic> json) => Result(
    id: json["id"],
    token: json["token"],
    fullName: json["full_name"],
    mobileNo: json["mobile_no"],
    membership: json["membership"],
    referralCode: json["referral_code"],
    deviceId: json["device_id"],
    status: json["status"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
    picture: json["picture"],
    otp: json["otp"],
    msgOtp: json["msg_otp"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "token": token,
    "full_name": fullName,
    "mobile_no": mobileNo,
    "membership": membership,
    "referral_code": referralCode,
    "device_id": deviceId,
    "status": status,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
    "picture": picture,
    "otp": otp,
    "msg_otp": msgOtp,
  };
}
