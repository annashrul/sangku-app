// To parse this JSON data, do
//
//     final bankMemberModel = bankMemberModelFromJson(jsonString);

import 'dart:convert';

BankMemberModel bankMemberModelFromJson(String str) => BankMemberModel.fromJson(json.decode(str));

String bankMemberModelToJson(BankMemberModel data) => json.encode(data.toJson());

class BankMemberModel {
  BankMemberModel({
    this.result,
    this.msg,
    this.status,
  });

  Result result;
  String msg;
  String status;

  factory BankMemberModel.fromJson(Map<String, dynamic> json) => BankMemberModel(
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
    this.bankName,
    this.accName,
    this.accNo,
    this.createdAt,
    this.updatedAt,
  });

  String totalrecords;
  String id;
  String idMember;
  String bankName;
  String accName;
  String accNo;
  DateTime createdAt;
  DateTime updatedAt;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    totalrecords: json["totalrecords"],
    id: json["id"],
    idMember: json["id_member"],
    bankName: json["bank_name"],
    accName: json["acc_name"],
    accNo: json["acc_no"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "totalrecords": totalrecords,
    "id": id,
    "id_member": idMember,
    "bank_name": bankName,
    "acc_name": accName,
    "acc_no": accNo,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
  };
}
