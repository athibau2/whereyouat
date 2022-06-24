import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

import 'package:whereyouat/app/home/models/places_search.dart';

class PlacesService {
  final key = 'AIzaSyA30BkN_es7g6dXeQ3wZAGv4o8UWJNaXS4';
  Future<List<PlaceSearch>> getAutoComplete(String search) async {
    var url = Uri.parse('https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$search&types=geocode&key=$key');
    var response = await http.get(url);
    var json = convert.jsonDecode(response.body);
    var jsonResult = json['predictions'] as List;
    
    return jsonResult.map((place) => PlaceSearch.fromJson(place)).toList();
  }
}