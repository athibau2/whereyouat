import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:latlng/latlng.dart';

class Event {
  Event({
    required this.name,
    required this.startTime,
    required this.location,
    // required this.latLng,
  });

  final String name;
  final DateTime startTime;
  final String location;
  // final LatLng latLng;

  factory Event.fromMap(Map<String, dynamic> data) {
    Timestamp date = data['startTime'];
    final String name = data['name'];
    final DateTime startTime = date.toDate();
    final String location = data['location'];
    return Event(
      name: name,
      startTime: startTime,
      location: location,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'startTime': startTime,
      'location': location,
      // 'latLng': latLng,
    };
  }
}
