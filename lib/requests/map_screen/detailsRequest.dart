import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LocationDetails {
  Future getLocationDetails(String value) async {
    Map mapResponse;
    var url = 'http://testing.thedivor.com/Home/PlaceInfo?place=$value';
    http.Response response;
    response = await http.get(url);
    mapResponse = json.decode(response.body);
    LatLng latLng = LatLng(mapResponse['Placedetails']['lattitude'],
        mapResponse['Placedetails']['longitude']);
    return LatLng(latLng.latitude, latLng.longitude);
  }
}