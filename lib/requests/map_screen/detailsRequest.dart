import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:zippy_rider/GooglePlaces.dart';

class LocationDetails {
  GooglePlaces googlePlaces = new GooglePlaces();

  Future<Map<String, dynamic>> getLocationDetails(String value) async {
    Map mapResponse;
    var url = 'http://testing.thedivor.com/Home/PlaceInfo?place=$value';
    http.Response response;
    response = await http.get(url);
    mapResponse = json.decode(response.body);
    Map<String, dynamic> map = mapResponse;

//_id: {Timestamp: 1582974663, Machine: 2321946, Pid: 15404, Increment: 5141045, CreationTime: /Date(1582974663000)/}, placeid: ChIJTeCZe14CdkgRBETeBppkPXc, address: London SE4 1UT, UK, postcode: SE4 1UT, outcode: SE4, lattitude: 51.4682062, longitude: -0.0261726, country: , city:
//{_id: {Timestamp: 1582898298, Machine: 2321946, Pid: 3796, Increment: 6118748, CreationTime: /Date(1582898298000)/}, placeid: , address: LONDON SE4 2EE, UK, postcode: SE4 2EE, outcode: SE4, lattitude: 51.4662693, longitude: -0.0501368, country: , city: }
    //Calculating test time and distance here using rest time and Distance API.
    final List<Map<String, dynamic>> params = [
      {
        "_id": null,
        "placeid": map['Placedetails']['placeid'],
        "address": map['Placedetails']['address'],
        "postcode": map['Placedetails']['postcode'],
        "outcode": map['Placedetails']['outcode'],
        "lattitude": map['Placedetails']['lattitude'],
        "country": map['Placedetails']['country'],
        "city": map['Placedetails']['city'],
        "longitude": map['Placedetails']['longitude'],
      },
      {
        "_id": "null",
        "placeid": "",
        "address": "LONDON SE4 2EE, UK",
        "postcode": "SE4 2EE",
        "outcode": "SE4",
        "lattitude": 51.4662693,
        "country": "",
        "city": "",
        "longitude": -0.0501368,
      },
    ];
    final req =
        await http.post('http://testing.thedivor.com/api/API/GetDistance',
            headers: {
              'Content-Type': 'application/json; charset=UTF-8',
            },
            body: jsonEncode(params));

    if (req.statusCode == 200) {
      String a = jsonDecode(req.body);
      var b = a.split(",");
      print(b[0]);
      print(b[1]);
    }

    return map;
  }
}
