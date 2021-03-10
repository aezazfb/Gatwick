import 'dart:convert';

String bookingDataToJson(List<BookingData> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

List<BookingData> bookingDataFromJson(String str) => List<BookingData>.from(
    json.decode(str).map((x) => BookingData.fromJson(x)));

class BookingData {
  String id = '';
  String drvrcallsign = '';
  String office = '';
  int despatchtime = 0;
  String jobtype = '';
  int flage = 0;
  double jobmileage = 0.0;
  String to_info = '';
  String to_outcode = '';
  String olddrvfare = '';
  int timetodespatch = 0;
  String cstate = '';
  bool hold = false;
  DateTime date;
  bool changed = false;
  String drvrreqcallsign = '';
  List logc = [];
  String tag = '1 of 1';
  String from_outcode = '';
  int fare = 0;
  String drvrname = '';
  int oldfare = 0;
  int numofvia = 0;
  List fromtovia = [];
  String comment = '';
  String bookedby = '';
  String from_info = '';
  String to = '';
  String callerid = '';
  String mstate = '';
  String orderno = '';
  String flightno = '';
  String userid = '';
  String time = '';
  String driverrate = '';
  String account = '';
  int leadtime = 0;
  String from = '';
  String creditcard = '';
  String accuser = '';
  String vehicletype = '';
  String dstate = '';
  String jobref = '';
  int drvfare = 0;
  bool isdirty = true;
  String telephone = '';
  String custname = '';
  String drvreqdname = '';
  int logd = 0;
  int datentime = 0;
  String pin = '';
  String jstate = '';

  BookingData({this.id,
    this.drvrcallsign,
    this.office,
    this.despatchtime,
    this.jobtype,
    this.flage,
    this.jobmileage,
    this.to_info,
    this.to_outcode,
    this.olddrvfare,
    this.timetodespatch,
    this.cstate,
    this.hold,
    this.date,
    this.changed,
    this.drvrreqcallsign,
    this.logc,
    this.tag,
    this.from_outcode,
    this.fare,
    this.drvrname,
    this.oldfare,
    this.numofvia,
    this.fromtovia,
    this.comment,
    this.bookedby,
    this.from_info,
    this.to,
    this.callerid,
    this.mstate,
    this.orderno,
    this.flightno,
    this.userid,
    this.time,
    this.driverrate,
    this.account,
    this.leadtime,
    this.from,
    this.creditcard,
    this.accuser,
    this.vehicletype,
    this.dstate,
      this.jobref,
      this.drvfare,
      this.isdirty,
      this.telephone,
      this.custname,
      this.drvreqdname,
      this.logd,
      this.datentime,
      this.pin,
      this.jstate});

  factory BookingData.fromJson(Map<String, dynamic> json) => BookingData(
        id: json['id'],
        drvrcallsign: json['drvrcallsign'],
        office: json['office'],
        despatchtime: json['despatchtime'],
        jobtype: json['jobtype'],
        flage: json['flage'],
        jobmileage: json['jobmileage'],
        to_info: json['to_info'],
        to_outcode: json['to_outcode'],
        olddrvfare: json['olddrvfare'],
        timetodespatch: json['timetodespatch'],
        cstate: json['cstate'],
        hold: json['hold'],
        date: json['date'],
        changed: json['changed'],
        drvrreqcallsign: json['drvrreqcallsign'],
        logc: json['logc'],
        tag: json['tag'],
        from_outcode: json['from_outcode'],
        fare: json['fare'],
        drvrname: json['drvrname'],
        oldfare: json['oldfare'],
        numofvia: json['numofvia'],
        fromtovia: json['fromtovia'],
        comment: json['comment'],
        bookedby: json['bookedby'],
        from_info: json['from_info'],
        to: json['to'],
        callerid: json['callerid'],
        mstate: json['mstate'],
        orderno: json['orderno'],
        flightno: json['flightno'],
        userid: json['userid'],
        time: json['time'],
        driverrate: json[''],
        account: json['driverrate'],
        leadtime: json['leadtime'],
        from: json['from'],
        creditcard: json['creditcard'],
        accuser: json['accuser'],
        vehicletype: json['vehicletype'],
        dstate: json['dstate'],
        jobref: json['jobref'],
        drvfare: json['drvfare'],
        isdirty: json['isdirty'],
        telephone: json['telephone'],
        custname: json['custname'],
        drvreqdname: json['drvreqdname'],
        logd: json['logd'],
        datentime: json['datentime'],
        pin: json['pin'],
        jstate: json['jstate'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'account': account,
        'bookedby': bookedby,
        'driverrate': driverrate,
        'jobref': jobref,
        'jobtype': jobtype,
        'jstate': jstate,
        'office': office,
        'telephone': telephone,
        'time': time,
        'to': to,
        'toInfo': to_info,
        'toOutcode': to_outcode,
        'userid': userid,
        'vehicletype': vehicletype,
        'callerid': callerid,
        'pin': pin,
        'mstate': mstate,
        'tag': tag,
        'accuser': accuser,
        'orderno': orderno,
        'flightno': flightno,
        'from': from,
        'fromInfo': from_info,
        'fromOutcode': from_outcode,
        'drvrcallsign': drvrcallsign,
        'drvrreqcallsign': drvrreqcallsign,
        'drvreqdname': drvreqdname,
        'drvrname': drvrname,
        'dstate': dstate,
        'comment': comment,
        'creditcard': creditcard,
        'cstate': cstate,
        'custname': custname,
        'date': date,
        'fare': fare,
        'oldfare': oldfare,
        'drvfare': drvfare,
        'olddrvfare': olddrvfare,
        'jobmileage': jobmileage,
        'leadtime': leadtime,
        'timetodespatch': timetodespatch,
        'datentime': datentime,
        'despatchtime': despatchtime,
        'flag': flage,
        'numofvia': numofvia,
        'hold': hold,
        'isdirty': isdirty,
        'changed': changed,
        'logc': logc,
        'logd': logd,
        'fromtovia': fromtovia,
      };
}
