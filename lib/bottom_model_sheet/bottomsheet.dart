import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_dropdown/flutter_dropdown.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:toast/toast.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:zippy_rider/models/BookingModel.dart';
import 'package:zippy_rider/requests/bottom_sheet/vehicle_details.dart';
import 'package:zippy_rider/requests/map_screen/insertBooking.dart';
import 'package:zippy_rider/states/map_state.dart';
import 'package:zippy_rider/states/vias_state.dart';
import 'package:zippy_rider/utils/util.dart' as util;

class BottomModelSheet with ChangeNotifier {
  DateTime pickedDate = DateTime.now();
  int _initialLabel = 1;
  TextEditingController _flightController = TextEditingController();
  TextEditingController _commenttController = TextEditingController();

  VehicleDetails _vehicleDetails = VehicleDetails();
  List carDetails = [];
  List cars = [];
  List<Fromtovia> fromToViaList = [];
  List<List<dynamic>> logc = [];

  String vechile = 'Saloon ';
  int suitCase = 0;
  int passengers = 0;
  String rideDate = 'Select Date';
  String rideTime = 'Select time';
  int count = 0;
  double jobmileage;

  SharedPreferences sharedPreferences;

  //String origin, destination, origin_outcode, dest_outcode,origin_postcode, dest_postcode;

  settingModelBottomSheet(context, distance, time) async {
    final mapState = Provider.of<MapState>(context, listen: false);
    final viasState = Provider.of<ViasState>(context, listen: false);

    getConfigFromSharedPref();
    /*
    origin,destination,o_outcode,d_outcode,o_postcode,d_postcode
    this.origin = origin;
    this.destination = destination;
    this.origin_outcode = o_outcode;
    this.dest_outcode = d_outcode;
    this.origin_postcode = o_postcode;
    this.dest_postcode = d_postcode;*/

    carDetails = await _vehicleDetails.getVehicleDetails(3);
    cars = carDetails[0]['carstype'];
    showModalBottomSheet(
        //backgroundColor: Colors.tealAccent,
        enableDrag: true,
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
            return Container(
              margin: EdgeInsets.all(0.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(12.0)),
                color: Colors.white,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Wrap(
                    children: [
                      Card(
                          elevation: 0.0,
                          child: Center(
                            child: Wrap(
                              children: [
                                Text('Driver will be available in 10 minutes'),
                                Text('Date: $rideDate , Time  $rideTime')
                              ],
                            ),
                          )),
                      Card(
                        color: Colors.grey[300],
                        child: Row(
                          children: [
                            Icon(Icons.monetization_on_outlined,
                                size: 30, color: Colors.purple),
                            Text('dummy ',
                                style: TextStyle(color: Colors.black)),
                            Icon(Icons.alt_route,
                                size: 30, color: Colors.purple),
                            Text('${getJobMileage(distance)} miles',
                                style: TextStyle(color: Colors.black)),
                            Spacer(),
                            Icon(
                              Icons.access_time_rounded,
                              size: 30,
                              color: Colors.purple,
                            ),
                            Text('$time',
                                style: TextStyle(color: Colors.black)),
                            Spacer(),
                            //Icon(Icons.clean_hands_outlined,size: 40),

                            DropDown(
                              items: [
                                'Cash',
                                'Card',
                              ],
                              hint: Text('Cash',
                                  style: TextStyle(color: Colors.black)),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                          height: 70.0,
                          //levation: 0.0,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            //crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              SizedBox(width: 15),
                              RotatedBox(
                                  quarterTurns: 3,
                                  child: Text(
                                    '${cars[count]['carname']}',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 10,
                                    ),
                                  )),
                              Icon(Icons.local_taxi_outlined,
                                  size: 40, color: Colors.black),
                              Spacer(),
                              RichText(
                                  text: TextSpan(
                                      text: '${cars[count]['carcapacity']}\n',
                                      style: TextStyle(
                                        color: Colors.black,
                                      ),
                                      children: <TextSpan>[
                                        TextSpan(
                                            text: ('Passangers'),
                                            style:
                                                TextStyle(color: Colors.black))
                                      ]),
                                  textAlign: TextAlign.center),
                              Spacer(),
                              RichText(
                                  text: TextSpan(
                                      text:
                                          '${cars[count]['lugagecapacity']}\n',
                                      style: TextStyle(color: Colors.black),
                                      children: <TextSpan>[
                                        TextSpan(
                                            text: ('Suitcases'),
                                            style:
                                                TextStyle(color: Colors.black))
                                      ]),
                                  textAlign: TextAlign.center),
                              SizedBox(width: 15),
                            ],
                          )),
                      Swiper(
                        itemWidth: 140,
                        itemHeight: 130,
                        itemCount: 5,
                        // outer: true,
                        layout: SwiperLayout.CUSTOM,
                        customLayoutOption: new CustomLayoutOption(
                                startIndex: -1, stateCount: 3)
                            .addTranslate([
                          new Offset(-140.0, 30.0),
                          new Offset(0.0, 20.0),
                          new Offset(140.0, 30.0)
                        ]).addOpacity([1.0, 1.0, 1.0]),
                        scrollDirection: Axis.horizontal,
                        onIndexChanged: (index) {
                          setState(() {
                            count = index;
                          });
                        },
                        itemBuilder: (BuildContext context, index) {
                          return Card(
                              elevation: 20.0,
                              shadowColor: Colors.transparent,
                              color: Colors.grey[300],
                              child: InkWell(
                                  child: Stack(
                                children: [
                                  Icon(
                                    Icons.local_taxi_rounded,
                                    size: 45,
                                    color: Colors.purple,
                                  ),
                                  Positioned(
                                    top: 50,
                                    left: 10.0,
                                    child: Row(
                                      children: [
                                        Text(
                                          "${cars[index]['carname']}",
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.w600,
                                              fontSize: 12),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Positioned(
                                      top: 65.0,
                                      left: 10,
                                      child: Text(
                                          "Passengers: ${cars[index]['carcapacity']}",
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.w400))),
                                  Positioned(
                                      top: 80.0,
                                      left: 10,
                                      child: Text(
                                          "Suitcase: ${cars[index]['lugagecapacity']}",
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.w400))),
                                ],
                              )));
                        },
                      ),
                      Card(
                          elevation: 0.0,
                          color: Colors.grey[400],
                          child: Wrap(
                            children: [
                              IconButton(
                                  icon: Icon(Icons.date_range),
                                  iconSize: 40,
                                  color: Colors.white,
                                  onPressed: () {
                                    // pickDate(context);

                                    DatePicker.showDateTimePicker(context,
                                        minTime: DateTime.now(),
                                        maxTime: DateTime(1),
                                        currentTime: DateTime.now(),
                                        locale: LocaleType.en,
                                        onConfirm: (value) {
                                      setState(() {
                                        rideDate =
                                            '${value.day}-${value.month}-${value.year}';
                                        rideTime =
                                            '${value.hour}:${value.minute}';
                                      });
                                    });

                                    print(carDetails);
                                    print('__________________________\n');
                                    print(cars[0]['carname']);
                                  }),
                              FlatButton(
                                  minWidth:
                                      MediaQuery.of(context).size.width - 120,
                                  height: 40,
                                  color: Colors.purple,
                                  child: Text('Confirm',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w700,
                                      )),
                                  onPressed: () {
                                    fillFromToViaList(viasState, mapState);

                                    fillLogcList();



                                    BookingModel bookingModel = BookingModel(
                                        from: mapState.sourceController.text
                                            .toString(),
                                        fromInfo: "",
                                        from_outcode: mapState.outcode1,
                                        fromtovia: fromToViaList,
                                        logc: logc,
                                        office: util.office,
                                        telephone: sharedPreferences.getString('cPhone').toString(),
                                        userid: sharedPreferences.getString('cEmail').toString(),//"tayyab.slash@gmail.com",
                                        custname: sharedPreferences.getString('cName').toString(),
                                        time: rideTime,
                                        date: rideDate,
                                        to: mapState.destinationController.text
                                            .toString(),
                                        toInfo: "",
                                        to_outcode: mapState.outcode2,
                                        fare: 2.0,
                                        drvfare: 2.0,
                                        jobmileage: getJobMileage(distance),
                                        jobref: "",
                                        mstate: "",
                                        timetodespatch: 0.0,
                                        datentime: DateTime.now()
                                            .millisecondsSinceEpoch
                                            .toDouble(),
                                        changed: false,
                                        account: "CARD",
                                        accuser: "",
                                        bookedby: "CustomerOnline",
                                        comment:
                                            "passenger = 1,checkin = 0,cabin = 0",
                                        creditcard: "tayyab.slash@gmail.com",
                                        cstate: "booked",
                                        despatchtime: 0.0,
                                        driverrate: "CASH",
                                        drvrcallsign: "",
                                        drvreqdname: "",
                                        drvrname: "",
                                        drvrreqcallsign: "",
                                        dstate: "",
                                        flag: 1,
                                        flightno: "",
                                        hold: false,
                                        isdirty: false,
                                        jobtype: "normal",
                                        jstate: "unallocated",
                                        leadtime: 0.0,
                                        logd: null,
                                        numofvia: viasState.viasList.length,
                                        oldfare: 0.0,
                                        olddrvfare: 0.0,
                                        orderno: "",
                                        tag: "1",
                                        vehicletype: "S",
                                        pin: "",
                                        callerid: "");

                                    //InsertBooking.insertBooking(bookingModel);
                                    print(bookingModel.toString());
                                    print(
                                        '------------------------------------');
                                    print(bookingModel.toJson());
                                  }),
                              IconButton(
                                  icon: Icon(Icons.add),
                                  iconSize: 40,
                                  color: Colors.white,
                                  onPressed: () {
                                    dialogShow(context);
                                  }),
                            ],
                          )),
                    ],
                  )
                ],
              ),
            );
          });
        });
  }

  //---> Preparing jobmileage Value
  double getJobMileage(dynamic distance){
    try {
      jobmileage = double.tryParse(distance.toString());
      jobmileage = shortDoubleToApprox(jobmileage, 2);
      print('jobmileage: $jobmileage');
      return jobmileage;
    } catch (e) {
      print('Exception Caught: $e');
    }
    return null;
  }

  //----> for Rounding long double values to approx, using it for time in above
  double shortDoubleToApprox(double val, int places){
    try{
    double mod = pow(10.0, places);
    print('${((val * mod).round().toDouble() / mod)}');
    return ((val * mod).round().toDouble() / mod);
    }catch(e){
      print('exception caught on method: $e');
      return null;
    }
  }

  getConfigFromSharedPref() async {
   sharedPreferences = await SharedPreferences.getInstance();
    print("Print value: ${sharedPreferences.getString('cEmail')}");
    print("Print value: ${sharedPreferences.getString('cPhone')}");
  }

  fillLogcList() {
    List<dynamic> listofLogc = [];
    listofLogc.add(DateTime.now().millisecondsSinceEpoch);
    listofLogc.add("booked");
    listofLogc.add("tayyab.slash@gmail.com");
    listofLogc.add("TaxisNetworkAndroid");

    print("logc ${logc.length}");
    logc.add(listofLogc);
  }

  //---->To check if( viaList is empty then put source/dest and put empty 7 data)
  // otherwise complete added vias in FromToVia
  fillFromToViaList(ViasState viasState, MapState mapState) {
    print('fromtovia: $fromToViaList');
    print('viasState.viasList: ${viasState.viasList}');

    Fromtovia fromtovia1 = Fromtovia(
        info: "",
        address: mapState.sourceController.text,
        lat: mapState.l1.latitude,
        lon: mapState.l1.longitude,
        postcode: mapState.postcode1);

    Fromtovia fromtovia2 = Fromtovia(
        info: "",
        address: mapState.destinationController.text,
        lat: mapState.l2.latitude,
        lon: mapState.l2.longitude,
        postcode: mapState.postcode2);

    fromToViaList.add(fromtovia1);
    fromToViaList.add(fromtovia2);

    if (viasState.viasList.length == 0) {
      //print('fromtovia: ${viasState.viasList}');
      for (int i = 0; i < 7; i++) {
        Fromtovia extrafromtovia = Fromtovia(
            info: null, address: null, lat: 0.0, lon: 0.0, postcode: null);

        fromToViaList.add(extrafromtovia);
      }
    } else {
      //---> for loop to add selected vias in FromToVia, for e.g: 3 selected vias
      for (int i = 0; i < viasState.viasList.length; i++) {
        Fromtovia existingvia = Fromtovia(
            info: "",
            address: viasState.viasList[i].toString(),
            lat: viasState.viasLatLongList[0].latitude,
            lon: viasState.viasLatLongList[0].longitude,
            postcode: viasState.viasPostCodeList[0]);

        fromToViaList.add(existingvia);
      }
      //---> for loop if 7 vias are not selected then filling with empty
      for (int i = viasState.viasList.length; i < 7; i++) {
        Fromtovia extrafromtovia = Fromtovia(
            info: null, address: null, lat: 0.0, lon: 0.0, postcode: null);

        fromToViaList.add(extrafromtovia);
      }
    }

    print('fromtovia: $fromToViaList');
  }

  //---->Date Picker
  pickDate(context) async {
    DatePicker.showDateTimePicker(context,
        minTime: DateTime.now(),
        maxTime: DateTime(1),
        currentTime: DateTime.now(),
        locale: LocaleType.en, onConfirm: (value) {
          DateFormat dateFormat = DateFormat('dd-MM-yyyy');
          DateFormat timeFormat = DateFormat('hh:mm');
      rideDate = '${dateFormat.format(value)}';//'${value.day}-${value.month}-${value.year}';
      rideTime = '${timeFormat.format(value)}';//'${value.hour}:${value.minute}';
      notifyListeners();
    });
  }

//---->Additional Information Dialog.
  dialogShow(context) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          scrollable: true,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
          insetPadding: EdgeInsets.all(10.0),
          titlePadding: EdgeInsets.all(0.0),
          titleTextStyle: TextStyle(
              color: Colors.white, fontSize: 20, fontWeight: FontWeight.w600),
          title: Container(
            width: MediaQuery.of(context).size.width - 40,
            padding: EdgeInsets.only(left: 10, bottom: 20, top: 10),
            child: Text(' Additional Information '),
            decoration: BoxDecoration(
              color: Colors.purple,
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(15),
                  topLeft: Radius.circular(15.0)),
            ),
          ),
          content: Container(
            width: MediaQuery.of(context).size.width - 40,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Child Seat'),
                    ToggleSwitch(
                      minWidth: 50.0,
                      cornerRadius: 10.0,
                      activeBgColor: Colors.purple,
                      activeFgColor: Colors.white,
                      inactiveBgColor: Colors.grey,
                      labels: ['YES', 'NO'],
                      initialLabelIndex: _initialLabel,
                      // icons: [Icons.check, Icons.clear_rounded],
                      onToggle: (index) {
                        print('switched to: $index');
                        if (index == 0) {
                          _initialLabel = index;
                          Toast.show('Child seat Selected', context,
                              duration: Toast.LENGTH_LONG);
                        }
                        if (index == 1) {
                          _initialLabel = index;
                          Toast.show('Child seat not selected', context,
                              duration: Toast.LENGTH_LONG);
                        }
                      },
                    ),
                  ],
                ),
                SizedBox(height: 10),
                ListTile(
                  leading: Icon(
                    Icons.flight,
                    color: Colors.purple,
                  ),
                  title: TextFormField(
                    controller: _flightController,
                    maxLines: 1,
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.go,
                    minLines: null,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      hintText: 'Flight Number',
                    ),
                  ),
                ),
                SizedBox(height: 10),
                ListTile(
                  leading: Icon(
                    Icons.comment,
                    color: Colors.purple,
                  ),
                  title: TextFormField(
                    controller: _commenttController,
                    maxLines: 4,
                    keyboardType: TextInputType.multiline,
                    minLines: null,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      hintText: 'Add Comment',
                    ),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            FlatButton(
                color: Colors.purple,
                onPressed: () {
                  _flightController = new TextEditingController(
                      text: _flightController.text.toString());
                  _commenttController = TextEditingController(
                      text: _commenttController.text.toString());
                  Navigator.pop(context);
                },
                child: Text('DONE')),
            FlatButton(
                color: Colors.purple,
                onPressed: () {
                  _initialLabel = 1;
                  Navigator.pop(context);
                },
                child: Text('CANCEL'))
          ],
        );
      },
    );
  }
}
