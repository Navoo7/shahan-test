import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shahan/views/login_screen.dart';

class SplashController {
  void startTimer(BuildContext context) {
    Timer(
      const Duration(seconds: 2),
      () => Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      ),
    );
  }
}
