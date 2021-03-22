import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:zippy_rider/states/map_state.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:zippy_rider/states/vias_state.dart';
import 'package:zippy_rider/utils/util.dart' as util;

class MapScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return MapScreenState();
  }
}

class MapScreenState extends State<MapScreen> {
  bool flage = true;
  bool _controllerflage = true;
  var heightFactor = 0.0;
  Set<Polyline> _polylines;

  @override
  Widget build(BuildContext context) {
    final mapState = Provider.of<MapState>(context);
    final viasState = Provider.of<ViasState>(context);
    return Scaffold(
      //check MapState() that starts initialPosition
      body: mapState.initialPosition == null
          ? Container(
              child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SpinKitRotatingCircle(
                      color: util.primaryColor,
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
                  polylines: _polylines,
                  circles: mapState.circle,
                  onCameraMove: mapState.onCameraMove,
                  onCameraMoveStarted: () {
                    mapState.checkConnectivity();
                    mapState.stackElementsVisibility = false;
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
                      visible: mapState.stackElementsVisibility,
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
                            _controllerflage = true;
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
                            contentPadding: EdgeInsets.only(
                                left: 6.0, top: 8.0, right: 6.0),
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
                      visible: mapState.stackElementsVisibility,
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
                            flage = true;
                            _controllerflage = false;
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

                //---->ADD VIAS BUTTON
                Positioned(
                    top: 175,
                    right: 10,
                    child: Visibility(
                      visible: mapState.stackElementsVisibility,
                      child: Card(
                        color: Colors.black45,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(10.0),
                          child: Text(
                            ' Add Vias ',
                            style:
                                TextStyle(color: Colors.white, fontSize: 17.0),
                          ),
                          onTap: () {
                            Navigator.pushReplacementNamed(
                                context, '/viasscreen');
                          },
                        ),
                      ),
                    )),

                //----> SWAP FIELDS  BUTTON
                Positioned(
                  top: 80,
                  left: 5.0,
                  child: Visibility(
                    visible: mapState.stackElementsVisibility,
                    child: IconButton(
                        icon: Icon(
                          Icons.swap_calls,
                          size: 40,
                          color: util.primaryColor,
                        ),
                        onPressed: () {
                          mapState.swapFields();
                          viasState.clearFields();
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
                        icon: Icon(Icons.circle, size: 12, color: Colors.black),
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
                        color: util.primaryColor.withOpacity(0.8),
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
                            if (mapState.suggestion.isNotEmpty) {
                              return Card(
                                margin: EdgeInsets.only(bottom: 1.0),
                                child: ListTile(
                                  title: Text(
                                    mapState.suggestion[index],
                                    style: TextStyle(color: Colors.black),
                                  ),
                                  onTap: () {
                                    if (_controllerflage == true) {
                                      mapState.sourceController.text =
                                          mapState.suggestion[index].toString();
                                      mapState.details(
                                          mapState.suggestion[index].toString(),
                                          flage);
                                    }
                                    if (_controllerflage == false) {
                                      mapState.destinationController.text =
                                          mapState.suggestion[index].toString();
                                      mapState.details(
                                          mapState.suggestion[index].toString(),
                                          flage);
                                    }
                                    mapState.suggestion.clear();
                                    mapState.clearfields();
                                    mapState.clearSuggestion();
                                  },
                                ),
                              );
                            } else {
                              return Center(
                                child: Container(
                                  child: CircularProgressIndicator(),
                                ),
                              );
                            }
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
                        visible: mapState.stackElementsVisibility,
                        child: FlatButton(
                          color: util.primaryColor,
                          onPressed: () async {
                            if (viasState.viasLatLangList.isEmpty) {
                              mapState.drawPolyLine(mapState.l1, mapState.l2);
                              mapState.settingModelBottomSheet(context);
                              mapState.addCircle(mapState.l1, mapState.l2,
                                  'origin', 'destination');
                              _polylines = mapState.polyLine;
                            } else {
                              viasState.calculateViasDistancetime(context);
                              // viasState.drawPolyLine();
                              // print(x
                              //     'Vias Polyline length___________________${viasState.polyLine.length}');
                              // _polylines = viasState.polyLine;
                            }
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
                        visible: mapState.stackElementsVisibility,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.grey.shade300.withOpacity(0.7),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: IconButton(
                            icon: Icon(Icons.location_searching,
                                color: util.primaryColor),
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
                        visible: mapState.stackElementsVisibility,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.grey.shade300.withOpacity(0.7),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: IconButton(
                            icon: Icon(Icons.flight_takeoff,
                                color: util.primaryColor),
                            onPressed: () {
                              Navigator.pushNamed(context, '/flightscreen');
                            },
                          ),
                        ))),
              ],
            ),
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                  gradient: SweepGradient(center: Alignment.topLeft, colors: [
                Colors.black45,
                Colors.purple,
                Colors.pink,
                //  Colors.yellowAccent,
                //Colors.brown,
                Colors.blue,
              ])),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.pink,
                    child: Icon(
                      Icons.person,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(width: 4.0),
                  RichText(
                      text: TextSpan(
                          text: ('Mussdiq\n'),
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w600),
                          children: [
                        TextSpan(
                            text: 'mussdiq.slashglobal@gmail.com',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w400))
                      ]))
                ],
              ),
              padding: EdgeInsets.only(left: 3.0, right: 3),
            ),
            ListTile(
              leading: Icon(Icons.history_toggle_off, color: util.primaryColor),
              title: Text('Ride History'),
              onTap: () => Navigator.pushNamed(context, '/ridehistory'),
            ),
            Divider(
              thickness: 0.5,
              height: 1,
              color: Colors.grey,
            ),
            ListTile(
              leading: Icon(Icons.settings_applications_outlined,
                  color: util.primaryColor),
              title: Text('Settings'),
            ),
            Divider(
              thickness: 0.5,
              height: 1,
              color: Colors.grey,
            ),
            ListTile(
              leading: Icon(Icons.share_sharp, color: util.primaryColor),
              title: Text('Share'),
              onTap: () => mapState.appshare(context),
            ),
            Divider(
              thickness: 0.5,
              height: 1,
              color: Colors.grey,
            ),
            ListTile(
              leading: Icon(Icons.feedback_outlined, color: util.primaryColor),
              title: Text('Give feedback'),
              onTap: () => mapState.feedBackDialog(context),
            ),
            Divider(
              thickness: 0.5,
              height: 1,
              color: Colors.grey,
            ),
            ListTile(
              leading: Icon(Icons.call, color: Colors.purple),
              title: Text('Contact us'),
            ),
            Divider(
              thickness: 0.5,
              height: 1,
              color: Colors.grey,
            ),
            ListTile(
              leading: Icon(Icons.monetization_on_outlined,
                  color: util.primaryColor),
              title: Text('Wallet'),
            ),
            Divider(
              thickness: 0.5,
              height: 1,
              color: Colors.grey,
            ),
            ListTile(
              leading:
                  Icon(Icons.info_outline_rounded, color: util.primaryColor),
              title: Text('About'),
              onTap: () {
                showAboutDialog(
                    context: context,
                    applicationName: 'Zippy Riders',
                    //applicationLegalese: 'All Rights Resrved by Slash Global',
                    //,
                    children: [
                      Text('1.0.1'),
                    ]);
              },
            ),
            Divider(
              thickness: 0.5,
              height: 1,
              color: Colors.grey,
            ),
            ListTile(
                leading: Icon(Icons.logout, color: util.primaryColor),
                title: Text('Logout'),
                onTap: () {
                  Navigator.pushReplacementNamed(context, '/login');
                }),
          ],
        ),
      ),
    );
  }
}
