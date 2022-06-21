import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:latlng/latlng.dart';

class Event {
  Event({
    required this.id,
    required this.name,
    required this.startTime,
    required this.endTime,
    required this.location,
    // required this.latLng,
  });

  final String id;
  final String name;
  final DateTime startTime;
  final DateTime endTime;
  final String location;
  // final LatLng latLng;

  factory Event.fromMap(Map<String, dynamic> data, String documentId) {
    Timestamp date = data['startTime'];
    Timestamp time = data['endTime'];
    final String name = data['name'];
    final DateTime startTime = date.toDate();
    final DateTime endTime = time.toDate();
    final String location = data['location'];
    return Event(
      id: documentId,
      name: name,
      startTime: startTime,
      endTime: endTime,
      location: location,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'startTime': startTime,
      'endTime': endTime,
      'location': location,
      // 'latLng': latLng,
    };
  }
}
