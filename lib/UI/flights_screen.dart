import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:zippy_rider/UI/map_screen.dart';
import 'package:zippy_rider/states/map_states.dart';

class FlightsScreen extends StatefulWidget {
  @override
  _FlightsScreenState createState() => _FlightsScreenState();
}

class _FlightsScreenState extends State<FlightsScreen> {
  List<String> url = ['1', '2', '3', '4', '5', '6', '7', '8', '9', '10'];
  Set<Marker> marker = Set();
  String value = '';
  List<LatLng> latlngList = [
    LatLng(51.1537, 0.1821),
    LatLng(53.3588, 2.2727),
    LatLng(51.8860, 0.2389)
  ];
  GoogleMapController _controller;
  CameraPosition cameraPosition;
  int i = 0;

  @override
  void initState() {
    // TODO: implement initState
    addMarker();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final mapState = Provider.of<MapState>(context);
    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
              onMapCreated: (controller) {
                _controller = controller;
              },
              markers: marker,
              initialCameraPosition: CameraPosition(
                target: LatLng(51.1537, 0.1821),
                zoom: 10,
              )),
          Positioned(
              bottom: 20,
              left: 10,
              right: 10,
              child: SizedBox(
                  child: CarouselSlider(
                options: CarouselOptions(
                    initialPage: 0,
                    height: 170,
                    viewportFraction: 0.6,
                    autoPlay: false,
                    scrollDirection: Axis.horizontal,
                    reverse: false,
                    enlargeCenterPage: true,
                    onScrolled: (index) {
                      setState(() {
                        value = "$index";
                        cameraPosition = CameraPosition(
                            target: LatLng(latlngList[i].latitude,
                                latlngList[i].longitude),
                            zoom: 17);
                        i++;

                        if (i >= 3) {
                          i = 0;
                        } else {
                          return null;
                        }
                      });
                      animateCamera();
                    }),
                items: url
                    .map((e) => Builder(
                          builder: (BuildContext context) {
                            return Container(
                                //
                                height: 230,
                                // width: 800.0,
                                color: Colors.white,
                                child: Stack(
                                  children: [
                                    Image(
                                        image: AssetImage(
                                          "assets/images/image.jpeg",
                                        ),
                                        fit: BoxFit.fitWidth,
                                        height: 100,
                                        width: 250),
                                    Positioned(
                                      bottom: 40,
                                      left: 15,
                                      child: Wrap(
                                        children: [
                                          Text(
                                            "London HEATTHROW Airport $e ",
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.w700),
                                          )
                                        ],
                                      ),
                                    ),
                                    Positioned(
                                        bottom: 10.0,
                                        left: 10,
                                        child: Text("CM4 1 RW",
                                            style: TextStyle(
                                                color: Colors.purple,
                                                fontWeight: FontWeight.w500)))
                                  ],
                                ));
                          },
                        ))
                    .toList(),
              ))),
          Positioned(
            bottom: 200,
            child: Visibility(
              visible: true,
              child: Align(
                child: Card(
                  color: Colors.white,
                  margin: EdgeInsets.all(8.0),
                  child: Column(children: [
                    Text("Set London HEATTHROW Airport $value  as?",
                        style: TextStyle(color: Colors.black)),
                    Align(
                      alignment: Alignment.bottomLeft,
                      child: Row(
                        //  mainAxisAlignment: MainAxisAlignment.end,
                        //crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          FlatButton(
                              onPressed: () {
                                mapState.sourceController.text =
                                    'Set Heat throw Airport $value';
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => MapScreen()));
                              },
                              child: Text('Origin',
                                  style: TextStyle(color: Colors.purple))),
                          FlatButton(
                              onPressed: () {
                                mapState.destinationController.text =
                                    'Set Heat throw Airport $value';
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => MapScreen()));
                              },
                              child: Text("Destination",
                                  style: TextStyle(color: Colors.purple))),
                        ],
                      ),
                    ),
                  ]),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void addMarker() {
    for (int i = 0; i < latlngList.length; i++) {
      marker.add(Marker(
        markerId: MarkerId("id $i"),
        visible: true,
        position: LatLng(latlngList[i].latitude, latlngList[i].longitude),
      ));
    }
  }

  void animateCamera() {
    _controller.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
  }
}
