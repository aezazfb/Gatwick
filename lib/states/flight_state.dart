import 'package:flutter/cupertino.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:zippy_rider/requests/airports_requests.dart';

class FlightState with ChangeNotifier {
  AirportsData airportsData = AirportsData();

  Set<Marker> _markers = Set();
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
  List<LatLng> latLangList = [];
  List<String> airPortNamelist = [];

  GoogleMapController get mapcontroller => _controller;
  CameraPosition cameraPosition;

  var data;
  String airportName = '';

  Set<Marker> get marker => _markers;
  //int num;

  FlightState() {
    _saveData();
  }

  _saveData() async {
    data = await airportsData.getAirportsData();
    for (int i = 0; i < 10; i++) {
      latLangList.add(LatLng(data[i]['Latitude'], data[i]['Longitude']));
      airPortNamelist.add(data[i]['Name']);
    }
    _addMarker();
  }

//----> ON MAP CREATED
  onMapCreated(GoogleMapController controller) async {
    _controller = controller;
  }

//animate Camera
  void animateCamera() {
    _controller.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
    notifyListeners();
  }

//----> ADD MARKER
  _addMarker() async {
    // data = await airportsData.getAirportsData();
    for (int i = 0; i < 10; i++) {
      _markers.add(Marker(
        markerId: MarkerId("id $i"),
        visible: true,
        position: LatLng(latLangList[i].latitude, latLangList[i].longitude),
      ));
    }
    notifyListeners();
  }


  changeCameraPosition(int index) {
    cameraPosition = CameraPosition(
        target:
            LatLng(latLangList[index].latitude, latLangList[index].longitude),
        zoom: 15);
    notifyListeners();
  }
}
