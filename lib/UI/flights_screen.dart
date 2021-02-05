import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:zippy_rider/UI/map_screen.dart';
import 'package:zippy_rider/states/flight_state.dart';
import 'package:zippy_rider/states/map_state.dart';

class FlightsScreen extends StatefulWidget {
  @override
  _FlightsScreenState createState() => _FlightsScreenState();
}

class _FlightsScreenState extends State<FlightsScreen> {
  String value = '';
  int i = 0;


  @override
  Widget build(BuildContext context) {
    final mapState = Provider.of<MapState>(context);
    final flightState = Provider.of<FlightState>(context);
    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
              onMapCreated: flightState.onMapCreated,
              markers: flightState.marker,
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
                        flightState.cameraPosition = CameraPosition(
                            target: LatLng(flightState.latlngList[i].latitude,
                                flightState.latlngList[i].longitude),
                            zoom: 17);
                        i++;
                        if (i >= 3) {
                          i = 0;
                        } else {
                          return null;
                        }
                      });
                      flightState.animateCamera();
                    }),
                    items: flightState.url
                    .map((e) => Builder(
                          builder: (BuildContext context) {
                            return Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15.0),
                                    color: Colors.white),
                                height: 230,
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
                  margin: EdgeInsets.all(4.0),
                  clipBehavior: Clip.hardEdge,
                  child: Column(children: [
                    Text("Set London HEATTHROW Airport $value  as?",
                        style: TextStyle(color: Colors.black)),
                    Align(
                      alignment: Alignment.bottomLeft,
                      child: ButtonBar(
                        mainAxisSize: MainAxisSize.min,
                        buttonMinWidth: 10,
                        buttonPadding: EdgeInsets.zero,
                        buttonHeight: 20.0,
                        children: [
                          FlatButton(
                              onPressed: () {
                                mapState.sourceController.text =
                                    'Set Heat throw Airport $value';
                                mapState.l1 = LatLng(
                                    flightState.latlngList[0].latitude,
                                    flightState.latlngList[0].longitude);
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
                                mapState.l2 = LatLng(
                                    flightState.latlngList[1].latitude,
                                    flightState.latlngList[1].longitude);
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => MapScreen()));
                              },
                              child: Text("Destination",
                                  style: TextStyle(color: Colors.purple))),
                        ],
                      ),
                    )
                  ]),
                ),
              ),
            ),
          ),
          Positioned(
              top: 40,
              right: 17,
              child: Visibility(
                  visible: mapState.stackElementsVisibality,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300.withOpacity(0.7),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: IconButton(
                      icon: Icon(Icons.location_searching,
                          color: Colors.deepPurpleAccent),
                      onPressed: () {
                        return flightState.mapcontroller.animateCamera(
                            CameraUpdate.newCameraPosition(
                                flightState.cameraPosition));
                      },
                    ),
                  ))),
        ],
      ),
    );
  }

}
