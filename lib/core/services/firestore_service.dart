import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fruits_hub/core/services/data_service.dart';

class FireStoreService implements DatabaseService {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  Future<void> addData({
    required String path,
    required Map<String, dynamic> data,
    String? documentId,
  }) async {
    try {
      if (documentId != null) {
        await firestore.collection(path).doc(documentId).set(data);
      } else {
        await firestore.collection(path).add(data);
      }
    } catch (e) {
      print('🔥 Firestore addData error: $e');
      rethrow;
    }
  }

  @override
  Future<dynamic> getData({
    required String path,
    String? documentId,
    Map<String, dynamic>? query,
  }) async {
    try {
      if (documentId != null) {
        final doc = await firestore.collection(path).doc(documentId).get();
        if (!doc.exists) {
          print('⚠️ Document not found at $path/$documentId');
          return null;
        }
        return doc.data();
      } else {
        Query<Map<String, dynamic>> ref = firestore.collection(path);

        // Apply query filters (orderBy, limit)
        if (query != null) {
          if (query['orderBy'] != null) {
            final orderByField = query['orderBy'] as String;
            final descending = query['descending'] as bool? ?? false;
            ref = ref.orderBy(orderByField, descending: descending);
          }
          if (query['limit'] != null) {
            final limit = query['limit'] as int;
            ref = ref.limit(limit);
          }
        }

        final snapshot = await ref.get();
        return snapshot.docs.map((e) => e.data()).toList();
      }
    } catch (e, s) {
      print('🔥 Firestore getData error: $e');
      print('📍 Stack trace: $s');
      rethrow;
    }
  }

  @override
  Future<bool> checkIfDataExists({
    required String path,
    required String documentId,
  }) async {
    try {
      final doc = await firestore.collection(path).doc(documentId).get();
      return doc.exists;
    } catch (e) {
      print('🔥 Firestore checkIfDataExists error: $e');
      rethrow;
    }
  }
}
