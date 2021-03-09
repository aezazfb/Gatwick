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

  BookingData(
      {this.id,
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
}
