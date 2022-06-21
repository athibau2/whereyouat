import 'package:nanoid/async.dart';
import 'package:whereyouat/app/home/models/event.dart';
import 'package:whereyouat/services/api_path.dart';
import 'package:whereyouat/services/firestore_service.dart';

abstract class Database {
  Future<void> setEvent(Event event);
  Stream<List<Event>> eventsStream();
}

Future<String> getId() async =>
    await customAlphabet('1234567890abcdefghijklmnopqrstuvwxyz', 20);

class FirestoreDatabase implements Database {
  FirestoreDatabase({required this.uid});
  final String uid;
  final _service = FirestoreService.instance;

  @override
  Future<void> setEvent(Event event) async => _service.setData(
        path: APIPath.event(uid, event.id),
        data: event.toMap(),
      );

  @override
  Stream<List<Event>> eventsStream() => _service.collectionStream(
      path: APIPath.events(uid), builder: (data, documentId) => Event.fromMap(data, documentId));
}
