import 'dart:convert';

import 'package:http/http.dart' as http;

class VehicleDetails {
  Future getVehicleDetails(int recordcount) async {
    Map<String, String> cars = Map();
    List mapResponse;
    var url =
        'http://testing.thedivor.com/api/Generic/GetALL?table=CfgCustApp&&count=$recordcount';
    http.Response response;
    response = await http.get(url);
    mapResponse = json.decode(response.body);
    return mapResponse;
  }
}
