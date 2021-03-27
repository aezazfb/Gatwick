// To parse this JSON data, do
//
//     final cfgCustAppModel = cfgCustAppModelFromJson(jsonString);

import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

part 'CfgCustAppModel.g.dart';

List<CfgCustAppModel> cfgCustAppModelFromJson(String str) => List<CfgCustAppModel>.from(json.decode(str).map((x) => CfgCustAppModel.fromJson(x)));

String cfgCustAppModelToJson(List<CfgCustAppModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

@JsonSerializable()
class CfgCustAppModel {
  CfgCustAppModel({
    this.id,
    this.officename,
    this.imageIp,
    this.officePosition,
    this.jobInOffice,
    this.googleServiceKey,
    this.googleDirectionKey,
    this.googlePlaceKey,
    this.legacyserverkey,
    this.phoneNumber,
    this.iOsVersion,
    this.androidVersion,
    this.airportMinPrice,
    this.airportPickupExt,
    this.allVehicleFare,
    this.milesUnit,
    this.costUnit,
    this.carstype,
    this.offemailpwd,
    this.offemail,
    this.smtpHost,
    this.stripkey,
    this.cardpaymentallow,
    this.ftphost,
    this.ftpuser,
    this.ftppass,
    this.ftppathUrl,
    this.drvdetailtime,
    this.drvsendjobtime,
    this.smtpPort,
    this.favouriteenabled,
    this.favouritedates,
    this.surchargeenabled,
    this.surchargevalue,
    this.walletstartdate,
    this.walletenddate,
    this.walletpercent,
    this.walletamount,
    this.surchargesstartdate,
    this.surchargesenddate,
    this.smsgateway,
  });

  String id;
  String officename;
  String imageIp;
  List<double> officePosition;
  String jobInOffice;
  String googleServiceKey;
  String googleDirectionKey;
  String googlePlaceKey;
  String legacyserverkey;
  String phoneNumber;
  String iOsVersion;
  String androidVersion;
  double airportMinPrice;
  double airportPickupExt;
  List<AllVehicleFare> allVehicleFare;
  List<int> milesUnit;
  List<double> costUnit;
  List<Carstype> carstype;
  String offemailpwd;
  String offemail;
  String smtpHost;
  String stripkey;
  bool cardpaymentallow;
  String ftphost;
  String ftpuser;
  String ftppass;
  String ftppathUrl;
  int drvdetailtime;
  int drvsendjobtime;
  int smtpPort;
  bool favouriteenabled;
  List<Favouritedate> favouritedates;
  bool surchargeenabled;
  double surchargevalue;
  int walletstartdate;
  int walletenddate;
  int walletpercent;
  int walletamount;
  int surchargesstartdate;
  int surchargesenddate;
  String smsgateway;

  factory CfgCustAppModel.fromJson(Map<String, dynamic> json) => CfgCustAppModel(
    id: json["_id"],
    officename: json["officename"],
    imageIp: json["imageIP"],
    officePosition: List<double>.from(json["officePosition"].map((x) => x.toDouble())),
    jobInOffice: json["jobInOffice"],
    googleServiceKey: json["googleServiceKey"],
    googleDirectionKey: json["googleDirectionKey"],
    googlePlaceKey: json["googlePlaceKey"],
    legacyserverkey: json["Legacyserverkey"],
    phoneNumber: json["phoneNumber"],
    iOsVersion: json["iOS_Version"],
    androidVersion: json["Android_Version"],
    airportMinPrice: json["airport_min_price"].toDouble(),
    airportPickupExt: json["airport_pickup_ext"].toDouble(),
    allVehicleFare: List<AllVehicleFare>.from(json["all_vehicle_fare"].map((x) => AllVehicleFare.fromJson(x))),
    milesUnit: List<int>.from(json["milesUnit"].map((x) => x)),
    costUnit: List<double>.from(json["costUnit"].map((x) => x.toDouble())),
    carstype: List<Carstype>.from(json["carstype"].map((x) => Carstype.fromJson(x))),
    offemailpwd: json["offemailpwd"],
    offemail: json["offemail"],
    smtpHost: json["SmtpHost"],
    stripkey: json["stripkey"],
    cardpaymentallow: json["cardpaymentallow"],
    ftphost: json["ftphost"],
    ftpuser: json["ftpuser"],
    ftppass: json["ftppass"],
    ftppathUrl: json["ftppath_url"],
    drvdetailtime: json["drvdetailtime"],
    drvsendjobtime: json["drvsendjobtime"],
    smtpPort: json["SmtpPort"],
    favouriteenabled: json["favouriteenabled"],
    favouritedates: List<Favouritedate>.from(json["favouritedates"].map((x) => Favouritedate.fromJson(x))),
    surchargeenabled: json["surchargeenabled"],
    surchargevalue: json["surchargevalue"].toDouble(),
    walletstartdate: json["walletstartdate"],
    walletenddate: json["walletenddate"],
    walletpercent: json["walletpercent"],
    walletamount: json["walletamount"],
    surchargesstartdate: json["surchargesstartdate"],
    surchargesenddate: json["surchargesenddate"],
    smsgateway: json["smsgateway"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "officename": officename,
    "imageIP": imageIp,
    "officePosition": List<dynamic>.from(officePosition.map((x) => x)),
    "jobInOffice": jobInOffice,
    "googleServiceKey": googleServiceKey,
    "googleDirectionKey": googleDirectionKey,
    "googlePlaceKey": googlePlaceKey,
    "Legacyserverkey": legacyserverkey,
    "phoneNumber": phoneNumber,
    "iOS_Version": iOsVersion,
    "Android_Version": androidVersion,
    "airport_min_price": airportMinPrice,
    "airport_pickup_ext": airportPickupExt,
    "all_vehicle_fare": List<dynamic>.from(allVehicleFare.map((x) => x.toJson())),
    "milesUnit": List<dynamic>.from(milesUnit.map((x) => x)),
    "costUnit": List<dynamic>.from(costUnit.map((x) => x)),
    "carstype": List<dynamic>.from(carstype.map((x) => x.toJson())),
    "offemailpwd": offemailpwd,
    "offemail": offemail,
    "SmtpHost": smtpHost,
    "stripkey": stripkey,
    "cardpaymentallow": cardpaymentallow,
    "ftphost": ftphost,
    "ftpuser": ftpuser,
    "ftppass": ftppass,
    "ftppath_url": ftppathUrl,
    "drvdetailtime": drvdetailtime,
    "drvsendjobtime": drvsendjobtime,
    "SmtpPort": smtpPort,
    "favouriteenabled": favouriteenabled,
    "favouritedates": List<dynamic>.from(favouritedates.map((x) => x.toJson())),
    "surchargeenabled": surchargeenabled,
    "surchargevalue": surchargevalue,
    "walletstartdate": walletstartdate,
    "walletenddate": walletenddate,
    "walletpercent": walletpercent,
    "walletamount": walletamount,
    "surchargesstartdate": surchargesstartdate,
    "surchargesenddate": surchargesenddate,
    "smsgateway": smsgateway,
  };
}

@JsonSerializable()
class AllVehicleFare {
  AllVehicleFare({
    this.the6,
    this.the8,
    this.e,
    this.x,
  });

  int the6;
  int the8;
  int e;
  int x;

  factory AllVehicleFare.fromJson(Map<String, dynamic> json) => AllVehicleFare(
    the6: json["6"],
    the8: json["8"],
    e: json["E"],
    x: json["X"],
  );

  Map<String, dynamic> toJson() => {
    "6": the6,
    "8": the8,
    "E": e,
    "X": x,
  };
}

@JsonSerializable()
class Carstype {
  Carstype({
    this.carname,
    this.carcapacity,
    this.lugagecapacity,
    this.activecar,
  });

  String carname;
  int carcapacity;
  int lugagecapacity;
  bool activecar;

  factory Carstype.fromJson(Map<String, dynamic> json) => Carstype(
    carname: json["carname"],
    carcapacity: json["carcapacity"],
    lugagecapacity: json["lugagecapacity"],
    activecar: json["activecar"],
  );

  Map<String, dynamic> toJson() => {
    "carname": carname,
    "carcapacity": carcapacity,
    "lugagecapacity": lugagecapacity,
    "activecar": activecar,
  };
}

@JsonSerializable()
class Favouritedate {
  Favouritedate({
    this.date,
    this.value,
  });

  String date;
  double value;

  factory Favouritedate.fromJson(Map<String, dynamic> json) => Favouritedate(
    date: json["date"],
    value: json["value"].toDouble(),
  );

  Map<String, dynamic> toJson() => {
    "date": date,
    "value": value,
  };
}
