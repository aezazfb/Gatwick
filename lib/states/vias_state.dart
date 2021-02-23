import 'package:flutter/cupertino.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:zippy_rider/bottom_model_sheet/bottomsheet.dart';
import 'package:zippy_rider/requests/map_screen/detailsRequest.dart';
import 'package:zippy_rider/requests/vias_screen/calculate_vias_time_distance.dart';
import 'package:zippy_rider/requests/vias_screen/decode_vias_polyline.dart';

class ViasState with ChangeNotifier {
  List<LatLng> viasLatLangList = [];
  List timeDisList = [];
  List viasList = [];
  List<LatLng> viasPolyLinePoints = [];
  Set<Marker> _markers = Set();
  var decodedPolylineString;

  CalculateViasDistanceTime _calculateViasDistanceTime =
      CalculateViasDistanceTime();
  LocationDetails locationDetails = LocationDetails();
  BottomModelSheet _bottomModelSheet = BottomModelSheet();
  DecodeViasPolyLine _decodeViasPolyLine = DecodeViasPolyLine();
  Set<Polyline> polyLine = Set();

  calculateVias(LatLng l1, LatLng l2, context) async {
    timeDisList = await _calculateViasDistanceTime.calculateViasDistanceTime(
        l1, l2, viasLatLangList);
    decodedPolylineString =
        await _calculateViasDistanceTime.viasPolyline(l1, l2, viasLatLangList);
    await _bottomModelSheet.settingModelBottomSheet(
        context, timeDisList[1], timeDisList[0]);
    decodePolyLine();
    timeDisList.clear();

    notifyListeners();
  }

  viasDetails(String value) async {
    LatLng latLng = await locationDetails.getLocationDetails(value);
    viasLatLangList.add(latLng);
    notifyListeners();
  }

  decodePolyLine() async {
    viasPolyLinePoints =
        await _decodeViasPolyLine.decodeViasPolyline(decodedPolylineString);
    print('Vias State $viasPolyLinePoints');
    return viasPolyLinePoints;
  }

  addMarker(LatLng position, String _title, bool flage, double hue) async {
    _markers.add(Marker(
      visible: true,
      markerId: MarkerId("$flage"),
      position: LatLng(position.latitude, position.longitude),
      icon: BitmapDescriptor.defaultMarkerWithHue(hue),
      infoWindow: InfoWindow(
        title: _title,
      ),
    ));
    notifyListeners();
  }
}