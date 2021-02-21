import 'package:flutter/cupertino.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:zippy_rider/bottom_model_sheet/bottomsheet.dart';
import 'package:zippy_rider/requests/map_screen/detailsRequest.dart';
import 'package:zippy_rider/requests/vias_screen/calculate_vias_time_distance.dart';
import 'package:zippy_rider/states/map_state.dart';

class ViasState with ChangeNotifier {
  List<LatLng> viasLatLangList = [];
  List timeDisList = [];
  CalculateViasDistanceTime _calculateViasDistanceTime =
      CalculateViasDistanceTime();
  LocationDetails locationDetails = LocationDetails();
  BottomModelSheet _bottomModelSheet = BottomModelSheet();

  calculateVias(LatLng l1, LatLng l2, context) async {
    timeDisList = await _calculateViasDistanceTime.calculateViasDistanceTime(
        l1, l2, viasLatLangList);
    await _bottomModelSheet.settingModelBottomSheet(
        context, timeDisList[1], timeDisList[0]);
    timeDisList.clear();
    notifyListeners();
  }
  viasDetails(String value) async {
    LatLng latLng = await locationDetails.getLocationDetails(value);
    viasLatLangList.add(latLng);
    notifyListeners();
  }
}
