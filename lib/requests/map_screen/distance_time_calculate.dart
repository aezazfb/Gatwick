import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';



class CalculateDistanceTime{
  calculateDistanceTime(LatLng l1, LatLng l2) async {
    String distance;
    String duration;
    List list = [];
    String _googleAPiKey = "AIzaSyDuoFHe7NQ5U6GZ1SSu7XcckrQ9Bi8_at0";
    Map mapResponse;
    var url =
        "https://maps.googleapis.com/maps/api/directions/json?&origin=${l1.latitude},${l1.longitude}&destination=${l2.latitude},${l2.longitude}&key=$_googleAPiKey";
    http.Response response;
    response = await http.get(url);
    mapResponse = json.decode(response.body);
    List data = mapResponse['routes'];
    if (data.isNotEmpty) {
      var named = data[0]['legs'][0]['distance']['value'];
      duration = data[0]['legs'][0]['duration']['text'];
      named = named / 1609.34;
      distance = named.toStringAsFixed(2);
    }

    list.add(distance);
    list.add(duration);
    return list;
  }



}