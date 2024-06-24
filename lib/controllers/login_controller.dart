import 'package:flutter/material.dart';
import 'package:shahan/models/user_model.dart';
import 'package:shahan/services/auth_service.dart';
import 'package:shahan/views/main_screen.dart';

class LoginController {
  final AuthService _authService = AuthService();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isLoading = false;

  Future<void> login(BuildContext context) async {
    isLoading = true;
    try {
      print('Attempting login with email: ${emailController.text}');
      final UserModel? user = await _authService.signIn(
        emailController.text,
        passwordController.text,
      );
      if (user == null) {
        _showSnackBar(context, 'Login failed', Colors.red);
        print('Login failed: user is null');
        return;
      }

      print('Login successful for user: ${user.uid}');
      // Navigate to MainScreen with user role
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => MainScreen(userRole: user.role),
        ),
      );
    } catch (e) {
      print('Failed to login: $e');
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
