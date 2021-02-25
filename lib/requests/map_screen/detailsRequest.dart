import 'package:flutter/cupertino.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:zippy_rider/GooglePlaces.dart';

class LocationDetails with ChangeNotifier {
  GooglePlaces _googlePlaces = GooglePlaces();

  Future<dynamic> getLocationDetails(String value, bool pos) async {
    Map mapResponse;
    var url = 'http://testing.thedivor.com/Home/PlaceInfo?place=$value';
    print(url);
    http.Response response;
    response = await http.get(url);
    mapResponse = json.decode(response.body);
    LatLng latLng = LatLng(mapResponse['Placedetails']['lattitude'],
        mapResponse['Placedetails']['longitude']);

    _googlePlaces.lattitude = mapResponse['Placedetails']['lattitude'];
    _googlePlaces.longitude = mapResponse['Placedetails']['longitude'];
    _googlePlaces.placeid = mapResponse['Placedetails']['placeid'];
    _googlePlaces.address = mapResponse['Placedetails']['address'];
    _googlePlaces.city = mapResponse['Placedetails']['city'];
    _googlePlaces.country = mapResponse['Placedetails']['country'];
    _googlePlaces.outcode = mapResponse['Placedetails']['outcode'];
    _googlePlaces.postcode = mapResponse['Placedetails']['postcode'];

    //return LatLng(latLng.latitude, latLng.longitude);
    return latLng;
  }
}