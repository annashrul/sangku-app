// To parse this JSON data, do
//
//     final categoryPpobModel = categoryPpobModelFromJson(jsonString);

import 'dart:convert';

CategoryPpobModel categoryPpobModelFromJson(String str) => CategoryPpobModel.fromJson(json.decode(str));

String categoryPpobModelToJson(CategoryPpobModel data) => json.encode(data.toJson());

class CategoryPpobModel {
  CategoryPpobModel({
    this.result,
    this.msg,
    this.status,
  });

  Result result;
  String msg;
  String status;

  factory CategoryPpobModel.fromJson(Map<String, dynamic> json) => CategoryPpobModel(
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
    this.code,
    this.title,
    this.prefix,
    this.kategori,
    this.status,
    this.opId,
    this.logo,
  });

  String totalrecords;
  String id;
  String code;
  String title;
  String prefix;
  int kategori;
  int status;
  int opId;
  String logo;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    totalrecords: json["totalrecords"],
    id: json["id"],
    code: json["code"],
    title: json["title"],
    prefix: json["prefix"],
    kategori: json["kategori"],
    status: json["status"],
    opId: json["op_id"],
    logo: json["logo"],
  );

  Map<String, dynamic> toJson() => {
    "totalrecords": totalrecords,
    "id": id,
    "code": code,
    "title": title,
    "prefix": prefix,
    "kategori": kategori,
    "status": status,
    "op_id": opId,
    "logo": logo,
  };
}
