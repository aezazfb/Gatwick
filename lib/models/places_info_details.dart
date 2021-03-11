import 'dart:convert';

Welcome welcomeFromJson(String str) => Welcome.fromJson(json.decode(str));

String welcomeToJson(Welcome data) => json.encode(data.toJson());

class Welcome {
  Welcome({
    this.placedetails,
  });

  Placedetails placedetails;

  factory Welcome.fromJson(Map<String, dynamic> json) => Welcome(
        placedetails: Placedetails.fromJson(json["Placedetails"]),
      );

  Map<String, dynamic> toJson() => {
        "Placedetails": placedetails.toJson(),
      };
}

class Placedetails {
  Placedetails({
    this.id,
    this.placeid,
    this.address,
    this.postcode,
    this.outcode,
    this.lattitude,
    this.longitude,
    this.country,
    this.city,
  });

  Id id;
  String placeid;
  String address;
  String postcode;
  String outcode;
  double lattitude;
  double longitude;
  String country;
  String city;

  factory Placedetails.fromJson(Map<String, dynamic> json) => Placedetails(
        id: Id.fromJson(json["_id"]),
        placeid: json["placeid"],
        address: json["address"],
        postcode: json["postcode"],
        outcode: json["outcode"],
        lattitude: json["lattitude"].toDouble(),
        longitude: json["longitude"].toDouble(),
        country: json["country"],
        city: json["city"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id.toJson(),
        "placeid": placeid,
        "address": address,
        "postcode": postcode,
        "outcode": outcode,
        "lattitude": lattitude,
        "longitude": longitude,
        "country": country,
        "city": city,
      };
}

class Id {
  Id({
    this.timestamp,
    this.machine,
    this.pid,
    this.increment,
    this.creationTime,
  });

  int timestamp;
  int machine;
  int pid;
  int increment;
  String creationTime;

  factory Id.fromJson(Map<String, dynamic> json) => Id(
        timestamp: json["Timestamp"],
        machine: json["Machine"],
        pid: json["Pid"],
        increment: json["Increment"],
        creationTime: json["CreationTime"],
      );

  Map<String, dynamic> toJson() => {
        "Timestamp": timestamp,
        "Machine": machine,
        "Pid": pid,
        "Increment": increment,
        "CreationTime": creationTime,
      };
}
