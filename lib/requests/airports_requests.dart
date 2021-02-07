import 'dart:convert';

import 'package:http/http.dart' as http;

class AirportsData {
  Future getAirportsData() async {
    List mapResponse;
    var url =
        'http://testing.thedivor.com/api/Generic/GetALL?table=Airports&&count=5';
    http.Response response;
    response = await http.get(url);
    mapResponse = json.decode(response.body);
    return mapResponse;
  }
}
