import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';



class CalculateDistanceTime{
  calculateDistanceTime(LatLng l1, LatLng l2) async {
    String distance;
    var duration;
    LatLng l3 = LatLng(37.77559448481996, -122.40550853312017);
    LatLng l4 = LatLng(37.76339464769511, -122.40968573838472);
    List list = [];
    String _googleAPiKey = "AIzaSyDuoFHe7NQ5U6GZ1SSu7XcckrQ9Bi8_at0";
    Map mapResponse;
    var url =
        "https://maps.googleapis.com/maps/api/directions/json?&origin=${l1.latitude},${l1.longitude}&destination=${l2.latitude},${l2.longitude}&waypoints=${l3.latitude},${l3.longitude}|${l4.latitude},${l4.longitude}&key=$_googleAPiKey";
    http.Response response;
    print(url);
    response = await http.get(url);
    mapResponse = json.decode(response.body);
    var disx;
    var dursd;
    var disx1;
    var dursd1;
    List data = mapResponse['routes'];
    if (data.isNotEmpty) {
      var named = data[0]['legs'][0]['distance']['value'];
      duration = data[0]['legs'][0]['duration']['value'];
      disx = data[0]['legs'][1]['distance']['value'];
      dursd = data[0]['legs'][1]['duration']['value'];
      disx1 = data[0]['legs'][2]['distance']['value'];
      dursd1 = data[0]['legs'][2]['duration']['value'];

      print(named);
      print(duration);
      print(disx);
      print(dursd);
      print(disx1);
      print(dursd1);
      named = named / 1609.34;
      distance = named.toStringAsFixed(2);
      duration = duration + dursd + dursd1;
      duration = duration / 60;
    } else {
      print('Calculation Not Found');
    }
    String a = '${duration.toStringAsFixed(2)}';
    list.add(distance);
    list.add(a);
    return list;
  }

//  https://maps.googleapis.com/maps/api/directions/json?&origin=37.785834,-122.406417&destination=37.77559448481996,-122.40550853312017&waypoints=24.896,67.0814&key=AIzaSyDuoFHe7NQ5U6GZ1SSu7XcckrQ9Bi8_at0
}