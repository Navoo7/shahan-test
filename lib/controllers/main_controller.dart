import 'package:flutter/material.dart';
import 'package:shahan/services/auth_service.dart';
import 'package:shahan/views/login_screen.dart';

class MainController {
  final AuthService _authService = AuthService();

  Future<void> loadRequests() async {
    // Implement loading requests based on user role
  }

  Future<void> signOut(BuildContext context) async {
    await _authService.signOut();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
    );
  }

  Future<void> createRequest(BuildContext context) async {
    // Implement creating a new request
  }
}
