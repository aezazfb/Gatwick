import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';


class CalculateDistanceTime {
  calculateDistanceTime(LatLng l1, LatLng l2) async {
    double distance;
    int duration;
    List list = [];
    String _googleAPiKey = "AIzaSyDuoFHe7NQ5U6GZ1SSu7XcckrQ9Bi8_at0";

    String _baseAPI = 'https://maps.googleapis.com/maps/api/directions/json?';
    Map mapResponse;
    var url =
        "$_baseAPI&origin=${l1.latitude},${l1.longitude}&destination=${l2.latitude},${l2.longitude}&key=$_googleAPiKey";
    http.Response response;
    response = await http.get(url);
    mapResponse = json.decode(response.body);
    print(url);
    List data = mapResponse['routes'];
    if (data.isNotEmpty) {
      var named = data[0]['legs'][0]['distance']['value'];
      duration = data[0]['legs'][0]['duration']['value'];
      distance = named.toDouble();
      distance = distance / 1609.3.toDouble();
      duration = (duration ~/ 60).toInt();
    } else {
      print('Calculation Not Found');
    }
    if (data.isNotEmpty) {
      String a = '${duration.toStringAsFixed(0)}';
      String b = '${distance.toStringAsFixed(2)}';
      list.add(b);
      list.add(a);
    } else {}

    return list;
  }
}