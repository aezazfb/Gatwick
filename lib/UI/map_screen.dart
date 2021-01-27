import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:zippy_rider/states/map_states.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
class MapScreen extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return MapScreenState();
  }
}

class MapScreenState extends State<MapScreen>{
  bool flage = true;
  var address;
  @override
  Widget build(BuildContext context) {
    print("Called Again");
    final appState = Provider.of<MapState>(context);
    return Scaffold(
      body:
      appState.initialPosition == null ? Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SpinKitRotatingCircle(
                    color: Colors.deepPurple,
                    size: 50.0,
                  )
                  ],
                ),
                SizedBox(height: 10),
                Visibility(
                  visible: appState.locationServiceActive == false,
                  child: Text("Please enable location services!",
                      style: TextStyle(color: Colors.grey, fontSize: 18)),
                )
              ],
            ))
          : Stack(
              children: [
                GoogleMap(
                  myLocationEnabled: true,
                  tiltGesturesEnabled: true,
                  mapType: MapType.normal,
                  zoomControlsEnabled: false,
                  initialCameraPosition: CameraPosition(
                    target: appState.initialPosition,
                    zoom: 17,
                  ),
                  onMapCreated: appState.onCreate,
                  markers: appState.marker,
                  polylines: appState.polyLine,
                  onCameraMove: appState.onCameraMove,
                  onCameraIdle: () {
                    appState.fetchAddressFromCoordinates(appState.centerPoints);
                  },
                ),

                //PICK UP TEXT FIELD
                Positioned(
                  top: 50.0,
                  right: 15.0,
                  left: 15.0,
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
                      controller: appState.sourceController,
                      onChanged: (bool) {
                        flage = true;
                        appState.suggestions(bool);
                        appState.flage = true;
                      },
                      textInputAction: TextInputAction.go,
                      decoration: InputDecoration(
                        icon: Container(
                          child: Icon(Icons.location_on),
                          margin:
                              EdgeInsets.only(left: 8.0, top: 0.5, bottom: 5),
                          width: 5.0,
                          height: 13,
                        ),
                        suffix: IconButton(
                            icon: Icon(
                              Icons.clear,
                              size: 15.0,
                              color: Colors.black,
                            ),
                            onPressed: () {
                              appState.sourceController.clear();
                              appState.polyLine.last.points.clear();
                            }),
                        hintText: "pick up",
                        border: InputBorder.none,
                        contentPadding:
                            EdgeInsets.only(left: 6.0, top: 8.0, right: 6.0),
                      ),
                    ),
                  ),
                ),

                //DROP OFF  TextField
                Positioned(
                  top: 110.0,
                  right: 15.0,
                  left: 15.0,
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
                        appState.suggestions(bool);
                        appState.flage = false;
                      },
                      cursorColor: Colors.black,
                      controller: appState.destinationController,
                      textInputAction: TextInputAction.go,
                      decoration: InputDecoration(
                        icon: Container(
                          margin:
                              EdgeInsets.only(left: 8.0, top: 0.5, bottom: 10),
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
                              color: Colors.black,
                            ),
                            onPressed: () {
                              appState.destinationController.clear();
                              appState.polyLine.last.points.clear();
                            }),
                        hintText: "go to...",
                        border: InputBorder.none,
                        contentPadding:
                            EdgeInsets.only(left: 6.0, top: 8.0, right: 6.0),
                      ),
                    ),
                  ),
                ),

                //----> SWAP FIELDS  BUTTON
                Positioned(
                  top: 80,
                  right: 5.0,
                  child: IconButton(
                      icon: Icon(
                        Icons.swap_calls,
                        size: 40,
                        color: Colors.deepPurple,
                      ),
                      onPressed: () {
                        appState.swapFields();
                      }),
                ),

                //----> SEARCH Suggestion  List View
                SizedBox(height: 20),
                Positioned(
                    left: 20,
                    right: 20,
                    top: 130,
                    child: SizedBox(
                      height: appState.suggestion.length * 60.0,
                      child: Container(
                        child: ListView.builder(
                          itemCount: appState.suggestion.length,
                          itemBuilder: (context, index) {
                            return Card(
                              child: ListTile(
                                title: Text(
                                  appState.suggestion[index],
                                  style: TextStyle(color: Colors.black),
                                ),
                                onTap: () {
                                  if (flage == true) {
                                    appState.sourceController.text =
                                        appState.suggestion[index].toString();
                                    appState.details(
                                        appState.suggestion[index].toString());
                                  }
                                  if (flage == false) {
                                    appState.destinationController.text =
                                        appState.suggestion[index].toString();
                                    appState.details(
                                        appState.suggestion[index].toString());
                                  }
                                  appState.clearfields();
                                },
                              ),
                            );
                          },
                        ),
                      ),
                    )),

                //FIXED ICON TO FETCH CENTER POSITION ON CAMERA MOVE
                Positioned(
                  child: Align(
                    alignment: Alignment.center,
                    child: IconButton(
                        icon: Icon(Icons.circle,
                            size: 17, color: Colors.deepPurple),
                        onPressed: () {
                          appState.fetchAddressFromCoordinates(
                              appState.centerPoints);
                        }),
                  ),
                ),

                //CAMERA MOVE SUGGESTIONS
                Positioned(
                  child: Align(
                    alignment: Alignment(0.1, -0.1),
                    child: Card(
                      color: Colors.deepPurple.withOpacity(.8),
                      margin: EdgeInsets.all(8.0),
                      child: InkWell(
                          child: Text(appState.name,
                              style: TextStyle(color: Colors.white)),
                          onTap: () {
                            appState.dialogShow(context);
                          }),
                    ),
                  ),
                ),

                //GET QUOTE BUTTON
                Positioned(
                    bottom: 20,
                    right: 17,
                    left: 17,
                    child: FlatButton(
                      color: Colors.deepPurple.withOpacity(0.9),
                      onPressed: () {
                        appState.drawPolyLine();
                        appState.settingModelBottomSheet(context);
                      },
                      child: Text(
                        'GET QUOTE',
                        style: TextStyle(color: Colors.white),
                      ),
                    )),
              ],
            ),
    );
  }


  }

