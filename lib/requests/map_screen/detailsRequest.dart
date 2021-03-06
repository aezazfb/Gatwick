import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:zippy_rider/GooglePlaces.dart';

class LocationDetails {
  List<Map<String, dynamic>> params = [];
  Map<String, dynamic> point = {};
  GooglePlaces googlePlaces = new GooglePlaces();

  getLocationDetails(String value) async {
    Map mapResponse;
    var url = 'http://testing.thedivor.com/Home/PlaceInfo?place=$value';
    http.Response response;
    response = await http.get(url);
    mapResponse = json.decode(response.body);
    Map<String, dynamic> map = mapResponse;
    Map<String, dynamic> point = {
      "_id": null,
      "placeid": map['Placedetails']['placeid'],
      "address": map['Placedetails']['address'],
      "postcode": map['Placedetails']['postcode'],
      "outcode": map['Placedetails']['outcode'],
      "lattitude": map['Placedetails']['lattitude'],
      "country": map['Placedetails']['country'],
      "city": map['Placedetails']['city'],
      "longitude": map['Placedetails']['longitude'],
    };

    params.add(point);
    if (params.length > 2) {
      params.removeAt(0);
    }
    //Distance time Time Test Calculation.

    //Calculating test time and distance here using rest time and Distance API.
    //  params = [
    //
    //   // {
    //   //   "_id": null,
    //   //   "placeid": map['Placedetails']['placeid'],
    //   //   "address": map['Placedetails']['address'],
    //   //   "postcode": map['Placedetails']['postcode'],
    //   //   "outcode": map['Placedetails']['outcode'],
    //   //   "lattitude": map['Placedetails']['lattitude'],
    //   //   "country": map['Placedetails']['country'],
    //   //   "city": map['Placedetails']['city'],
    //   //   "longitude": map['Placedetails']['longitude'],
    //   // },
    //   // {
    //   //   "_id": "null",
    //   //   "placeid": "",
    //   //   "address": "LONDON SE4 2EE, UK",
    //   //   "postcode": "SE4 2EE",
    //   //   "outcode": "SE4",
    //   //   "lattitude": 51.4662693,
    //   //   "country": "",
    //   //   "city": "",
    //   //   "longitude": -0.0501368,
    //   // },
    // ];
    // final req =
    //     await http.post('http://testing.thedivor.com/api/API/GetDistance',
    //         headers: {
    //           'Content-Type': 'application/json; charset=UTF-8',
    //         },
    //         body: jsonEncode(params));
    //
    // if (req.statusCode == 200) {
    //   String a = jsonDecode(req.body);
    //   var b = a.split(",");
    //   print(b[0]);
    //   print(b[1]);
    // }

    return map;
  }

  getTimeDistance() async {
    List list = [];
    final req =
        await http.post('http://testing.thedivor.com/api/API/GetDistance',
            headers: {
              'Content-Type': 'application/json; charset=UTF-8',
            },
            body: jsonEncode(params));
    print("MMMMMMM\n n \n n \n");
    print(req.body);
    if (req.statusCode == 200) {
      String a = jsonDecode(req.body);
      print(req.body);
      // var b = a.split(",");
      // print(b[0]);
      //print(b[1]);
      // list.add(a[0]);
      // list.add(b[1]);
    }
    return list;
  }
}

