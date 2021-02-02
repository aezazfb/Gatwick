import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoder/geocoder.dart';
import 'package:zippy_rider/UI/map_screen.dart';
import 'package:zippy_rider/requests/polyline_request.dart';
import 'package:zippy_rider/requests/suggestionRequest.dart';
import 'package:flutter/material.dart';
import 'package:zippy_rider/requests/detailsRequest.dart';
import 'package:zippy_rider/requests/distance_time_calculate.dart';

class MapState with ChangeNotifier {
  static LatLng _initialPosition;
  static LatLng _centerPoints;
  GoogleMapController _mapController;
  CameraPosition cameraPosition;

  bool locationServiceActive = true;
  Set<Marker> _markers = Set();
  Set<Polyline> polyLine = Set();
  TextEditingController sourceController = TextEditingController();
  TextEditingController destinationController = TextEditingController();

  GoogleMapController get mapController => _mapController;

  LatLng get initialPosition => _initialPosition;

  Set<Marker> get marker => _markers;
  List<LatLng> polyCoordinates = [];
  LatLng get centerPoints => _centerPoints;
  PolylinePoints polylinePoints;


  LocationDetails locationDetails = LocationDetails();
  SuggestionRequest suggestionRequest = SuggestionRequest();
  FetchPolylinePoints fetchPolylinePoints = FetchPolylinePoints();
  MapScreenState mapScreenState = MapScreenState();
  CalculateDistanceTime calculateDistanceTime = CalculateDistanceTime();
  List suggestion = [];
  List<LatLng> latLangList = [];
  Map mapResponse;
  LatLng cameraPositionLatLng;

  LatLng l1;
  LatLng l2;
  String distance;
  String duration;
  String _name = '';
  double originHue = 70.0;

  String get name => _name;

  bool visibility = true;

  MapState() {
    _getUserLocation();
    _loadingInitialPosition();
    notifyListeners();
  }

  //----> Creating onMapCreated for our Map
  void onCreate(GoogleMapController controller) {
    _mapController = controller;
    notifyListeners();
  }

  //----> get Users Current location
  _getUserLocation() async {
    print("get Location Called");
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    _initialPosition = LatLng(position.latitude, position.longitude);
    l1 = LatLng(position.latitude, position.longitude);
    Coordinates latLng =
        Coordinates(initialPosition.latitude, initialPosition.longitude);
    var addreslocation =
        await Geocoder.local.findAddressesFromCoordinates(latLng);
    var first = addreslocation.first;
    sourceController.text = first.addressLine;
    addMarker(_initialPosition, sourceController.text, true, originHue);
    notifyListeners();
  }

//----> SET USERS INITIAL LOCATION
  void _loadingInitialPosition() async {
    await Future.delayed(Duration(milliseconds: 100)).then((v) {
      if (_initialPosition == null) {
        locationServiceActive = false;
        notifyListeners();
      }
    });
  }

  suggestions(value) async {
    suggestion = await suggestionRequest.getSuggestion(value);
    notifyListeners();
  }

  //----->GET LAT LANG FROM ADDRESS
  details(String value, bool flage) async {
    double hue;
    LatLng latLng = await locationDetails.getLocationDetails(value);
    CameraPosition cameraPosition = new CameraPosition(
        target: LatLng(latLng.latitude, latLng.longitude), zoom: 14);
    _mapController
        .animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
    if (flage == true) {
      latLangList.insert(0, latLng);
      l1 = latLangList[0];
    }
    if (flage == false) {
      latLangList.insert(latLangList.length, latLng);
      l2 = latLangList[latLangList.length - 1];
    }

    addMarker(latLng, value, flage, originHue);
    notifyListeners();
  }

//----> ADD MARKER ON MAP
  addMarker(LatLng position, String _title, bool flage, double hue) {
    _markers.add(Marker(
      visible: true,
      markerId: MarkerId("$flage"),
      position: LatLng(position.latitude, position.longitude),
      icon: BitmapDescriptor.defaultMarkerWithHue(hue),
      infoWindow: InfoWindow(
        title: _title,
      ),
    ));
  }

//---> ADD POLYLINE ON GOOGLE MAPS
  drawPolyLine() async {
    if (polyLine.length == 0 || polyLine.last.points.length == 0) {
      polyCoordinates = await fetchPolylinePoints.getPolyPoints(l1, l2);
      polyLine.add(
        Polyline(
          polylineId: PolylineId("poly"),
          visible: true,
          points: polyCoordinates,
          width: 8,
          color: Colors.purple,
        ),
      );
      print(polyLine.length);
    } else {}
    notifyListeners();
  }


  settingModelBottomSheet(context) async {
    List list = await calculateDistanceTime.calculateDistanceTime(l1, l2);
    if (sourceController.text.toString().isNotEmpty &&
        destinationController.text.toString().isNotEmpty) {
      showModalBottomSheet(
          backgroundColor: Colors.deepPurple.withOpacity(0.1),
          enableDrag: true,
          context: context,
          builder: (BuildContext context) {
            return Container(
              margin: EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(12.0)),
                color: Colors.white,
              ),
            child: Wrap(
              children: [
                ListTile(
                  title: Text("Distance ${list[0]} miles"),
                ),
                ListTile(
                  title: Text("Duration ${list[1]} "),
                ),
                Center(
                  child: FlatButton(
                    color: Colors.deepPurple,
                    child: Text("Book Now",
                          style: TextStyle(color: Colors.white)),
                      onPressed: () {
                        print("hello Your flight is Booked Sir....");
                      },
                    ),
                  ),
                ],
              ),
            );
          });
    } else {
      polyLine.last.points.clear();
    }
    notifyListeners();
  }


  onCameraMove(CameraPosition position) async {
    _centerPoints = position.target;
    visibality();
  }

  fetchAddressFromCoordinates(LatLng latLng) async {
    Coordinates coordinates =
        new Coordinates(latLng.latitude, latLng.longitude);
    var locationName =
        await Geocoder.local.findAddressesFromCoordinates(coordinates);
    var first = locationName.first;
    _name = first.addressLine;
    notifyListeners();
  }

  dialogShow(context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: ListTile(
              title: Text("Location Selection",
                  style: TextStyle(color: Colors.black, fontSize: 20.0)),
              leading: Icon(Icons.location_on, size: 40, color: Colors.black),
             ),
             content: Text(
                 "Please Specify That you want to set this Location as you Destination or Origin?"),
             actions: [
               FlatButton(
                 child: Text("CANCEL"),
                 onPressed: () {
                   Navigator.pop(context);
                 },
               ),
               FlatButton(
                 child: Text("ORIGIN"),
                 onPressed: () async {
                   sourceController.text = name;
                  addMarker(_centerPoints, name, true, originHue);
                  l1 = LatLng(_centerPoints.latitude, _centerPoints.longitude);
                  Navigator.pop(context);
                },
               ),
               FlatButton(
                 child: Text("DESTINATION"),
                 onPressed: () {
                   destinationController.text = name;
                  addMarker(_centerPoints, name, false, originHue);
                  l2 = LatLng(_centerPoints.latitude, _centerPoints.longitude);
                  ;
                  Navigator.pop(context);
                },
              )
            ],
          );
        });
  }

  swapFields() async {
    String address = sourceController.text.toString();
    sourceController.text = destinationController.text;
    destinationController.text = address;
    LatLng latLng = l1;
    l1 = l2;
    l2 = latLng;

    notifyListeners();
  }

  clearfields() {
    suggestion.clear();
    notifyListeners();
  }

  visibality() {
    if (destinationController.text.toString().isNotEmpty &&
        sourceController.text.toString().isNotEmpty) {
      visibility = false;
    } else {
      visibility = true;
    }
    notifyListeners();
  }
}