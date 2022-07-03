import 'package:cloud_firestore/cloud_firestore.dart';

class Event {
  Event({
    required this.id,
    required this.name,
    required this.startTime,
    required this.endTime,
    required this.location,
    required this.owner,
    required this.attendees,
    required this.description,
  });

  final String id;
  final String name;
  final DateTime startTime;
  final DateTime endTime;
  final Map<String, dynamic> location;
  final Map<String, dynamic> owner;
  final List<dynamic> attendees;
  final String description;

  factory Event.fromMap(Map<String, dynamic> data, String documentId) {
    Timestamp date = data['startTime'];
    Timestamp time = data['endTime'];
    final String name = data['name'];
    final DateTime startTime = date.toDate();
    final DateTime endTime = time.toDate();
    final Map<String, dynamic> location = data['location'];
    final Map<String, dynamic> owner = data['owner'];
    final List<dynamic> attendees = data['attendees'];
    final String description = data['description'];
    return Event(
      id: documentId,
      name: name,
      startTime: startTime,
      endTime: endTime,
      location: location,
      owner: owner,
      attendees: attendees,
      description: description,
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
      'description': description,
    };
  }
}
