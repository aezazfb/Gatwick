// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'CustomerModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CustomerModel _$CustomerModelFromJson(Map<String, dynamic> json) {
  return CustomerModel(
    custUid: json['custUid'] as String,
    appname: json['appname'] as String,
    blacklist: json['blacklist'] as bool,
    custEmail: json['custEmail'] as String,
    custName: json['custName'] as String,
    custPhone: json['custPhone'] as String,
    fcmToken: json['fcmToken'] as String,
    password: json['password'] as String,
    agentnin: json['agentnin'] as String,
    source: json['source'] as String,
    signupDate: json['signupDate'] as int,
    commStartTime: json['commStartTime'] as int,
    commEndTime: json['commEndTime'] as int,
    commMaxValue: json['commMaxValue'] as int,
    commMinValue: json['commMinValue'] as int,
    commDownValue: json['commDownValue'] as int,
    walletamount: json['walletamount'] as int,
  );
}

Map<String, dynamic> _$CustomerModelToJson(CustomerModel instance) =>
    <String, dynamic>{
      'custUid': instance.custUid,
      'appname': instance.appname,
      'blacklist': instance.blacklist,
      'custEmail': instance.custEmail,
      'custName': instance.custName,
      'custPhone': instance.custPhone,
      'fcmToken': instance.fcmToken,
      'password': instance.password,
      'agentnin': instance.agentnin,
      'source': instance.source,
      'signupDate': instance.signupDate,
      'commStartTime': instance.commStartTime,
      'commEndTime': instance.commEndTime,
      'commMaxValue': instance.commMaxValue,
      'commMinValue': instance.commMinValue,
      'commDownValue': instance.commDownValue,
      'walletamount': instance.walletamount,
    };
