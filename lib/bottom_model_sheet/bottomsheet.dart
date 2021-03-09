import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_dropdown/flutter_dropdown.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:toast/toast.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:zippy_rider/requests/bottom_sheet/vehicle_details.dart';

class BottomModelSheet with ChangeNotifier {
  DateTime pickedDate = DateTime.now();
  int _initialLabel = 1;
  TextEditingController _flightController = TextEditingController();
  TextEditingController _commenttController = TextEditingController();

  VehicleDetails _vehicleDetails = VehicleDetails();
  List carDetails = [];
  List cars = [];

  String vechile = 'Saloon ';
  int suitCase = 0;
  int passengers = 0;
  String rideDate = 'Select Date';
  String rideTime = 'Select time';
  int count = 0;

  settingModelBottomSheet(context, distance, time) async {
    carDetails = await _vehicleDetails.getVehicleDetails(3);
    cars = carDetails[0]['carstype'];
    showModalBottomSheet(
        backgroundColor: Colors.tealAccent,
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
                            Text('10000.00 ',
                                style: TextStyle(color: Colors.black)),
                            Icon(Icons.alt_route,
                                size: 30, color: Colors.purple),
                            Text('$distance miles',
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
                                            style: TextStyle(color: Colors.black))
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
                                            '${value.day}/${value.month}/${value.year}';
                                        rideTime =
                                            '${value.hour} : ${value.minute}';
                                      });
                                    });

                                    print(carDetails);
                                    print('__________________________\n');
                                    print(cars[0]['carname']);
                                  }),
                              FlatButton(
                                  // ignore: deprecated_member_use
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
                                    print('null');
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

  //---->Date Picker
  pickDate(context) async {
    DatePicker.showDateTimePicker(context,
        minTime: DateTime.now(),
        maxTime: DateTime(1),
        currentTime: DateTime.now(),
        locale: LocaleType.en, onConfirm: (value) {
      rideDate = '${value.day}/${value.month}/${value.year}';
      rideTime = '${value.hour} : ${value.minute}';
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