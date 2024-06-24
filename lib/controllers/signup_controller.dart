import 'package:flutter/material.dart';
import 'package:shahan/services/auth_service.dart';
import 'package:shahan/views/login_screen.dart';
import 'package:shahan/views/main_screen.dart';

class SignUpController {
  final AuthService _authService = AuthService();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  bool isLoading = false;

  Future<void> signUp(BuildContext context) async {
    if (passwordController.text != confirmPasswordController.text) {
      _showSnackBar(context, 'Passwords do not match', Colors.red);
      return;
    }

    isLoading = true;
    try {
      final user = await _authService.signUp(
        nameController.text,
        emailController.text,
        passwordController.text,
      );
      if (user != null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => const MainScreen(
                    userRole: '',
                  )),
        );
      } else {
        _showSnackBar(context, 'Sign Up Failed', Colors.red);
      }
    } catch (e) {
      _showSnackBar(context, e.toString(), Colors.red);
    } finally {
      isLoading = false;
    }
  }

  void navigateToLogin(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
    );
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
