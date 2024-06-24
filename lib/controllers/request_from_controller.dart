import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RequestFormController {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  bool isLoading = false;

  Future<void> createRequest(BuildContext context) async {
    isLoading = true;

    try {
      // Get the current user's uid
      User? user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        throw Exception('No user is currently signed in');
      }
      String uid = user.uid;

      // Fetch the user's display name and email from Firestore
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('accounts')
          .doc(uid)
          .get();
      String userEmail = userDoc['email'];
      String userName = userDoc['name'];

      // Create a request document with the uid
      await FirebaseFirestore.instance.collection('requests').add({
        'title': titleController.text,
        'description': titleController.text,
        'uid': uid,
        'timestamp': FieldValue.serverTimestamp(),
        'name': userName,
        'email': userEmail,
      });

      titleController.clear();
      descriptionController.clear();
      // Show success message
      _showSnackBar(context, 'Request created successfully', Colors.green);
    } catch (e) {
      // Show error message
      _showSnackBar(context, 'Failed to create request', Colors.red);
    } finally {
      isLoading = false;
    }
  }

  void _showSnackBar(
      BuildContext context, String message, Color backgroundColor) {
    final snackBar = SnackBar(
      content: Text(message),
      backgroundColor: backgroundColor,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
