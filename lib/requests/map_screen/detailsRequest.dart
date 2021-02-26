import 'package:flutter/cupertino.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:zippy_rider/GooglePlaces.dart';

class LocationDetails {
  GooglePlaces _googlePlaces = GooglePlaces();

  Future<Map<String, dynamic>> getLocationDetails(String value) async {
    Map mapResponse;
    var url = 'http://testing.thedivor.com/Home/PlaceInfo?place=$value';
    print(url);
    http.Response response;
    response = await http.get(url);
    mapResponse = json.decode(response.body);
    Map<String, dynamic> map = mapResponse;

    _googlePlaces.lattitude = mapResponse['Placedetails']['lattitude'];
    _googlePlaces.longitude = mapResponse['Placedetails']['longitude'];
    _googlePlaces.placeid = mapResponse['Placedetails']['placeid'];
    _googlePlaces.address = mapResponse['Placedetails']['address'];
    _googlePlaces.city = mapResponse['Placedetails']['city'];
    _googlePlaces.country = mapResponse['Placedetails']['country'];
    _googlePlaces.outcode = mapResponse['Placedetails']['outcode'];
    _googlePlaces.postcode = mapResponse['Placedetails']['postcode'];
    return map;
  }
}