import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:whereyouat/app/home/models/event.dart';

class FirestoreService {
  FirestoreService._();
  static final instance = FirestoreService._();

  Future<void> setData({
    required String path,
    required Map<String, dynamic> data,
  }) async {
    final reference = FirebaseFirestore.instance.doc(path);
    await reference.set(data);
  }

  Future<void> deleteData({required String path}) async {
    final reference = FirebaseFirestore.instance.doc(path);
    await reference.delete();
  }

  Future<bool> isAttending({required String path}) async {
    final reference = FirebaseFirestore.instance.doc(path);
    final data = await reference.get();
    return data.exists;
  }

  Future<Future<QuerySnapshot<Map<String, dynamic>>>> userEvents<T>({
    required String path,
    required T Function(Map<String, dynamic> data, String documentId) builder,
  }) async {
    final reference = FirebaseFirestore.instance.collection(path).get();
    return reference;
  }

  Stream<List<T>> collectionStream<T>({
    required String path,
    required T Function(Map<String, dynamic> data, String documentId) builder,
  }) {
    final reference = FirebaseFirestore.instance.collection(path);
    final snapshots = reference.snapshots();
    return snapshots.map((snapshot) => snapshot.docs
        .map((snapshot) => builder(snapshot.data(), snapshot.id))
        .toList());
  }

  Stream<Map<String, dynamic>> documentStream<T>({
    required String path,
    required T Function(Map<String, dynamic> data, String documentId) builder,
  }) {
    final reference = FirebaseFirestore.instance.doc(path);
    final snapshot = reference.snapshots();
    return snapshot.map((event) => event.data()!);
  }
}
