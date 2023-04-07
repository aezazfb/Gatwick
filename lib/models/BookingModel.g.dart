// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'BookingModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BookingModel _$BookingModelFromJson(Map<String, dynamic> json) {
  return BookingModel(
    id: json['_id'] as String,
    account: json['account'] as String,
    bookedby: json['bookedby'] as String,
    driverrate: json['driverrate'] as String,
    jobref: json['jobref'] as String,
    jobtype: json['jobtype'] as String,
    jstate: json['jstate'] as String,
    office: json['office'] as String,
    telephone: json['telephone'] as String,
    time: json['time'] as String,
    to: json['to'] as String,
    toInfo: json['toInfo'] as String,
    to_outcode: json['to_outcode'] as String,
    userid: json['userid'] as String,
    vehicletype: json['vehicletype'] as String,
    callerid: json['callerid'] as String,
    pin: json['pin'] as String,
    mstate: json['mstate'] as String,
    tag: json['tag'] as String,
    accuser: json['accuser'] as String,
    orderno: json['orderno'] as String,
    flightno: json['flightno'] as String,
    from: json['from'] as String,
    from_info: json['from_info'] as String,
    //------------------------------fromInfo
    from_outcode: json['from_outcode'] as String,
    drvrcallsign: json['drvrcallsign'] as String,
    drvrreqcallsign: json['drvrreqcallsign'] as String,
    drvreqdname: json['drvreqdname'] as String,
    drvrname: json['drvrname'] as String,
    dstate: json['dstate'] as String,
    comment: json['comment'] as String,
    creditcard: json['creditcard'] as String,
    cstate: json['cstate'] as String,
    custname: json['custname'] as String,
    date: json['date'] as String,
    fare: (json['fare'] as num)?.toDouble(),
    oldfare: (json['oldfare'] as num)?.toDouble(),
    drvfare: (json['drvfare'] as num)?.toDouble(),
    olddrvfare: (json['olddrvfare'] as num)?.toDouble(),
    jobmileage: (json['jobmileage'] as num)?.toDouble(),
    leadtime: (json['leadtime'] as num)?.toDouble(),
    timetodespatch: (json['timetodespatch'] as num)?.toDouble(),
    datentime: (json['datentime'] as num)?.toDouble(),
    despatchtime: (json['despatchtime'] as num)?.toDouble(),
    flag: json['flag'] as int,
    numofvia: json['numofvia'] as int,
    hold: json['hold'] as bool,
    isdirty: json['isdirty'] as bool,
    changed: json['changed'] as bool,
    logc: (json['logc'] as List)?.map((e) => e as List)?.toList(),
    logd: json['logd'],
    fromtovia: (json['fromtovia'] as List)
        ?.map((e) =>
            e == null ? null : Fromtovia.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}
// ------- neeche waala posting values hai... toInfo -> to_info change kiya tha.....
Map<String, dynamic> _$BookingModelToJson(BookingModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'account': instance.account,
      'bookedby': instance.bookedby,
      'driverrate': instance.driverrate,
      'jobref': instance.jobref,
      'jobtype': instance.jobtype,
      'jstate': instance.jstate,
      'office': instance.office,
      'telephone': instance.telephone,
      'time': instance.time,
      'to': instance.to,
      'to_info': instance.toInfo,
      'to_outcode': instance.to_outcode,
      'userid': instance.userid,
      'vehicletype': instance.vehicletype,
      'callerid': instance.callerid,
      'pin': instance.pin,
      'mstate': instance.mstate,
      'tag': instance.tag,
      'accuser': instance.accuser,
      'orderno': instance.orderno,
      'flightno': instance.flightno,
      'from': instance.from,
      'from_info': instance.from_info,
      'from_outcode': instance.from_outcode,
      'drvrcallsign': instance.drvrcallsign,
      'drvrreqcallsign': instance.drvrreqcallsign,
      'drvreqdname': instance.drvreqdname,
      'drvrname': instance.drvrname,
      'dstate': instance.dstate,
      'comment': instance.comment,
      'creditcard': instance.creditcard,
      'cstate': instance.cstate,
      'custname': instance.custname,
      'date': instance.date,
      'fare': instance.fare,
      'oldfare': instance.oldfare,
      'drvfare': instance.drvfare,
      'olddrvfare': instance.olddrvfare,
      'jobmileage': instance.jobmileage,
      'leadtime': instance.leadtime,
      'timetodespatch': instance.timetodespatch,
      'datentime': instance.datentime,
      'despatchtime': instance.despatchtime,
      'flag': instance.flag,
      'numofvia': instance.numofvia,
      'hold': instance.hold,
      'isdirty': instance.isdirty,
      'changed': instance.changed,
      'logc': instance.logc,
      'logd': instance.logd,
      'fromtovia': instance.fromtovia,
    };

Fromtovia _$FromtoviaFromJson(Map<String, dynamic> json) {
  return Fromtovia(
    info: json['info'] as String,
    address: json['address'] as String,
    lat: (json['lat'] as num)?.toDouble(),
    lon: (json['lon'] as num)?.toDouble(),
    postcode: json['postcode'] as String,
  );
}

Map<String, dynamic> _$FromtoviaToJson(Fromtovia instance) => <String, dynamic>{
      'info': instance.info,
      'address': instance.address,
      'lat': instance.lat,
      'lon': instance.lon,
      'postcode': instance.postcode,
    };
