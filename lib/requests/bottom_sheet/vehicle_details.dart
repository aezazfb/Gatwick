import 'dart:convert';

import 'package:http/http.dart' as http;

class VehicleDetails {
  Future getVehicleDetails(int recordcount) async {
    Map<String, String> cars = Map();
    List mapResponse;
    var url =
        'http://testing.thedivor.com/api/Generic/GetALL?table=CfgCustApp&&count=$recordcount';
    // 'http://testing.thedivor.com/api/Generic/GetALL?table=CfgCustApp&&count=1';
    //  http://testing.thedivor.com/api/Generic/GetALL?table=CfgCustApp&&count=1 ---> Working API
    http.Response response;
    response = await http.get(url);
    mapResponse = json.decode(response.body);

    //cars['careType'] = 'care';
    for (int i = 0; i < recordcount - 1; i++) {
      print(mapResponse[i]['carstype'][i]);
      cars[mapResponse[i]['carstype'][i]['carname']] =
          '${cars[mapResponse[i]['carstype'][i]['carcapacity']]}';
    }

    cars.forEach((key, value) => print('$key : $value'));
    return mapResponse;
  }
}
