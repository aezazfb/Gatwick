import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:zippy_rider/states/flight_state.dart';
import 'package:zippy_rider/states/map_state.dart';

class FlightsScreen extends StatefulWidget {
  @override
  _FlightsScreenState createState() => _FlightsScreenState();
}

class _FlightsScreenState extends State<FlightsScreen> {
  int indu = 0;

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
                zoom: 7,
              )),
          Positioned(
            bottom: 10,
            left: 3,
            right: 3,
            child: Swiper(
              itemWidth: 300,
              itemHeight: 190,
              itemCount: 10,
              outer: true,
              layout: SwiperLayout.CUSTOM,
              customLayoutOption:
                  new CustomLayoutOption(startIndex: -1, stateCount: 3)
                      .addTranslate([
                new Offset(-310.0, -60.0),
                new Offset(0.0, 0.0),
                new Offset(310.0, -60.0)
              ]).addOpacity([0.7, 1.0, 0.7]),
              scrollDirection: Axis.horizontal,
              onIndexChanged: (index) {
                flightState.changeCameraPosition(index);
                flightState.animateCamera();
                indu = index;
              },
              itemBuilder: (BuildContext context, index) {
                return Card(
                    // height: 300,
                    // width: 300,
                    child: InkWell(
                        child: Stack(
                  children: [
                    Image(
                        image: AssetImage('assets/airportsImages/ap1.jpeg'),
                        fit: BoxFit.fitWidth,
                        height: 100,
                        width: 360),
                    Positioned(
                      top: 110,
                      left: 8.0,
                      child: Row(
                        children: [
                          Text(
                            "${flightState.airPortNamelist[index]}",
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w700,
                                fontSize: 13),
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                        top: 145.0,
                        left: 10,
                        child: Text("${flightState.postCode[index]}",
                            style: TextStyle(
                                color: Colors.purple,
                                fontWeight: FontWeight.w500))),
                  ],
                )));
              },
            ),
          ),
          Positioned(
            bottom: 220,
            child: Visibility(
              visible: true,
              child: Align(
                child: Card(
                  color: Colors.white,
                  margin: EdgeInsets.all(4.0),
                  clipBehavior: Clip.hardEdge,
                  child: Column(children: [
                    Text("Set ${flightState.airPortNamelist[indu]} as?",
                        style: TextStyle(color: Colors.black)),
                    Align(
                      alignment: Alignment.bottomLeft,
                      child: ButtonBar(
                        mainAxisSize: MainAxisSize.min,
                        buttonMinWidth: 10,
                        buttonPadding: EdgeInsets.zero,
                        children: [
                          FlatButton(
                              onPressed: () {
                                mapState.sourceController.text =
                                    '${flightState.airPortNamelist[indu]} ';
                                mapState.l1 = LatLng(
                                    flightState.latLangList[indu].latitude,
                                    flightState.latLangList[indu].longitude);

                                MapState.initialPositions = LatLng(
                                    flightState.latLangList[indu].latitude,
                                    flightState.latLangList[indu].longitude);
                                Navigator.pushNamed(context, '/');
                              },
                              child: Text('Origin',
                                  style: TextStyle(color: Colors.purple))),
                          FlatButton(
                              onPressed: () {
                                mapState.destinationController.text =
                                    '${flightState.airPortNamelist[indu]} ';
                                mapState.l2 = LatLng(
                                    flightState.latLangList[indu].latitude,
                                    flightState.latLangList[indu].longitude);
                                MapState.initialPositions = LatLng(
                                    flightState.latLangList[indu].latitude,
                                    flightState.latLangList[indu].longitude);
                                Navigator.pushNamed(context, '/');
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
