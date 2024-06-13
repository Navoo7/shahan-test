import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({Key? key}) : super(key: key);

  @override
  _AdminDashboardState createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> _approveUserRequest(
      String docId, Map<String, dynamic> data) async {
    try {
      String email = data['email'] ?? '';
      String password = data['password'] ?? '';

      if (email.isEmpty || password.isEmpty) {
        throw Exception('Email or Password is missing');
      }

      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      await _db.collection('accounts').doc(userCredential.user!.uid).set({
        'name': data['name'] ?? '',
        'email': email,
        'location': data['location'] ?? '',
        'timestamp': FieldValue.serverTimestamp(),
        'role': 'user'
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
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to approve user request: $e')),
      );
    }
  }

  Future<void> _rejectUserRequest(String docId) async {
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
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to reject user request: $e')),
      );
    }
  }

  Widget _buildRequestCard(Map<String, dynamic> data, String docId) {
    return Card(
      margin: const EdgeInsets.all(10),
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Name: ${data['name']}',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Text('Email: ${data['email']}', style: TextStyle(fontSize: 16)),
            Text('Location: ${data['location']}',
                style: TextStyle(fontSize: 16)),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => _approveUserRequest(docId, data),
                  child: Text('Approve', style: TextStyle(color: Colors.green)),
                ),
                TextButton(
                  onPressed: () => _rejectUserRequest(docId),
                  child: Text('Reject', style: TextStyle(color: Colors.red)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _db
            .collection('admin')
            .doc('accountrequest')
            .collection('requests')
            .where('approved', isEqualTo: false)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No user requests found.'));
          }

          List<DocumentSnapshot> docs = snapshot.data!.docs;

          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (context, index) {
              Map<String, dynamic> data =
                  docs[index].data() as Map<String, dynamic>;
              String docId = docs[index].id;
              return _buildRequestCard(data, docId);
            },
          );
        },
      ),
    );
  }
}
