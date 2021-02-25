import 'package:flutter/widgets.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoder/geocoder.dart';
import 'package:share/share.dart';
import 'package:zippy_rider/UI/map_screen.dart';
import 'package:zippy_rider/UI/vias_screen.dart';
import 'package:zippy_rider/requests/map_screen/polyline_request.dart';
import 'package:zippy_rider/requests/map_screen/suggestionRequest.dart';
import 'package:flutter/material.dart';
import 'package:zippy_rider/requests/map_screen/detailsRequest.dart';
import 'package:zippy_rider/requests/map_screen/distance_time_calculate.dart';
import 'package:connectivity/connectivity.dart';
import 'package:zippy_rider/bottom_model_sheet/bottomsheet.dart';

class MapState with ChangeNotifier {
  static LatLng initialPositions;
  static LatLng _centerPoints;
  DateTime userSelectedDate = DateTime.now();
  TimeOfDay userSelectedTime = TimeOfDay.now();
  LatLng l1 = LatLng(0.0000, 0.0000);
  LatLng l2 = LatLng(0.0000, 0.0000);

  GoogleMapController mapControllerr;

  bool locationServiceActive = true;
  Set<Marker> _markers = Set();
  Set<Circle> _circles = Set<Circle>();
  Set<Polyline> polyLine = Set();
  List<dynamic> polyCoordinates = [];
  PolylinePoints polylinePoints;
  List suggestion = [];
  List viasSuggestionList = [];
  List<LatLng> latLangList = [];
  Position position;
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

  bool cardVisibility = true;
  bool stackElementsVisibality = true;
  bool showAppBar = false;

  MapState() {
    checkConnectivity();
    _getUserLocation();
    _loadingInitialPosition();
    notifyListeners();
  }

  //----> Creating onMapCreated for our Map
  void onCreate(GoogleMapController controller) {
    mapControllerr = controller;
    notifyListeners();
  }

  //----> get Users Initial location
  _getUserLocation() async {
    position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    initialPositions = LatLng(position.latitude, position.longitude);

    l1 = LatLng(position.latitude, position.longitude);

    Coordinates latLng =
    Coordinates(initialPosition.latitude, initialPosition.longitude);
    var addreslocation =
    await Geocoder.local.findAddressesFromCoordinates(latLng);
    var first = addreslocation.first;
    if (first.addressLine.isNotEmpty) {
      sourceController.text = first.addressLine;
    } else {
      return null;
    }
    notifyListeners();
  }

//----> GET USERS CURRENT LOCATION
  currentLocation() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    CameraPosition cameraPosition = new CameraPosition(
        target: LatLng(position.latitude, position.longitude), zoom: 17);
    mapController.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
    LatLng latLng = LatLng(position.latitude, position.longitude);
    fetchAddressFromCoordinates(latLng);
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

  viaSuggestion(value) async {
    viasSuggestionList = await suggestionRequest.getSuggestion(value);
    notifyListeners();
  }

  //----->GET LAT LANG FROM ADDRESS
  details(String value, bool flage) async {
    LatLng latLng = await locationDetails.getLocationDetails(value);
    CameraPosition cameraPosition = new CameraPosition(
        target: LatLng(latLng.latitude, latLng.longitude), zoom: 14);
    mapControllerr
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
  addMarker(LatLng position, String _title, bool flage, double hue) async {
    _markers.add(Marker(
      visible: true,
      markerId: MarkerId("$flage"),
      position: LatLng(position.latitude, position.longitude),
      icon: BitmapDescriptor.defaultMarkerWithHue(hue),
      infoWindow: InfoWindow(
        title: _title,
      ),
    ));
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
  drawPolyLine(List<dynamic> latLngList) async {
    if (sourceController.text.toString().isNotEmpty &&
        destinationController.text.toString().isNotEmpty) {
      polyCoordinates = await fetchPolylinePoints.getPolyPoints(l1, l2);
      if (polyLine.length == 0) {
        print("polyline length ${polyLine.length}");
        polyLine.add(
          Polyline(
            polylineId: PolylineId("poly"),
            visible: true,
            points: polyCoordinates,
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
      List list = await calculateDistanceTime.calculateDistanceTime(l1, l2);
      bottomModelSheet.settingModelBottomSheet(context, 'aa', 'bb');
      print('Map Screen');
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
    Coordinates coordinates =
    new Coordinates(latLng.latitude, latLng.longitude);
    var locationName =
    await Geocoder.local.findAddressesFromCoordinates(coordinates);
    var first = locationName.first;
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
                  // addCircle(centerPoints);
                  Navigator.pop(context);
                },
              ),
              FlatButton(
                child: Text("DESTINATION"),
                onPressed: () {
                  destinationController.text = name;
                  addMarker(_centerPoints, name, false, originHue);
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
    polyLine.last.points.clear();
    notifyListeners();
  }

//----> CHANGES VISIBILITY OF STACK EELEMENTS.
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
    stackElementsVisibality = true;
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