import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:zippy_rider/bottom_model_sheet/bottomsheet.dart';
import 'package:zippy_rider/requests/map_screen/detailsRequest.dart';
import 'package:zippy_rider/requests/map_screen/suggestionRequest.dart';
import 'package:zippy_rider/requests/vias_screen/decode_vias_polyline.dart';
import 'package:zippy_rider/utils/util.dart' as util;

class ViasState with ChangeNotifier {
  List<LatLng> viasLatLongList = [];
  List viasList = [];
  List<LatLng> viasPolyLinePoints = [];
  Set<Marker> _markers = Set();
  var decodedPolylineString;
  List viasSuggestionList = [];
  List<String> viasPostCodeList = [];
  List<String> viasOutCodeList = [];

  SuggestionRequest suggestionRequest = SuggestionRequest();
  LocationDetails locationDetails = LocationDetails();
  BottomModelSheet _bottomModelSheet = BottomModelSheet();
  DecodeViasPolyLine _decodeViasPolyLine = DecodeViasPolyLine();
  Set<Polyline> polyLine = Set();


  // calculateVias(LatLng l1, LatLng l2, context) async {
  //   timeDisList = await _calculateViasDistanceTime.calculateViasDistanceTime(
  //       l1, l2, viasLatLangList);
  //
  //   decodedPolylineString =
  //       await _calculateViasDistanceTime.viasPolyline(l1, l2, viasLatLangList);
  //   await _bottomModelSheet.settingModelBottomSheet(
  //       context, timeDisList[1], timeDisList[0]);
  //
  //   decodePolyLine();
  //   timeDisList.clear();
  //   notifyListeners();
  // }


  viasDetails(String value, int flag) async {// bool flage,
    Map<String, dynamic> map =
        await LocationDetails.getLocationDetails(value, flag);
    LatLng latLng = LatLng(
        map['Placedetails']['lattitude'], map['Placedetails']['longitude']);
    viasLatLongList.add(latLng);
    viasPostCodeList.add(map['Placedetails']['outcode']);
    viasOutCodeList.add(map['Placedetails']['postcode']);

    notifyListeners();
  }

  calculateViasDistancetime(context) async {
    List list = await locationDetails.getTimeDistance();
    await _bottomModelSheet.settingModelBottomSheet(context, list[0], list[1]);
    print('${list[0]}');
    print('${list[1]}');
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
        color: util.primaryColor,
      ),
    );
    print("polyline length ${polyLine.length}");
    notifyListeners();
  }

  clearFields() {
    polyLine.first.points.clear();
    notifyListeners();
  }

  //For Logout
  clearAll(){
    viasList.clear();
    viasPostCodeList.clear();
    viasLatLongList.clear();
    viasOutCodeList.clear();
    viasSuggestionList.clear();
    viasPolyLinePoints.clear();
    _markers.clear();
    polyLine.clear();
  }
}
