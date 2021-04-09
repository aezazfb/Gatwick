import 'dart:math';

import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:zippy_rider/models/places_info_details.dart';

class LocationDetails {
  static List<Map<String, dynamic>> params = [];
  Map<String, dynamic> point = {};
  List placesDetails = <Placedetails>[];

  static getLocationDetails(String value, bool flage, int flag) async {
    Map mapResponse;
    var url = 'http://testing.thedivor.com/Home/PlaceInfo?place=$value';
    print('Places info url\n ');
    print(url);
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
    /* if (flage == true ) { //|| params.length == 0

      params.insert(0, point);
      print('PrintHere $params');
    }*/
    if (flag == 0) {
      //|| params.length == 0
      params.insert(0, point);
      print('PrintHere0 $params');
    }
    if (flag == 1) {
      params.insert(1, point);
      print('PrintHere1 $params');
    }
    if (flag == 7) {
      print('PrintHere7 $params');
      params.add(point);
    }
    /*if (flage == true || params.length != 0) {

      params.insert(1, point);
      print('PrintHere1 $params');
    }*/
    /*if (flage == false) {
      params.add(point);
      print('PrintHere2 $params');
    }*/

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
    //print('Point $point');
    //print('R Map $map');
    return map;
  }

//----> Calculate Time and Distance
  getTimeDistance() async {
    print("P\n${jsonEncode(params)}");
    print("________\n${params.length}");
    print("Parameters\n${params.toString()}");
    List list = [];
    final req =
        await http.post('http://testing.thedivor.com/api/API/GetDistance',
            headers: {
              'Content-Type': 'application/json; charset=UTF-8',
            },
            body: jsonEncode(params));
    if (req.statusCode == 200) {
      Map a = jsonDecode(req.body);
      print('Before - Distance: ${a['distance']} \n Time: ${a['time']}');

      try {
        list.add(a['distance']);
        list.add(a['time']);
        //list.add(shortDoubleToApprox(a['time'], 2));
        /*print(
            'After - Distance: ${a['distance']} \n Time: ${shortDoubleToApprox(
                a['time'], 2)}');*/
      } catch (e) {
        print("exception caught: $e");
      }
    }
    return list;
  }
/*
  //----> for Rounding long double values to approx, using it for time in above
  dynamic shortDoubleToApprox(double val, int places){
    try{
    double mod = pow(10.0, places);
    print('${((val * mod).round().toDouble() / mod)}');
    return ((val * mod).round().toDouble() / mod);
    }catch(e){
      print('exception caught on method: $e');
      return null;
    }
  }*/
}
