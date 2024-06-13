// ignore_for_file: file_names, unnecessary_import

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:shahan/screens/Login.dart';
import 'package:shahan/core/MyImage.dart';

class SplashScreeen extends StatefulWidget {
  const SplashScreeen({super.key});

  @override
  State<SplashScreeen> createState() => _SplashScreeenState();
}

class _SplashScreeenState extends State<SplashScreeen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Timer(
        const Duration(seconds: 2),
        () => Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => const Login())));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        reverse: false,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(
                width: double.infinity,
                height: 140,
              ),
              Image.asset(
                MyImage.minuspluas,
                scale: 1.1,
              ),
              const SizedBox(
                width: double.infinity,
                height: 240,
              ),
              // const SpinKitCubeGrid(
              //   size: 35,
              //   color: Colors.black,
              // )
              Image.asset(MyImage.noti)
            ],
          ),
        ),
      ),
    );
  }
}
