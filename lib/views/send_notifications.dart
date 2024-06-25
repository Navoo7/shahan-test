import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class SendNotificationScreen extends StatefulWidget {
  @override
  _SendNotificationScreenState createState() => _SendNotificationScreenState();
}

class _SendNotificationScreenState extends State<SendNotificationScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseMessaging _fcm = FirebaseMessaging.instance;

  String _selectedRecipient = 'All'; // Default value
  bool _showDropdown = false;

  void _sendNotification() async {
    String title = _titleController.text;
    String message = _messageController.text;

    if (title.isEmpty || message.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Please enter both title and message'),
        backgroundColor: Colors.red,
      ));
      return;
    }

    // Save notification to Firestore
    DocumentReference notificationRef =
        await _db.collection('notifications').add({
      'title': title,
      'message': message,
      'timestamp': Timestamp.now(),
      'recipient': _selectedRecipient, // Added recipient field
    });

    // Clear input fields
    _titleController.clear();
    _messageController.clear();

    // Show a success message
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('Notification sent successfully'),
    ));
  }

  void _dismissKeyboardAndDropdown() {
    // Dismiss keyboard
    FocusScope.of(context).unfocus();

    // Dismiss dropdown
    setState(() {
      _showDropdown = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Send Notification'),
      ),
      body: GestureDetector(
        onTap: _dismissKeyboardAndDropdown,
        child: SingleChildScrollView(
          reverse: true,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextField(
                  controller: _titleController,
                  decoration: InputDecoration(labelText: 'Title'),
                ),
                TextField(
                  controller: _messageController,
                  decoration: InputDecoration(labelText: 'Message'),
                ),
                SizedBox(height: 20),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _showDropdown = !_showDropdown;
                    });
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Recipient: $_selectedRecipient'),
                        Icon(_showDropdown
                            ? Icons.arrow_drop_up
                            : Icons.arrow_drop_down),
                      ],
                    ),
                  ),
                ),
                Visibility(
                  visible: _showDropdown,
                  child: Container(
                    margin: EdgeInsets.only(top: 5),
                    padding: EdgeInsets.symmetric(vertical: 5),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <String>['All', 'user', 'worker']
                            .map<Widget>((String value) => InkWell(
                                  onTap: () {
                                    setState(() {
                                      _selectedRecipient = value;
                                      _showDropdown = false;
                                    });
                                  },
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 16, vertical: 12),
                                    child: Text(value),
                                  ),
                                ))
                            .toList(),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _sendNotification,
                  child: Text('Send Notification'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
