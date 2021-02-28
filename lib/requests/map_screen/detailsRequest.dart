import 'package:http/http.dart' as http;

import 'package:basic_utils/basic_utils.dart';
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
      "_id": 'null',
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
      '_id': 'null',
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
    var a = jsonEncode(pickup);
    var b = jsonEncode(dropoff);
    List<dynamic> list = [a, b];

/*
    var url4 = 'http://testing.thedivor.com/api/API/GetDistance?${a},${b}';
    final response1 = await http.get(url4);
    print(url4.toString());
    print("__________________________________${response1.body} ");
*/

    Map<String, String> queryParameters = {
      'pickup': pickup.toString(),
      'dropoff': dropoff.toString(),
    };
    var url3 =
        "http://testing.thedivor.com/api/API/GetDistance?$queryParameters";
    String qureyString = Uri(queryParameters: queryParameters).query;
    var endpointUrl = 'http://testing.thedivor.com/api/API/GetDistance?';

    var requestUrl = endpointUrl + '?' + qureyString;
    var repu = await http.get(requestUrl);
    print('ittttsss_______________${repu.body}');
    var uri = Uri.https(
        'testing.thedivor.com', '/api/API/GetDistance?', queryParameters);

    Map<String, String> headers = {"Accept": "application/json"};

// Body
    String body = "[{'pickup':$pickup},{'dropoff': $dropoff}]";
// Send request
    var responseData = await HttpUtils.postForJson(
        "http://testing.thedivor.com/api/API/GetDistance?", body);
    print(responseData);
  }
}
