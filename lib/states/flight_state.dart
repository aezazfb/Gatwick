import 'package:flutter/cupertino.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:zippy_rider/requests/airports_requests.dart';

class FlightState with ChangeNotifier {
  AirportsData airportsData = AirportsData();

  Set<Marker> _markers = Set();
  List<String> url = [];
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
  var data;
  String airportName;

  Set<Marker> get marker => _markers;

  FlightState() {
    airportsData.getAirportsData();
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
    data = await airportsData.getAirportsData();
    for (int i = 0; i < data.toString().length; i++) {
      _markers.add(Marker(
        markerId: MarkerId("id $i"),
        visible: true,
        position: LatLng(data[i]['Latitude'], data[i]['Longitude']),
      ));
    }
    notifyListeners();
  }

  int i = 0;

  changeCameraPosition() {
    cameraPosition = CameraPosition(
        target: LatLng(data[i]['Latitude'], data[i]['Latitude']), zoom: 13);
    i++;
    if (i > data.toString().length) {
      i = 0;
    } else {
      return null;
    }
    print('++++++++++++++++++++++++++++++++++++++++$airportName');
    notifyListeners();
  }
}
