import 'package:whereyouat/app/home/models/event.dart';
import 'package:whereyouat/services/api_path.dart';
import 'package:whereyouat/services/firestore_service.dart';

abstract class Database {
  Future<void> createEvent(Event event);
  Stream<List<Event>> eventsStream();
}

class FirestoreDatabase implements Database {
  FirestoreDatabase({required this.uid});
  final String uid;
  final _service = FirestoreService.instance;

  @override
  Future<void> createEvent(Event event) => _service.setData(
        path: APIPath.event(uid, 'event_def'),
        data: event.toMap(),
      );

  @override
  Stream<List<Event>> eventsStream() => _service.collectionStream(
      path: APIPath.events(uid), builder: (data) => Event.fromMap(data));
}
