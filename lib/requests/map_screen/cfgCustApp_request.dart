
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:zippy_rider/models/CfgCustAppModel.dart';
import 'package:zippy_rider/retrofitConfig/RetrofitConfig.dart';

class CfgCustAppRequest{

  static Future<CfgCustAppModel> getCgfCustApp(String office) async {
    final dio = Dio(); // Provide a dio instance

    dio.options.headers['content-Type'] = 'application/json';
    final client = RetrofitConfig(dio);

    try {
      final response = await client.getCfgCustApp(office);
      print("------------------------------------------------------------------------");
      print("this is response: ${response[0].carstype[0].carname}");

      /*final Map<String,dynamic> map = json.decode(response);
      print('JsonResponse: $map');

      return map;*/
      return response[0];
    } catch (E) {
      print("Exception is caught: $E");
    }
    return null;
  }

}