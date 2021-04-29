import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:toast/toast.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:zippy_rider/models/BookingModel.dart';
import 'package:zippy_rider/models/cars_type_model.dart';
import 'package:zippy_rider/states/edit_booking_state.dart';
import 'package:zippy_rider/states/ridehistory_state.dart';

class EditBooking extends StatefulWidget {
  @override
  _EditBookingState createState() => _EditBookingState();
}

class _EditBookingState extends State<EditBooking> {

  List<Fromtovia> fromToViaList = [];

  fillFromToViaList() {
    fromToViaList.clear();

    for (int i = 2; i < selectedBookingModel.fromtovia.length; i++) {
      if (selectedBookingModel.fromtovia[i].info != null &&
          selectedBookingModel.fromtovia[i].postcode != null &&
          selectedBookingModel.fromtovia[i].address != null) {
        setState(() {
          fromToViaList.add(selectedBookingModel.fromtovia[i]);
        });
      }
    }
  }
  int _selectedCar = 0;
  BookingModel selectedBookingModel;
  List<PaymentType> paymentTypeList = RideHistoryState.paymentTypeList;

  int _initialLabel = 1;
  TextEditingController _flightController = TextEditingController();
  TextEditingController _commenttController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      fillFromToViaList();
    });
  }


  @override
  Widget build(BuildContext context) {
    final editBookingState = Provider.of<EditBookingState>(context);
    selectedBookingModel = ModalRoute
        .of(context)
        .settings
        .arguments;
    PaymentType selectedPaymentType =
    Provider.of<RideHistoryState>(context).returnPaymentType();
    _selectedCar = editBookingState.selectedCar(selectedBookingModel);
    print('initial: $_selectedCar');


    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            child: Column(
              children: [
                Card(
                  color: Color(0xFFEBEBEB),
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          "Journey Details",
                          style: TextStyle(
                              color: editBookingState.applicationColor(),
                              fontSize: 25,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ), //end of Journey Details Text

                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                            width: 40,
                            child: Icon(
                              Icons.radio_button_off_sharp,
                              color: editBookingState.applicationColor(),
                              size: 20,
                            )),
                        Text(
                          'Your Pickup',
                          style: TextStyle(
                              color: editBookingState.applicationColor(),
                              fontWeight: FontWeight.bold,
                              fontSize: 10),
                        ),
                      ],
                    ),
                    IntrinsicHeight(
                      child: Row(
                        children: <Widget>[
                          // This is your divider

                          SizedBox(
                            width: 40,
                            child: VerticalDivider(
                                thickness: 4, color: editBookingState.applicationColor()),
                          ),

                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              SizedBox(
                                  width: 220,
                                  child: Text('${selectedBookingModel.from}')),
                              Padding(
                                padding: const EdgeInsets.only(top: 10),
                                child: Row(
                                  children: [
                                    SizedBox(
                                      width: 20,
                                      child: Icon(
                                        Icons.radio_button_checked,
                                        size: 15,
                                      ),
                                    ),
                                    Text(
                                      'Vias',
                                      style: TextStyle(
                                          color: Colors.grey, fontSize: 10),
                                    ),
                                  ],
                                ),
                              ),
                              Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  SizedBox(
                                    width: 250,
                                    height: fromToViaList.length * 50.0,
                                    child: ListView.builder(
                                        shrinkWrap: true,
                                        scrollDirection: Axis.vertical,
                                        itemBuilder: (context, index) {
                                          return ListTile(
                                            dense: true,
                                            title: Text(
                                                '${fromToViaList[index]
                                                    .address}'),
                                          );
                                        },
                                        itemCount: fromToViaList.length
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        SizedBox(
                            width: 40,
                            child:
                            Icon(Icons.circle, color: editBookingState.applicationColor())),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Your Destination',
                              style: TextStyle(
                                  color: editBookingState.applicationColor(),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 10),
                            ),
                            Text('${selectedBookingModel.to}'),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),

                Row(
                  children: [
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.fromLTRB(8.0, 5.0, 8.0, 1.0),
                        padding: const EdgeInsets.all(3.0),
                        decoration: BoxDecoration(
                            border: Border(
                                top: BorderSide(
                                    width: 2, color: editBookingState.applicationColor()),
                                bottom: BorderSide(
                                    width: 2, color: editBookingState.applicationColor())),
                            color: Color(0xFFEBEBEB)),
                        child: Text(
                          "Date And Time",
                          style: TextStyle(
                              fontSize: 25,
                              color: editBookingState.applicationColor(),
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: Container(
                        margin: const EdgeInsets.fromLTRB(15.0, 2.0, 15.0, 2.0),
                        padding: const EdgeInsets.all(5.0),
                        decoration: BoxDecoration(color: Color(0xFFEBEBEB)),
                        child: Text(
                          '${selectedBookingModel.date}',
                          style: TextStyle(
                              fontSize: 15, color: editBookingState.applicationColor()),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        margin: const EdgeInsets.fromLTRB(15.0, 2.0, 15.0, 2.0),
                        padding: const EdgeInsets.all(5.0),
                        decoration: BoxDecoration(color: Color(0xFFEBEBEB)),
                        child: Text(
                          '${selectedBookingModel.time}',
                          style: TextStyle(
                              fontSize: 15, color: editBookingState.applicationColor()),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.fromLTRB(8.0, 1.0, 8.0, 3.0),
                        padding: const EdgeInsets.all(3.0),
                        decoration: BoxDecoration(
                            border: Border(
                                top: BorderSide(
                                    width: 2, color: editBookingState.applicationColor()),
                                bottom: BorderSide(
                                    width: 2, color: editBookingState.applicationColor())),
                            color: Color(0xFFEBEBEB)),
                        child: Text(
                          "Vehicle Detail",
                          style: TextStyle(
                              fontSize: 25,
                              color: editBookingState.applicationColor(),
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        margin: const EdgeInsets.all(8.0),
                        decoration: BoxDecoration(color: Color(0xFFBDBDBD)),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Row(
                            children: [
                              Padding(
                                padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                                child: Icon(
                                  Icons.euro,
                                  color: Colors.blue.shade900,
                                  size: 30,
                                ),
                              ),
                              Text(
                                //'${selectedBookingModel.fare}',
                                '',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                              Padding(
                                padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                                child: Icon(
                                  Icons.location_pin,
                                  color: Colors.blue.shade900,
                                  size: 30,
                                ),
                              ),
                              Text(
                                //'${selectedBookingModel.jobmileage} miles',
                                '',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                              Spacer(),
                              DropdownButton<PaymentType>(
                                value: selectedPaymentType,
                                icon: Icon(Icons.arrow_drop_down),
                                dropdownColor: Color(0xFFBDBDBD),
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                                items: paymentTypeList
                                    .map((PaymentType paymentType) {
                                  return DropdownMenuItem(
                                    value: paymentType,
                                    child: Row(
                                      children: [
                                        paymentType.image,
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Text(
                                          paymentType.name,
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 20),
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                      ],
                                    ),
                                  );
                                }).toList(),
                                onChanged: (PaymentType newvalue) {
                                  Provider.of<RideHistoryState>(context,
                                      listen: false)
                                      .changedValue(newvalue);
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        margin: const EdgeInsets.all(8.0),
                        padding: const EdgeInsets.all(3.0),
                        decoration: BoxDecoration(color: Colors.white),
                        //Color(0xFFEBEBEB)
                        child: Row(
                          children: [
                            Padding(
                              padding:
                              const EdgeInsets.symmetric(horizontal: 8.0),
                              child: RotatedBox(
                                quarterTurns: -1,
                                child: Text(
                                  '${editBookingState.carsTypeList[_selectedCar].carName}',
                                  style: TextStyle(
                                      fontSize: 10,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                            Image.asset(
                              '${editBookingState.carsTypeList[_selectedCar].imagePath}',
                              width: 90,
                              height: 70,
                            ),
                            Spacer(),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: [
                                  Text(
                                      '${editBookingState.carsTypeList[_selectedCar]
                                          .passengers}'),
                                  Text('Passengers')
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: [
                                  Text(
                                      '${editBookingState.carsTypeList[_selectedCar]
                                          .suitcases}'),
                                  Text('Suitcases')
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 8),
                              child: IconButton(
                                icon: Icon(
                                    editBookingState.changeIcon == true
                                        ? Icons.arrow_drop_down
                                        : Icons.arrow_drop_up,
                                    size: 30),
                                onPressed: () {
                                  editBookingState.setCarsTypeVisibility();
                                },
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                Visibility(
                  visible: editBookingState.displayCars,
                  child: Row(
                    children: [
                      Container(
                        color: Color(0xFFEBEBEB),
                        height: 120,
                        width: 400,
                        child: PageView(
                          controller:PageController(
                              initialPage: _selectedCar,
                              viewportFraction: 0.4),
                          onPageChanged: (int a) {
                            print("I am at $a");
                            setState(() {
                              _selectedCar = a;
                            });
                          },
                          children: [
                            Transform.scale(
                                scale: _selectedCar == 0 ? 1 : 0.9, //
                                child: Card(
                                  elevation: 6,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20)),
                                  child: Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Visibility(
                                        visible:
                                        _selectedCar == 0 ? true : false,
                                        child: SizedBox(
                                          width: 40,
                                          child: VerticalDivider(
                                            thickness: 4,
                                            color: editBookingState.applicationColor(),
                                            indent: 10,
                                            endIndent: 10,
                                          ),
                                        ),
                                      ),
                                      selectedCarCard(0,editBookingState)
                                    ],
                                  ),
                                )),
                            Transform.scale(
                                scale: _selectedCar == 1 ? 1 : 0.9, //
                                child: Card(
                                  elevation: 6,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20)),
                                  child: Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Visibility(
                                        visible:
                                        _selectedCar == 1 ? true : false,
                                        child: SizedBox(
                                          width: 40,
                                          child: VerticalDivider(
                                            thickness: 4,
                                            color: editBookingState.applicationColor(),
                                            indent: 10,
                                            endIndent: 10,
                                          ),
                                        ),
                                      ),
                                      selectedCarCard(1,editBookingState)
                                    ],
                                  ),
                                )),
                            Transform.scale(
                                scale: _selectedCar == 2 ? 1 : 0.9, //
                                child: Card(
                                  elevation: 6,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20)),
                                  child: Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Visibility(
                                        visible:
                                        _selectedCar == 2 ? true : false,
                                        child: SizedBox(
                                          width: 40,
                                          child: VerticalDivider(
                                            thickness: 4,
                                            color: editBookingState.applicationColor(),
                                            indent: 10,
                                            endIndent: 10,
                                          ),
                                        ),
                                      ),
                                      selectedCarCard(2,editBookingState)
                                    ],
                                  ),
                                )),
                            Transform.scale(
                                scale: _selectedCar == 3 ? 1 : 0.9, //
                                child: Card(
                                  elevation: 6,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20)),
                                  child: Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Visibility(
                                        visible:
                                        _selectedCar == 3 ? true : false,
                                        child: SizedBox(
                                          width: 40,
                                          child: VerticalDivider(
                                            thickness: 4,
                                            color: editBookingState.applicationColor(),
                                            indent: 10,
                                            endIndent: 10,
                                          ),
                                        ),
                                      ),
                                      selectedCarCard(3,editBookingState)
                                    ],
                                  ),
                                )),
                            Transform.scale(
                                scale: _selectedCar == 4 ? 1 : 0.9, //
                                child: Card(
                                  elevation: 6,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20)),
                                  child: Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Visibility(
                                        visible:
                                        _selectedCar == 4 ? true : false,
                                        child: SizedBox(
                                          width: 40,
                                          child: VerticalDivider(
                                            thickness: 4,
                                            color: editBookingState.applicationColor(),
                                            indent: 10,
                                            endIndent: 10,
                                          ),
                                        ),
                                      ),
                                      selectedCarCard(4,editBookingState)
                                    ],
                                  ),
                                )),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        margin: const EdgeInsets.all(8.0),
                        padding: const EdgeInsets.all(3.0),
                        decoration: BoxDecoration(
                            border: Border(
                                top: BorderSide(
                                    width: 2, color: editBookingState.applicationColor()),
                                bottom: BorderSide(
                                    width: 2, color: editBookingState.applicationColor())),
                            color: Color(0xFFEBEBEB)),
                        child: Row(
                          children: [
                            Text(
                              "Additional Information",
                              style: TextStyle(
                                  fontSize: 25,
                                  color: editBookingState.applicationColor(),
                                  fontWeight: FontWeight.bold),
                            ),
                            Spacer(),
                            IconButton(
                              icon: Icon(Icons.arrow_right, size: 40),
                              onPressed: (){
                                dialogShow(context);
                              }
                            )
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
                        margin: const EdgeInsets.all(8.0),
                        padding: const EdgeInsets.all(3.0),
                        decoration: BoxDecoration(
                            border: Border(
                                top: BorderSide(
                                    width: 2, color: editBookingState.applicationColor()),
                                bottom: BorderSide(
                                    width: 2, color: editBookingState.applicationColor())),
                            color: Color(0xFFEBEBEB)),
                        child: Text(
                          "Payment",
                          style: TextStyle(
                              fontSize: 25,
                              color: editBookingState.applicationColor(),
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text(
                          "Cash",
                          style: TextStyle(
                            fontSize: 25,
                            color: editBookingState.applicationColor(),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                Row(
                  children: [
                    Expanded(
                        child: ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor:
                            MaterialStateProperty.all<Color>(Colors.black),
                          ),
                          child: Text(
                            'Update',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        )),
                  ],
                )
              ],
            ), // this is the last column
          ),
        ),
      ),
    );
  }


//---->Repeated CarWidget Function.
  Widget selectedCarCard(int calledFunction, EditBookingState editBookingState) {
    return Column(
      children: [
        Image.asset(
          '${editBookingState.carsTypeList[calledFunction].imagePath}',
          width: 90,
          height: 50,
        ),
        Text(
          '${editBookingState.carsTypeList[calledFunction].carName}',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        Text('${editBookingState.carsTypeList[calledFunction].passengers} Passengers '),
        Text('${editBookingState.carsTypeList[calledFunction].suitcases} Suitcases '),
      ],
    );
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
