// To parse this JSON data, do
//
//     final historyWithdrawModel = historyWithdrawModelFromJson(jsonString);

import 'dart:convert';

HistoryWithdrawModel historyWithdrawModelFromJson(String str) => HistoryWithdrawModel.fromJson(json.decode(str));

String historyWithdrawModelToJson(HistoryWithdrawModel data) => json.encode(data.toJson());

class HistoryWithdrawModel {
  HistoryWithdrawModel({
    this.result,
    this.msg,
    this.status,
  });

  Result result;
  String msg;
  String status;

  factory HistoryWithdrawModel.fromJson(Map<String, dynamic> json) => HistoryWithdrawModel(
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
    this.idMember,
    this.fullName,
    this.idBank,
    this.bankName,
    this.accName,
    this.accNo,
    this.amount,
    this.charge,
    this.status,
    this.kdTrx,
    this.createdAt,
    this.updatedAt,
  });

  String totalrecords;
  String id;
  String idMember;
  String fullName;
  String idBank;
  String bankName;
  String accName;
  String accNo;
  String amount;
  String charge;
  int status;
  String kdTrx;
  DateTime createdAt;
  DateTime updatedAt;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    totalrecords: json["totalrecords"],
    id: json["id"],
    idMember: json["id_member"],
    fullName: json["full_name"],
    idBank: json["id_bank"],
    bankName: json["bank_name"],
    accName: json["acc_name"],
    accNo: json["acc_no"],
    amount: json["amount"],
    charge: json["charge"],
    status: json["status"],
    kdTrx: json["kd_trx"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "totalrecords": totalrecords,
    "id": id,
    "id_member": idMember,
    "full_name": fullName,
    "id_bank": idBank,
    "bank_name": bankName,
    "acc_name": accName,
    "acc_no": accNo,
    "amount": amount,
    "charge": charge,
    "status": status,
    "kd_trx": kdTrx,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
  };
}
