// To parse this JSON data, do
//
//     final dataMemberModel = dataMemberModelFromJson(jsonString);

import 'dart:convert';

DataMemberModel dataMemberModelFromJson(String str) => DataMemberModel.fromJson(json.decode(str));

String dataMemberModelToJson(DataMemberModel data) => json.encode(data.toJson());

class DataMemberModel {
  DataMemberModel({
    this.result,
    this.msg,
    this.status,
  });

  Result result;
  String msg;
  String status;

  factory DataMemberModel.fromJson(Map<String, dynamic> json) => DataMemberModel(
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
    this.totalrecords,
    this.id,
    this.fullName,
    this.mobileNo,
    this.saldo,
    this.sponsor,
    this.pin,
    this.leftPv,
    this.rightPv,
    this.totalPayment,
    this.membership,
    this.referralCode,
    this.founderIdentity,
    this.deviceId,
    this.signupSource,
    this.status,
    this.leftRewardPoint,
    this.rightRewardPoint,
    this.jenjangKarir,
    this.plafon,
    this.pointRo,
    this.membershipBadge,
    this.jenjangKarirBadge,
    this.idCard,
    this.picture,
    this.createdAt,
  });

  String totalrecords;
  String id;
  String fullName;
  String mobileNo;
  String saldo;
  String sponsor;
  String pin;
  String leftPv;
  String rightPv;
  String totalPayment;
  String membership;
  String referralCode;
  String founderIdentity;
  String deviceId;
  String signupSource;
  int status;
  int leftRewardPoint;
  int rightRewardPoint;
  String jenjangKarir;
  String plafon;
  String pointRo;
  String membershipBadge;
  String jenjangKarirBadge;
  String idCard;
  String picture;
  DateTime createdAt;

  factory Result.fromJson(Map<String, dynamic> json) => Result(
    totalrecords: json["totalrecords"],
    id: json["id"],
    fullName: json["full_name"],
    mobileNo: json["mobile_no"],
    saldo: json["saldo"],
    sponsor: json["sponsor"],
    pin: json["pin"],
    leftPv: json["left_pv"],
    rightPv: json["right_pv"],
    totalPayment: json["total_payment"],
    membership: json["membership"],
    referralCode: json["referral_code"],
    founderIdentity: json["founder_identity"],
    deviceId: json["device_id"],
    signupSource: json["signup_source"],
    status: json["status"],
    leftRewardPoint: json["left_reward_point"],
    rightRewardPoint: json["right_reward_point"],
    jenjangKarir: json["jenjang_karir"],
    plafon: json["plafon"],
    pointRo: json["point_ro"],
    membershipBadge: json["membership_badge"],
    jenjangKarirBadge: json["jenjang_karir_badge"],
    idCard: json["id_card"],
    picture: json["picture"],
    createdAt: DateTime.parse(json["created_at"]),
  );

  Map<String, dynamic> toJson() => {
    "totalrecords": totalrecords,
    "id": id,
    "full_name": fullName,
    "mobile_no": mobileNo,
    "saldo": saldo,
    "sponsor": sponsor,
    "pin": pin,
    "left_pv": leftPv,
    "right_pv": rightPv,
    "total_payment": totalPayment,
    "membership": membership,
    "referral_code": referralCode,
    "founder_identity": founderIdentity,
    "device_id": deviceId,
    "signup_source": signupSource,
    "status": status,
    "left_reward_point": leftRewardPoint,
    "right_reward_point": rightRewardPoint,
    "jenjang_karir": jenjangKarir,
    "plafon": plafon,
    "point_ro": pointRo,
    "membership_badge": membershipBadge,
    "jenjang_karir_badge": jenjangKarirBadge,
    "id_card": idCard,
    "picture": picture,
    "created_at": createdAt.toIso8601String(),
  };
}
