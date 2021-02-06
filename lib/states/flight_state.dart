import 'package:flutter/cupertino.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class FlightState with ChangeNotifier {
  Set<Marker> _markers = Set();
  List<String> url = ['1', '2', '3', '4', '5'];
  List<String> images = [
    'assets/airportsImages/ap1.jpeg',
    'assets/airportsImages/ap2.jpg',
    'assets/airportsImages/ap3.jpg',
    'assets/images/logo2.png',
    'assets/images/markerLogo.png',
    'assets/images/marker_logo.png',
    'assets/images/logo2.webp' 'assets/images/image.jpeg'
  ];
  GoogleMapController _controller;

  GoogleMapController get mapcontroller => _controller;
  CameraPosition cameraPosition;
  List<LatLng> latlngList = [
    LatLng(51.1537, 0.1821),
    LatLng(53.3588, 2.2727),
    LatLng(51.8860, 0.2389)
  ];

  Set<Marker> get marker => _markers;
  FlightState() {
    _addMarker();
  }
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
  _addMarker() {
    for (int i = 0; i < latlngList.length; i++) {
      _markers.add(Marker(
        markerId: MarkerId("id $i"),
        visible: true,
        position: LatLng(latlngList[i].latitude, latlngList[i].longitude),
      ));
    }
    notifyListeners();
  }

  int i = 0;

  changeCameraPosition() {
    cameraPosition = CameraPosition(
        target: LatLng(latlngList[i].latitude, latlngList[i].longitude),
        zoom: 18);
    i++;
    if (i > 2) {
      i = 0;
    } else {
      return null;
    }
    notifyListeners();
  }
}
