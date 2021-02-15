// To parse this JSON data, do
//
//     final historyTransactionModel = historyTransactionModelFromJson(jsonString);

import 'dart:convert';

HistoryTransactionModel historyTransactionModelFromJson(String str) => HistoryTransactionModel.fromJson(json.decode(str));

String historyTransactionModelToJson(HistoryTransactionModel data) => json.encode(data.toJson());

class HistoryTransactionModel {
  HistoryTransactionModel({
    this.result,
    this.msg,
    this.status,
  });

  Result result;
  String msg;
  String status;

  factory HistoryTransactionModel.fromJson(Map<String, dynamic> json) => HistoryTransactionModel(
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
    this.summary,
  });

  int total;
  int perPage;
  int offset;
  int to;
  int lastPage;
  int currentPage;
  int from;
  List<Datum> data;
  Summary summary;

  factory Result.fromJson(Map<String, dynamic> json) => Result(
    total: json["total"],
    perPage: json["per_page"],
    offset: json["offset"],
    to: json["to"],
    lastPage: json["last_page"],
    currentPage: json["current_page"],
    from: json["from"],
    data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
    summary: Summary.fromJson(json["summary"]),
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
    "summary": summary.toJson(),
  };
}

class Datum {
  Datum({
    this.totalrecords,
    this.id,
    this.kdTrx,
    this.fullName,
    this.trxIn,
    this.trxOut,
    this.note,
    this.createdAt,
    this.updatedAt,
  });

  String totalrecords;
  String id;
  String kdTrx;
  String fullName;
  String trxIn;
  String trxOut;
  String note;
  DateTime createdAt;
  DateTime updatedAt;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    totalrecords: json["totalrecords"],
    id: json["id"],
    kdTrx: json["kd_trx"],
    fullName: json["full_name"],
    trxIn: json["trx_in"],
    trxOut: json["trx_out"],
    note: json["note"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "totalrecords": totalrecords,
    "id": id,
    "kd_trx": kdTrx,
    "full_name": fullName,
    "trx_in": trxIn,
    "trx_out": trxOut,
    "note": note,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
  };
}

class Summary {
  Summary({
    this.trxIn,
    this.trxOut,
    this.saldoAwal,
  });

  String trxIn;
  String trxOut;
  String saldoAwal;

  factory Summary.fromJson(Map<String, dynamic> json) => Summary(
    trxIn: json["trx_in"],
    trxOut: json["trx_out"],
    saldoAwal: json["saldo_awal"],
  );

  Map<String, dynamic> toJson() => {
    "trx_in": trxIn,
    "trx_out": trxOut,
    "saldo_awal": saldoAwal,
  };
}
