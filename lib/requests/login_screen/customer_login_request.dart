import 'dart:convert';

import 'package:zippy_rider/models/CustomerModel.dart';

import 'package:dio/dio.dart';
import 'package:zippy_rider/retrofitConfig/RetrofitConfig.dart';

class CustomerLoginRequest {

  static Future<Map<String,dynamic>> loginCustomer(String email_or_number, String pass, String check) async {
    final dio = Dio(); // Provide a dio instance

    dio.options.headers['content-Type'] = 'application/json';
    final client = RetrofitConfig(dio);

    try {
      final response = await client.loginCustomer(email_or_number,pass,check);
      print("------------------------------------------------------------------------");
      print("this is response: $response");

      final Map<String,dynamic> map = json.decode(response);
      print('JsonResponse: $map');

      return map;
    } catch (E) {
      print("Exception is caught: $E");
    }
    return null;
  }
}