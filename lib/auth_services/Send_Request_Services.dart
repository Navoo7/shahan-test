import 'package:cloud_firestore/cloud_firestore.dart';

class RequestService {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  Future<void> sendUserRequest(Map<String, dynamic> requestData) async {
    await _firebaseFirestore
        .collection('admin')
        .doc('AccountRequest')
        .collection('requests')
        .add(requestData);
  }

  Future<void> sendBarberRequest(Map<String, dynamic> requestData) async {
    await _firebaseFirestore.collection('barber')
      ..doc('Notifications').collection('notifi').add(requestData);
  }
}
