import 'package:http/http.dart' as http;
import 'dart:convert';



class SuggestionRequest{

  List suggestionList = [];
  List suggestionCompare =[];


  //----> FETCH SUGGESTION FROM API
  getSuggestion(value) async {
    List idList =[];
    Map mapResponse;
    var url = 'http://testing.thedivor.com/Home/Indextwo?Prefix=$value';
    http.Response response;
    response = await http.get(url);
    mapResponse = json.decode(response.body);
    idList = mapResponse['list'];
    for (int i = 0; i < idList.length; i++) {
      suggestionList.add(idList[i]['address']);
    }
    //_sourceSearch(value);
    suggestionCompare = suggestionList
        .where((item) => item.toString().toLowerCase().contains('$value'))
        .toList();
    return suggestionCompare;
  }

}