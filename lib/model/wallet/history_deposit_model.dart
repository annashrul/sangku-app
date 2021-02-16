// To parse this JSON data, do
//
//     final historyDepositModel = historyDepositModelFromJson(jsonString);

import 'dart:convert';

HistoryDepositModel historyDepositModelFromJson(String str) => HistoryDepositModel.fromJson(json.decode(str));

String historyDepositModelToJson(HistoryDepositModel data) => json.encode(data.toJson());

class HistoryDepositModel {
  HistoryDepositModel({
    this.result,
    this.msg,
    this.status,
  });

  Result result;
  String msg;
  String status;

  factory HistoryDepositModel.fromJson(Map<String, dynamic> json) => HistoryDepositModel(
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
    this.fullName,
    this.idBankDestination,
    this.bankName,
    this.accName,
    this.accNo,
    this.amount,
    this.uniqueCode,
    this.status,
    this.paymentSlip,
    this.createdAt,
    this.updatedAt,
  });

  String totalrecords;
  String id;
  String kdTrx;
  String idMember;
  String fullName;
  String idBankDestination;
  String bankName;
  String accName;
  String accNo;
  String amount;
  int uniqueCode;
  int status;
  String paymentSlip;
  DateTime createdAt;
  DateTime updatedAt;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    totalrecords: json["totalrecords"],
    id: json["id"],
    kdTrx: json["kd_trx"],
    idMember: json["id_member"],
    fullName: json["full_name"],
    idBankDestination: json["id_bank_destination"],
    bankName: json["bank_name"],
    accName: json["acc_name"],
    accNo: json["acc_no"],
    amount: json["amount"],
    uniqueCode: json["unique_code"],
    status: json["status"],
    paymentSlip: json["payment_slip"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "totalrecords": totalrecords,
    "id": id,
    "kd_trx": kdTrx,
    "id_member": idMember,
    "full_name": fullName,
    "id_bank_destination": idBankDestination,
    "bank_name": bankName,
    "acc_name": accName,
    "acc_no": accNo,
    "amount": amount,
    "unique_code": uniqueCode,
    "status": status,
    "payment_slip": paymentSlip,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
  };
}
