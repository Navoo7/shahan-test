import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class NotificationUserDetails extends StatelessWidget {
  final Map<String, dynamic> requestData;
  final String docId;

  NotificationUserDetails({required this.requestData, required this.docId});

  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Future that fetches the notification details and caches the result
  Future<Map<String, dynamic>> _fetchNotificationDetails() async {
    DocumentSnapshot snapshot =
        await _db.collection('replies').doc(docId).get();
    if (snapshot.exists) {
      return snapshot.data() as Map<String, dynamic>;
    } else {
      throw Exception('Notification not found');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notification Details'),
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _fetchNotificationDetails(), // Fetch notification details
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData) {
            return Center(child: Text('Notification not found.'));
          }

          Map<String, dynamic> replyData = snapshot.data!;

          Timestamp timestamp = replyData['timestamp'] as Timestamp;
          DateTime dateTime = timestamp.toDate();
          String formattedDate =
              DateFormat('yyyy-MM-dd – kk:mm').format(dateTime);

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Title: ${replyData['title']}',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Text(
                  'Message: ${replyData['message']}',
                  style: TextStyle(fontSize: 16),
                ),
                Text(
                  'Timestamp: $formattedDate',
                  style: TextStyle(fontSize: 10),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
