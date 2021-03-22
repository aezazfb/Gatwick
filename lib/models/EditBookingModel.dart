// To parse this JSON data, do
//
//     final booking = bookingFromJson(jsonString);

import 'package:zippy_rider/models/FromToViaModel.dart';

class EditBookingModel{
  EditBookingModel({
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
    this.toOutcode,
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
    this.fromOutcode,
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
  String toOutcode;
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
  String fromOutcode;
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


}