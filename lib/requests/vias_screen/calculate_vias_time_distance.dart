import 'dart:convert';
import 'dart:ffi';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

class CalculateViasDistanceTime {
  List timeDurlist = [];

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
//https://maps.googleapis.com/maps/api/directions/json?&origin=51.454334,-0.03796349999998938&destination=51.4920904,-0.03893120000000749&key=AIzaSyDuoFHe7NQ5U6GZ1SSu7XcckrQ9Bi8_at0

    http.Response response;
    response = await http.get(url);
    mapResponse = json.decode(response.body);

    List data = mapResponse['routes'];
    if (data.isNotEmpty) {
      for (int i = 0; i <= list.length; i++) {
        var dis = data[0]['legs'][i]['distance']['value'];
        var dur = data[0]['legs'][i]['duration']['value'];

        // dis = dis / 1609.34;
        distance = distance + dis;
        duration = duration + dur;
        // duration = duration / 60;
      }
    }
    print('Distance :$distance');
    print('Duration : $duration');
    duration = (duration / 60).toInt();
    distance = (distance / 1609.34).toInt();
    print('After Cast Duration : $duration');
    print('After Cast Distance : $distance');
    // var disx1;
    //var dursd1;
    // print("Final Results Diatance: $distance & Duration: $duration");
    //  String a = '${duration.toStringAsFixed(0)}';
    //list.add(distance);
    timeDurlist.add(duration);
    timeDurlist.add(distance);
    return timeDurlist;
  }
//  https://maps.googleapis.com/maps/api/directions/json?&origin=37.785834,-122.406417&destination=37.77559448481996,-122.40550853312017&waypoints=24.896,67.0814&key=AIzaSyDuoFHe7NQ5U6GZ1SSu7XcckrQ9Bi8_at0
}
