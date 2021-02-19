import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zippy_rider/states/map_state.dart';

class AddVias extends StatefulWidget {
  @override
  _AddViasState createState() => _AddViasState();
}

class _AddViasState extends State<AddVias> {
  bool flage = true;
  var heightFactor = 0.0;
  bool _viasVisibility = false;
  var count = 1;
  List viasList = [];

  @override
  Widget build(BuildContext context) {
    final mapState = Provider.of<MapState>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple,
        title: Text('ZippyRider'),
        centerTitle: false,
      ),
      body: Stack(
        children: [
          //---->Pick Up Text Field
          Positioned(
            top: 10,
            left: 8.0,
            right: 8.0,
            child: Container(
              height: 60.0,
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
                  heightFactor = 80;
                  mapState.suggestions(bool);
                },
                onEditingComplete: () {
                  mapState.clearSuggestion();
                },
                decoration: InputDecoration(
                  icon: Container(
                    child: Icon(Icons.location_on),
                    margin: EdgeInsets.only(left: 8.0, top: 0.5, bottom: 5),
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
                        // Marker markers = mapState.marker.firstWhere(
                        //          (p) => p.markerId == MarkerId('true'),
                        //      orElse: () => null);
                        //  mapState.marker.remove(markers);
                        mapState.sourceController.clear();
                        //  mapState.clearfields();
                        mapState.clearSuggestion();
                      }),
                  hintText: "pick up",
                  border: InputBorder.none,
                  contentPadding:
                      EdgeInsets.only(left: 6.0, top: 8.0, right: 6.0),
                ),
              ),
            ),
          ),
          //---->Drop Off Text Field
          Positioned(
            top: 75,
            left: 8.0,
            right: 8.0,
            child: Container(
              height: 60.0,
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
                  heightFactor = 150;
                },
                cursorColor: Colors.black,
                controller: mapState.destinationController,
                onEditingComplete: () {
                  mapState.clearSuggestion();
                },
                decoration: InputDecoration(
                  icon: Container(
                    margin: EdgeInsets.only(left: 8.0, top: 0.5, bottom: 10),
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
                        // Marker markers = mapState.marker.firstWhere(
                        //          (p) => p.markerId == MarkerId('false'),
                        //      orElse: () => null);
                        //  mapState.marker.remove(markers);
                        mapState.destinationController.clear();
                        mapState.clearfields();
                        mapState.clearSuggestion();
                      }),
                  hintText: "go to...",
                  border: InputBorder.none,
                  contentPadding:
                      EdgeInsets.only(left: 6.0, top: 8.0, right: 6.0),
                ),
              ),
            ),
          ),
          //VIAS TEXT FIELD
          Positioned(
            top: 140,
            left: 8.0,
            right: 8.0,
            child: Visibility(
                visible: _viasVisibility,
                child: Container(
                  height: 60.0,
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
                    controller: mapState.viasController,
                    onChanged: (bool) {
                      count = 0;
                      //flage = false;
                      mapState.suggestions(bool);
                      heightFactor = 200;
                    },
                    cursorColor: Colors.black,
                    //  controller: mapState.destinationController,
                    onEditingComplete: () {
                      mapState.clearSuggestion();
                    },
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
                            //   color: Colors.black,
                          ),
                          onPressed: () {
                            // Marker markers = mapState.marker.firstWhere(
                            //          (p) => p.markerId == MarkerId('false'),
                            //      orElse: () => null);
                            //  mapState.marker.remove(markers);
                            //  mapState.viasController.clear();
                            _viasVisibility = false;
                            mapState.clearfields();
                            mapState.clearSuggestion();
                          }),
                      hintText: "go to...",
                      border: InputBorder.none,
                      contentPadding:
                          EdgeInsets.only(left: 6.0, top: 8.0, right: 6.0),
                    ),
                  ),
                )),
          ),

          //---->SWAP FIELDS BUTTON
          Positioned(
            top: 40,
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

          //---->SUGGESTIONS LIST VIEW
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
                              if (count == 0) {
                                mapState.viasController.text =
                                    mapState.suggestion[index].toString();
                                viasList
                                    .add(mapState.suggestion[index].toString());
                                count = 1;
                              }
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

          //---->ADD VIAS BUTTON
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
                      icon: Icon(Icons.add, color: Colors.purple),
                      onPressed: () {
                        setState(() {
                          _viasVisibility = true;
                        });
                        print("My Locationbutton Pressed");
                      },
                    ),
                  ))),

          //----> ADD VIAS FROM MAP BUTTON
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
                      icon: Icon(Icons.location_on, color: Colors.purple),
                      onPressed: () {
                        print(viasList);
                        Navigator.pushNamed(context, '/flightscreen');
                      },
                    ),
                  ))),

          //GET QUOTE BUTTON
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
                          mapState.l1, mapState.l2, 'origin', 'destination');
                      mapState.showAppBar = true;
                      mapState.settingModelBottomSheet(context);
                      mapState.visibility();
                    },
                    child: Text(
                      'GET QUOTE',
                      style: TextStyle(color: Colors.white),
                    ),
                  ))),
        ],
      ),
    );
  }
}
