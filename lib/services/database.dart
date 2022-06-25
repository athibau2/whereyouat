import 'package:nanoid/async.dart';
import 'package:whereyouat/app/home/models/event.dart';
import 'package:whereyouat/services/api_path.dart';
import 'package:whereyouat/services/firestore_service.dart';

abstract class Database {
  Future<void> setEvent(Event event);
  Stream<List<Event>> userEventsStream();
  Future<void> deleteEvent(Event event);
}

Future<String> getId() async =>
    await customAlphabet('1234567890abcdefghijklmnopqrstuvwxyz', 20);

class FirestoreDatabase implements Database {
  FirestoreDatabase({required this.uid});
  final String uid;
  final _service = FirestoreService.instance;

  @override
  Future<void> setEvent(Event event) async => _service.setData(
        path: APIPath.userEvent(uid, event.id),
        data: event.toMap(),
      );

  @override
  Future<void> deleteEvent(Event event) =>
      _service.deleteData(path: APIPath.userEvent(uid, event.id));

  @override
  Stream<List<Event>> userEventsStream() => _service.collectionStream(
      path: APIPath.userEvents(uid),
      builder: (data, documentId) => Event.fromMap(data, documentId));
}
