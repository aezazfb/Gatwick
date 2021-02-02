import 'dart:convert';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:http/http.dart' as http;
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

  String get name => _name;

  bool visibility = true;
  bool flage;

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
  void _getUserLocation() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    _initialPosition = LatLng(position.latitude, position.longitude);
    print(_initialPosition);
    l1 = _initialPosition;
    print(_initialPosition);
    Coordinates latLng =
    Coordinates(initialPosition.latitude, initialPosition.longitude);
    var addreslocation =
    await Geocoder.local.findAddressesFromCoordinates(latLng);
    var first = addreslocation.first;
    sourceController.text = first.addressLine;
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
  void details(String value) async {
    Map mapResponse;
    var url = 'http://testing.thedivor.com/Home/PlaceInfo?place=$value';
    http.Response response;
    response = await http.get(url);
    mapResponse = json.decode(response.body);
    LatLng latLng = LatLng(mapResponse['Placedetails']['lattitude'],
        mapResponse['Placedetails']['longitude']);
    CameraPosition cameraPosition = new CameraPosition(
        target: LatLng(latLng.latitude, latLng.longitude), zoom: 14);

    _mapController.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
    if (flage == true) {
      latLangList.insert(0, latLng);
      l1 = latLangList[0];
    }
    if (flage == false) {
      latLangList.insert(latLangList.length, latLng);
      l2 = latLangList[latLangList.length - 1];
    }

    addMarker(latLng, value, flage);
    notifyListeners();
  }

//----> ADD MARKER ON MAP
  void addMarker(LatLng position, String _title, bool flage) {
    _markers.add(Marker(
      visible: true,
      markerId: MarkerId("$flage"),
      position: LatLng(position.latitude, position.longitude),
      infoWindow: InfoWindow(
        title: _title,
      ),
    ));
  }

//---> ADD POLYLINE ON GOOGLE MAPS
  drawPolyLine() async {
    polyCoordinates = await fetchPolylinePoints.getPolyPoints(l1, l2);
    polyLine.add(
      Polyline(
        polylineId: PolylineId("$flage"),
        visible: true,
        points: polyCoordinates,
        width: 5,
        color: Colors.purple,
      ),
    );
    notifyListeners();
  }

  calcu() async {
    calculateDistanceTime.calculateDistanceTime(l1, l2);
  }






  settingModelBottomSheet(context) async {
    List list = await calculateDistanceTime.calculateDistanceTime(l1, l2);
    print(list);
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
                    child:
                        Text("Book Now", style: TextStyle(color: Colors.white)),
                    onPressed: () {
                      print("hello Your flight is Booked Sir....");
                    },
                  ),
                ),
              ],
            ),
          );
        });
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
                 onPressed: () {
                   sourceController.text = name;
                  flage = false;
                  addMarker(_centerPoints, name, flage);
                  // getPolyPoints();
                  Navigator.pop(context);
                },
               ),
               FlatButton(
                 child: Text("DESTINATION"),
                 onPressed: () async {
                   destinationController.text = name;
                  addMarker(_centerPoints, name, flage = true);
                  // getPolyPoints();
                  Navigator.pop(context);
                },
              )
            ],
          );
        });
  }

  swapFields() {
    String address = sourceController.text.toString();
    sourceController.text = destinationController.text;
    destinationController.text = address;
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