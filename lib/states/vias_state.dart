import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:zippy_rider/bottom_model_sheet/bottomsheet.dart';
import 'package:zippy_rider/requests/map_screen/detailsRequest.dart';
import 'package:zippy_rider/requests/map_screen/suggestionRequest.dart';
import 'package:zippy_rider/requests/vias_screen/calculate_vias_time_distance.dart';
import 'package:zippy_rider/requests/vias_screen/decode_vias_polyline.dart';

class ViasState with ChangeNotifier {
  List<LatLng> viasLatLangList = [];
  List timeDisList = [];
  List viasList = [];
  List<LatLng> viasPolyLinePoints = [];
  Set<Marker> _markers = Set();
  var decodedPolylineString;
  List viasSuggestionList = [];
  SuggestionRequest suggestionRequest = SuggestionRequest();
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
    Map<String, dynamic> map = locationDetails.getLocationDetails(value) as Map;
    LatLng latLng = LatLng(
        map['Placedetails']['lattitude'], map['Placedetails']['longitude']);
    // LatLng latLng = await locationDetails.getLocationDetails(value);
    viasLatLangList.add(latLng);
    notifyListeners();
  }

  viaSuggestion(value) async {
    viasSuggestionList = await suggestionRequest.getSuggestion(value);
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
      markerId: MarkerId("$_title"),
      position: LatLng(position.latitude, position.longitude),
      icon: BitmapDescriptor.defaultMarkerWithHue(hue),
      infoWindow: InfoWindow(
        title: _title,
      ),
    ));
    print('marker Added');
    notifyListeners();
  }

  drawPolyLine() async {
      polyLine.add(
      Polyline(
        polylineId: PolylineId("poly"),
        visible: true,
        points: viasPolyLinePoints,
        width: 5,
        color: Colors.purple,
      ),
    );
    print("polyline length ${polyLine.length}");
    notifyListeners();
  }

  clearFields() {
    polyLine.first.points.clear();
    notifyListeners();
  }
}