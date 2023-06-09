import 'dart:convert';

import 'package:http/http.dart' as http;

class AirportsDetails {
  Future getAirportsDetails(int recordcount) async {
    List mapResponse;
    var url =
        'http://testing.thedivor.com/api/Generic/GetALL?table=Airports&&count=$recordcount';
    // 'http://testing.thedivor.com/api/Generic/GetALL?table=CfgCustApp&&count=1';
    //http://testing.thedivor.com/api/Generic/GetALL?table=CfgCustApp&&count=1 ---> Working API
    http.Response response;
    response = await http.get(url);
    mapResponse = json.decode(response.body);
    return mapResponse;
  }
}
