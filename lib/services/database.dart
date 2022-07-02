import 'package:nanoid/async.dart';
import 'package:whereyouat/app/home/models/event.dart';
import 'package:whereyouat/services/api_path.dart';
import 'package:whereyouat/services/firestore_service.dart';

abstract class Database {
  Future<void> setEvent(Event event);
  Future<void> deleteEvent(Event event);
  Future<void> optOut(Event event);
  Future<bool> isAttending(String uid, String eventId);
  Stream<List<Event>> userEventsStream();
  Stream<List<Event>> eventsStream();
  Stream<Map<String, dynamic>> eventStream(String uid, String eventId);
}

Future<String> getId() async =>
    await customAlphabet('1234567890abcdefghijklmnopqrstuvwxyz', 20);

class FirestoreDatabase implements Database {
  FirestoreDatabase({required this.uid});
  final String uid;
  final _service = FirestoreService.instance;

  @override
  Future<void> setEvent(Event event) async {
    _service.setData(
      path: APIPath.userEvent(uid, event.id),
      data: event.toMap(),
    );
    _service.setData(
      path: APIPath.event(event.id),
      data: event.toMap(),
    );
  }

  @override
  Future<void> deleteEvent(Event event) async {
    _service.deleteData(path: APIPath.userEvent(uid, event.id));
    _service.deleteData(path: APIPath.event(event.id));
  }

  @override
  Future<void> optOut(Event event) async {
    _service.deleteData(path: APIPath.userEvent(uid, event.id));
    _service.setData(
      path: APIPath.event(event.id),
      data: event.toMap(),
    );
  }

  @override
  Future<bool> isAttending(String uid, String eventId) async {
    final bool isAttending = await _service.isAttending(path: APIPath.userEvent(uid, eventId));
    return isAttending;
  }

  @override
  Stream<List<Event>> userEventsStream() => _service.collectionStream(
      path: APIPath.userEvents(uid),
      builder: (data, documentId) => Event.fromMap(data, documentId));

  @override
  Stream<List<Event>> eventsStream() => _service.collectionStream(
      path: APIPath.events(),
      builder: (data, documentId) => Event.fromMap(data, documentId));

  @override
  Stream<Map<String, dynamic>> eventStream(String uid, String eventId) =>
      _service.documentStream(
          path: APIPath.userEvent(uid, eventId),
          builder: (data, documentId) => Event.fromMap(data, documentId));
}
