import 'package:flutter/material.dart';
import 'package:shahan/services/auth_service.dart';
import 'package:shahan/models/user_model.dart';
import 'package:shahan/views/main_screen.dart'; // Ensure MainScreen is imported

class LoginController {
  final AuthService _authService = AuthService();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isLoading = false;

  Future<void> login(BuildContext context) async {
    isLoading = true;
    try {
      final UserModel? user = await _authService.signIn(
        emailController.text,
        passwordController.text,
      );
      if (user == null) {
        _showSnackBar(context, 'Login failed', Colors.red);
        return;
      }

      // Navigate to MainScreen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => MainScreen()),
      );
    } catch (e) {
      _showSnackBar(context, 'Failed to login', Colors.red);
    } finally {
      isLoading = false;
    }
  }

  void navigateToSignUp(BuildContext context) {
    // Implement navigation to sign-up screen
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
