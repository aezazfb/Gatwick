import 'dart:convert';
import 'dart:ffi';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

class CalculateViasDistanceTime {
  List timeDurlist = [];
  var viasPolylineString;

  calculateViasDistanceTime(LatLng l1, LatLng l2, List<LatLng> list) async {
    int distance = 0;
    int duration = 0;
    var url;

    String _googleAPiKey = "AIzaSyDuoFHe7NQ5U6GZ1SSu7XcckrQ9Bi8_at0";
    String _baseAPI =
        'https://maps.googleapis.com/maps/api/directions/json?&origin';
    Map mapResponse;
    String waypoint = '';
    for (int i = 0; i < list.length; i++) {
      if (list.length == 1) {
        waypoint = '${list[i].latitude},${list[i].longitude}';
      }
      if (list.length > 1) {
        waypoint = '$waypoint|${list[i].latitude},${list[i].longitude}';
      }
    }

    url =
        "$_baseAPI=${l1.latitude},${l1.longitude}&destination=${l2.latitude},${l2.longitude}&waypoints=$waypoint&key=$_googleAPiKey";
    print(url);

    http.Response response;
    response = await http.get(url);
    mapResponse = json.decode(response.body);

    List data = mapResponse['routes'];
    if (data.isNotEmpty) {
      for (int i = 0; i <= list.length; i++) {
        var dis = data[0]['legs'][i]['distance']['value'];
        var dur = data[0]['legs'][i]['duration']['value'];
        distance = distance + dis;
        duration = duration + dur;
      }
    }
    viasPolylineString = data[0]['overview_polyline'];
    print('Distance :$distance');
    print('Duration : $duration');
    duration = (duration / 60).toInt();
    distance = (distance / 1609.34).toInt();
    print('After Cast Duration : $duration');
    print('After Cast Distance : $distance');
    print('$viasPolylineString');
    //list.add(distance);
    timeDurlist.add(duration);
    timeDurlist.add(distance);
    return timeDurlist;
  }

  viasPolyline(LatLng l1, LatLng l2, List<LatLng> list) async {
    var url;

    String _googleAPiKey = "AIzaSyDuoFHe7NQ5U6GZ1SSu7XcckrQ9Bi8_at0";
    String _baseAPI =
        'https://maps.googleapis.com/maps/api/directions/json?&origin';
    Map mapResponse;
    String waypoint = '';
    for (int i = 0; i < list.length; i++) {
      if (list.length == 1) {
        waypoint = '${list[i].latitude},${list[i].longitude}';
      }
      if (list.length > 1) {
        waypoint = '$waypoint|${list[i].latitude},${list[i].longitude}';
      }
    }

    url =
        "$_baseAPI=${l1.latitude},${l1.longitude}&destination=${l2.latitude},${l2.longitude}&waypoints=$waypoint&key=$_googleAPiKey";
    print(url);

    http.Response response;
    response = await http.get(url);
    mapResponse = json.decode(response.body);

    List data = mapResponse['routes'];
    viasPolylineString = data[0]['overview_polyline']['points'];
    return viasPolylineString;
  }
}
