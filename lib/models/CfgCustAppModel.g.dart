// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'CfgCustAppModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CfgCustAppModel _$CfgCustAppModelFromJson(Map<String, dynamic> json) {
  return CfgCustAppModel(
    id: json['id'] as String,
    officename: json['officename'] as String,
    imageIp: json['imageIp'] as String,
    officePosition: (json['officePosition'] as List)
        ?.map((e) => (e as num)?.toDouble())
        ?.toList(),
    jobInOffice: json['jobInOffice'] as String,
    googleServiceKey: json['googleServiceKey'] as String,
    googleDirectionKey: json['googleDirectionKey'] as String,
    googlePlaceKey: json['googlePlaceKey'] as String,
    legacyserverkey: json['legacyserverkey'] as String,
    phoneNumber: json['phoneNumber'] as String,
    iOsVersion: json['iOsVersion'] as String,
    androidVersion: json['androidVersion'] as String,
    airportMinPrice: (json['airportMinPrice'] as num)?.toDouble(),
    airportPickupExt: (json['airportPickupExt'] as num)?.toDouble(),
    allVehicleFare: (json['allVehicleFare'] as List)
        ?.map((e) => e == null
            ? null
            : AllVehicleFare.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    milesUnit: (json['milesUnit'] as List)?.map((e) => e as int)?.toList(),
    costUnit: (json['costUnit'] as List)
        ?.map((e) => (e as num)?.toDouble())
        ?.toList(),
    carstype: (json['carstype'] as List)
        ?.map((e) =>
            e == null ? null : Carstype.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    offemailpwd: json['offemailpwd'] as String,
    offemail: json['offemail'] as String,
    smtpHost: json['smtpHost'] as String,
    stripkey: json['stripkey'] as String,
    cardpaymentallow: json['cardpaymentallow'] as bool,
    ftphost: json['ftphost'] as String,
    ftpuser: json['ftpuser'] as String,
    ftppass: json['ftppass'] as String,
    ftppathUrl: json['ftppathUrl'] as String,
    drvdetailtime: json['drvdetailtime'] as int,
    drvsendjobtime: json['drvsendjobtime'] as int,
    smtpPort: json['smtpPort'] as int,
    favouriteenabled: json['favouriteenabled'] as bool,
    favouritedates: (json['favouritedates'] as List)
        ?.map((e) => e == null
            ? null
            : Favouritedate.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    surchargeenabled: json['surchargeenabled'] as bool,
    surchargevalue: (json['surchargevalue'] as num)?.toDouble(),
    walletstartdate: json['walletstartdate'] as int,
    walletenddate: json['walletenddate'] as int,
    walletpercent: json['walletpercent'] as int,
    walletamount: json['walletamount'] as int,
    surchargesstartdate: json['surchargesstartdate'] as int,
    surchargesenddate: json['surchargesenddate'] as int,
    smsgateway: json['smsgateway'] as String,
  );
}

Map<String, dynamic> _$CfgCustAppModelToJson(CfgCustAppModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'officename': instance.officename,
      'imageIp': instance.imageIp,
      'officePosition': instance.officePosition,
      'jobInOffice': instance.jobInOffice,
      'googleServiceKey': instance.googleServiceKey,
      'googleDirectionKey': instance.googleDirectionKey,
      'googlePlaceKey': instance.googlePlaceKey,
      'legacyserverkey': instance.legacyserverkey,
      'phoneNumber': instance.phoneNumber,
      'iOsVersion': instance.iOsVersion,
      'androidVersion': instance.androidVersion,
      'airportMinPrice': instance.airportMinPrice,
      'airportPickupExt': instance.airportPickupExt,
      'allVehicleFare': instance.allVehicleFare,
      'milesUnit': instance.milesUnit,
      'costUnit': instance.costUnit,
      'carstype': instance.carstype,
      'offemailpwd': instance.offemailpwd,
      'offemail': instance.offemail,
      'smtpHost': instance.smtpHost,
      'stripkey': instance.stripkey,
      'cardpaymentallow': instance.cardpaymentallow,
      'ftphost': instance.ftphost,
      'ftpuser': instance.ftpuser,
      'ftppass': instance.ftppass,
      'ftppathUrl': instance.ftppathUrl,
      'drvdetailtime': instance.drvdetailtime,
      'drvsendjobtime': instance.drvsendjobtime,
      'smtpPort': instance.smtpPort,
      'favouriteenabled': instance.favouriteenabled,
      'favouritedates': instance.favouritedates,
      'surchargeenabled': instance.surchargeenabled,
      'surchargevalue': instance.surchargevalue,
      'walletstartdate': instance.walletstartdate,
      'walletenddate': instance.walletenddate,
      'walletpercent': instance.walletpercent,
      'walletamount': instance.walletamount,
      'surchargesstartdate': instance.surchargesstartdate,
      'surchargesenddate': instance.surchargesenddate,
      'smsgateway': instance.smsgateway,
    };

AllVehicleFare _$AllVehicleFareFromJson(Map<String, dynamic> json) {
  return AllVehicleFare(
    the6: json['the6'] as int,
    the8: json['the8'] as int,
    e: json['e'] as int,
    x: json['x'] as int,
  );
}

Map<String, dynamic> _$AllVehicleFareToJson(AllVehicleFare instance) =>
    <String, dynamic>{
      'the6': instance.the6,
      'the8': instance.the8,
      'e': instance.e,
      'x': instance.x,
    };

Carstype _$CarstypeFromJson(Map<String, dynamic> json) {
  return Carstype(
    carname: json['carname'] as String,
    carcapacity: json['carcapacity'] as int,
    lugagecapacity: json['lugagecapacity'] as int,
    activecar: json['activecar'] as bool,
  );
}

Map<String, dynamic> _$CarstypeToJson(Carstype instance) => <String, dynamic>{
      'carname': instance.carname,
      'carcapacity': instance.carcapacity,
      'lugagecapacity': instance.lugagecapacity,
      'activecar': instance.activecar,
    };

Favouritedate _$FavouritedateFromJson(Map<String, dynamic> json) {
  return Favouritedate(
    date: json['date'] as String,
    value: (json['value'] as num)?.toDouble(),
  );
}

Map<String, dynamic> _$FavouritedateToJson(Favouritedate instance) =>
    <String, dynamic>{
      'date': instance.date,
      'value': instance.value,
    };
