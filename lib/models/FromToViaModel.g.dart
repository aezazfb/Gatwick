// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'FromToViaModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

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
