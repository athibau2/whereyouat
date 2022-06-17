import 'package:flutter/material.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:latlng/latlng.dart';

class Event {
  Event({
    required this.eventName,
    required this.startTime,
    required this.location,
    // required this.latLng,
  });

  final String eventName;
  final DateTime startTime;
  final String location;
  // final LatLng latLng;

  Map<String, dynamic> toMap() {
    return {
      'name': eventName,
      'startTime': startTime,
      'location': location,
      // 'latLng': latLng,
    };
  }
}
