import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

class RequestDetails extends StatelessWidget {
  final Map<String, dynamic> requestData;
  final String docId;

  RequestDetails({required this.requestData, required this.docId});

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    // Format the timestamp
    Timestamp timestamp = requestData['timestamp'] as Timestamp;
    DateTime dateTime = timestamp.toDate();
    String formattedDate = DateFormat('yyyy-MM-dd – kk:mm').format(dateTime);

    return Scaffold(
      appBar: AppBar(
        title: Text('Request Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Name: ${requestData['name']}',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              'Email: ${requestData['email']}',
              style: TextStyle(fontSize: 16),
            ),
            Text(
              'Title: ${requestData['title']}',
              style: TextStyle(fontSize: 16),
            ),
            Text(
              'Description: ${requestData['description']}',
              style: TextStyle(fontSize: 16),
            ),
            Text(
              'Timestamp: $formattedDate',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  _showReplyBottomSheet(context, requestData['uid']);
                },
                child: Text('Reply'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showReplyBottomSheet(BuildContext context, String uid) {
    TextEditingController messageController = TextEditingController();
    TextEditingController titleController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: Container(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Reply to ${requestData['name']}',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  TextField(
                    controller: titleController,
                    decoration: InputDecoration(
                      labelText: 'Title',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 10),
                  TextField(
                    controller: messageController,
                    decoration: InputDecoration(
                      labelText: 'Message',
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 3,
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      _sendReply(context, uid, titleController.text,
                          messageController.text);
                    },
                    child: Text('Send Reply'),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _sendReply(
      BuildContext context, String uid, String title, String message) async {
    try {
      await _db.collection('replies').add({
        'uid': uid,
        'title': title,
        'message': message,
        'timestamp': FieldValue.serverTimestamp(),
      });

      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Reply sent successfully'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to send reply'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
