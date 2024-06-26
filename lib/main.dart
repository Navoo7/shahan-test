import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shahan/services/NotificationController.dart';
import 'package:shahan/views/splash_screen.dart'; // Adjust import path as per your project
import 'package:firebase_messaging/firebase_messaging.dart'; // Add this import

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(
      _firebaseMessagingBackgroundHandler); // Add this line
  runApp(const Shahan());
}

// Background message handler
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print('Handling a background message: ${message.notification!.title}');
  // Handle your background message here
}

class Shahan extends StatefulWidget {
  const Shahan({Key? key});

  @override
  State<Shahan> createState() => _ShahanState();
}

NotificationServices _notificationServices = NotificationServices();

class _ShahanState extends State<Shahan> {
  @override
  void initState() {
    _notificationServices.initNotification();
    _notificationServices.forgroundMessage();
    _notificationServices.firebaseInit(context);
    _notificationServices.setupInteractMessage(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}
