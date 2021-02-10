import 'package:expansion_tile_card/expansion_tile_card.dart';
import 'package:flutter/widgets.dart';
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
import 'package:connectivity/connectivity.dart';
import 'package:flutter_dropdown/flutter_dropdown.dart';
import 'package:flutter_swiper/flutter_swiper.dart';

class MapState with ChangeNotifier {
  static LatLng initialPositions;
  static LatLng _centerPoints;

  LatLng l1 = LatLng(0.0000, 0.0000);
  LatLng l2 = LatLng(0.0000, 0.0000);

  GoogleMapController _mapController;

  bool locationServiceActive = true;
  Set<Marker> _markers = Set();
  Set<Circle> _circles = Set<Circle>();
  Set<Polyline> polyLine = Set();
  List<LatLng> polyCoordinates = [];
  PolylinePoints polylinePoints;
  List suggestion = [];
  List<LatLng> latLangList = [];
  Position position;

  TextEditingController sourceController = TextEditingController();
  TextEditingController destinationController = TextEditingController();

  GoogleMapController get mapController => _mapController;

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

  String distance;
  String duration;
  String _name = '';
  String originCircle = 'origin';
  String destinationCircle = 'destination';
  double originHue = 70.0;

  bool cardVisibility = true;
  bool stackElementsVisibality = true;

  MapState() {
    checkConnectivity();
    _getUserLocation();
    _loadingInitialPosition();
    notifyListeners();
  }

  //----> Creating onMapCreated for our Map
  void onCreate(GoogleMapController controller) {
    _mapController = controller;
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

  //----->GET LAT LANG FROM ADDRESS
  details(String value, bool flage) async {
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

//---->ADD CIRCLES ON SOURCE AND DESTINATION
  addCircle(LatLng latLng1, LatLng latLng2, String id1, String id2) async {
    _circles.add(Circle(
      circleId: CircleId(id1),
      center: latLng1,
      visible: true,
      strokeColor: Colors.purple,
      strokeWidth: 2,
      fillColor: Colors.greenAccent,
      radius: 10.0,
    ));

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
  drawPolyLine() async {
    if (sourceController.text.toString().isNotEmpty &&
        destinationController.text.toString().isNotEmpty) {
      if (polyLine.length == 0 || polyLine.last.points.length == 0) {
        polyCoordinates = await fetchPolylinePoints.getPolyPoints(l1, l2);
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
    } else {
      return null;
    }
    notifyListeners();
  }

//----> BOTTOM MODEL SHEET
  settingModelBottomSheet(context) async {
    List list = await calculateDistanceTime.calculateDistanceTime(l1, l2);

    if (sourceController.text.toString().isNotEmpty &&
        destinationController.text.toString().isNotEmpty) {
      String vechile = 'Saloon ';
      int suitCase = 0;
      int passengers = 0;
      showModalBottomSheet(
          backgroundColor: Colors.deepPurple.withOpacity(0.1),
          enableDrag: true,
          context: context,
          builder: (BuildContext context) {
            return Container(
              margin: EdgeInsets.all(0.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(12.0)),
                color: Colors.white,
              ),
              child: Column(
                children: [
                  Wrap(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Driver Time'),
                        ],
                      ),
                      Card(
                          // margin: EdgeInsets.symmetric(horizontal: 10.0),
                          color: Colors.blueGrey,
                          margin: EdgeInsets.all(0.0),
                          child: Row(
                            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Icon(Icons.alt_route,
                                  size: 40, color: Colors.white),
                              Text('${list[0]} miles',
                                  style: TextStyle(color: Colors.white)),
                              Spacer(),
                              Icon(
                                Icons.timelapse,
                                size: 40,
                                color: Colors.white,
                              ),
                              Text('${list[1]}',
                                  style: TextStyle(color: Colors.white)),
                              Spacer(),
                              //Icon(Icons.clean_hands_outlined,size: 40),
                              DropDown(
                                items: [
                                  'Cash',
                                  'Card',
                                ],
                                hint: Text('Cash',
                                    style: TextStyle(color: Colors.white)),
                              ),
                            ],
                          )),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(width: 10),
                          RotatedBox(quarterTurns: 3, child: Text('$vechile ')),
                          Icon(Icons.local_taxi_outlined,
                              size: 40, color: Colors.blueGrey),
                          Spacer(),
                          RichText(
                              text: TextSpan(
                                  text: '$passengers\n',
                                  style: TextStyle(
                                    color: Colors.black,
                                  ),
                                  children: <TextSpan>[
                                    TextSpan(
                                        text: ('Passangers'),
                                        style:
                                            TextStyle(color: Colors.blueGrey))
                                  ]),
                              textAlign: TextAlign.center),
                          Spacer(),
                          RichText(
                              text: TextSpan(
                                  text: '$suitCase\n',
                                  style: TextStyle(color: Colors.black),
                                  children: <TextSpan>[
                                    TextSpan(
                                        text: ('Suitcases'),
                                        style:
                                            TextStyle(color: Colors.blueGrey))
                                  ]),
                              textAlign: TextAlign.center),
                          SizedBox(width: 10),
                        ],
                      ),
                      Swiper(
                        itemWidth: 130,
                        itemHeight: 130,
                        itemCount: 10,
                        outer: true,
                        layout: SwiperLayout.CUSTOM,
                        customLayoutOption: new CustomLayoutOption(
                                startIndex: -1, stateCount: 3)
                            .addTranslate([
                          new Offset(-140.0, 25.0),
                          new Offset(0.0, 20.0),
                          new Offset(140.0, 25.0)
                        ]).addOpacity([1.0, 1.0, 1.0]),
                        scrollDirection: Axis.horizontal,
                        onIndexChanged: (index) {
                          print('im dsegggg $index');
                          vechile = 'vechile $index ';
                          suitCase = index;
                          passengers = index;

                          notifyListeners();
                        },
                        itemBuilder: (BuildContext context, index) {
                          return Card(
                              elevation: 5.0,
                              color: Colors.blueGrey,
                              child: InkWell(
                                  child: Stack(
                                children: [
                                  Icon(
                                    Icons.local_taxi_rounded,
                                    size: 45,
                                    color: Colors.white,
                                  ),
                                  Positioned(
                                    top: 50,
                                    left: 10.0,
                                    child: Row(
                                      children: [
                                        Text(
                                          " Vechile $index",
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.w600,
                                              fontSize: 12),
                                          overflow: TextOverflow.visible,
                                        ),
                                      ],
                                    ),
                                  ),
                                  Positioned(
                                      top: 65.0,
                                      left: 10,
                                      child: Text(" Passangers: $index",
                                          style: TextStyle(
                                              color: Colors.purple,
                                              fontWeight: FontWeight.w400))),
                                  Positioned(
                                      top: 80.0,
                                      left: 10,
                                      child: Text(" Suitcase: $index",
                                          style: TextStyle(
                                              color: Colors.purple,
                                              fontWeight: FontWeight.w400))),
                                ],
                              )));
                        },
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          IconButton(
                              icon: Icon(Icons.date_range),
                              iconSize: 40,
                              onPressed: () => print('select Date')),
                          Positioned(
                            width: 100,
                            child: FlatButton(
                              color: Colors.purple,
                              child: Text('Confirm'),
                              onPressed: () => print('Booked'),
                            ),
                          ),
                          IconButton(
                              icon: Icon(Icons.add),
                              iconSize: 40,
                              onPressed: () => print('add Comment')),
                        ],
                      )
                    ],
                  )
                ],
              ),
            );
          });
    } else {
      Scaffold.of(context)
          .showSnackBar(SnackBar(content: Text("Fields are Empty....")));
      polyLine.last.points.clear();
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

//----> DIALOG SHOW.
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

      String value = originCircle;
      originCircle = destinationCircle;
      destinationCircle = value;
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

  clearSuggestion() {
    suggestion.clear();
    notifyListeners();
  }

  cameraIdle() {
    stackElementsVisibality = true;
    notifyListeners();
  }

  checkConnectivity() async {
    Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      if (result == ConnectivityResult.mobile ||
          result == ConnectivityResult.wifi) {
        print('Connected');
      }
      if (result != ConnectivityResult.mobile &&
          result != ConnectivityResult.wifi) {
        _name = "  No Internet ! \n Please Check your Internet Connection.... ";
        print('Not Connected !');
      }
    });
    notifyListeners();
  }

// ignore: non_constant_identifier_names

}