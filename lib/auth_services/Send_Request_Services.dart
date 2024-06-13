import 'package:cloud_firestore/cloud_firestore.dart';

class RequestService {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  Future<void> sendUserRequest(Map<String, dynamic> requestData) async {
    await _firebaseFirestore
        .collection('admin')
        .doc('accountrequest')
        .collection('requests')
        .add(requestData);
  }

  Future<void> report(Map<String, dynamic> requestData) async {
    await _firebaseFirestore
        .collection('admin')
        .doc('userreports')
        .collection('report')
        .add(requestData);
  }

  Future<void> sendBarberRequest(Map<String, dynamic> requestData) async {
    await _firebaseFirestore.collection('barber')
      ..doc('notifications').collection('notifi').add(requestData);
  }
}
