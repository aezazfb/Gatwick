import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class DecodeViasPolyLine {
  PolylinePoints polylinePoints = PolylinePoints();
  List<LatLng> list = [];

  decodeViasPolyline(String decodedPolylineString) {
    List<PointLatLng> result =
        polylinePoints.decodePolyline("$decodedPolylineString");
    for (int i = 0; i < result.length; i++) {
      list.add(LatLng(result[i].latitude, result[i].longitude));
    }
    print('__________');
    print(list);
    print(result);
    return list;
  }
}
