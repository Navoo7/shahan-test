import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AccountRequestDetailScreen extends StatelessWidget {
  final Map<String, dynamic> requestData;
  final String docId;

  AccountRequestDetailScreen({required this.requestData, required this.docId});

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> _approveUserRequest(BuildContext context) async {
    try {
      String email = requestData['email'] ?? '';
      String password = requestData['password'] ?? '';

      if (email.isEmpty || password.isEmpty) {
        throw Exception('Email or Password is missing');
      }

      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      await _db.collection('accounts').doc(userCredential.user!.uid).set({
        'name': requestData['name'] ?? '',
        'email': email,
        'location': requestData['location'] ?? '',
        'timestamp': FieldValue.serverTimestamp(),
        'role': requestData['role'] ?? 'user'
      });

      await _db
          .collection('admin')
          .doc('accountrequest')
          .collection('requests')
          .doc(docId)
          .update({'approved': true});

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('User approved and created successfully')),
      );

      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to approve user request: $e')),
      );
    }
  }

  Future<void> _rejectUserRequest(BuildContext context) async {
    try {
      await _db
          .collection('admin')
          .doc('accountrequest')
          .collection('requests')
          .doc(docId)
          .delete();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('User request rejected')),
      );

      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to reject user request: $e')),
      );
    }
  }

  Future<void> _replyToUserRequest(BuildContext context) async {
    // Implement reply functionality here
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Request Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Name: ${requestData['name']}',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Text('Email: ${requestData['email']}',
                style: TextStyle(fontSize: 16)),
            Text('Location: ${requestData['location']}',
                style: TextStyle(fontSize: 16)),
            Text('Role: ${requestData['role']}',
                style: TextStyle(fontSize: 16)),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  height: 35,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.green,
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: ElevatedButton(
                    onPressed: () => _approveUserRequest(context),
                    child: Text(
                      'Approve',
                      style: TextStyle(fontSize: 14, color: Colors.black),
                    ),
                  ),
                ),
                Container(
                  height: 35,
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.red),
                      borderRadius: BorderRadius.circular(20)),
                  child: ElevatedButton(
                    onPressed: () => _rejectUserRequest(context),
                    child: Text(
                      'Reject',
                      style: TextStyle(fontSize: 14, color: Colors.black),
                    ),
                  ),
                ),
                Container(
                  height: 35,
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.blue),
                      borderRadius: BorderRadius.circular(20)),
                  child: ElevatedButton(
                    onPressed: () => _replyToUserRequest(context),
                    child: Text(
                      'Reply',
                      style: TextStyle(fontSize: 14, color: Colors.black),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
