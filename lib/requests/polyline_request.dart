import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class FetchPolylinePoints{
  Map<PolylineId, Polyline> polylines = {};
  PolylinePoints polylinePoints = PolylinePoints();
  String _googleAPiKey = "AIzaSyDuoFHe7NQ5U6GZ1SSu7XcckrQ9Bi8_at0";
  List<LatLng> polylineCoordinates = [];
  Future<List> getPolyPoints(LatLng l1, LatLng l2) async {
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      _googleAPiKey,
      PointLatLng(l1.latitude, l1.longitude),
      PointLatLng(l2.latitude, l2.longitude),
      travelMode: TravelMode.driving,
      avoidFerries: true,
      avoidTolls: true,
      optimizeWaypoints: true,
    );
    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
    }
  return polylineCoordinates;
  }
}