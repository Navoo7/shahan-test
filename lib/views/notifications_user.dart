import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:async/async.dart'; // Import async package for StreamGroup
import 'package:shahan/views/notification_user_details.dart';
import 'package:shahan/controllers/main_controller.dart';
import 'package:rxdart/rxdart.dart'; // Import rxdart for combineLatest

class UserNotifications extends StatefulWidget {
  final String userRole;

  const UserNotifications({Key? key, required this.userRole}) : super(key: key);

  @override
  State<UserNotifications> createState() => _UserNotificationsState();
}

class _UserNotificationsState extends State<UserNotifications> {
  final MainController _controller = MainController();
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  late User _currentUser;

  @override
  void initState() {
    super.initState();
    _currentUser = FirebaseAuth.instance.currentUser!;
    _controller.loadRequests();
  }

  Stream<List<Map<String, dynamic>>> _combineStreams() {
    // Stream for notifications
    Stream<List<Map<String, dynamic>>> notificationsStream = _db
        .collection('notifications')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) {
              Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
              return {'type': 'notification', 'data': data, 'id': doc.id};
            }).toList());

    // Stream for replies (only for workers)
    Stream<List<Map<String, dynamic>>> repliesStream = Stream.empty();
    if (widget.userRole != 'users') {
      repliesStream = _db
          .collection('replies')
          .where('uid', isEqualTo: _currentUser.uid)
          .orderBy('timestamp', descending: true)
          .snapshots()
          .map((snapshot) => snapshot.docs.map((doc) {
                Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
                return {'type': 'reply', 'data': data, 'id': doc.id};
              }).toList());
    }

    // Combine both streams using combineLatest from rxdart
    return Rx.combineLatest2<List<Map<String, dynamic>>,
        List<Map<String, dynamic>>, List<Map<String, dynamic>>>(
      notificationsStream,
      repliesStream,
      (notifications, replies) {
        List<Map<String, dynamic>> result = [];

        // Filter notifications based on user role
        if (widget.userRole == 'user') {
          // Users should see notifications intended for 'users' or 'All'
          result.addAll(notifications.where((notification) =>
              notification['data']['recipient'] == 'user' ||
              notification['data']['recipient'] == 'All'));
          result.addAll(replies);
        } else if (widget.userRole == 'worker') {
          // Workers should see notifications intended for 'workers', 'All', and their specific notifications
          result.addAll(notifications.where((notification) =>
              notification['data']['recipient'] == 'worker' ||
              notification['data']['recipient'] == 'All' ||
              (notification['data']['recipient'] == _currentUser.uid &&
                  notification['data']['type'] == 'notification')));
          result.addAll(replies);
        } else {
          // Admin or other roles can see all notifications and replies
          result.addAll(notifications);
          result.addAll(replies);
        }

        // Sort result by timestamp in descending order
        result.sort((a, b) => (b['data']['timestamp'] as Timestamp)
            .compareTo(a['data']['timestamp'] as Timestamp));

        return result;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              _controller.signOut(context);
            },
          ),
        ],
      ),
      body: StreamBuilder<List<Map<String, dynamic>>>(
        stream: _combineStreams(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No notifications found.'));
          }

          List<Map<String, dynamic>> combinedData = snapshot.data!;

          return ListView.builder(
            itemCount: combinedData.length,
            itemBuilder: (context, index) {
              Map<String, dynamic> data = combinedData[index]['data'];
              String docId = combinedData[index]['id'];
              String type = combinedData[index]['type'];
              return _buildNotificationCard(data, docId, type);
            },
          );
        },
      ),
    );
  }

  Widget _buildNotificationCard(
      Map<String, dynamic> data, String docId, String type) {
    Timestamp timestamp = data['timestamp'] as Timestamp;
    DateTime dateTime = timestamp.toDate();
    String formattedDate = DateFormat('yyyy-MM-dd – kk:mm').format(dateTime);

    return Card(
      margin: const EdgeInsets.all(10),
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              type == 'notification' ? 'Notification' : 'Admin Reply',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 5),
            Text(
              'Title: ${data['title'] ?? ''}',
              style: TextStyle(fontSize: 16),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: 5),
            Text(
              'Message: ${data['message'] ?? ''}',
              style: TextStyle(fontSize: 16),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: 5),
            Text(
              'Timestamp: $formattedDate',
              style: TextStyle(fontSize: 10),
            ),
            SizedBox(height: 10),
            if (type == 'reply') // Show "View" button only for replies
              Align(
                alignment: Alignment.bottomRight,
                child: Container(
                  height: 25,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.green),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: ElevatedButton(
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => NotificationUserDetails(
                          requestData: data,
                          docId: docId,
                        ),
                      ),
                    ),
                    child: Text(
                      'View',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
