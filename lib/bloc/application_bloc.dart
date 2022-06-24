import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';
import 'package:whereyouat/app/home/models/places_search.dart';
import 'package:whereyouat/services/location.dart';
import 'package:whereyouat/services/places_service.dart';

class ApplicationBloc with ChangeNotifier {

  final placesService = PlacesService();
  final locationAuth = Location();

  late Position currentLocation;
  late List<PlaceSearch> searchResults;

  ApplicationBloc() {
    setCurrentLocation();
  }

  setCurrentLocation() async {
    currentLocation = await locationAuth.determinePosition();
    notifyListeners();
  }

  Future<List<PlaceSearch>> searchPlaces(String searchTerm) async {
    searchResults = await placesService.getAutoComplete(searchTerm).whenComplete(() => []);
    notifyListeners();
    return searchResults;
  }

}

