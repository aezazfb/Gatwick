import 'package:flutter/cupertino.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:zippy_rider/GooglePlaces.dart';

class LocationDetails {
  GooglePlaces _origin;
  GooglePlaces _destination;

  /*var origin;
  var  destinatin;*/
  Future<Map<String, dynamic>> getLocationDetails(String value) async {
    Map mapResponse;
    var url = 'http://testing.thedivor.com/Home/PlaceInfo?place=$value';
    print(url);
    http.Response response;
    response = await http.get(url);
    // print(response.body);
    mapResponse = json.decode(response.body);
    Map<String, dynamic> map = mapResponse;

    // print(map);

    _origin = new GooglePlaces.paramterizedConstructor(
        null,
        mapResponse['Placedetails']['placeid'],
        mapResponse['Placedetails']['address'],
        mapResponse['Placedetails']['postcode'],
        mapResponse['Placedetails']['outcode'],
        mapResponse['Placedetails']['lattitude'],
        mapResponse['Placedetails']['country'],
        mapResponse['Placedetails']['city'],
        mapResponse['Placedetails']['longitude']);

    _destination = new GooglePlaces.paramterizedConstructor(
        null,
        mapResponse['Placedetails']['placeid'],
        mapResponse['Placedetails']['address'],
        mapResponse['Placedetails']['postcode'],
        mapResponse['Placedetails']['outcode'],
        mapResponse['Placedetails']['lattitude'],
        mapResponse['Placedetails']['country'],
        mapResponse['Placedetails']['city'],
        mapResponse['Placedetails']['longitude']);
    // print(JsonEncoder(_origin.toJson));

    // print(_origin.toString());
    /*  _googlePlaces.lattitude = mapResponse['Placedetails']['lattitude'];
    _googlePlaces.longitude = mapResponse['Placedetails']['longitude'];
    _googlePlaces.placeid = mapResponse['Placedetails']['placeid'];
    _googlePlaces.address = mapResponse['Placedetails']['address'];
    _googlePlaces.city = mapResponse['Placedetails']['city'];
    _googlePlaces.country = mapResponse['Placedetails']['country'];
    _googlePlaces.outcode = mapResponse['Placedetails']['outcode'];
    _googlePlaces.postcode = mapResponse['Placedetails']['postcode'];*/

//     var endpointUrl = 'http://testing.thedivor.com/api/API/GetDistance';
//     Map<String, dynamic> queryParams = {
//       'pickup': '${_origin.toString()}',
//       ' dropoff': '${_origin.toString()}'
//     };
//     String queryString = Uri(queryParameters: queryParams).query.toString();
// //print(queryString);
//     var requestUrl = endpointUrl+'?' + queryString; // result - https://www.myurl.com/api/v1/user?param1=1&param2=2t
//    // print(endpointUrl);
//     var response1 = await http.get(requestUrl);
    // print(response1.body);

    return map;
  }
}