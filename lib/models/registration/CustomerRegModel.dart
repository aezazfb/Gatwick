// To parse this JSON data, do
//
//     final customerReg = customerRegFromJson(jsonString);

import 'dart:convert';

part 'CustomerRegModel.g.dart';

CustomerRegModel customerRegFromJson(String str) => CustomerRegModel.fromJson(json.decode(str));

String customerRegToJson(CustomerRegModel data) => json.encode(data.toJson());

class CustomerRegModel {
  CustomerRegModel({
    this.custUid,
    this.appname,
    this.blacklist,
    this.custEmail,
    this.custName,
    this.custPhone,
    this.fcmToken,
    this.password,
    this.agentnin,
    this.source,
    this.signupDate,
    this.commStartTime,
    this.commEndTime,
    this.commMaxValue,
    this.commMinValue,
    this.commDownValue,
    this.walletamount,
  });

  String custUid;
  String appname;
  bool blacklist;
  String custEmail;
  String custName;
  String custPhone;
  String fcmToken;
  String password;
  String agentnin;
  String source;
  int signupDate;
  int commStartTime;
  int commEndTime;
  int commMaxValue;
  int commMinValue;
  int commDownValue;
  int walletamount;

  factory CustomerRegModel.fromJson(Map<String, dynamic> json) => CustomerRegModel(
    custUid: json["cust_uid"],
    appname: json["appname"],
    blacklist: json["blacklist"],
    custEmail: json["cust_email"],
    custName: json["cust_name"],
    custPhone: json["cust_phone"],
    fcmToken: json["fcm_token"],
    password: json["password"],
    agentnin: json["agentnin"],
    source: json["source"],
    signupDate: json["signup_date"],
    commStartTime: json["comm_start_time"],
    commEndTime: json["comm_end_time"],
    commMaxValue: json["comm_max_value"],
    commMinValue: json["comm_min_value"],
    commDownValue: json["comm_down_value"],
    walletamount: json["walletamount"],
  );

  Map<String, dynamic> toJson() => {
    "cust_uid": custUid,
    "appname": appname,
    "blacklist": blacklist,
    "cust_email": custEmail,
    "cust_name": custName,
    "cust_phone": custPhone,
    "fcm_token": fcmToken,
    "password": password,
    "agentnin": agentnin,
    "source": source,
    "signup_date": signupDate,
    "comm_start_time": commStartTime,
    "comm_end_time": commEndTime,
    "comm_max_value": commMaxValue,
    "comm_min_value": commMinValue,
    "comm_down_value": commDownValue,
    "walletamount": walletamount,
  };
}
