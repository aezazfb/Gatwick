import 'package:flutter/cupertino.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:zippy_rider/bottom_model_sheet/bottomsheet.dart';
import 'package:zippy_rider/requests/map_screen/detailsRequest.dart';
import 'package:zippy_rider/requests/vias_screen/calculate_vias_time_distance.dart';

class ViasState with ChangeNotifier {
  CalculateViasDistanceTime _calculateViasDistanceTime =
      CalculateViasDistanceTime();
  LocationDetails locationDetails = LocationDetails();
  BottomModelSheet _bottomModelSheet = BottomModelSheet();

  List<LatLng> viasLatLangList = [];

  calculateVias(LatLng l1, LatLng l2, context) async {
    List timeDisList = await _calculateViasDistanceTime
        .calculateViasDistanceTime(l1, l2, viasLatLangList);

    _bottomModelSheet.settingModelBottomSheet(
        context, timeDisList[1], timeDisList[0]);
  }

  viasDetails(String value) async {
    LatLng latLng = await locationDetails.getLocationDetails(value);
    print(latLng);
    viasLatLangList.add(latLng);
    notifyListeners();
  }
}
