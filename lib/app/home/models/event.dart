import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:open_location_picker/open_location_picker.dart';

class Event {
  Event({
    required this.id,
    required this.name,
    required this.startTime,
    required this.endTime,
    required this.location,
    required this.owner,
    required this.attendees,
  });

  final String id;
  final String name;
  final DateTime startTime;
  final DateTime endTime;
  final Map<String, dynamic> location;
  final String owner;
  final int attendees;

  factory Event.fromMap(Map<String, dynamic> data, String documentId) {
    Timestamp date = data['startTime'];
    Timestamp time = data['endTime'];
    final String name = data['name'];
    final DateTime startTime = date.toDate();
    final DateTime endTime = time.toDate();
    final Map<String, dynamic> location = data['location'];
    final String owner = data['owner'];
    final int attendees = data['attendees'];
    return Event(
      id: documentId,
      name: name,
      startTime: startTime,
      endTime: endTime,
      location: location,
      owner: owner,
      attendees: attendees,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'startTime': startTime,
      'endTime': endTime,
      'location': location,
      'owner': owner,
      'attendees': attendees,
    };
  }
}
