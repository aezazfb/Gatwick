import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zippy_rider/models/BookingModel.dart';
import 'package:zippy_rider/requests/bookinghistory_request.dart';
import 'package:zippy_rider/states/map_state.dart';
import 'package:zippy_rider/states/ridehistory_state.dart';

import 'package:zippy_rider/utils/util.dart' as util;

class RideHistory extends StatefulWidget {
  @override
  _RideHistoryState createState() => _RideHistoryState();
}

class _RideHistoryState extends State<RideHistory> {
  String _track = "Track";
  List<String> tempList = List<String>.generate(100, (index) => "Item $index");

  @override
  Widget build(BuildContext context) {
    final rideHistoryState = Provider.of<RideHistoryState>(context);
    return DefaultTabController(
      length: 3,
      child: Scaffold(
          appBar: AppBar(
            title: Text('ZippyRider'),
            bottom: TabBar(
                labelPadding: EdgeInsets.zero,
                indicatorColor: util.primaryColor,
                physics: BouncingScrollPhysics(),
                unselectedLabelColor: Colors.white,
                labelStyle: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 17,
                ),
                unselectedLabelStyle: TextStyle(
                  fontSize: 15,
                ),
                labelColor: util.primaryColor,
                indicatorSize: TabBarIndicatorSize.tab,
                indicator: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(15),
                      topLeft: Radius.circular(15)),
                ),
                tabs: [
                  Tab(text: 'BOOKED'),
                  Tab(text: 'COMPLETED'),
                  Tab(text: 'CANCELLED'),
                ]),
          ),
          body: Builder(
            builder: (context) => TabBarView(children: [
              FutureBuilder(
                  future: rideHistoryState.getbookedHistory(),
                  builder: (BuildContext buildContext,
                      AsyncSnapshot<List<BookingModel>> snapshot) {
                    if (snapshot.hasError) {
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        /*ScaffoldMessenger.of(context).showSnackBar(new SnackBar(
                          content: new Text('Loading Data Error'),
                        ));*/
                        getDefaultColumn('booked');
                      });
                      return Text('Got Error');
                    }
                    if(snapshot.hasData && snapshot.data != null){
                      return getListView(
                          rideHistoryState.bookedBookingHistoryList, 'booked',
                          editDetails: true,
                          viewDetails: false,
                          review: false);
                    }else if(snapshot.data == null){
                      return getDefaultColumn('booked');
                    }else{
                     return displayProgressBar();
                    }
                  }),
              FutureBuilder(
                  future: rideHistoryState.getcompletedHistory(),
                  builder: (BuildContext buildContext,
                      AsyncSnapshot<List<BookingModel>> snapshot) {
                    if (snapshot.hasError) {
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        // Add Your Code here.
                        /*ScaffoldMessenger.of(context).showSnackBar(new SnackBar(
                          content: new Text('Loading Data Error'),
                        ));*/
                        getDefaultColumn('completed');
                      });
                      return Text('Got Error');
                    }
                    if(snapshot.hasData && snapshot.data != null){
                      return getListView(
                          rideHistoryState.completedBookingHistoryList,
                          'completed',
                          editDetails: true,
                          viewDetails: true,
                          review: true);
                    }else if(snapshot.data == null){
                      return getDefaultColumn('completed');
                    }else{
                      return displayProgressBar();
                    }

                  }),
              FutureBuilder(
                  future: rideHistoryState.getcancelledHistory(),
                  builder: (BuildContext buildContext,
                      AsyncSnapshot<List<BookingModel>> snapshot) {
                    if (snapshot.hasError) {
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        // Add Your Code here.
                        /*ScaffoldMessenger.of(context).showSnackBar(new SnackBar(
                          content: new Text('Loading Data Error'),
                        ));*/
                        getDefaultColumn('cancelled');
                      });
                      return Text('Got Error');
                    }
                    if(snapshot.hasData && snapshot.data != null){
                      return getListView(
                          rideHistoryState.cancelledBookingHistoryList,
                          'cancelled',
                          editDetails: false,
                          viewDetails: true,
                          review: true);
                    }else if(snapshot.data == null){
                      return getDefaultColumn('cancelled');
                    }else{
                      return displayProgressBar();
                    }
                  }),
            ]),
          )),
    );
  }

  Widget displayProgressBar() {
    return Center(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CircularProgressIndicator(),
        SizedBox(height: 10),
        Text('Please wait...')
      ],
    ));
  }

  Widget getDefaultColumn(String value) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset("assets/images/emptydoc.png"),
        Text('No $value booking yet'),
      ],
    );
  }

  Widget getListView(List<BookingModel> selectedBookingList, String status,
      {bool editDetails, bool viewDetails, bool review}) {
    return ListView.builder(
        itemCount: selectedBookingList.length,
        itemBuilder: (context, index) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Card(
                margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
                elevation: 4.0,
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(selectedBookingList[index].date),
                        Container(
                            height: 40,
                            padding: EdgeInsets.symmetric(vertical: 8.0),
                            child: VerticalDivider(
                                thickness: 1, color: Color(0xFF424242))),
                        Text(selectedBookingList[index].time),
                        Visibility(
                          visible: viewDetails,
                          replacement: Container(
                            height: 0,
                            width: 0,
                          ),
                          child: IconButton(
                            icon: Icon(Icons.article_outlined,
                                color: Colors.blue.shade700, size: 30.0),
                          ),
                        ),
                        Visibility(
                          visible: editDetails,
                          replacement: Container(
                            height: 0,
                            width: 0,
                          ),
                          child: IconButton(
                            icon: Icon(Icons.create_outlined,
                                color: Colors.orange, size: 30.0),
                            onPressed: () {
                              Navigator.pushNamed(context, '/editbooking',
                                  arguments: selectedBookingList[index]);
                            },
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    Row(
                      children: [
                        SizedBox(
                            width: 40,
                            child: Icon(Icons.my_location_sharp,
                                color: Colors.red)),
                        Flexible(child: Text(selectedBookingList[index].from))
                      ],
                    ),
                    SizedBox(height: 10),
                    Row(
                      children: [
                        SizedBox(
                            width: 40,
                            child: Icon(Icons.location_on_outlined,
                                color: Colors.red)),
                        Flexible(child:Text(selectedBookingList[index].to))
                      ],
                    ),
                    SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: 16.0),
                      child: Row(
                        children: [
                          Visibility(
                            visible: review,
                            child: Text(
                              'Review',
                              style: TextStyle(
                                backgroundColor: Colors.red[800],
                                color: Colors.white,
                              ),
                            ),
                          ),
                          Spacer(),
                          Icon(
                            Icons.monetization_on,
                            color: Colors.green,
                            size: 25.0,
                          ),
                          Text(selectedBookingList[index].fare.toString())
                        ],
                      ),
                    ),
                    Divider(
                      color: Colors.black,
                      thickness: 1.0,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Row(
                            children: [
                              SizedBox(
                                  width: 30,
                                  child: Icon(
                                    Icons.location_pin,
                                    color: Colors.blue,
                                  )),
                              Text(_track),
                            ],
                          ),
                          Text(
                            '$status',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Offstage(
                            offstage: true,
                            child: Row(
                              children: [
                                Icon(
                                  Icons.refresh_outlined,
                                  color: Colors.red,
                                ),
                                Text('Rebook'),
                              ],
                            ),
                          ),
                          Row(
                            children: [
                              Icon(
                                Icons.delete_outline_outlined,
                                color: Colors.red,
                              ),
                              Text('Cancel Ride'),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Divider(
                      color: Colors.black,
                      thickness: 1.0,
                    )
                  ],
                ),
              )
            ],
          );
        });
  }

  Color applicationColor() {
    return Color(0xFF8E24AA);
  }
}
