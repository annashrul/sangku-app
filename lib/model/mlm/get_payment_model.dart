// To parse this JSON data, do
//
//     final getPaymentModel = getPaymentModelFromJson(jsonString);

import 'dart:convert';

GetPaymentModel getPaymentModelFromJson(String str) => GetPaymentModel.fromJson(json.decode(str));

String getPaymentModelToJson(GetPaymentModel data) => json.encode(data.toJson());

class GetPaymentModel {
  GetPaymentModel({
    this.result,
    this.msg,
    this.status,
  });

  Result result;
  String msg;
  String status;

  factory GetPaymentModel.fromJson(Map<String, dynamic> json) => GetPaymentModel(
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
    this.kdTrx,
    this.kdUnique,
    this.grandTotal,
    this.bankName,
    this.accName,
    this.accNo,
    this.tfCode,
    this.paymentSlip,
    this.logo,
    this.limitTf,
  });

  String kdTrx;
  int kdUnique;
  String grandTotal;
  String bankName;
  String accName;
  String accNo;
  int tfCode;
  String paymentSlip;
  String logo;
  DateTime limitTf;

  factory Result.fromJson(Map<String, dynamic> json) => Result(
    kdTrx: json["kd_trx"],
    kdUnique: json["kd_unique"],
    grandTotal: json["grand_total"],
    bankName: json["bank_name"],
    accName: json["acc_name"],
    accNo: json["acc_no"],
    tfCode: json["tf_code"],
    paymentSlip: json["payment_slip"],
    logo: json["logo"],
    limitTf: DateTime.parse(json["limit_tf"]),
  );

  Map<String, dynamic> toJson() => {
    "kd_trx": kdTrx,
    "kd_unique": kdUnique,
    "grand_total": grandTotal,
    "bank_name": bankName,
    "acc_name": accName,
    "acc_no": accNo,
    "tf_code": tfCode,
    "payment_slip": paymentSlip,
    "logo": logo,
    "limit_tf": limitTf.toIso8601String(),
  };
}
