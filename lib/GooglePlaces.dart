import 'package:zippy_rider/requests/map_screen/detailsRequest.dart';

class GooglePlaces {
  var _id = null;
  String _placeid = "ChIJt3-FKDsKdkgRrsljcgmJThU";
  String _address = 'Surbiton KT6 7QD, UK';
  String _postcode = "KT6 7QD";
  String _outcode = "KT6";
  double _lattitude = 51.3751638;
  String _country = "United Kingdom";
  String _city = "";
  double _longitude = -0.293779;

  GooglePlaces();

  GooglePlaces.paramterizedConstructor(
      this._id,
      this._placeid,
      this._address,
      this._postcode,
      this._outcode,
      this._lattitude,
      this._country,
      this._city,
      this._longitude);

  double get longitude => _longitude;

  set longitude(double value) {
    _longitude = value;
  }

  String get city => _city;

  set city(String value) {
    _city = value;
  }

  String get country => _country;

  set country(String value) {
    _country = value;
  }

  double get lattitude => _lattitude;

  set lattitude(double value) {
    _lattitude = value;
  }

  String get outcode => _outcode;

  set outcode(String value) {
    _outcode = value;
  }

  String get postcode => _postcode;

  set postcode(String value) {
    _postcode = value;
  }

  String get address => _address;

  set address(String value) {
    _address = value;
  }

  String get placeid => _placeid;

  set placeid(String value) {
    _placeid = value;
  }

  get id => _id;

  set id(value) {
    _id = value;
  }

  @override
  String toString() {
    return 'GooglePlaces{_id: $_id, _placeid: $_placeid, _address: $_address, _postcode: $_postcode, _outcode: $_outcode, _lattitude: $_lattitude, _country: $_country, _city: $_city, _longitude: $_longitude}';
  }
}
