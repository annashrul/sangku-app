// To parse this JSON data, do
//
//     final infoTambahanModel = infoTambahanModelFromJson(jsonString);

import 'dart:convert';

InfoTambahanModel infoTambahanModelFromJson(String str) => InfoTambahanModel.fromJson(json.decode(str));

String infoTambahanModelToJson(InfoTambahanModel data) => json.encode(data.toJson());

class InfoTambahanModel {
  InfoTambahanModel({
    this.result,
    this.msg,
    this.status,
  });

  Result result;
  String msg;
  String status;

  factory InfoTambahanModel.fromJson(Map<String, dynamic> json) => InfoTambahanModel(
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
    this.bonus,
    this.bonusSponsor,
    this.withdrawal,
    this.reward,
  });

  int bonus;
  int bonusSponsor;
  String withdrawal;
  Reward reward;

  factory Result.fromJson(Map<String, dynamic> json) => Result(
    bonus: json["bonus"],
    bonusSponsor: json["bonus_sponsor"],
    withdrawal: json["withdrawal"],
    reward: Reward.fromJson(json["reward"]),
  );

  Map<String, dynamic> toJson() => {
    "bonus": bonus,
    "bonus_sponsor": bonusSponsor,
    "withdrawal": withdrawal,
    "reward": reward.toJson(),
  };
}

class Reward {
  Reward({
    this.id,
    this.title,
    this.caption,
    this.gambar,
    this.isClaimed,
  });

  String id;
  String title;
  String caption;
  String gambar;
  bool isClaimed;

  factory Reward.fromJson(Map<String, dynamic> json) => Reward(
    id: json["id"],
    title: json["title"],
    caption: json["caption"],
    gambar: json["gambar"],
    isClaimed: json["is_claimed"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "caption": caption,
    "gambar": gambar,
    "is_claimed": isClaimed,
  };
}
