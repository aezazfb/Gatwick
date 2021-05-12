
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zippy_rider/states/map_state.dart';

class Testing extends StatefulWidget {
  @override
  _TestingState createState() => _TestingState();
}

class _TestingState extends State<Testing> {
  @override
  Widget build(BuildContext context) {
    final mapState = Provider.of<MapState>(context);
    return Scaffold(
      body: Stack(
        children: [

          Positioned(
              top: 50.0,
              right: 17.0,
              left: 12.0,
              child: Visibility(
                visible: true,//mapState.stackElementsVisibility,
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
                          ),
                          onPressed: () {
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

          Positioned(
              left: 12,
              right: 17,
              top: 100,//heightFactor,
              child: Column(
                children: [
                  SizedBox(
                    height:200.0,
                    child: Scrollbar(
                      thickness: 10.0,
                      radius: Radius.circular(10.0),
                      isAlwaysShown: true,
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
                                  //mapState.suggestion.clear();
                                  mapState.clearfields();

                                  print(
                                      'SUGGESTION: ${mapState.suggestion}');
                                  mapState.clearSuggestion();
                                  print(
                                      'SUGGESTION: ${mapState.suggestion}');
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
                  ),
                ],
              )),
        ],
      ),
    );
  }
}
