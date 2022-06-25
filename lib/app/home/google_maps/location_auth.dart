import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:open_location_picker/open_location_picker.dart';

class LocationAuth {
  LocationAuth({Key? key,});


  Future<Map<String, double>?> determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    var data = await Geolocator.getCurrentPosition();
    return {
      'latitude': data.latitude,
      'longitude': data.longitude,
    };
  }

  LatLng eventLatLng(Position event) {
    return LatLng(event.latitude, event.longitude);
  }
}
