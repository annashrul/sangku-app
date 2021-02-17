// To parse this JSON data, do
//
//     final detailContentModel = detailContentModelFromJson(jsonString);

import 'dart:convert';

DetailContentModel detailContentModelFromJson(String str) => DetailContentModel.fromJson(json.decode(str));

String detailContentModelToJson(DetailContentModel data) => json.encode(data.toJson());

class DetailContentModel {
  DetailContentModel({
    this.result,
    this.msg,
    this.status,
  });

  Result result;
  String msg;
  String status;

  factory DetailContentModel.fromJson(Map<String, dynamic> json) => DetailContentModel(
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
    this.writer,
    this.title,
    this.category,
    this.caption,
    this.type,
    this.video,
    this.picture,
    this.createdAt,
    this.updatedAt,
  });

  String id;
  String writer;
  String title;
  String category;
  String caption;
  String type;
  String video;
  String picture;
  DateTime createdAt;
  DateTime updatedAt;

  factory Result.fromJson(Map<String, dynamic> json) => Result(
    id: json["id"],
    writer: json["writer"],
    title: json["title"],
    category: json["category"],
    caption: json["caption"],
    type: json["type"],
    video: json["video"],
    picture: json["picture"],
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "writer": writer,
    "title": title,
    "category": category,
    "caption": caption,
    "type": type,
    "video": video,
    "picture": picture,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
  };
}
