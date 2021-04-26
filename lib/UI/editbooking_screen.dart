import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
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

  /*List<Widget> getViaListWidgets() {
    List<Widget> listWidget = []; //List<Widget>();

    for (int i = 0; i < fromToViaList.length; i++) {
      listWidget.add(
        ListTile(
          title: Text('${fromToViaList[i].address}'),
        ),
      );
    }
    return listWidget;
  }*/

  //CarsType selectedCarsType = carsTypeList[0];

  int _selectedCar = 0;
  BookingModel selectedBookingModel;
  List<PaymentType> paymentTypeList = RideHistoryState.paymentTypeList;

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
                                            title: Text(
                                                '${fromToViaList[index]
                                                    .address}'),
                                          );
                                        },
                                        itemCount: fromToViaList.length
                                      //tempList.length,
                                      //children: getViaListWidgets()),
                                      //fromToViaList.length * 50.0,
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
                        margin: const EdgeInsets.all(8.0),
                        padding: const EdgeInsets.all(3.0),
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
                        margin: const EdgeInsets.all(8.0),
                        padding: const EdgeInsets.all(3.0),
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
                                 /* setState(() {
                                    displayCars == true
                                        ? displayCars = false
                                        : displayCars = true;
                                    changeIcon == true
                                        ? changeIcon = false
                                        : changeIcon = true;
                                  });*/
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
                        /*Swiper(
                            itemBuilder:
                                (BuildContext buildContext, int index) {
                              return Column(
                                children: [
                                  Image.asset(
                                    '${editBookingState.carsTypeList[index].imagePath}',
                                    width: 90,
                                    height: 50,
                                  ),
                                  Text('${editBookingState.carsTypeList[index].carName}'),
                                  Text(
                                      '${editBookingState.carsTypeList[index].passengers} Passengers '),
                                  Text(
                                      '${editBookingState.carsTypeList[index].suitcases} Suitcases '),
                                ],
                              );
                            },
                            itemCount: editBookingState.carsTypeList.length,
                            viewportFraction: 0.8,
                            scale: 0.9,
                          )*/
                        /*ListView(
                          scrollDirection: Axis.vertical,
                          children: [
                            Column(
                              children: [
                                Image.asset(
                                  '${editBookingState.carsTypeList[0].imagePath}',width: 90,height: 50,
                                ),
                                Text('${editBookingState.carsTypeList[0].carName}'),
                                Text(
                                    '${editBookingState.carsTypeList[0].passengers} Passengers '),
                                Text('${editBookingState.carsTypeList[0].suitcases} Suitcases '),
                              ],
                            )
                          ],
                        ),*/
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
                            Icon(
                              Icons.arrow_right,
                              size: 40,
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

  
}
