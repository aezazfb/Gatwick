
import 'package:json_annotation/json_annotation.dart';

part 'FromToViaModel.g.dart';

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
}
