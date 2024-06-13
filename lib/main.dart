// ignore_for_file: unnecessary_const

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
// import 'package:shahan/sadqew.dart';
import 'package:shahan/screens/Splash_Screen.dart';
import 'package:shahan/firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const Shahan());
}

class Shahan extends StatelessWidget {
  const Shahan({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreeen(),
    );
  }
}
