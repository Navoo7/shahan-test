import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shahan/models/user_model.dart';
import 'package:shahan/services/auth_service.dart';
import 'package:shahan/views/login_screen.dart';
import 'package:shahan/views/main_screen.dart'; // Adjust import as per your project structure

class MainController extends ChangeNotifier {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final AuthService _authService = AuthService();
  UserModel? _currentUser;

  UserModel? get currentUser => _currentUser;

  void setUser(UserModel? user) {
    _currentUser = user;
    notifyListeners(); // Notify listeners when user changes
  }

  Future<void> signIn(
      BuildContext context, String email, String password) async {
    try {
      final UserModel? user = await _authService.signIn(email, password);
      if (user != null) {
        setUser(user);
        // Navigate to main screen with user role
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => MainScreen(
                  userRole: user.role)), // Set default role or handle null case
        );
      } else {
        _showSnackBar(context, 'Login failed', Colors.red);
      }
    } catch (e) {
      _showSnackBar(context, 'Failed to login', Colors.red);
    }
  }

  void signOut(BuildContext context) {
    _authService.signOut();
    _currentUser = null;
    // Clear any cached user data
    notifyListeners();
    // Navigate to login or home screen
    // Example:
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
    );
  }

  Future<void> createRequest(BuildContext context) async {
    try {
      // Replace with your logic to create a request
      // For demonstration, let's assume adding a document to Firestore
      await _db.collection('requests').add({
        'timestamp': DateTime.now(),
        'status': 'pending',
        // Add other fields as needed
      });
      // Example: Show success message
      _showSnackBar(context, 'Request created successfully', Colors.green);
    } catch (e) {
      // Handle error
      _showSnackBar(context, 'Failed to create request', Colors.red);
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

  void loadRequests() {}
}
