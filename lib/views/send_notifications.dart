import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:shahan/services/NotificationController.dart';

class SendNotificationScreen extends StatefulWidget {
  @override
  _SendNotificationScreenState createState() => _SendNotificationScreenState();
}

class _SendNotificationScreenState extends State<SendNotificationScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final NotificationServices _notificationServices = NotificationServices();

  String _selectedRecipient = 'All';
  bool _showDropdown = false;

  Future<void> _sendNotification() async {
    String title = _titleController.text;
    String message = _messageController.text;

    if (title.isEmpty || message.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Please enter both title and message'),
        backgroundColor: Colors.red,
      ));
      return;
    }

    try {
      // String recipientTopic = '$_selectedRecipient';
      String recipientTopic = '/topics/$_selectedRecipient';
      String reciption = '$_selectedRecipient';

      // Save notification to collection
      await _notificationServices.saveNotification(title, message, reciption);

      // Send notification
      _notificationServices.SendNotification(title, message, recipientTopic);

      _titleController.clear();
      _messageController.clear();

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Notification sent successfully'),
      ));
    } catch (e) {
      print('Error sending notification: $e');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Failed to send notification'),
        backgroundColor: Colors.red,
      ));
    }
  }

  void _dismissKeyboardAndDropdown() {
    FocusScope.of(context).unfocus();
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
