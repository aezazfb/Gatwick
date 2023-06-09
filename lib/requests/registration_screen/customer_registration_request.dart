
import 'package:zippy_rider/models/CustomerModel.dart';

import 'package:dio/dio.dart';
import 'package:zippy_rider/retrofitConfig/RetrofitConfig.dart';

class CustomerRegistrationRequest {

  static Future<bool> registerCustomer(CustomerModel customerModel) async {
    final dio = Dio(); // Provide a dio instance

    dio.options.headers['content-Type'] = 'application/json';
    final client = RetrofitConfig(dio);

    try {
      final response = await client.signupCustomerRegistration(customerModel);
      print("------------------------------------------------------------------------");
      print("this is response: $response");

      return response.success;
    } catch (E) {
      print("Exception is caught: $E");
    }
    return null;
  }
}