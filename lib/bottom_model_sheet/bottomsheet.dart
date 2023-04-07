import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_dropdown/flutter_dropdown.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:toast/toast.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:zippy_rider/base_class.dart';
import 'package:zippy_rider/models/BookingModel.dart';
import 'package:zippy_rider/models/cars_type_model.dart';
import 'package:zippy_rider/payment_gateways/stripe-payment-service.dart';
import 'package:zippy_rider/requests/map_screen/insertBooking.dart';
import 'package:zippy_rider/states/map_state.dart';
import 'package:zippy_rider/states/vias_state.dart';
import 'package:zippy_rider/utils/util.dart' as util;

class BottomModelSheet extends BaseClass with ChangeNotifier {
  DateTime pickedDate = DateTime.now();
  int _initialLabel = 1;
  TextEditingController _flightController = TextEditingController();
  TextEditingController _commenttController = TextEditingController();

  //VehicleDetails _vehicleDetails = VehicleDetails();

  List carDetails = [];
  List cars = [];
  List<CarsType> carsTypeList = [];

  List<Fromtovia> fromToViaList = [];

  List<List<dynamic>> logc = [];

  String selectedVehicleSymbol = 'S';
  double fareMultiplier = 1;
  double fareadd = 0;

  int suitCase = 0;
  int passengers = 0;
  String rideDate = 'Select Date';
  String rideTime = 'Select time';
  double theRideTime;
  String flightNo = "";
  String theComment = "";
  String alertTime = 'Value Missing!';
  String alertTimeMsg = 'Please Select Time!';
  String alertBookedT = "Booking!";
  String alertBookingMsg = "Booking Done!\nContinue to Booking Screen.";
  String myAlertTitle;
  String myAlertText;
  int count = 0;
  double jobmileage;
  String time;
  String selectedVehicle;
  bool cardFlag = false;

  settingModelBottomSheet(context, distance, time) async {
    final mapState = Provider.of<MapState>(context, listen: false);
    final viasState = Provider.of<ViasState>(context, listen: false);

    StripeService.init();
    //carDetails = await _vehicleDetails.getVehicleDetails(3);
    //cars = carDetails[0]['carstype'];

    fillCarsListFromFetchedData();

    showModalBottomSheet(
        enableDrag: true,
        isScrollControlled: true,
        isDismissible: true,
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setmyState) {
            return Container(
              margin: EdgeInsets.fromLTRB(0, 0, 0, 7),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(12.0)),
                color: Colors.white,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Wrap(
                    children: [
                      Card(
                          elevation: 0.0,
                          child: Center(
                            child: Wrap(
                              children: [
                                // Text('Driver will be available in 10 minutes'),
                                Text('Date: $rideDate , Time  $rideTime')
                              ],
                            ),
                          )),
                      Card(
                        color: Colors.grey[300],
                        child: Row(
                          children: [
                            Icon(Icons.monetization_on_outlined,
                                size: 30, color: util.primaryColor),
                            Text(
                                '${getJobMileage(distance) * 2 * fareMultiplier + fareadd}',
                                style: TextStyle(color: Colors.black)),
                            Icon(Icons.alt_route,
                                size: 30, color: util.primaryColor),
                            Text('${getJobMileage(distance)} miles',
                                style: TextStyle(color: Colors.black)),
                            Spacer(),
                            Icon(
                              Icons.access_time_rounded,
                              size: 30,
                              color: util.primaryColor,
                            ),
                            Text('${getConvertedTime(time)}', //
                                style: TextStyle(color: Colors.black)),
                            Spacer(),
                            //Icon(Icons.clean_hands_outlined,size: 40),

                            DropDown(
                              items: [
                                'Cash',
                                // 'Card',
                              ],
                              hint: Text('Cash',
                                  style: TextStyle(color: Colors.black)),
                              onChanged: (value) {
                                print('ChangedValue: $value');
                                setmyState(() {
                                  value == 'Card'
                                      ? cardFlag = true
                                      : cardFlag = false;
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              margin: const EdgeInsets.all(5.0),
                              padding: const EdgeInsets.all(3.0),
                              decoration: BoxDecoration(color: Colors.white),
                              //Color(0xFFEBEBEB)
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Row(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 5.0),
                                        child: RotatedBox(
                                          quarterTurns: -1,
                                          child: Text(
                                            '${carsTypeList[count].carName}',
                                            style: TextStyle(
                                                fontSize: 9,
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ),
                                      Image.asset(
                                        '${carsTypeList[count].imagePath}',
                                        width: 57,
                                        //=================================================================
                                        height: 37,
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    width: 17,
                                  ),
                                  //Spacer(),
                                  Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Column(
                                      children: [
                                        Text(
                                            '${carsTypeList[count].passengers}',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold)),
                                        Text(
                                          'Passengers',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        )
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Column(
                                      children: [
                                        Text('${carsTypeList[count].suitcases}',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold)),
                                        Text('Suitcases',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold))
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              color: Color(0xFFEBEBEB),
                              height: 77,
                              width: 357,
                              child: PageView(
                                controller: PageController(
                                    initialPage: 0, viewportFraction: 0.37),
                                onPageChanged: (int a) {
                                  print("I am at $a");
                                  setmyState(() {
                                    //_selectedCar = a;
                                    count = a;
                                    selectedCarSymbol(a);
                                    print(
                                        'SelectedSymbol: $selectedVehicleSymbol');
                                  });
                                },
                                children: [
                                  Transform.scale(
                                      scale: count == 0 ? 0.795 : 0.5, //
                                      child: Card(
                                        elevation: 6,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(20)),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Visibility(
                                              visible:
                                                  count == 0 ? true : false,
                                              child: SizedBox(
                                                width: 37,
                                                child: VerticalDivider(
                                                  thickness: 4,
                                                  color: applicationColor(),
                                                  indent: 9,
                                                  endIndent: 9,
                                                ),
                                              ),
                                            ),
                                            carReusableWidget(0)
                                          ],
                                        ),
                                      )),
                                  Transform.scale(
                                      scale: count == 1 ? 0.795 : 0.5, //
                                      child: Card(
                                        elevation: 6,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(20)),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Visibility(
                                              visible:
                                                  count == 1 ? true : false,
                                              child: SizedBox(
                                                width: 37,
                                                child: VerticalDivider(
                                                  thickness: 3,
                                                  color: applicationColor(),
                                                  indent: 9,
                                                  endIndent: 9,
                                                ),
                                              ),
                                            ),
                                            carReusableWidget(1)
                                          ],
                                        ),
                                      )),
                                  Transform.scale(
                                      scale: count == 2 ? 0.795 : 0.5, //
                                      child: Card(
                                        elevation: 6,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(17)),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Visibility(
                                              visible:
                                                  count == 2 ? true : false,
                                              child: SizedBox(
                                                width: 37,
                                                child: VerticalDivider(
                                                  thickness: 3,
                                                  color: applicationColor(),
                                                  indent: 9,
                                                  endIndent: 9,
                                                ),
                                              ),
                                            ),
                                            carReusableWidget(2)
                                          ],
                                        ),
                                      )),
                                  Transform.scale(
                                      scale: count == 3 ? 0.795 : 0.5, //
                                      child: Card(
                                        elevation: 6,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(20)),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Visibility(
                                              visible:
                                                  count == 3 ? true : false,
                                              child: SizedBox(
                                                width: 37,
                                                child: VerticalDivider(
                                                  thickness: 3,
                                                  color: applicationColor(),
                                                  indent: 9,
                                                  endIndent: 9,
                                                ),
                                              ),
                                            ),
                                            carReusableWidget(3)
                                          ],
                                        ),
                                      )),
                                  Transform.scale(
                                      scale: count == 4 ? 0.795 : 0.5,
                                      // myx edited
                                      child: Card(
                                        elevation: 7,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(17)),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Visibility(
                                              visible:
                                                  count == 4 ? true : false,
                                              child: SizedBox(
                                                width: 37,
                                                child: VerticalDivider(
                                                  thickness: 3,
                                                  color: applicationColor(),
                                                  indent: 9,
                                                  endIndent: 9,
                                                ),
                                              ),
                                            ),
                                            carReusableWidget(4)
                                          ],
                                        ),
                                      )),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                      Card(
                          elevation: 0.0,
                          //margin: ,
                          color: Colors.grey[400],
                          semanticContainer: true,
                          child: Wrap(
                            crossAxisAlignment: WrapCrossAlignment.center,
                            clipBehavior: Clip.hardEdge,
                            children: [
                              IconButton(
                                  icon: Icon(Icons.access_time_sharp),
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
                                      setmyState(() {
                                        DateFormat dateFormat =
                                            DateFormat('dd-MM-yyyy');
                                        DateFormat timeFormat =
                                            DateFormat('hh:mm');
                                        rideDate =
                                            '${dateFormat.format(value)}'; //'${value.day}-${value.month}-${value.year}';
                                        //  theRideTime= DateTime.utc(value.year, value.day, value.hour, value.minute, value.second);
                                        theRideTime = value
                                                .millisecondsSinceEpoch
                                                .toDouble() /
                                            1000;
                                        rideTime =
                                            '${timeFormat.format(value)}';

                                        // rideDate =
                                        //     '${value.day}-${value.month}-${value.year}';
                                        // rideTime =
                                        //     '${value.hour}:${value.minute}'; // :${value.second}
                                      });
                                    });
                                  }),
                              FlatButton(
                                  minWidth:
                                      MediaQuery.of(context).size.width - 120,
                                  height: 30,
                                  color: util.primaryColor,
                                  child: Text(
                                      '${cardFlag == true ? 'Confirm Booking with Card' : 'Confirm Booking'}',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w700,
                                      )),
                                  onPressed: () async {
                                    if (rideDate != 'Select Date' &&
                                        rideTime != 'Select time') {
                                      myAlertTitle = alertBookedT;
                                      myAlertText = alertBookingMsg;
                                      print("clickedhere");
                                      if (cardFlag == true) {
                                        var response =
                                            await StripeService.payWithCard(
                                                amount:
                                                    '${getJobMileage(distance) * 2 * fareMultiplier + fareadd}',
                                                currency: 'USD');

                                        if (response.success == true) {
                                          Navigator.pop(context);
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(SnackBar(
                                            content: Text(response.message),
                                            duration: new Duration(
                                                milliseconds: 1200),
                                          ));

                                          fillFromToViaList(
                                              viasState, mapState);
                                          fillLogcList();
                                          fillBookingModelAndInsert(
                                              mapState, viasState, distance);
                                          Navigator.pop(context);
                                        } else if (response.success == false) {
                                          Toast.show(
                                              'Booking with Card Failed, Try Again',
                                              context,
                                              duration: Toast.LENGTH_LONG);
                                        }
                                      } else if (cardFlag == false) {
                                        print("clickedhere");
                                        fillFromToViaList(viasState, mapState);
                                        fillLogcList();
                                        fillBookingModelAndInsert(
                                            mapState, viasState, distance);

                                        rideDate = 'Select Date';
                                        rideTime = 'Select time';
                                        // mapState.stackElementsVisibility = true;
                                        mapState.visibility();
                                        mapState.viasVisiBility_chng();
                                        showAlertDialog(
                                            context, mapState, viasState);
                                        //Navigator.pop(context);

                                      }
                                    } else {
                                      myAlertTitle = alertTime;
                                      myAlertText = alertTimeMsg;
                                      showAlertDialog(
                                          context, mapState, viasState);
                                    }
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
        }).whenComplete(() {
      //bottomsheet hide karne k baad k actions
      mapState.destinationController.clear();
      mapState.sourceController.clear();
      viasState.viasPostCodeList.clear();
      viasState.viasOutCodeList.clear();
      viasState.viasLatLongList.clear();
      viasState.viasList.clear();
      viasState.viasList.removeRange(0, viasState.viasList.length - 1);
      fromToViaList.clear();
      mapState.viasVb = false;
    });
  }

  showAlertDialog(
      BuildContext context, MapState mapState, ViasState viasStateee) {
    //MapState mpp = MapState();

    // set up the buttons
    Widget cancelButton = TextButton(
      child: Text("Cancel"),
      onPressed: () {},
    );
    Widget continueButton = TextButton(
      child: Text("Continue"),
      onPressed: () {
        if (myAlertTitle != alertBookedT) {
          Navigator.pop(context);
        } else {
          mapState.destinationController.clear();
          mapState.sourceController.clear();
          viasStateee.viasPostCodeList.clear();
          viasStateee.viasOutCodeList.clear();
          viasStateee.viasLatLongList.clear();
          viasStateee.viasList.clear();
          fromToViaList.clear();
          mapState.viasVb = false;
          Navigator.pushReplacementNamed(context, '/bookinghistory');
        }
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(myAlertTitle),
      content: Text(myAlertText),
      actions: [
        // cancelButton,
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return WillPopScope(child: alert, onWillPop: () {});
      },
    );
  }

  fillBookingModelAndInsert(
      MapState mapState, ViasState viasState, dynamic distance) {
    BookingModel bookingModel = BookingModel(
        from: mapState.sourceController.text.toString(),
        from_info: "",
        from_outcode: mapState.outcode1,
        fromtovia: fromToViaList,
        logc: logc,
        office: util.office,
        telephone: MapState.userPhone,
        userid: 'manager@cyp.sc',
        //"tayyab.slash@gmail.com",
        custname: MapState.userName,
        time: rideTime,
        date: rideDate,
        to: mapState.destinationController.text.toString(),
        toInfo: "",
        to_outcode: mapState.outcode2,
        fare: getJobMileage(distance) * 2 * fareMultiplier + fareadd,
        drvfare: getJobMileage(distance) * 2 * fareMultiplier + fareadd,
        jobmileage: getJobMileage(distance),
        jobref: "",
        mstate: "",
        timetodespatch: theRideTime,
        datentime: DateTime.now().millisecondsSinceEpoch.toDouble() / 1000,
        changed: false,
        account: cardFlag == true ? 'CARD' : 'CASH',
        accuser: "",
        bookedby: util.bookedBy,
        comment: theComment,
        creditcard: MapState.userEmail,
        cstate: "booked",
        despatchtime: 0.0,
        driverrate: "CASH",
        drvrcallsign: "",
        drvreqdname: "",
        drvrname: "",
        drvrreqcallsign: "",
        dstate: "",
        flag: 0,
        flightno: flightNo,
        hold: false,
        isdirty: false,
        jobtype: "normal",
        jstate: "unallocated",
        leadtime: 600,
        logd: null,
        numofvia: viasState.viasList.length,
        oldfare: 0.0,
        olddrvfare: 0.0,
        orderno: "",
        tag: "1",
        vehicletype: selectedVehicleSymbol,
        pin: "",
        callerid: "");

    InsertBooking.insertBooking(bookingModel);
    print(bookingModel.toString());
    print('------------------------------------');
    print(bookingModel.toJson());

  }

  selectedCarSymbol(int value) {
    if (carsTypeList[value].carName == 'Saloon') {
      selectedVehicleSymbol = 'S';
      //fare = (2 * fareMultiplier);
      fareMultiplier = 1;
      fareadd = 0;
    } else if (carsTypeList[value].carName == 'Estate') {
      selectedVehicleSymbol = 'E';
      fareMultiplier = 1;
      fareadd = 5;
    } else if (carsTypeList[value].carName == 'MPV') {
      selectedVehicleSymbol = '6';
      fareMultiplier = 1.5;
      fareadd = 0;
    } else if (carsTypeList[value].carName == 'Executive') {
      selectedVehicleSymbol = 'X';
      fareMultiplier = 1.5;
      fareadd = 0;
    } else if (carsTypeList[value].carName == '8 Passenger') {
      selectedVehicleSymbol = '8';
      fareMultiplier = 2;
      fareadd = 0;
    }
  }

  //---> To display carstype list on bottom sheet,
  fillCarsListFromFetchedData() {
    print('cfghere ${BaseClass.cfgCustAppModel.carstype.length}');
    CarsType carsType;
    for (int i = 0; i < BaseClass.cfgCustAppModel.carstype.length; i++) {
      if (i == 0) {
        carsType = new CarsType(
          BaseClass.cfgCustAppModel.carstype[0].carname,
          "assets/carsimages/saloonimage.png",
          BaseClass.cfgCustAppModel.carstype[0].carcapacity,
          BaseClass.cfgCustAppModel.carstype[0].lugagecapacity,
        );
      } else if (i == 1) {
        carsType = new CarsType(
            BaseClass.cfgCustAppModel.carstype[1].carname,
            "assets/carsimages/estateimage.png",
            BaseClass.cfgCustAppModel.carstype[1].carcapacity,
            BaseClass.cfgCustAppModel.carstype[1].lugagecapacity);
      } else if (i == 2) {
        carsType = new CarsType(
          BaseClass.cfgCustAppModel.carstype[2].carname,
          "assets/carsimages/mpvimage.png",
          BaseClass.cfgCustAppModel.carstype[2].carcapacity,
          BaseClass.cfgCustAppModel.carstype[2].lugagecapacity,
        );
      } else if (i == 3) {
        carsType = new CarsType(
          BaseClass.cfgCustAppModel.carstype[3].carname,
          "assets/carsimages/saloonimage.png",
          BaseClass.cfgCustAppModel.carstype[3].carcapacity,
          BaseClass.cfgCustAppModel.carstype[3].lugagecapacity,
        );
      } else if (i == 4) {
        carsType = new CarsType(
          BaseClass.cfgCustAppModel.carstype[4].carname,
          "assets/carsimages/eightpassenger.png",
          BaseClass.cfgCustAppModel.carstype[4].carcapacity,
          BaseClass.cfgCustAppModel.carstype[4].lugagecapacity,
        );
      }
      carsTypeList.add(carsType);
    }
    print("CARTYPELIST: $carsTypeList");
  }

  Widget carReusableWidget(int calledFunction) {
    return Column(
      children: [
        Image.asset(
          '${carsTypeList[calledFunction].imagePath}',
          width: 70,
          height: 50,
        ),
        Text(
          '${carsTypeList[calledFunction].carName}',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        // Text('${carsTypeList[calledFunction].passengers} Passengers '),
        // Text('${carsTypeList[calledFunction].suitcases} Suitcases '),
      ],
    );
  }

  //---> Preparing jobmileage Value
  double getJobMileage(dynamic distance) {
    try {
      jobmileage = double.tryParse(distance.toString());
      jobmileage = shortDoubleToApprox(jobmileage, 2);
      print('jobmileage: $jobmileage');
      return jobmileage;
    } catch (e) {
      print('Exception Caught On JobMileage: $e');
    }
    return null;
  }

  //---> Preparing time Value casting to double for display on UI
  String getConvertedTime(dynamic time) {
    try {
      double t;
      String value = time.toString();
      var splitvalue = value.split(" ");
      //print('timevalue: $splitvalue');
      t = double.tryParse(splitvalue[0].toString());
      t = shortDoubleToApprox(t, 2);
      //print('time: ${t}');
      return '$t ${splitvalue[1].toString()}';
    } catch (e) {
      print('Exception Caught on Converting Time: $e');
    }
    return null;
  }

  //----> for Rounding long double values to approx, using it for distance and time in above
  double shortDoubleToApprox(double val, int places) {
    try {
      double mod = pow(10.0, places);
      print('${((val * mod).round().toDouble() / mod)}');
      return ((val * mod).round().toDouble() / mod);
    } catch (e) {
      print('exception caught on method: $e');
      return null;
    }
  }



  fillLogcList() {
    List<dynamic> listofLogc = [];
    listofLogc.add(DateTime.now().millisecondsSinceEpoch.toDouble() / 1000);
    listofLogc.add("booked");
    //listofLogc.add("tayyab.slash@gmail.com");
    listofLogc.add(util.appTitle);

    //print("logc ${logc.length}");

    listofLogc.add("logc: ${logc.length}");
    logc.add(listofLogc);
  }

  //---->To check if( viaList is empty then put source/dest and put empty 7 data)
  // otherwise complete added vias in FromToVia
  fillFromToViaList(ViasState viasState, MapState mapState) {
    print('fromtovia: $fromToViaList');
    print('viasState.viasList: ${viasState.viasList}');

    Fromtovia fromtovia1 = Fromtovia(
        info: null,
        address: mapState.sourceController.text,
        lat: mapState.l1.latitude,
        lon: mapState.l1.longitude,
        postcode: mapState.postcode1);

    Fromtovia fromtovia2 = Fromtovia(
        info: null,
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
      rideDate =
          '${dateFormat.format(value)}'; //'${value.day}-${value.month}-${value.year}';
      rideTime =
          '${timeFormat.format(value)}'; //'${value.hour}:${value.minute}'; '${timeFormat.format(value)}';
      notifyListeners();
      // theRideTime= DateTime.utc(value.year, value.day, value.hour, value.minute, value.second);
    });
  }

//---->Additional Information Dialog.
  dialogShow(context) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () {},
          child: AlertDialog(
            scrollable: true,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0)),
            insetPadding: EdgeInsets.all(10.0),
            titlePadding: EdgeInsets.all(0.0),
            titleTextStyle: TextStyle(
                color: Colors.white, fontSize: 20, fontWeight: FontWeight.w600),
            title: Container(
              width: MediaQuery.of(context).size.width - 40,
              padding: EdgeInsets.only(left: 10, bottom: 20, top: 10),
              child: Text(' Additional Information '),
              decoration: BoxDecoration(
                color: util.primaryColor,
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
                        activeBgColor: util.primaryColor,
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
                      color: util.primaryColor,
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
                      color: util.primaryColor,
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
                  color: util.primaryColor,
                  onPressed: () {
                    flightNo = _flightController.text.toString();
                    // _flightController = new TextEditingController(
                    //     text: _flightController.text.toString());
                    // _commenttController = TextEditingController(
                    //     text: _commenttController.text.toString());
                    theComment = _commenttController.text.toString();
                    Navigator.pop(context);
                  },
                  child: Text('DONE')),
              FlatButton(
                  color: util.primaryColor,
                  onPressed: () {
                    _initialLabel = 1;
                    Navigator.pop(context);
                  },
                  child: Text('CANCEL'))
            ],
          ),
        );
      },
    );
  }

  //----> Default Application Color
  Color applicationColor() {
    return Color(0xFF8E24AA);
  }
}
