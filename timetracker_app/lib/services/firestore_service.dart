import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  FirestoreService._();
  static final instance = FirestoreService._();

  Future<void> addData(
      {required String collectionPath,
      required Map<String, dynamic> data}) async {
    final collectionReference =
        FirebaseFirestore.instance.collection(collectionPath);
    await collectionReference.add(data).then((value) => print("Added data"));
  }

  Future<void> setData(
      {required String path, required Map<String, dynamic> data}) async {
    final reference = FirebaseFirestore.instance.doc(path);
    await reference.set(data);
  }

  Stream<List<T>> collectionStream<T>({
    required String path,
    required T Function(Map<String, dynamic> data, String documentId) builder,
  }) {
    final collectionReference = FirebaseFirestore.instance.collection(path);
    final snapshots = collectionReference.snapshots();
    return snapshots.map((collectionSnapshot) => collectionSnapshot.docs
        .map((docSnapshot) => builder(docSnapshot.data(), docSnapshot.id))
        .toList());
  }
}
