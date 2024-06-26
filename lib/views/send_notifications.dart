import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_messaging/firebase_messaging.dart';

class SendNotificationScreen extends StatefulWidget {
  @override
  _SendNotificationScreenState createState() => _SendNotificationScreenState();
}

class _SendNotificationScreenState extends State<SendNotificationScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

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
      // Send notification through FCM
      await _sendPushNotification(title, message, _selectedRecipient);

      // Clear input fields
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

  Future<void> _sendPushNotification(
      String title, String message, String recipient) async {
    String topic = 'all'; // Default topic

    if (recipient == 'user') {
      topic = 'user';
    } else if (recipient == 'worker') {
      topic = 'worker';
    }

    // Prepare the message payload
    var messagePayload = {
      'notification': {
        'title': title,
        'body': message,
      },
      'data': {
        'click_action': 'FLUTTER_NOTIFICATION_CLICK',
        'id': '1',
        'status': 'done'
      },
      'token': await _firebaseMessaging.getToken(),
    };

    try {
      // Send the message using FirebaseMessaging
      final String serverKey = ''; // Your server key here
      final String fcmEndpoint =
          'https://fcm.googleapis.com/v1/projects/shahan-app/messages:send';

      var response = await http.post(
        Uri.parse(fcmEndpoint),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $serverKey',
        },
        body: jsonEncode(messagePayload),
      );

      if (response.statusCode == 200) {
        print('Notification sent successfully');
      } else {
        print('Failed to send notification: ${response.body}');
        throw Exception('Failed to send notification');
      }
    } catch (e) {
      print('Error sending notification: $e');
      throw Exception('Failed to send notification');
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


// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';

// class SendNotificationScreen extends StatefulWidget {
//   @override
//   _SendNotificationScreenState createState() => _SendNotificationScreenState();
// }

// class _SendNotificationScreenState extends State<SendNotificationScreen> {
//   final TextEditingController _titleController = TextEditingController();
//   final TextEditingController _messageController = TextEditingController();
//   final FirebaseFirestore _db = FirebaseFirestore.instance;

//   String _selectedRecipient = 'All';
//   bool _showDropdown = false;

//   Future<void> _sendNotification() async {
//     String title = _titleController.text;
//     String message = _messageController.text;

//     if (title.isEmpty || message.isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//         content: Text('Please enter both title and message'),
//         backgroundColor: Colors.red,
//       ));
//       return;
//     }

//     // Save notification to Firestore
//     DocumentReference notificationRef =
//         await _db.collection('notifications').add({
//       'title': title,
//       'message': message,
//       'timestamp': Timestamp.now(),
//       'recipient': _selectedRecipient,
//     });

//     // Send notification through FCM
//     await _sendPushNotification(title, message, _selectedRecipient);

//     // Clear input fields
//     _titleController.clear();
//     _messageController.clear();

//     ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//       content: Text('Notification sent successfully'),
//     ));
//   }

//   Future<void> _sendPushNotification(
//       String title, String message, String recipient) async {
//     String topic = '/topics/All'; // Default topic

//     if (recipient == 'user') {
//       topic = '/topics/user';
//     } else if (recipient == 'worker') {
//       topic = '/topics/worker';
//     }

//     // Prepare the message payload
//     var messagePayload = {
//       'notification': {
//         'title': title,
//         'body': message,
//       },
//       'data': {
//         'click_action': 'FLUTTER_NOTIFICATION_CLICK',
//         'id': '1',
//         'status': 'done'
//       },
//       'to': topic,
//     };

//     try {
//       // Send the message using FirebaseMessaging
//       // await FirebaseMessaging.instance.send(
//       //   RemoteMessage(
//       //     data: messagePayload['data'],
//       //     notification: messagePayload['notification'],
//       //     to: messagePayload['to'],
//       //   ),
//       // );
//     } catch (e) {
//       print('Error sending notification: $e');
//       // Handle error as needed
//     }
//   }

//   void _dismissKeyboardAndDropdown() {
//     FocusScope.of(context).unfocus();
//     setState(() {
//       _showDropdown = false;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Send Notification'),
//       ),
//       body: GestureDetector(
//         onTap: _dismissKeyboardAndDropdown,
//         child: SingleChildScrollView(
//           reverse: true,
//           child: Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: Column(
//               children: [
//                 TextField(
//                   controller: _titleController,
//                   decoration: InputDecoration(labelText: 'Title'),
//                 ),
//                 TextField(
//                   controller: _messageController,
//                   decoration: InputDecoration(labelText: 'Message'),
//                 ),
//                 SizedBox(height: 20),
//                 GestureDetector(
//                   onTap: () {
//                     setState(() {
//                       _showDropdown = !_showDropdown;
//                     });
//                   },
//                   child: Container(
//                     padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//                     decoration: BoxDecoration(
//                       border: Border.all(color: Colors.grey),
//                       borderRadius: BorderRadius.circular(5),
//                     ),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Text('Recipient: $_selectedRecipient'),
//                         Icon(_showDropdown
//                             ? Icons.arrow_drop_up
//                             : Icons.arrow_drop_down),
//                       ],
//                     ),
//                   ),
//                 ),
//                 Visibility(
//                   visible: _showDropdown,
//                   child: Container(
//                     margin: EdgeInsets.only(top: 5),
//                     padding: EdgeInsets.symmetric(vertical: 5),
//                     decoration: BoxDecoration(
//                       border: Border.all(color: Colors.grey),
//                       borderRadius: BorderRadius.circular(5),
//                     ),
//                     child: SingleChildScrollView(
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.stretch,
//                         children: <String>['All', 'user', 'worker']
//                             .map<Widget>((String value) => InkWell(
//                                   onTap: () {
//                                     setState(() {
//                                       _selectedRecipient = value;
//                                       _showDropdown = false;
//                                     });
//                                   },
//                                   child: Container(
//                                     padding: EdgeInsets.symmetric(
//                                         horizontal: 16, vertical: 12),
//                                     child: Text(value),
//                                   ),
//                                 ))
//                             .toList(),
//                       ),
//                     ),
//                   ),
//                 ),
//                 SizedBox(height: 20),
//                 ElevatedButton(
//                   onPressed: _sendNotification,
//                   child: Text('Send Notification'),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
