import 'dart:core';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:zippy_rider/GooglePlaces.dart';

class LocationDetails {
  GooglePlaces _origin;
  GooglePlaces _destination;

  Future<Map<String, dynamic>> getLocationDetails(String value) async {
    Map mapResponse;
    var url = 'http://testing.thedivor.com/Home/PlaceInfo?place=$value';
    http.Response response;
    response = await http.get(url);
    mapResponse = json.decode(response.body);
    Map<String, dynamic> map = mapResponse;
    Map<String, dynamic> pickup = {
      "id": 'null',
      "placeid": "ChIJ7ZFe_0gCdkgRRcALA0ZN5EE",
      "address": "Brockley Road, London SE4 2BY, UK",
      "postcode": "SE4 2BY",
      "outcode": "SE4",
      "lattitude": 51.454334,
      "country": "United Kingdom",
      "city": "Greater London",
      "longitude": -0.0379635,
    };

    Map<String, dynamic> dropoff = {
      'id': 'null',
      'placeid':
          'EiBMZXdpc2hhbSBXYXksIExvbmRvbiBTRTQgMVVZLCBVSyIuKiwKFAoSCXk1YsdYAnZIERCJXqRiE8WPEhQKEgnrjwApXwJ2SBH76fXJO6C02w',
      'address': 'Lewisham Way, London SE4 1UY, UK',
      'postcode': 'SE4 1UY',
      'outcode': 'SE4 1UY',
      'lattitude': 51.4702816,
      'country': 'United Kingdom',
      'city': 'Greater London',
      'longitude': -0.029187800000045172,
    };

    List<dynamic> list = [pickup, dropoff];
    var url4 = 'http://testing.thedivor.com/api/API/GetDistance?$list';
    final response1 = await http.get(url4);
    print(url4.toString());
    print("__________________________________${response1.body} ");
    return map;
  }
}
