import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:zippy_rider/models/BookingModel.dart';
import 'package:zippy_rider/models/cars_type_model.dart';
import 'package:zippy_rider/states/ridehistory_state.dart';

class EditBooking extends StatefulWidget {
  @override
  _EditBookingState createState() => _EditBookingState();
}

class _EditBookingState extends State<EditBooking> {

  List<String> tempList = List<String>.generate(100, (index) => "Item $index");

  static List<CarsType> carsTypeList = [
    CarsType(
      'Saloon',
      "assets/carsimages/saloonimage.png",
      4,
      2,
    ),
    CarsType(
      'Estate',
      "assets/carsimages/estateimage.png",
      4,
      3,
    ),
    CarsType(
      'MPV',
      "assets/carsimages/mpvimage.png",
      6,
      3,
    ),
    CarsType(
      'Executive',
      "assets/carsimages/saloonimage.png",
      4,
      2,
    ),
    CarsType(
      '8 Passenger',
      "assets/carsimages/eightpassenger.png",
      8,
      4,
    ),
  ];


  int selectedCar() {
    if (selectedBookingModel.vehicletype == 'S')
      return 0;
    else if (selectedBookingModel.vehicletype == 'E')
      return 1;
    else if (selectedBookingModel.vehicletype == '6')
      return 2;
    else if (selectedBookingModel.vehicletype == 'X')
      return 3;
    else if (selectedBookingModel.vehicletype == '8')
      return 4;
    return -1;
  }


  CarsType selectedCarsType = carsTypeList[0];
  bool display_cars = true;
  bool change_icon = true;
  int _selectedCar=0;
  BookingModel selectedBookingModel;

  List<PaymentType> paymentTypeList = RideHistoryState.paymentTypeList;
  @override
  Widget build(BuildContext context) {
    selectedBookingModel = ModalRoute.of(context).settings.arguments;
    PaymentType selectedPaymentType = Provider.of<RideHistoryState>(context).returnPaymentType();

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
                              color: applicationColor(),
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
                              color: applicationColor(),
                              size: 20,
                            )),
                        Text(
                          'Your Pickup',
                          style: TextStyle(
                              color: applicationColor(),
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
                                thickness: 4, color: applicationColor()),
                          ),

                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              SizedBox(
                                  width: 220,
                                  child: Text(
                                      '${selectedBookingModel.from}')),
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
                              Row(
                                children: [
                                  SizedBox(
                                    width: 280,
                                    height: 220,
                                    child: ListView.builder(
                                      scrollDirection: Axis.vertical,
                                      shrinkWrap: true,
                                      itemBuilder: (context, index) {
                                        return ListTile(
                                          title: Text('${tempList[index]}'),
                                        );
                                      },
                                      itemCount: tempList.length,
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
                                Icon(Icons.circle, color: applicationColor())),
                        Column(
                          children: [
                            Text(
                              'Your Destination',
                              style: TextStyle(
                                  color: applicationColor(),
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
                                    width: 2, color: applicationColor()),
                                bottom: BorderSide(
                                    width: 2, color: applicationColor())),
                            color: Color(0xFFEBEBEB)),
                        child: Text(
                          "Date And Time",
                          style: TextStyle(
                              fontSize: 25,
                              color: applicationColor(),
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
                              fontSize: 15, color: applicationColor()),
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
                              fontSize: 15, color: applicationColor()),
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
                                    width: 2, color: applicationColor()),
                                bottom: BorderSide(
                                    width: 2, color: applicationColor())),
                            color: Color(0xFFEBEBEB)),
                        child: Text(
                          "Vehicle Detail",
                          style: TextStyle(
                              fontSize: 25,
                              color: applicationColor(),
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
                                  Provider.of<RideHistoryState>(context,listen: false).changedValue(newvalue);
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
                                  '${carsTypeList[_selectedCar].carName}',
                                  style: TextStyle(
                                      fontSize: 10,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                            Image.asset(
                              '${carsTypeList[_selectedCar].imagePath}',
                              width: 90,
                              height: 70,
                            ),
                            Spacer(),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: [
                                  Text(
                                      '${carsTypeList[_selectedCar].passengers}'),
                                  Text('Passengers')
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: [
                                  Text(
                                      '${carsTypeList[_selectedCar].suitcases}'),
                                  Text('Suitcases')
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 8),
                              child: IconButton(
                                icon: Icon(
                                    change_icon == true
                                        ? Icons.arrow_drop_down
                                        : Icons.arrow_drop_up,
                                    size: 30),
                                onPressed: () {
                                  setState(() {
                                    display_cars == true
                                        ? display_cars = false
                                        : display_cars = true;
                                    change_icon == true
                                        ? change_icon = false
                                        : change_icon = true;
                                  });
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
                  visible: display_cars,
                  child: Row(
                    children: [
                      Container(
                        color: Color(0xFFEBEBEB),
                        height: 120,
                        width: 400,
                        child: PageView(
                          controller: PageController(
                              initialPage: selectedCar(), viewportFraction: 0.4),
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
                                            color: applicationColor(),
                                            indent: 10,
                                            endIndent: 10,
                                          ),
                                        ),
                                      ),
                                      selectedCarCard(0)
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
                                            color: applicationColor(),
                                            indent: 10,
                                            endIndent: 10,
                                          ),
                                        ),
                                      ),
                                      selectedCarCard(1)
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
                                            color: applicationColor(),
                                            indent: 10,
                                            endIndent: 10,
                                          ),
                                        ),
                                      ),
                                      selectedCarCard(2)
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
                                            color: applicationColor(),
                                            indent: 10,
                                            endIndent: 10,
                                          ),
                                        ),
                                      ),
                                      selectedCarCard(3)
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
                                            color: applicationColor(),
                                            indent: 10,
                                            endIndent: 10,
                                          ),
                                        ),
                                      ),
                                      selectedCarCard(4)
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
                                    '${carsTypeList[index].imagePath}',
                                    width: 90,
                                    height: 50,
                                  ),
                                  Text('${carsTypeList[index].carName}'),
                                  Text(
                                      '${carsTypeList[index].passengers} Passengers '),
                                  Text(
                                      '${carsTypeList[index].suitcases} Suitcases '),
                                ],
                              );
                            },
                            itemCount: carsTypeList.length,
                            viewportFraction: 0.8,
                            scale: 0.9,
                          )*/
                        /*ListView(
                          scrollDirection: Axis.vertical,
                          children: [
                            Column(
                              children: [
                                Image.asset(
                                  '${carsTypeList[0].imagePath}',width: 90,height: 50,
                                ),
                                Text('${carsTypeList[0].carName}'),
                                Text(
                                    '${carsTypeList[0].passengers} Passengers '),
                                Text('${carsTypeList[0].suitcases} Suitcases '),
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
                                    width: 2, color: applicationColor()),
                                bottom: BorderSide(
                                    width: 2, color: applicationColor())),
                            color: Color(0xFFEBEBEB)),
                        child: Row(
                          children: [
                            Text(
                              "Additional Information",
                              style: TextStyle(
                                  fontSize: 25,
                                  color: applicationColor(),
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
                                    width: 2, color: applicationColor()),
                                bottom: BorderSide(
                                    width: 2, color: applicationColor())),
                            color: Color(0xFFEBEBEB)),
                        child: Text(
                          "Payment",
                          style: TextStyle(
                              fontSize: 25,
                              color: applicationColor(),
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
                            color: applicationColor(),
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



  Widget selectedCarCard(int calledFunction) {
    return Column(
      children: [
        Image.asset(
          '${carsTypeList[calledFunction].imagePath}',
          width: 90,
          height: 50,
        ),
        Text(
          '${carsTypeList[calledFunction].carName}',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        Text('${carsTypeList[calledFunction].passengers} Passengers '),
        Text('${carsTypeList[calledFunction].suitcases} Suitcases '),
      ],
    );
  }

  Color applicationColor() {
    return Color(0xFF8E24AA);
  }
}
