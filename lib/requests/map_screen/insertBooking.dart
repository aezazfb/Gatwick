import 'package:zippy_rider/models/BookingModel.dart';
import 'package:zippy_rider/retrofitConfig/RetrofitConfig.dart';
import 'package:dio/dio.dart' hide Headers;

class InsertBooking{

  static void insertBooking(BookingModel insertBookingObject) async{
    final dio = Dio(); // Provide a dio instance

    dio.options.headers['content-Type'] = 'application/json';
    final client = RetrofitConfig(dio);

    try {

      final response = await client.insertBooking(insertBookingObject);
      print("------------------------------------------------------------------------");
      print("this is response: $response");

    } catch (E) {
      print("Exception is caught: $E");
    }
  }

}