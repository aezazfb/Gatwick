import 'package:appbar_textfield/appbar_textfield.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:zippy_rider/states/map_state.dart';
import 'package:zippy_rider/states/vias_state.dart';

class AddVias extends StatefulWidget {
  @override
  _AddViasState createState() => _AddViasState();
}

class _AddViasState extends State<AddVias> {
  bool flage = true;
  var heightFactor = 0.0;
  var count = 1;
  List viasList = [];
  String listTitle = '';

  @override
  Widget build(BuildContext context) {
    final mapState = Provider.of<MapState>(context);
    final viasState = Provider.of<ViasState>(context);
    return Scaffold(
      appBar: AppBarTextField(
        title: Text('Add Vias'),
        centerTitle: false,
        searchContainerColor: Colors.white,
        searchButtonIcon: Icon(Icons.add_location, size: 30),
        onChanged: (value) {
          mapState.viaSuggestion(value);
        },
        onBackPressed: () {
          setState(() {
            mapState.viasSuggestionList.clear();
          });
        },
        clearBtnIcon: Icon(Icons.clear, size: 30),
        defaultHintText: 'Search Vias....',
        controller: mapState.viasController,
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
          //VIAS LIST
          Positioned(
            top: 190,
            left: 30,
            right: 30,
            child: Container(
                child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: viasList.length,
                    itemBuilder: (context, index) {
                      if (index == 0) {
                        listTitle = '  Via: \n \n';
                      } else {
                        listTitle = '';
                      }
                      return ListTile(
                        title: Text(
                          '$listTitle ${viasList[index]}',
                        ),
                        trailing: IconButton(
                          icon: Icon(Icons.remove_circle_outline,
                              color: Colors.red),
                          onPressed: () {
                            setState(() {
                              viasList.removeAt(index);
                              viasState.viasLatLangList.removeAt(index);
                            });
                          },
                        ),
                      );
                    })),
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

          //---->VIAS SUGGESTION LIST VIEW
          Positioned(
              left: 4.0,
              right: 4.0,
              top: 10.0,
              child: LimitedBox(
                maxHeight: mapState.viasSuggestionList.length * 50.0,
                child: Container(
                  child: ListView.builder(
                    itemCount: mapState.viasSuggestionList.length,
                    padding: EdgeInsets.all(0.0),
                    itemBuilder: (context, index) {
                      if (mapState.viasSuggestionList.isNotEmpty) {
                        return Card(
                          margin: EdgeInsets.only(bottom: 1.0),
                          child: ListTile(
                            title: Text(
                              mapState.viasSuggestionList[index],
                              style: TextStyle(color: Colors.black),
                            ),
                            onTap: () {
                              // mapState.details(mapState.suggestion[index].toString(), flage);
                              viasState.viasDetails(mapState
                                  .viasSuggestionList[index]
                                  .toString());

                              viasList.add(mapState.viasSuggestionList[index]
                                  .toString());
                              mapState.viasController.text =
                                  mapState.viasSuggestionList[index].toString();
                              // viasState.viaSuggestion(value)
                              setState(() {
                                mapState.viasSuggestionList.clear();
                              });
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
          // Positioned(
          //     bottom: 70,
          //     left: 17,
          //     child: Visibility(
          //         visible: mapState.stackElementsVisibality,
          //         child: Container(
          //           decoration: BoxDecoration(
          //             color: Colors.grey.shade300.withOpacity(0.7),
          //             borderRadius: BorderRadius.circular(10.0),
          //           ),
          //           child: IconButton(
          //             icon: Icon(Icons.add, color: Colors.purple),
          //             onPressed: () {
          //               setState(() {
          //                 _viasVisibility = true;
          //               });
          //               print("My Locationbutton Pressed");
          //             },
          //           ),
          //         ))),

          //----> ADD VIAS FROM MAP BUTTON
          // Positioned(
          //     bottom: 70,
          //     right: 17,
          //     child: Visibility(
          //         visible: mapState.stackElementsVisibality,
          //         child: Container(
          //           decoration: BoxDecoration(
          //             color: Colors.grey.shade300.withOpacity(0.7),
          //             borderRadius: BorderRadius.circular(10.0),
          //           ),
          //           child: IconButton(
          //             icon: Icon(Icons.location_on, color: Colors.purple),
          //             onPressed: () {
          //               print(viasList);
          //               Navigator.pushNamed(context, '/flightscreen');
          //             },
          //           ),
          //         ))),

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
                      print(viasList);
                      // mapState.drawPolyLine();
                      // mapState.addCircle(
                      //     mapState.l1, mapState.l2, 'origin', 'destination');
                      // mapState.showAppBar = true;
                      print(viasState.viasLatLangList);
                      // mapState.settingModelBottomSheet(context);
                      viasState.calculateVias(
                          mapState.l1, mapState.l2, context);
                      mapState.addMarker(
                          viasState.viasLatLangList[0], 'vias', flage, 70);
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