import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
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

class Shahan extends StatelessWidget {
  const Shahan({Key? key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}
