import 'package:flutter/material.dart';
import 'package:shahan/controllers/splash_controller.dart';
import 'package:shahan/core/MyImage.dart';
import 'package:shahan/services/NotificationController.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final SplashController _controller = SplashController();
  // NotificationServices _notificationServices = NotificationServices();

  @override
  void initState() {
    super.initState();
    _controller.startTimer(context);
    // _notificationServices.initNotification();
    // _notificationServices.forgroundMessage();
    // _notificationServices.firebaseInit(context);
    // _notificationServices.setupInteractMessage(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 140),
            Image.asset(MyImage.minuspluas, scale: 1.1),
            const SizedBox(height: 240),
            Image.asset(MyImage.noti),
          ],
        ),
      ),
    );
  }
}
