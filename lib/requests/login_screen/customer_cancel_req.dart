import 'dart:convert';

import 'package:retrofit/dio.dart';
import 'package:zippy_rider/models/CustomerModel.dart';

import 'package:dio/dio.dart';
import 'package:zippy_rider/retrofitConfig/RetrofitConfig.dart';

class CustomerCancelReq {
  static Future<Map<String, dynamic>> CancelRequest(
      String jobid, String reason) async {
    final dio = Dio(); // Provide a dio instance

    dio.options.headers['content-Type'] = 'application/json';
    final client = RetrofitConfig(dio);

    try {
      final response = await client.CancelBooking(jobid, reason);
      print(
          "------------------------------------------------------------------------");
      print("this is response: $response");

      final Map<String, dynamic> map = json.decode(response);
      print('JsonResponse: $map');

      return map;
    } catch (E) {
      print("Exception is caught: $E");
    }
    return null;
  }
}
