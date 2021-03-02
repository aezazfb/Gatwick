import 'package:basic_utils/basic_utils.dart';
import 'package:http/http.dart' as http;
import 'package:requests/requests.dart';

import 'dart:convert';
import 'package:zippy_rider/GooglePlaces.dart';

class LocationDetails {
  GooglePlaces googlePlaces = new GooglePlaces();

  Future<Map<String, dynamic>> getLocationDetails(String value) async {
    Map mapResponse;
    var url = 'http://testing.thedivor.com/Home/PlaceInfo?place=$value';
    http.Response response;
    response = await http.get(url);
    mapResponse = json.decode(response.body);
    Map<String, dynamic> map = mapResponse;

    var pickUp = {
      "",
      "ChIJ7ZFe_0gCdkgRRcALA0ZN5EE",
      "Brockley Road, London SE4 2BY, UK",
      " SE4 2BY",
      "SE4",
      51.454334,
      "United Kingdom",
      "Greater London",
      -0.0379635
    };

    var dropOff = {
      "",
      "ChIJt3-FKDsKdkgRrsljcgmJThU",
      "Surbiton KT6 7QD, UK",
      "KT6 7QD",
      "KT6",
      51.3751638,
      "United Kingdom",
      "",
      -0.293779
    };

    Map<String, dynamic> pickup = {
      "_id": "",
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
      "_id": "",
      "placeid": "",
      "address": "Kenley Road, London SW19 3DW, UK",
      "postcode": "SE23 3RF",
      "outcode": "SE23",
      "lattitude": 51.404556,
      "country": "",
      "city": "",
      "longitude": -0.194486
    };

    // var url1 = 'http://testing.thedivor.com/api/API/GetDistance?${list[0]},${list[1]}';
    // print(url1);
    // final response1 = await http.post(url1,null,list,Json);
    // print("__________________________________${response1.body}");

    // var urlpp = 'http://testing.thedivor.com/api/API/GetDistance';
    // var responsepp = await http.post(urlpp,body: list);
    // print('Response status: ${responsepp.statusCode}');
    // print('Response body: ${responsepp.body}');

    // print(await http.read('https://example.com/foobar.txt'));

    var req = await Requests.post(
        'http://testing.thedivor.com/api/API/GetDistance',
        headers: {'Content-Type': 'application/json'},
        body: {pickup, dropoff});
    print(
        'response_____________O______________)___________________0___________O_________\n');
    print(req.json());
    print(req.content());
    if (req.statusCode == 200) {
      print(
          'response_____________O______________)___________________0___________O_________\n');
    }

//
//     var url3 =
//         "http://testing.thedivor.com/api/API/GetDistance?$queryParameters";
//     String qureyString = Uri(queryParameters: queryParameters).query;
//     var endpointUrl = 'http://testing.thedivor.com/api/API/GetDistance?';
//
//     var requestUrl = endpointUrl + '?' + qureyString;
//     var repu = await http.get(requestUrl);
//     print('ittttsss_______________${repu.body}');
//     var uri = Uri.https(
//         'testing.thedivor.com', '/api/API/GetDistance?', queryParameters);
//
//     Map<String, String> headers = {"Accept": "application/json"};
//
//Body
//     String body = "[{$pickUp},{$dropOff}]";
// // Send request
//     var responseData = await HttpUtils.postForJson(
//         "http://testing.thedivor.com", body);
//     print(responseData.values);

    return map;
  }
}
