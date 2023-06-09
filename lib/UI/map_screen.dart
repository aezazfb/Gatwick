import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zippy_rider/states/map_state.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:zippy_rider/states/vias_state.dart';
import 'package:zippy_rider/utils/util.dart' as util;
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:zippy_rider/requests/map_screen/suggestionRequest.dart';

class MapScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return MapScreenState();
  }
}

class MapScreenState extends State<MapScreen> {
  //bool flage = true;
  int flag = -1;
  bool _controllerflag = true;
  var heightFactor = 0.0;
  Set<Polyline> _polylines;
  var mapState;
  bool vb = true;
  SuggestionRequest mysugg = SuggestionRequest();

  mapTapfn() {
    mapState.visibility();
    mapState.viasVisiBility_chng();
  }

  @override
  Widget build(BuildContext context) {
    mapState = Provider.of<MapState>(context);

    final viasState = Provider.of<ViasState>(context);
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Make a Booking!'),
          toolbarHeight: 37,
        ),

        //check MapState() that starts initialPosition
        body: mapState.initialPosition == LatLng(51.5074, 0.1278)
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
                    //  onTap: mapTapfn(),
                    tiltGesturesEnabled: true,
                    mapType: MapType.normal,
                    myLocationButtonEnabled: false,
                    zoomControlsEnabled: false,
                    initialCameraPosition: CameraPosition(
                      target: LatLng(51.5074, 0.1278),
                      zoom: MapState.initialPositions ==
                              LatLng(0.000000, 0.000000)
                          ? 0 //if initial position is empty,zoom out 0 level map
                          : 17, //17,
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
                      mapState
                          .fetchAddressFromCoordinates(mapState.centerPoints);
                      mapState.cameraIdle();
                    },
                  ),

            //----> PICK UP TEXT FIELD
            Positioned(
                      top: 17.0,
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
                          child: TypeAheadField(
                            textFieldConfiguration: TextFieldConfiguration(
                              cursorColor: Colors.black,
                              controller: mapState.sourceController,
                              onChanged: (bool) {
                                //flage = true;
                                flag = 0;
                                _controllerflag = true;
                                heightFactor = 100;
                                if (mapState.sourceController.text ==
                                    mapState.destinationController.text) {
                                  mapState.sourceController.clear();
                                  Fluttertoast.showToast(
                                      msg:
                                          'PickUp and Destination can not be same!');
                                }

                                //mapState.suggestions(bool);
                              },
                              onEditingComplete: () {
                                //mapState.clearSuggestion();
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
                                      Marker markers = mapState.marker
                                          .firstWhere(
                                              (p) =>
                                                  p.markerId == MarkerId('0'),
                                              orElse: () => null);
                                      mapState.marker.remove(markers);
                                      mapState.sourceController.clear();
                                      mapState.clearfields();
                                      //mapState.clearSuggestion();

                                      setState(() {
                                        //viasState.viasSuggestionList.clear();
                                        mapState.viasVisiBility_chng();
                                      });
                                    }),
                                hintText: "pick up",
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.only(
                                    left: 6.0, top: 8.0, right: 6.0),
                              ),
                            ),
                            //-----------------------------------------------------------------------
                            suggestionsCallback: (pattern) async {
                              List looo = await mysugg.getSuggestion(pattern);

                              if (mapState.sourceController.text.isNotEmpty) {
                                return looo;
                              } else {
                                return looo = [];
                              }
                            },
                            getImmediateSuggestions: true,
                            itemBuilder: (context, itemData) {
                              return ListTile(
                                title: Text(itemData.toString()),
                                //subtitle: Text(itemData['symbol'].toString()),
                              );
                            },
                            onSuggestionSelected: (suggestion) {
                              mapState.sourceController.text =
                                  suggestion.toString();
                              mapState
                                  .viasVisiBility_chng(); //-----------calling VIas Icon
                              if (_controllerflag == true) {
                                // mapState.sourceController.text =
                                //     mapState.suggestion[index]
                                //         .toString();
                                mapState.details(suggestion.toString(), flag);
                              }
                              if (_controllerflag == false) {
                                print('false selected');
                                // mapState.destinationController.text =
                                //     mapState.suggestion[index]
                                //         .toString();
                                print(
                                    'selected value: ${mapState.destinationController.text}');
                                mapState.details(suggestion.toString(), flag);
                              }

                              //mapState.suggestion.clear();
                              mapState.clearfields();
                              if (mapState.sourceController.text ==
                                  mapState.destinationController.text) {
                                mapState.sourceController.clear();
                                Fluttertoast.showToast(
                                    msg:
                                        'PickUp and Destination can not be same!');
                              }

                              // print(
                              //     'SUGGESTION: ${mapState.suggestion}');
                              // mapState.clearSuggestion();
                              // print(
                              //     'SUGGESTION: ${mapState.suggestion}');
                            },
                          ),
                        ),
                      )),

            //----> DROP OFF  TEXT FIELD
            Positioned(
                      top: 79.0,
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
                          child: TypeAheadField(
                            textFieldConfiguration: TextFieldConfiguration(
                              onChanged: (bool) {
                                //flage = false;
                                flag = 1;
                                _controllerflag = false;
                                //mapState.suggestions(bool);
                                heightFactor = 170;
                                if (mapState.sourceController.text ==
                                    mapState.destinationController.text) {
                                  mapState.destinationController.clear();
                                  Fluttertoast.showToast(
                                      msg:
                                          'PickUp and Destination can not be same!');
                                }
                              },
                              cursorColor: Colors.black,
                              controller: mapState.destinationController,
                              onEditingComplete: () {
                                //mapState.clearSuggestion();
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
                                      setState(() {
                                        mapState.viasVb = false;
                                      });

                                      Marker markers = mapState.marker
                                          .firstWhere(
                                              (p) =>
                                                  p.markerId == MarkerId('1'),
                                              orElse: () => null);
                                      mapState.marker.remove(markers);
                                      print('AFTER REMOVE: ${mapState.marker}');
                                      mapState.destinationController.clear();
                                      mapState.clearfields();
                                      //mapState.clearSuggestion();

                                      //mapState.viasVisiBility_chng();// vias button apperance
                                    }),
                                hintText: "go to...",
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.only(
                                    left: 6.0, top: 8.0, right: 6.0),
                              ),
                            ),
                            // -------------------------------------------------------------------------
                            suggestionsCallback: (pattern) async {
                              List looo = await mysugg.getSuggestion(pattern);

                              if (mapState
                                  .destinationController.text.isNotEmpty) {
                                return looo;
                              } else {
                                return looo = [];
                              }
                            },
                            getImmediateSuggestions: true,
                            itemBuilder: (context, itemData) {
                              return ListTile(
                                title: Text(itemData.toString()),
                                //subtitle: Text(itemData['symbol'].toString()),
                              );
                            },
                            onSuggestionSelected: (suggestion) {
                              mapState.destinationController.text =
                                  suggestion.toString();
                              setState(() {
                                mapState.viasVisiBility_chng();
                              });
                              //-----------calling VIas Icon
                              if (_controllerflag == true) {
                                // mapState.sourceController.text =
                                //     mapState.suggestion[index]
                                //         .toString();
                                mapState.details(suggestion.toString(), flag);
                              }
                              if (_controllerflag == false) {
                                print('false selected');
                                // mapState.destinationController.text =
                                //     mapState.suggestion[index]
                                //         .toString();
                                print(
                                    'selected value: ${mapState.destinationController.text}');
                                mapState.details(suggestion.toString(), flag);
                              }

                              //mapState.suggestion.clear();
                              mapState.clearfields();
                              if (mapState.sourceController.text ==
                                  mapState.destinationController.text) {
                                mapState.destinationController.clear();
                                Fluttertoast.showToast(
                                    msg:
                                        'PickUp and Destination can not be same!');
                              }

                              // print(
                              //     'SUGGESTION: ${mapState.suggestion}');
                              // mapState.clearSuggestion();
                              // print(
                              //     'SUGGESTION: ${mapState.suggestion}');
                            },
                          ),
                        ),
                      )),

            //---->ADD VIAS BUTTON
            Positioned(
                top: 175,
                right: 10,
                child: Visibility(
                        visible: mapState.viasVb,
                        child: Card(
                          color: Colors.black45,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(10.0),
                            child: Text(
                              ' Add Vias ',
                              style: TextStyle(
                                  color: Colors.white, fontSize: 17.0),
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
                    top: 50,
                    left: 5.0,
                    child: Visibility(
                      visible: mapState.stackElementsVisibility,
                      child: IconButton(
                          icon: Icon(
                            Icons.swap_calls,
                            size: 35.75,
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
                        icon:
                        Icon(Icons.circle, size: 12, color: Colors.black),
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
                  // Positioned(
                  //     left: 12,
                  //     right: 17,
                  //     top: heightFactor,
                  //     child: LimitedBox(
                  //       maxHeight: mapState.suggestion.length * 50.0,//,200.0
                  //       child: Container(
                  //         child: ListView.builder(
                  //           itemCount: mapState.suggestion.length,
                  //           padding: EdgeInsets.all(0.0),
                  //           itemBuilder: (context, index) {
                  //             if (mapState.suggestion.isNotEmpty) {
                  //               return Card(
                  //                 margin: EdgeInsets.only(bottom: 1.0),
                  //                 child: ListTile(
                  //                   title: Text(
                  //                     mapState.suggestion[index],
                  //                     style: TextStyle(color: Colors.black),
                  //                   ),
                  //                   onTap: () {
                  //                     mapState.viasVisiBility_chng(); //-----------calling VIas Icon
                  //                     if (_controllerflag == true) {
                  //                       mapState.sourceController.text =
                  //                           mapState.suggestion[index]
                  //                               .toString();
                  //                       mapState.details(
                  //                           mapState.suggestion[index]
                  //                               .toString(),
                  //                           flag);
                  //                     }
                  //                     if (_controllerflag == false) {
                  //                       print('false selected');
                  //                       mapState.destinationController.text =
                  //                           mapState.suggestion[index]
                  //                               .toString();
                  //                       print(
                  //                           'selected value: ${mapState
                  //                               .destinationController.text}');
                  //                       mapState.details(
                  //                           mapState.suggestion[index]
                  //                               .toString(),
                  //                           flag);
                  //                     }
                  //
                  //                     //mapState.suggestion.clear();
                  //                     mapState.clearfields();
                  //
                  //                     // print(
                  //                     //     'SUGGESTION: ${mapState.suggestion}');
                  //                     // mapState.clearSuggestion();
                  //                     // print(
                  //                     //     'SUGGESTION: ${mapState.suggestion}');
                  //                   },
                  //                 ),
                  //               );
                  //             } else {
                  //               return Center(
                  //                 child: Container(
                  //                   child: CircularProgressIndicator(),
                  //                 ),
                  //               );
                  //             }
                  //           },
                  //         ),
                  //       ),
                  //     )),

                  //----> GET QUOTE BUTTON
                  Positioned(
                      bottom: 15,
                      right: 77,
                      left: 77,
                      child: Visibility(
                          visible: mapState.stackElementsVisibility,
                          child: TextButton(
                            style: TextButton.styleFrom(
                              primary: Colors.white,
                              backgroundColor: util.primaryColor,
                            ),
                            onPressed: () async {
                              // if(mapState.destinationController.text!=null && mapState.sourceController.text!=null){
                              //   vb = false;
                              // }
                              mapState.visibility();
                              mapState.viasVisiBility_chng();

                              if (viasState.viasLatLongList.isNotEmpty) {
                                viasState.viasList.clear();
                                viasState.viasLatLongList.clear();
                                viasState.viasPolyLinePoints.clear();
                                viasState.viasOutCodeList.clear();
                                viasState.viasPostCodeList.clear();
                              }
                              if (viasState.viasLatLongList.isEmpty) {
                                setState(() {
                                  mapState.drawPolyLine(
                                      mapState.l1, mapState.l2);
                                  mapState.settingModelBottomSheet(context);
                                  mapState.addCircle(mapState.l1, mapState.l2,
                                      'origin', 'destination');
                                  _polylines = mapState.polyLine;
                                });
                              } else {
                                setState(() {
                                  viasState.calculateViasDistancetime(context);
                                  // mapState.destinationcontroller.clear();
                                });

                                // viasState.drawPolyLine();
                                // print(x
                                //     'Vias Polyline length___________________${viasState.polyLine.length}');
                                // _polylines = viasState.polyLine;
                              }
                            },
                            child: Text(
                              'GET QUOTE',
                              style: TextStyle(color: Colors.white),
                            ),
                          ))),

                  //---->   CURRENT POSITION BUTTTON
                  Positioned(
                      bottom: 15,
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
                              onPressed: () async {
                                await mapState.currentLocation();

                                print("My Locationbutton Pressed");
                              },
                            ),
                          ))),

            //----> FLIGHTS BUTTON
            Positioned(
                      bottom: 15,
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
                                setState(() {
                                  Navigator.pushReplacementNamed(
                                      context, '/flightscreen');
                                });
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
                  util.primaryColor,
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
                            text: ('${MapState.userName}\n'),
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w600),
                            children: [
                              TextSpan(
                                  text: '${MapState.userEmail}',
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
                leading:
                    Icon(Icons.history_toggle_off, color: util.primaryColor),
                title: Text('Ride History'),
                onTap: () {
                  mapState.getConfigFromSharedPref();
                  Navigator.pushReplacementNamed(context, '/bookinghistory');
                },
              ),
              Divider(
                thickness: 0.5,
                height: 1,
                color: Colors.grey,
              ),
              // ListTile(
              //   leading: Icon(Icons.settings_applications_outlined,
              //       color: util.primaryColor),
              //   title: Text('Settings'),
              // ),
              // Divider(
              //   thickness: 0.5,
              //   height: 1,
              //   color: Colors.grey,
              // ),
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
                leading:
                Icon(Icons.feedback_outlined, color: util.primaryColor),
                title: Text('Give feedback'),
                onTap: () => mapState.feedBackDialog(context),
              ),
              Divider(
                thickness: 0.5,
                height: 1,
                color: Colors.grey,
              ),
              ListTile(
                leading: Icon(Icons.call, color: util.primaryColor),
                title: Text('Contact us'),
                onTap: () => showDialog(
                    context: context,
                    builder: (BuildContext context) => new AlertDialog(
                          title: new Text('Contact Details'),
                          content: new Text('Mera Number..'),
                          actions: <Widget>[
                            new IconButton(
                                icon: new Icon(Icons.close),
                                onPressed: () {
                                  Navigator.pop(context);
                                })
                          ],
                        )),
              ),
              Divider(
                thickness: 0.5,
                height: 1,
                color: Colors.grey,
              ),
              // ListTile(
              //   leading: Icon(Icons.monetization_on_outlined,
              //       color: util.primaryColor),
              //   title: Text('Wallet'),
              // ),
              // Divider(
              //   thickness: 0.5,
              //   height: 1,
              //   color: Colors.grey,
              // ),
              ListTile(
                leading:
                    Icon(Icons.info_outline_rounded, color: util.primaryColor),
                title: Text('About'),
                onTap: () {
                  showAboutDialog(
                      context: context,
                      applicationName: util.appTitle,
                      applicationLegalese: 'All Rights Resrved by Slash Global',
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
                  onTap: () async {
                    mapState.clearAll();
                    viasState.clearAll();

                    SharedPreferences sharedPreferences =
                    await SharedPreferences.getInstance();
                    sharedPreferences.remove('cEmail');
                    sharedPreferences.remove('cPhone');
                    sharedPreferences.remove('cName');
                    print(
                        "Print value: ${sharedPreferences.getString(
                            'cEmail')}");
                    print(
                        "Print value: ${sharedPreferences.getString(
                            'cPhone')}");
                    Navigator.pushReplacementNamed(context, '/login');
                  }),
            ],
          ),
        ),
      ),
    );
  }


/*gettinglatlngbounds(){
    LatLngBounds(

    )
  }*/
}
