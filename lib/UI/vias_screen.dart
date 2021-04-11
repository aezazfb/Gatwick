import 'package:appbar_textfield/appbar_textfield.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:toast/toast.dart';
import 'package:zippy_rider/states/map_state.dart';
import 'package:zippy_rider/states/vias_state.dart';
import 'package:zippy_rider/utils/util.dart' as util;

class AddVias extends StatefulWidget {
  @override
  AddViasState createState() => AddViasState();
}

class AddViasState extends State<AddVias> {
  bool flage = false;
  int flag = -1;
  var heightFactor = 0.0;
  String listTitle = '';

  @override
  Widget build(BuildContext context) {
    final mapState = Provider.of<MapState>(context);
    final viasState = Provider.of<ViasState>(context);
    return WillPopScope(
      onWillPop: () async{
        Navigator.pop(context);
        return true;
      },
      child: Scaffold(
        appBar: AppBarTextField(
          title: Text('Add Vias'),
          centerTitle: false,
          leading: new Container(),
          searchContainerColor: Colors.white,
          searchButtonIcon: Icon(Icons.location_searching_rounded, size: 30),
          onChanged: (value) {
            flage = false;
            flag = 7;
            viasState.viaSuggestion(value);
          },
          onBackPressed: () {
            setState(() {
              viasState.viasSuggestionList.clear();
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
                    flag = 0;
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
                          Marker markers = mapState.marker.firstWhere(
                              (p) => p.markerId == MarkerId('0'),
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
                    flag = 1;
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
                          Marker markers = mapState.marker.firstWhere(
                              (p) => p.markerId == MarkerId('1'),
                              orElse: () => null);
                          mapState.marker.remove(markers);
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

            //VIAS LIST
            Positioned(
              top: 190,
              left: 30,
              right: 30,
              child: Container(
                  child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: viasState.viasList.length,
                      itemBuilder: (context, index) {
                        if (index == 0) {
                          listTitle = '  Via: \n';
                        } else {
                          listTitle = '';
                        }
                        return ListTile(
                          title: Text(
                            '$listTitle ${viasState.viasList[index]}',
                          ),
                          trailing: IconButton(
                            icon: Icon(Icons.remove_circle_outline,
                                color: Colors.red),
                            onPressed: () {
                              setState(() {
                                viasState.viasList.removeAt(index);
                                viasState.viasPostCodeList.removeAt(index);
                                viasState.viasOutCodeList.removeAt(index);

                                if (viasState.polyLine.isNotEmpty) {
                                  viasState.polyLine.last.points.clear();
                                }
                                viasState.viasLatLongList.removeAt(index);

                                print('MARKER VALUE: ${mapState.marker}');
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
                                      mapState.suggestion[index].toString(),flag);
                                }
                                if (flage == false) {
                                  mapState.destinationController.text =
                                      mapState.suggestion[index].toString();
                                  mapState.details(
                                      mapState.suggestion[index].toString(),flag);
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
                  maxHeight: viasState.viasSuggestionList.length * 50.0,
                  child: Container(
                    child: ListView.builder(
                      itemCount: viasState.viasSuggestionList.length,
                      padding: EdgeInsets.all(0.0),
                      itemBuilder: (context, index) {
                        if (viasState.viasSuggestionList.isNotEmpty) {
                          return Card(
                            margin: EdgeInsets.only(bottom: 1.0),
                            child: ListTile(
                              title: Text(
                                viasState.viasSuggestionList[index],
                                style: TextStyle(color: Colors.black),
                              ),
                              onTap: () {
                                if (viasState.viasList.length < 7) {
                                  viasState.viasList.add(viasState
                                      .viasSuggestionList[index]
                                      .toString());
                                } else {
                                  Toast.show('You can not add more than 7 vias ',
                                      context,
                                      duration: Toast.LENGTH_LONG);
                                }
                                viasState.viasDetails(
                                    viasState.viasSuggestionList[index]
                                        .toString(), flag);
                                setState(() {
                                  viasState.viasSuggestionList.clear();
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

            //GET QUOTE BUTTON
            Positioned(
                bottom: 15,
                right: 17,
                left: 17,
                child: TextButton(
                  style: TextButton.styleFrom(
                    primary: Colors.white,
                    backgroundColor: util.primaryColor,
                  ),
                  onPressed: () {
                    for (int i = 0; i < viasState.viasLatLongList.length; i++) {
                      mapState.addMarker(
                          viasState.viasLatLongList[i], "${viasState.viasList[i]}", 7, 90);//Via$i
                    }
                    print('VIAS MARKER: ${mapState.marker}');

                    viasState.calculateViasDistancetime(context);
                    print('Vias List: ${viasState.viasList}');
                    print('Vias LatLng List: ${viasState.viasLatLongList}');

                    Navigator.pushNamed(context, '/mapscreen');
                  },
                  child: Text(
                    'GET QUOTE',
                    style: TextStyle(color: Colors.white),
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
