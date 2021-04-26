import 'package:flutter/material.dart';
import 'package:zippy_rider/models/BookingModel.dart';
import 'package:zippy_rider/models/cars_type_model.dart';

class EditBookingState with ChangeNotifier{

  bool displayCars = true;
  bool changeIcon = true;


  int selectedCar(BookingModel selectedBookingModel) {
    int value;
    if (selectedBookingModel.vehicletype == 'S')
      value = 0;
    else if (selectedBookingModel.vehicletype == 'E')
      value = 1;
    else if (selectedBookingModel.vehicletype == '6')
      value = 2;
    else if (selectedBookingModel.vehicletype == 'X')
      value = 3;
    else if (selectedBookingModel.vehicletype == '8')
      value = 4;

    return value;
  }

  Color applicationColor() {
    return Color(0xFF8E24AA);
  }

  //To display all available cars on down button click and hide while up button click
  setCarsTypeVisibility(){
    displayCars == true
        ? displayCars = false
        : displayCars = true;
    changeIcon == true
        ? changeIcon = false
        : changeIcon = true;
    notifyListeners();
  }

  List<CarsType> carsTypeList = [
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
}