// To parse this JSON data, do
//
//     final siteModel = siteModelFromJson(jsonString);

import 'dart:convert';

SiteModel siteModelFromJson(String str) => SiteModel.fromJson(json.decode(str));

String siteModelToJson(SiteModel data) => json.encode(data.toJson());

class SiteModel {
  SiteModel({
    this.result,
    this.msg,
    this.status,
  });

  Result result;
  String msg;
  String status;

  factory SiteModel.fromJson(Map<String, dynamic> json) => SiteModel(
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
    this.logo,
    this.title,
    this.address,
    this.email,
    this.noTelp,
    this.fax,
    this.legalitas,
    this.socialMedia,
    this.header,
    this.about,
    this.howto,
    this.paket,
    this.download,
    this.testimoni,
    this.privacy,
    this.terms,
  });

  String logo;
  String title;
  String address;
  String email;
  String noTelp;
  String fax;
  String legalitas;
  SocialMedia socialMedia;
  Header header;
  About about;
  Howto howto;
  Paket paket;
  Download download;
  List<Testimoni> testimoni;
  About privacy;
  About terms;

  factory Result.fromJson(Map<String, dynamic> json) => Result(
    logo: json["logo"],
    title: json["title"],
    address: json["address"],
    email: json["email"],
    noTelp: json["no_telp"],
    fax: json["fax"],
    legalitas: json["legalitas"],
    socialMedia: SocialMedia.fromJson(json["social_media"]),
    header: Header.fromJson(json["header"]),
    about: About.fromJson(json["about"]),
    howto: Howto.fromJson(json["howto"]),
    paket: Paket.fromJson(json["paket"]),
    download: Download.fromJson(json["download"]),
    testimoni: List<Testimoni>.from(json["testimoni"].map((x) => Testimoni.fromJson(x))),
    privacy: About.fromJson(json["privacy"]),
    terms: About.fromJson(json["terms"]),
  );

  Map<String, dynamic> toJson() => {
    "logo": logo,
    "title": title,
    "address": address,
    "email": email,
    "no_telp": noTelp,
    "fax": fax,
    "legalitas": legalitas,
    "social_media": socialMedia.toJson(),
    "header": header.toJson(),
    "about": about.toJson(),
    "howto": howto.toJson(),
    "paket": paket.toJson(),
    "download": download.toJson(),
    "testimoni": List<dynamic>.from(testimoni.map((x) => x.toJson())),
    "privacy": privacy.toJson(),
    "terms": terms.toJson(),
  };
}

class About {
  About({
    this.title,
    this.deskripsi,
  });

  String title;
  String deskripsi;

  factory About.fromJson(Map<String, dynamic> json) => About(
    title: json["title"],
    deskripsi: json["deskripsi"],
  );

  Map<String, dynamic> toJson() => {
    "title": title,
    "deskripsi": deskripsi,
  };
}

class Download {
  Download({
    this.title,
    this.deskripsi,
    this.link,
  });

  String title;
  String deskripsi;
  String link;

  factory Download.fromJson(Map<String, dynamic> json) => Download(
    title: json["title"],
    deskripsi: json["deskripsi"],
    link: json["link"],
  );

  Map<String, dynamic> toJson() => {
    "title": title,
    "deskripsi": deskripsi,
    "link": link,
  };
}

class Header {
  Header({
    this.title,
    this.image,
    this.background,
  });

  String title;
  String image;
  String background;

  factory Header.fromJson(Map<String, dynamic> json) => Header(
    title: json["title"],
    image: json["image"],
    background: json["background"],
  );

  Map<String, dynamic> toJson() => {
    "title": title,
    "image": image,
    "background": background,
  };
}

class Howto {
  Howto({
    this.title,
    this.deskripsi,
    this.data,
  });

  String title;
  String deskripsi;
  List<HowtoDatum> data;

  factory Howto.fromJson(Map<String, dynamic> json) => Howto(
    title: json["title"],
    deskripsi: json["deskripsi"],
    data: List<HowtoDatum>.from(json["data"].map((x) => HowtoDatum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "title": title,
    "deskripsi": deskripsi,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class HowtoDatum {
  HowtoDatum({
    this.title,
    this.deskripsi,
    this.image,
  });

  String title;
  String deskripsi;
  String image;

  factory HowtoDatum.fromJson(Map<String, dynamic> json) => HowtoDatum(
    title: json["title"],
    deskripsi: json["deskripsi"],
    image: json["image"],
  );

  Map<String, dynamic> toJson() => {
    "title": title,
    "deskripsi": deskripsi,
    "image": image,
  };
}

class Paket {
  Paket({
    this.title,
    this.deskripsi,
    this.data,
  });

  String title;
  String deskripsi;
  List<PaketDatum> data;

  factory Paket.fromJson(Map<String, dynamic> json) => Paket(
    title: json["title"],
    deskripsi: json["deskripsi"],
    data: List<PaketDatum>.from(json["data"].map((x) => PaketDatum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "title": title,
    "deskripsi": deskripsi,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class PaketDatum {
  PaketDatum({
    this.title,
    this.deskripsi,
    this.price,
    this.link,
    this.image,
  });

  String title;
  String deskripsi;
  String price;
  String link;
  String image;

  factory PaketDatum.fromJson(Map<String, dynamic> json) => PaketDatum(
    title: json["title"],
    deskripsi: json["deskripsi"],
    price: json["price"],
    link: json["link"],
    image: json["image"],
  );

  Map<String, dynamic> toJson() => {
    "title": title,
    "deskripsi": deskripsi,
    "price": price,
    "link": link,
    "image": image,
  };
}

class SocialMedia {
  SocialMedia({
    this.fb,
    this.tw,
    this.ig,
    this.yt,
  });

  String fb;
  String tw;
  String ig;
  String yt;

  factory SocialMedia.fromJson(Map<String, dynamic> json) => SocialMedia(
    fb: json["fb"],
    tw: json["tw"],
    ig: json["ig"],
    yt: json["yt"],
  );

  Map<String, dynamic> toJson() => {
    "fb": fb,
    "tw": tw,
    "ig": ig,
    "yt": yt,
  };
}

class Testimoni {
  Testimoni({
    this.writer,
    this.jobs,
    this.caption,
    this.picture,
    this.video,
  });

  String writer;
  String jobs;
  String caption;
  String picture;
  String video;

  factory Testimoni.fromJson(Map<String, dynamic> json) => Testimoni(
    writer: json["writer"],
    jobs: json["jobs"],
    caption: json["caption"],
    picture: json["picture"],
    video: json["video"],
  );

  Map<String, dynamic> toJson() => {
    "writer": writer,
    "jobs": jobs,
    "caption": caption,
    "picture": picture,
    "video": video,
  };
}
