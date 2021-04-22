
import 'package:dio/dio.dart';
import 'package:zippy_rider/models/BookingModel.dart';
import 'package:zippy_rider/retrofitConfig/RetrofitConfig.dart';
import 'package:zippy_rider/states/map_state.dart';

class BookingHistoryRequest{

  static Future<List<BookingModel>> getBookingHistory() async {
    final dio = Dio(); // Provide a dio instance

    dio.options.headers['content-Type'] = 'application/json';
    final client = RetrofitConfig(dio);

    try {
      String email = "${MapState.userEmail.trim()}";
      print('PrintingEmail: $email');
      final response = await client.getBookingDetails(email);
      print("------------------------------------------------------------------------");

      //print("this is response: $response");
      return response;
    } catch (E) {
      print("Exception is caught: $E");
    }
    return null;
  }
}