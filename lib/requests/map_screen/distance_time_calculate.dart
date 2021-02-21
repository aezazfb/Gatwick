import 'dart:ffi';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CalculateDistanceTime {
  calculateDistanceTime(LatLng l1, LatLng l2) async {
    double distance;
    int duration;
    List list = [];
    String _googleAPiKey = "AIzaSyDuoFHe7NQ5U6GZ1SSu7XcckrQ9Bi8_at0";
    Map mapResponse;
    var url =
        "https://maps.googleapis.com/maps/api/directions/json?&origin=${l1.latitude},${l1.longitude}&destination=${l2.latitude},${l2.longitude}&key=$_googleAPiKey";
    http.Response response;
    print(url);
    response = await http.get(url);
    mapResponse = json.decode(response.body);

    List data = mapResponse['routes'];
    if (data.isNotEmpty) {
      var named = data[0]['legs'][0]['distance']['value'];
      duration = data[0]['legs'][0]['duration']['value'];
      distance = named.toDouble();
      distance = distance / 1609.3.toDouble();
      duration = (duration ~/ 60).toInt();
      print('distance: $distance');
      print('duration: $duration');
    } else {
      print('Calculation Not Found');
    }
    String a = '${duration.toStringAsFixed(0)}';
    String b = '${distance.toStringAsFixed(2)}';
    list.add(b);
    list.add(a);
    return list;
  }

//  https://maps.googleapis.com/maps/api/directions/json?&origin=37.785834,-122.406417&destination=37.77559448481996,-122.40550853312017&waypoints=24.896,67.0814&key=AIzaSyDuoFHe7NQ5U6GZ1SSu7XcckrQ9Bi8_at0
}