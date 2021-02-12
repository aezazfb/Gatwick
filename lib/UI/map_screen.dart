import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:zippy_rider/states/map_state.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class MapScreen extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return MapScreenState();
  }
}

class MapScreenState extends State<MapScreen>{
  bool flage = true;
  var heightFactor = 0.0;
  @override
  Widget build(BuildContext context) {
    final mapState = Provider.of<MapState>(context);
    return Scaffold(
      body: mapState.initialPosition == null
          ? Container(
              child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SpinKitRotatingCircle(
                      color: Colors.purple,
                      size: 50.0,
                    )
                ],
              ),
              SizedBox(height: 10),
              Visibility(
                visible: mapState.locationServiceActive == false,
                child: Text("Please enable location services!",
                    style: TextStyle(color: Colors.grey, fontSize: 18)),
              )
            ],
          ))
          : Stack(
        children: [
          GoogleMap(
            tiltGesturesEnabled: true,
            mapType: MapType.normal,
            zoomControlsEnabled: false,
            initialCameraPosition: CameraPosition(
              target: mapState.initialPosition,
              zoom: 17,
            ),
            onMapCreated: mapState.onCreate,
            markers: mapState.marker,
            polylines: mapState.polyLine,
            circles: mapState.circle,
            onCameraMove: mapState.onCameraMove,
            onCameraMoveStarted: () {
              mapState.checkConnectivity();
              mapState.stackElementsVisibality = false;
            },
            onCameraIdle: () {
              mapState.fetchAddressFromCoordinates(mapState.centerPoints);
              mapState.cameraIdle();
            },
          ),

          //----> PICK UP TEXT FIELD
          Positioned(
              top: 50.0,
              right: 17.0,
              left: 12.0,
              child: Visibility(
                visible: mapState.stackElementsVisibality,
                child: Container(
                  height: 55.0,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(3.0),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                          color: Colors.grey,
                          offset: Offset(1.0, 1.0),
                          blurRadius: 5.0,
                          spreadRadius: 2.0)
                    ],
                  ),
                  child: TextField(
                    cursorColor: Colors.black,
                    controller: mapState.sourceController,
                    onChanged: (bool) {
                      flage = true;
                      heightFactor = 100;
                      mapState.suggestions(bool);
                    },
                    onEditingComplete: () {
                      mapState.clearSuggestion();
                    },
                    decoration: InputDecoration(
                      icon: Container(
                        child: Icon(Icons.location_on),
                        margin: EdgeInsets.only(
                            left: 8.0, top: 0.5, bottom: 5),
                        width: 5.0,
                        height: 13,
                      ),
                      suffix: IconButton(
                          icon: Icon(
                            Icons.clear,
                            size: 15.0,
                            //   color: Colors.black,
                          ),
                          onPressed: () {
                            Marker markers = mapState.marker.firstWhere(
                                    (p) => p.markerId == MarkerId('true'),
                                orElse: () => null);
                            mapState.marker.remove(markers);
                            mapState.sourceController.clear();
                            mapState.clearfields();
                            mapState.clearSuggestion();
                          }),
                      hintText: "pick up",
                      border: InputBorder.none,
                      contentPadding:
                      EdgeInsets.only(left: 6.0, top: 8.0, right: 6.0),
                    ),
                  ),
                ),
              )),

          //----> DROP OFF  TEXT FIELD
          Positioned(
              top: 115.0,
              right: 17.0,
              left: 12.0,
              child: Visibility(
                visible: mapState.stackElementsVisibality,
                child: Container(
                  height: 55.0,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(3.0),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                          color: Colors.grey,
                          offset: Offset(1.0, 1.0),
                          blurRadius: 5.0,
                          spreadRadius: 2.0)
                    ],
                  ),
                  child: TextField(
                    onChanged: (bool) {
                      flage = false;
                      mapState.suggestions(bool);
                      heightFactor = 170;
                    },
                    cursorColor: Colors.black,
                    controller: mapState.destinationController,
                    onEditingComplete: () {
                      mapState.clearSuggestion();
                    },
                    decoration: InputDecoration(
                      icon: Container(
                        margin: EdgeInsets.only(
                            left: 8.0, top: 0.5, bottom: 10),
                        width: 5.0,
                        height: 13,
                        child: Icon(
                          Icons.local_taxi_sharp,
                        ),
                      ),
                      suffix: IconButton(
                          icon: Icon(
                            Icons.clear,
                            size: 15.0,
                            //   color: Colors.black,
                          ),
                          onPressed: () {
                            Marker markers = mapState.marker.firstWhere(
                                    (p) => p.markerId == MarkerId('false'),
                                orElse: () => null);
                            mapState.marker.remove(markers);
                            mapState.destinationController.clear();
                            mapState.clearfields();
                            mapState.clearSuggestion();
                          }),
                      hintText: "go to...",
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.only(
                          left: 6.0, top: 8.0, right: 6.0),
                    ),
                  ),
                ),
              )),

          //----> SWAP FIELDS  BUTTON
          Positioned(
            top: 80,
            left: 5.0,
            // right: 2.0,
            child: Visibility(
              visible: mapState.stackElementsVisibality,
              child: IconButton(
                  icon: Icon(
                    Icons.swap_calls,
                          size: 40,
                          color: Colors.purple,
                        ),
                  onPressed: () {
                    mapState.swapFields();
                  }),
            ),
          ),

          //----> FIXED ICON TO FETCH CENTER POSITION ON CAMERA MOVE
          Positioned(
              child: Visibility(
                visible: mapState.cardVisibility,
                child: Align(
                  alignment: Alignment.center,
                  child: IconButton(
                      icon:
                            Icon(Icons.circle, size: 17, color: Colors.purple),
                        onPressed: () {
                          mapState.fetchAddressFromCoordinates(
                              mapState.centerPoints);
                        }),
                ),
              )),

          //CAMERA MOVE SUGGESTIONS
          Positioned(
            child: Visibility(
              visible: mapState.cardVisibility,
              child: Align(
                alignment: Alignment(0.1, -0.1),
                child: Card(
                  color: Colors.purple.withOpacity(.8),
                        margin: EdgeInsets.all(20.0),
                        child: InkWell(
                            child: Text(mapState.name,
                                style: TextStyle(
                                  color: Colors.white,
                                )),
                            onTap: () {
                              mapState.dialogShow(context);
                            }),
                      ),
              ),
            ),
          ),

          //----> SEARCH SUGGESTION  LIST VIEW
          // SizedBox(height: heightFactor),
          Positioned(
              left: 12,
              right: 17,
              top: heightFactor,
              child: LimitedBox(
                maxHeight: mapState.suggestion.length * 50.0,
                child: Container(
                  child: ListView.builder(
                    itemCount: mapState.suggestion.length,
                    padding: EdgeInsets.all(0.0),
                    itemBuilder: (context, index) {
                      return Card(
                        margin: EdgeInsets.only(bottom: 1.0),
                        child: ListTile(
                          title: Text(
                            mapState.suggestion[index],
                            style: TextStyle(color: Colors.black),
                          ),
                          onTap: () {
                            if (flage == true) {
                              mapState.sourceController.text =
                                  mapState.suggestion[index].toString();
                              mapState.details(
                                  mapState.suggestion[index].toString(),
                                  flage);
                            }
                            if (flage == false) {
                              mapState.destinationController.text =
                                  mapState.suggestion[index].toString();
                              mapState.details(
                                  mapState.suggestion[index].toString(),
                                  flage);
                            }
                            mapState.clearfields();
                            mapState.clearSuggestion();
                          },
                        ),
                      );
                    },
                  ),
                ),
              )),

          //----> GET QUOTE BUTTON
          Positioned(
              bottom: 15,
              right: 17,
              left: 17,
              child: Visibility(
                  visible: mapState.stackElementsVisibality,
                  child: FlatButton(
                    color: Colors.purple.withOpacity(0.8),
                          onPressed: () {
                            mapState.drawPolyLine();
                            mapState.addCircle(
                                mapState.l1,
                                mapState.l2,
                                mapState.originCircle,
                                mapState.destinationCircle);
                            mapState.showAppBar = true;
                            mapState.settingModelBottomSheet(context);
                            mapState.visibility();
                          },
                    child: Text(
                      'GET QUOTE',
                      style: TextStyle(color: Colors.white),
                    ),
                  ))),

          //---->   CURRENT POSITION BUTTTON
          Positioned(
              bottom: 70,
              left: 17,
              child: Visibility(
                  visible: mapState.stackElementsVisibality,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300.withOpacity(0.7),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: IconButton(
                      icon: Icon(Icons.location_searching,
                                color: Colors.purple),
                            onPressed: () {
                              mapState.currentLocation();
                              print("My Locationbutton Pressed");
                            },
                          ),
                  ))),

          //----> FLIGHTS BUTTON
          Positioned(
              bottom: 70,
              right: 17,
              child: Visibility(
                  visible: mapState.stackElementsVisibality,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300.withOpacity(0.7),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: IconButton(
                      icon: Icon(Icons.flight_takeoff,
                                color: Colors.purple),
                            onPressed: () {
                              Navigator.pushNamed(context, '/flightscreen');
                            },
                          ),
                  ))),
        ],
      ),
    );
  }

  }

