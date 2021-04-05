// To parse this JSON data, do
//
//     final booking = bookingFromJson(jsonString);


import 'package:json_annotation/json_annotation.dart';

part 'BookingModel.g.dart';


@JsonSerializable()
class BookingModel {
  BookingModel({
    this.id,
    this.account,
    this.bookedby,
    this.driverrate,
    this.jobref,
    this.jobtype,
    this.jstate,
    this.office,
    this.telephone,
    this.time,
    this.to,
    this.toInfo,
    this.to_outcode,
    this.userid,
    this.vehicletype,
    this.callerid,
    this.pin,
    this.mstate,
    this.tag,
    this.accuser,
    this.orderno,
    this.flightno,
    this.from,
    this.fromInfo,
    this.from_outcode,
    this.drvrcallsign,
    this.drvrreqcallsign,
    this.drvreqdname,
    this.drvrname,
    this.dstate,
    this.comment,
    this.creditcard,
    this.cstate,
    this.custname,
    this.date,
    this.fare,
    this.oldfare,
    this.drvfare,
    this.olddrvfare,
    this.jobmileage,
    this.leadtime,
    this.timetodespatch,
    this.datentime,
    this.despatchtime,
    this.flag,
    this.numofvia,
    this.hold,
    this.isdirty,
    this.changed,
    this.logc,
    this.logd,
    this.fromtovia,
  });

  String id;
  String account;
  String bookedby;
  String driverrate;
  String jobref;
  String jobtype;
  String jstate;
  String office;
  String telephone;
  String time;
  String to;
  String toInfo;
  String to_outcode;
  String userid;
  String vehicletype;
  String callerid;
  String pin;
  String mstate;
  String tag;
  String accuser;
  String orderno;
  String flightno;
  String from;
  String fromInfo;
  String from_outcode;
  String drvrcallsign;
  String drvrreqcallsign;
  String drvreqdname;
  String drvrname;
  String dstate;
  String comment;
  String creditcard;
  String cstate;
  String custname;
  String date;
  double fare;
  double oldfare;
  double drvfare;
  double olddrvfare;
  double jobmileage;
  double leadtime;
  double timetodespatch;
  double datentime;
  double despatchtime;
  int flag;
  int numofvia;
  bool hold;
  bool isdirty;
  bool changed;
  List<List<dynamic>> logc;
  dynamic logd;
  List<Fromtovia> fromtovia;


  factory BookingModel.fromJson(Map<String, dynamic> json) => _$BookingModelFromJson(json);
  Map<String, dynamic> toJson() => _$BookingModelToJson(this);

  @override
  String toString() {
    return '{"id": "$id", "account": "$account", "bookedby": "$bookedby", "driverrate": "$driverrate", "jobref": "$jobref",'
        ' "jobtype": "$jobtype", "jstate": "$jstate", "office": "$office", "telephone": "$telephone", "time": "$time",'
        ' "to": $to,\n "toInfo": "$toInfo", "to_outcode": "$to_outcode", "userid": "$userid", "vehicletype": "$vehicletype",'
        ' "callerid": "$callerid", "pin": "$pin", "mstate": "$mstate", "tag": "$tag", "accuser": "$accuser",'
        ' "orderno": "$orderno", "flightno": "$flightno",\n "from": "$from", "fromInfo": "$fromInfo",'
        ' "from_outcode": "$from_outcode", "drvrcallsign": "$drvrcallsign", "drvrreqcallsign": "$drvrreqcallsign",'
        ' "drvreqdname": "$drvreqdname", "drvrname": "$drvrname",\n "dstate": "$dstate", "comment": "$comment",'
        ' "creditcard": "$creditcard", "cstate": "$cstate", "custname": "$custname", "date": "$date", "fare": $fare,'
        ' "oldfare": $oldfare,\n "drvfare": $drvfare, "olddrvfare": $olddrvfare, "jobmileage": $jobmileage,'
        ' "leadtime": $leadtime, "timetodespatch": $timetodespatch, "datentime": $datentime,'
        ' "despatchtime": $despatchtime, "flag": $flag,\n "numofvia": $numofvia, "hold": $hold,'
        ' "isdirty": $isdirty, "changed": $changed, "logc": $logc, "logd": $logd, "fromtovia": ${fromtovia.toString()}';
  }
}

@JsonSerializable()
class Fromtovia {
  Fromtovia({
    this.info,
    this.address,
    this.lat,
    this.lon,
    this.postcode,
  });

  String info;
  String address;
  double lat;
  double lon;
  String postcode;

  factory Fromtovia.fromJson(Map<String, dynamic> json) => _$FromtoviaFromJson(json);
  Map<String, dynamic> toJson() => _$FromtoviaToJson(this);

  @override
  String toString() {
    return '{"info": "$info", "address": "$address", "lat": $lat, "lon": $lon, "postcode": "$postcode"}';
  }
}