import 'package:flutter/cupertino.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class FlightState with ChangeNotifier {
  Set<Marker> _markers = Set();
  List<String> url = ['1', '2', '3', '4', '5'];
  GoogleMapController _controller;

  GoogleMapController get mapcontroller => _controller;
  CameraPosition cameraPosition;
  List<LatLng> latlngList = [
    LatLng(51.1537, 0.1821),
    LatLng(53.3588, 2.2727),
    LatLng(51.8860, 0.2389)
  ];

  Set<Marker> get marker => _markers;

//----> ON MAP CREATED
  onMapCreated(GoogleMapController controller) {
    _controller = controller;
  }

//animate Camera
  void animateCamera() {
    _controller.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
    notifyListeners();
  }

//----> ADD MARKER
  void addMarker() {
    for (int i = 0; i < latlngList.length; i++) {
      _markers.add(Marker(
        markerId: MarkerId("id $i"),
        visible: true,
        position: LatLng(latlngList[i].latitude, latlngList[i].longitude),
      ));
    }
    notifyListeners();
  }
}
