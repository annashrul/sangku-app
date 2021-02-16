// To parse this JSON data, do
//
//     final productPpobPraModel = productPpobPraModelFromJson(jsonString);

import 'dart:convert';

ProductPpobPraModel productPpobPraModelFromJson(String str) => ProductPpobPraModel.fromJson(json.decode(str));

String productPpobPraModelToJson(ProductPpobPraModel data) => json.encode(data.toJson());

class ProductPpobPraModel {
  ProductPpobPraModel({
    this.result,
    this.msg,
    this.status,
  });

  Result result;
  String msg;
  String status;

  factory ProductPpobPraModel.fromJson(Map<String, dynamic> json) => ProductPpobPraModel(
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
    this.datumOperator,
    this.prefix,
    this.kategori,
    this.note,
    this.price,
    this.status,
    this.type,
    this.provider,
    this.logo,
  });

  String totalrecords;
  String id;
  String code;
  String datumOperator;
  String prefix;
  String kategori;
  String note;
  String price;
  int status;
  int type;
  String provider;
  String logo;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    totalrecords: json["totalrecords"],
    id: json["id"],
    code: json["code"],
    datumOperator: json["operator"],
    prefix: json["prefix"],
    kategori: json["kategori"],
    note: json["note"],
    price: json["price"],
    status: json["status"],
    type: json["type"],
    provider: json["provider"],
    logo: json["logo"],
  );

  Map<String, dynamic> toJson() => {
    "totalrecords": totalrecords,
    "id": id,
    "code": code,
    "operator": datumOperator,
    "prefix": prefix,
    "kategori": kategori,
    "note": note,
    "price": price,
    "status": status,
    "type": type,
    "provider": provider,
    "logo": logo,
  };
}
