import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
      final UserModel? user = await _authService.signIn(
        emailController.text,
        passwordController.text,
      );

      if (user == null) {
        _showSnackBar(context, 'Login failed: user is null', Colors.red);
        return;
      }

      // Navigate to MainScreen with user role
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => MainScreen(userRole: user.role)),
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        _showSnackBar(context, 'No user found for that email.', Colors.red);
      } else if (e.code == 'wrong-password') {
        _showSnackBar(context, 'Wrong password provided.', Colors.red);
      } else if (e.code == 'invalid-email') {
        _showSnackBar(context, 'Invalid email provided.', Colors.red);
      } else {
        _showSnackBar(context, 'Failed to login: ${e.message}', Colors.red);
      }
    } catch (e) {
      _showSnackBar(context, 'Failed to login: $e', Colors.red);
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
