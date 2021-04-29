import 'dart:async';
import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart' as GeoLocatorPackage;
import 'package:geocoder/geocoder.dart' as GeocoderPackage;
import 'package:location/location.dart';

//import 'package:permission_handler/permission_handler.dart' as PermissionHandler;
//import 'package:location_permissions/location_permissions.dart' as lpPackage;
import 'package:share/share.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zippy_rider/UI/map_screen.dart';
import 'package:zippy_rider/UI/vias_screen.dart';
import 'package:zippy_rider/base_class.dart';
import 'package:zippy_rider/requests/map_screen/polyline_request.dart';
import 'package:zippy_rider/requests/map_screen/suggestionRequest.dart';
import 'package:flutter/material.dart';
import 'package:zippy_rider/requests/map_screen/detailsRequest.dart';
import 'package:zippy_rider/requests/map_screen/distance_time_calculate.dart';
import 'package:connectivity/connectivity.dart';
import 'package:maps_curved_line/maps_curved_line.dart';
import 'package:zippy_rider/bottom_model_sheet/bottomsheet.dart';

class MapState extends BaseClass with ChangeNotifier {
  static LatLng initialPositions;
  static LatLng _centerPoints;
  DateTime userSelectedDate = DateTime.now();
  TimeOfDay userSelectedTime = TimeOfDay.now();
  LatLng l1 = LatLng(0.0000, 0.0000);
  LatLng l2 = LatLng(0.0000, 0.0000);
  String outcode1, outcode2, postcode1, postcode2;
  GoogleMapController mapControllerr;
  Set<Marker> _wholeMarkersList = Set();

  bool locationServiceActive = true;
  Location location = new Location();
  bool _serviceEnabled;

  Set<Marker> _markers = Set();
  Set<Circle> _circles = Set<Circle>();
  Set<Polyline> polyLine = Set();
  List<dynamic> polyCoordinates = [];
  PolylinePoints polylinePoints;
  List suggestion = [];
  List<LatLng> latLangList = [];
  GeoLocatorPackage.Position position;
  List dummyList = [];
  TextEditingController sourceController = TextEditingController();
  TextEditingController destinationController = TextEditingController();
  TextEditingController feedBackController = TextEditingController();

  TextEditingController viasController = TextEditingController();

  GoogleMapController get mapController => mapControllerr;

  LatLng get initialPosition => initialPositions;

  Set<Marker> get marker => _markers;

  Set<Circle> get circle => _circles;

  LatLng get centerPoints => _centerPoints;

  String get name => _name;

  LocationDetails locationDetails = LocationDetails();
  SuggestionRequest suggestionRequest = SuggestionRequest();
  FetchPolylinePoints fetchPolylinePoints = FetchPolylinePoints();
  MapScreenState mapScreenState = MapScreenState();
  CalculateDistanceTime calculateDistanceTime = CalculateDistanceTime();
  BottomModelSheet bottomModelSheet = BottomModelSheet();
  AddViasState viasScreen = AddViasState();

  String distance;
  String time;
  String _name = '';
  double originHue = 70.0;
  static String userName, userEmail, userPhone;

  bool cardVisibility = true;
  bool stackElementsVisibility = true;
  bool showAppBar = false;

  MapState() {
    checkConnectivity();
    enableLocationService();
    //_getUserLocation();
    _loadingInitialPosition();
    callcfgCustAppMethod();
    getConfigFromSharedPref();
    notifyListeners();
  }

  //----> setting config of customer at start of app
  callcfgCustAppMethod() async {
    await setCfgCustAppModel();
  }

  //----> Creating onMapCreated for our Map
  void onCreate(GoogleMapController controller) {
    mapControllerr = controller;

    notifyListeners();
  }

  clearAll() {
    sourceController.clear();
    destinationController.clear();
    latLangList.clear();
    outcode1 ='';
    outcode2 ='';
    postcode1 ='';
    postcode2 ='';
    polyCoordinates.clear();
    marker.clear();
    userName = '';
    userEmail = '';
    userPhone = '';
  }

  void getConfigFromSharedPref() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    print("Print value: ${sharedPreferences.getString('cEmail')}");
    print("Print value: ${sharedPreferences.getString('cPhone')}");
    print("Print value: ${sharedPreferences.getString('cName')}");
    if (sharedPreferences.getString('cEmail') != null &&
        sharedPreferences.getString('cPhone') != null &&
        sharedPreferences.getString('cName') != null) {
      //Navigator.pushNamed(context, '/mapscreen');
      userName = sharedPreferences.getString('cName');
      userEmail = sharedPreferences.getString('cEmail');
      userPhone = sharedPreferences.getString('cPhone');
    }
  }

  //----> enable location service to handle initial position
  enableLocationService() async {
    try {
      _serviceEnabled =
          await GeoLocatorPackage.Geolocator.isLocationServiceEnabled();
      if (!_serviceEnabled) {
        _serviceEnabled = await location.requestService();
        if (!_serviceEnabled) {
          initialPositions = LatLng(0.000000, 0.000000);
          notifyListeners();
        } else {
          _getUserLocation();
        }
      } else {
        _getUserLocation();
      }
    } catch (e) {
      print('Exception caught: $e');
    }
  }

  //----> get Users Initial location
  _getUserLocation() async {
    position = await GeoLocatorPackage.Geolocator.getCurrentPosition(
        desiredAccuracy: GeoLocatorPackage.LocationAccuracy.high);
    print('position: $position');

    initialPositions = LatLng(position.latitude, position.longitude);
    print('initialposition: $initialPositions');

    l1 = LatLng(position.latitude, position.longitude);
    GeocoderPackage.Coordinates latLng = GeocoderPackage.Coordinates(
        initialPosition.latitude, initialPosition.longitude);
    var addresslocation = await GeocoderPackage.Geocoder.local
        .findAddressesFromCoordinates(latLng);
    var first = addresslocation.first;
    if (first.addressLine.isNotEmpty) {
      sourceController.text = first.addressLine;
    } else {
      return null;
    }
    notifyListeners();
  }

//----> GET USERS CURRENT LOCATION
  currentLocation() async {
    try {
      GeoLocatorPackage.Position position =
          await GeoLocatorPackage.Geolocator.getCurrentPosition(
              desiredAccuracy: GeoLocatorPackage.LocationAccuracy.high);
      CameraPosition cameraPosition = new CameraPosition(
          target: LatLng(position.latitude, position.longitude), zoom: 17);
      mapController.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));

      LatLng latLng = LatLng(position.latitude, position.longitude);
      fetchAddressFromCoordinates(latLng);
    } catch (e) {
      print('Caught Exception: $e');
    }
  }

//----> SET USERS INITIAL LOCATION
  void _loadingInitialPosition() async {
    await Future.delayed(Duration(milliseconds: 100)).then((v) {
      if (initialPositions == null) {
        locationServiceActive = false;
        notifyListeners();
      }
    });
  }

//---->FETCH SUGGESTION ON SEARCH
  suggestions(value) async {
    suggestion = await suggestionRequest.getSuggestion(value);
    notifyListeners();
  }

  //----->GET LAT LANG FROM ADDRESS
  details(String value, int flag) async {
    //bool flage
    print("Selected Location Name: $value");
    Map<String, dynamic> map =
        await LocationDetails.getLocationDetails(value, flag); //flage
    LatLng latLng = LatLng(
        map['Placedetails']['lattitude'], map['Placedetails']['longitude']);
    CameraPosition cameraPosition = new CameraPosition(
        target: LatLng(latLng.latitude, latLng.longitude), zoom: 14);
    print("cameraPosition: $cameraPosition");
    await mapControllerr
        .animateCamera(CameraUpdate.newCameraPosition(cameraPosition));

    if (flag == 0) {
      latLangList.insert(0, latLng);
      l1 = latLangList[0];

      print('outcode1: ${map['Placedetails']['outcode']}');
      print('postcode1: ${map['Placedetails']['postcode']}');

      outcode1 = map['Placedetails']['outcode'];
      postcode1 = map['Placedetails']['postcode'];
    }
    if (flag == 1) {
      latLangList.insert(latLangList.length, latLng);
      l2 = latLangList[latLangList.length - 1];

      print('outcode2: ${map['Placedetails']['outcode']}');
      print('postcode2: ${map['Placedetails']['postcode']}');

      outcode2 = map['Placedetails']['outcode'];
      postcode2 = map['Placedetails']['postcode'];
    }
    print("____________________________________________________");
    addMarker(latLng, value, flag, originHue);
    notifyListeners();
  }

//----> ADD MARKER ON MAP
  addMarker(LatLng position, String _title, int flag, double hue) async {
    var value;
    if (flag == 7) {
      value = _title.trim();
    } else {
      value = flag;
    }
    _markers.add(Marker(
      visible: true,
      markerId: MarkerId("$value"),
      //$flag
      position: LatLng(position.latitude, position.longitude),
      icon: BitmapDescriptor.defaultMarkerWithHue(hue),
      infoWindow: InfoWindow(
        title: _title,
      ),
    ));
    print('MARKERS: $_markers');
    notifyListeners();
  }

//---->ADD CIRCLES ON SOURCE AND DESTINATION
  addCircle(LatLng latLng1, LatLng latLng2, String id1, String id2) async {
    //SOURCE CIRCLE
    _circles.add(Circle(
      circleId: CircleId(id1),
      center: latLng1,
      visible: true,
      strokeColor: Colors.purple,
      strokeWidth: 2,
      fillColor: Colors.greenAccent,
      radius: 10.0,
    ));
    //DESTINATION
    _circles.add(Circle(
      circleId: CircleId(id2),
      center: latLng2,
      visible: true,
      strokeColor: Colors.purple,
      strokeWidth: 3,
      fillColor: Colors.greenAccent,
      radius: 10.0,
    ));
    _markers.clear();
  }

//----> ADD POLYLINE ON GOOGLE MAPS
  drawPolyLine(LatLng l1, LatLng l2) async {
    if (sourceController.text.toString().isNotEmpty &&
        destinationController.text.toString().isNotEmpty) {
      polyCoordinates = await fetchPolylinePoints.getPolyPoints(l1, l2);
      if (polyLine.length == 0) {
        print("polyline length ${polyLine.length}");
        polyLine.add(
          Polyline(
            polylineId: PolylineId("poly"),
            visible: true,
            points: MapsCurvedLines.getPointsOnCurve(l1, l2),
            width: 5,
            color: Colors.purple,
          ),
        );
      } else {
        return null;
      }
    }
    notifyListeners();
  }

//----> BOTTOM MODEL SHEET
  settingModelBottomSheet(context) async {
    if (sourceController.text.toString().isNotEmpty &&
        destinationController.text.toString().isNotEmpty) {
      //calculateDistanceTime.calculateDistanceTime(l1, l2);
      List list = await locationDetails.getTimeDistance();
      bottomModelSheet.settingModelBottomSheet(
          context, '${list[0]}', '${list[1]}');
      //sourceController.text.toString(),destinationController.text.toString(),outcode1,outcode2,postcode1,postcode2
      print('Time Distance $list');
    } else {
      return null;
    }
    notifyListeners();
  }

//---->FETCH CORDINATES ON CAMERA MOVE
  onCameraMove(CameraPosition position) async {
    _centerPoints = position.target;
    visibility();
  }

//----> FETCH ADDRESSES FROM COORDINATES
  fetchAddressFromCoordinates(LatLng latLng) async {
    GeocoderPackage.Coordinates coordinates =
        new GeocoderPackage.Coordinates(latLng.latitude, latLng.longitude);
    var locationName = await GeocoderPackage.Geocoder.local
        .findAddressesFromCoordinates(coordinates);
    var first = locationName.first;
    print(
        'total stuff: $first \n ${first.postalCode}\n${first.locality}\n${first.subLocality}\n${first.thoroughfare}'
        '\n\n\n\n\n');
    _name = first.addressLine;
    notifyListeners();
  }

//----> ADD PICKUP/DROPOFF DIALOG SHOW.
  dialogShow(context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: ListTile(
              title: Text("Location Selection",
                  style: TextStyle(color: Colors.black, fontSize: 20.0)),
              leading: Icon(Icons.not_listed_location,
                  size: 40, color: Colors.black),
            ),
            content: Text(
                "Please Specify that you want to set this Location as your Destination or Origin?"),
            actions: [
              TextButton(
                child: Text("CANCEL"),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              TextButton(
                child: Text("ORIGIN"),
                onPressed: () async {
                  sourceController.text = name;
                  addMarker(_centerPoints, name, 0, originHue);
                  l1 = LatLng(_centerPoints.latitude, _centerPoints.longitude);
                  // addCircle(centerPoints);
                  Navigator.pop(context);
                },
              ),
              TextButton(
                child: Text("DESTINATION"),
                onPressed: () {
                  destinationController.text = name;
                  addMarker(_centerPoints, name, 1, originHue);
                  l2 = LatLng(_centerPoints.latitude, _centerPoints.longitude);
                  Navigator.pop(context);
                },
              )
            ],
          );
        });
  }

//----> SWAP DESTINATION and SOURCE TEXFIELDS.
  swapFields() async {
    if (sourceController.text.toString().isNotEmpty &&
        destinationController.text.toString().isNotEmpty) {
      String address = sourceController.text.toString();
      sourceController.text = destinationController.text;
      destinationController.text = address;

      LatLng latLng = l1;
      l1 = l2;
      l2 = latLng;

      polyLine.last.points.clear();
    } else {
      return null;
    }
    notifyListeners();
  }

//----> CLEAR FIELDS.
  clearfields() {
    if (polyLine.isNotEmpty) {
      polyLine.last.points.clear();
    } else {
      return null;
    }
    notifyListeners();
  }

//----> CHANGES VISIBILITY OF STACK ELEMENTS.
  visibility() {
    if (destinationController.text.toString().isNotEmpty &&
        sourceController.text.toString().isNotEmpty) {
      cardVisibility = false;
    } else {
      cardVisibility = true;
    }
    notifyListeners();
  }

//CLEAR FIELDS
  clearSuggestion() {
    suggestion.clear();
    notifyListeners();
  }

//ON_CAMERA_IDLE
  cameraIdle() {
    stackElementsVisibility = true;
    notifyListeners();
  }

//----> CHECK INTERNET CONNECTIVITY
  checkConnectivity() async {
    Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      if (result != ConnectivityResult.mobile &&
          result != ConnectivityResult.wifi) {
        _name = "  No Internet ! \n Please Check your Internet Connection.... ";
      }
    });
    notifyListeners();
  }

//----> FEED BACK DIALOGBOX
  feedBackDialog(context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          scrollable: true,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
          insetPadding: EdgeInsets.all(10.0),
          titlePadding: EdgeInsets.all(0.0),
          titleTextStyle: TextStyle(
              color: Colors.white, fontSize: 20, fontWeight: FontWeight.w600),
          title: Container(
            width: MediaQuery.of(context).size.width - 40,
            padding: EdgeInsets.only(left: 10, bottom: 20, top: 10),
            child: Text(' Feedback '),
            decoration: BoxDecoration(
                color: Colors.purple,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(15),
                  topLeft: Radius.circular(15),
                )),
          ),
          content: Container(
            width: MediaQuery.of(context).size.width - 40,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: 10),
                ListTile(
                  leading: Icon(
                    Icons.comment_outlined,
                    color: Colors.purple,
                  ),
                  title: TextFormField(
                    controller: feedBackController,
                    maxLines: 4,
                    keyboardType: TextInputType.multiline,
                    minLines: null,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      hintText: 'Add Comment',
                    ),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            FlatButton(
                color: Colors.purple,
                onPressed: () {
                  if (feedBackController.text.isNotEmpty) {
                    Navigator.pop(context);
                  } else {
                    return null;
                  }
                },
                child: Text('DONE')),
            FlatButton(
                color: Colors.purple,
                onPressed: () {
                  //_initialLabel = 1;
                  Navigator.pop(context);
                },
                child: Text('CANCEL'))
          ],
        );
      },
    );
  }

//---->Share App Link
  appshare(context) {
    Share.share(
      'Sharing app Link ',
      subject: 'DemoShare',
    );
  }
}
