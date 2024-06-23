import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shahan/models/request_model.dart';

class RequestService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collectionPath = 'requests'; // Collection name in Firestore

  Future<void> createRequest(RequestModel request) async {
    try {
      await _firestore.collection(_collectionPath).add(request.toMap());
    } catch (e) {
      print('Error creating request: $e');
      rethrow; // Rethrow the error to handle it in the caller
    }
  }

  Future<List<RequestModel>> getRequests() async {
    try {
      final querySnapshot = await _firestore.collection(_collectionPath).get();
      return querySnapshot.docs.map((doc) {
        return RequestModel.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();
    } catch (e) {
      print('Error getting requests: $e');
      rethrow; // Rethrow the error to handle it in the caller
    }
  }

  Future<void> updateRequest(String docId, RequestModel updatedRequest) async {
    try {
      await _firestore
          .collection(_collectionPath)
          .doc(docId)
          .update(updatedRequest.toMap());
    } catch (e) {
      print('Error updating request: $e');
      rethrow; // Rethrow the error to handle it in the caller
    }
  }

  Future<void> deleteRequest(String docId) async {
    try {
      await _firestore.collection(_collectionPath).doc(docId).delete();
    } catch (e) {
      print('Error deleting request: $e');
      rethrow; // Rethrow the error to handle it in the caller
    }
  }
}
