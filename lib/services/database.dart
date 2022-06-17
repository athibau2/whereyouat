import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:whereyouat/app/home/models/event.dart';
import 'package:whereyouat/services/api_path.dart';

abstract class Database {
  Future<void> createEvent(Event event);
  Stream<List<Event>> eventsStream();
}

class FirestoreDatabase implements Database {
  FirestoreDatabase({required this.uid});
  final String uid;

  @override
  Future<void> createEvent(Event event) => _setData(
        path: APIPath.event(uid, 'event_def'),
        data: event.toMap(),
      );

  @override
  Stream<List<Event>> eventsStream() {
    final path = APIPath.events(uid);
    final reference = FirebaseFirestore.instance.collection(path);
    final snapshots = reference.snapshots();
    return snapshots.map((snapshot) => snapshot.docs.map((snapshot) {
          final data = snapshot.data();
          Timestamp date = data['startTime'];
          return Event(
            eventName: data['name'],
            startTime: date.toDate(),
            location: data['location'],
          );
        }).toList());
  }

  Future<void> _setData(
      {required String path, required Map<String, dynamic> data}) async {
    final reference = FirebaseFirestore.instance.doc(path);
    await reference.set(data);
  }
}
