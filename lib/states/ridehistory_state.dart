import 'package:flutter/material.dart';
import 'package:zippy_rider/models/BookingModel.dart';
import 'package:zippy_rider/requests/bookinghistory_request.dart';

class PaymentType {
  String name;
  Image image;

  PaymentType(this.name, this.image);
}

class RideHistoryState extends ChangeNotifier {

  List<BookingModel> bookingList = [];
  List<BookingModel> bookedBookingHistoryList = [];
  List<BookingModel> cancelledBookingHistoryList= [];
  List<BookingModel> completedBookingHistoryList= [];
  PaymentType selectedPaymentType = paymentTypeList[0];

  static List<PaymentType> paymentTypeList = [
    PaymentType(
        'Cash',
        Image.asset(
          "assets/images/cash.png",
          width: 40,
          height: 30,
        )),
    PaymentType(
        'Card',
        Image.asset(
          "assets/images/creditcard.png",
          width: 40,
          height: 40,
        )),
  ];

  PaymentType returnPaymentType(){
    return selectedPaymentType;
  }

  changedValue(PaymentType newvalue) {
    selectedPaymentType = newvalue;
    notifyListeners();
  }

  Future<List<BookingModel>> getbookedHistory() async {
    bookingList = await BookingHistoryRequest.getBookingHistory();
    //print("this is bookingList: $bookingList");

    if (bookingList.length == 0) {
      print('got here');
      return [];
      //return null;
    } else {
      bookingList.forEach((bookingmodel) {

        if ((bookingmodel.cstate == "booked") &&
            !(bookingmodel.jstate == "JobDone") ||
            (bookingmodel.cstate == "despatched") &&
                !(bookingmodel.jstate == "JobDone") ||
            (bookingmodel.cstate == "reverted") &&
                !(bookingmodel.jstate == "JobDone") ||
            (bookingmodel.cstate == "Redespatched") &&
                !(bookingmodel.jstate == "JobDone")) {
          bookedBookingHistoryList.add(bookingmodel);

        }
      });
      if(bookedBookingHistoryList.length == 0){
        return null;
      }
      return bookedBookingHistoryList;
    }

  }

  Future<List<BookingModel>> getcompletedHistory() async {
    bookingList = await BookingHistoryRequest.getBookingHistory();

    if (bookingList.length == 0) {
      return null;
    } else {
      bookingList.forEach((bookingmodel) {
        if (bookingmodel.jstate == "JobDone") {
          completedBookingHistoryList.add(bookingmodel);
        }
      });
      if(completedBookingHistoryList.length == 0){
        return null;
      }
      return completedBookingHistoryList;
    }

  }

  Future<List<BookingModel>> getcancelledHistory() async {
    bookingList = await BookingHistoryRequest.getBookingHistory();

    if (bookingList.length == 0) {
      return null;
    } else {
      bookingList.forEach((bookingmodel) {
        if (bookingmodel.cstate == "cancelled") {
          cancelledBookingHistoryList.add(bookingmodel);
        }
      });
      if(cancelledBookingHistoryList.length == 0){
        return null;
      }
      return cancelledBookingHistoryList;
    }
  }
}
