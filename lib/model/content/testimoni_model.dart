// To parse this JSON data, do
//
//     final testimoniModel = testimoniModelFromJson(jsonString);

import 'dart:convert';

TestimoniModel testimoniModelFromJson(String str) => TestimoniModel.fromJson(json.decode(str));

String testimoniModelToJson(TestimoniModel data) => json.encode(data.toJson());

class TestimoniModel {
  TestimoniModel({
    this.result,
    this.msg,
    this.status,
  });

  Result result;
  String msg;
  String status;

  factory TestimoniModel.fromJson(Map<String, dynamic> json) => TestimoniModel(
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
    this.writer,
    this.foto,
    this.jobs,
    this.caption,
    this.type,
    this.picture,
    this.video,
    this.createdAt,
    this.updatedAt,
    this.typeNo,
    this.namaLain,
    this.status,
  });

  String totalrecords;
  String id;
  String writer;
  String foto;
  String jobs;
  String caption;
  String type;
  String picture;
  String video;
  DateTime createdAt;
  DateTime updatedAt;
  int typeNo;
  String namaLain;
  int status;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    totalrecords: json["totalrecords"],
    id: json["id"],
    writer: json["writer"],
    foto: json["foto"],
    jobs: json["jobs"],
    caption: json["caption"],
    type: json["type"],
    picture: json["picture"],
    video: json["video"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
    typeNo: json["type_no"],
    namaLain: json["nama_lain"],
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "totalrecords": totalrecords,
    "id": id,
    "writer": writer,
    "foto": foto,
    "jobs": jobs,
    "caption": caption,
    "type": type,
    "picture": picture,
    "video": video,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
    "type_no": typeNo,
    "nama_lain": namaLain,
    "status": status,
  };
}
