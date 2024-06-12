// ignore_for_file: use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
// ignore: unnecessary_import
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:shahan/auth_services/auth_services.dart';
import 'package:shahan/screens/MainScreen.dart';
import 'package:shahan/screens/Signup.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController _emailcontroller = TextEditingController();
  final TextEditingController _passcontroller = TextEditingController();
  String mytext = '';
  final AuthService _authService = AuthService();
  bool _isLoading = false;
  Future<void> _login() async {
    setState(() {
      _isLoading = true;
    });

    try {
      User? user = await _authService.signIn(
          _emailcontroller.text, _passcontroller.text);
      if (user != null) {
        await _authService.saveUserData(user);
        // Navigate to the next screen, for example:
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const MainScreen()));
      } else {
        _showSnackBar(context, 'Login Failed', Colors.red);
      }
    } catch (e) {
      _showSnackBar(context, e.toString(), Colors.red);
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: GestureDetector(
            onTap: () {
              FocusScope.of(context).requestFocus(new FocusNode());
            },
            child: SingleChildScrollView(
              reverse: true,
              child: Column(
                children: [
                  const Padding(
                    padding: const EdgeInsets.only(
                        top: 160, left: 40, right: 40, bottom: 15),
                    child: Text(
                      "Login Test",
                      style: TextStyle(
                          color: Colors.black87,
                          fontSize: 50,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 40, left: 40, right: 40, bottom: 0),
                    child: TextField(
                      style: const TextStyle(color: Colors.black, fontSize: 15),
                      keyboardType: TextInputType.emailAddress,
                      cursorColor: Colors.black,
                      controller: _emailcontroller,
                      decoration: InputDecoration(
                        counterText: '',
                        contentPadding: const EdgeInsets.only(
                          top: 25,
                          bottom: 2,
                          right: 0,
                          left: 20,
                        ),
                        hintText: 'EMAIL',
                        hintStyle: const TextStyle(
                          color: Colors.grey,
                          fontSize: 14,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                              const BorderSide(color: Colors.black54, width: 2),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        floatingLabelStyle: const TextStyle(
                          color: Colors.black,
                          fontSize: 18.0,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              const BorderSide(color: Colors.grey, width: 1.5),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 20, left: 40, right: 40, bottom: 0),
                    child: TextField(
                      style: const TextStyle(color: Colors.black, fontSize: 15),
                      keyboardType: TextInputType.emailAddress,
                      cursorColor: Colors.black,
                      controller: _passcontroller,
                      decoration: InputDecoration(
                        counterText: '',
                        contentPadding: const EdgeInsets.only(
                          top: 25,
                          bottom: 2,
                          right: 0,
                          left: 20,
                        ),
                        hintText: 'PASSWORD',
                        hintStyle: const TextStyle(
                          color: Colors.grey,
                          fontSize: 14,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                              const BorderSide(color: Colors.black54, width: 2),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        floatingLabelStyle: const TextStyle(
                          color: Colors.black,
                          fontSize: 18.0,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              const BorderSide(color: Colors.grey, width: 1.5),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 30),
                    child: SizedBox(
                      height: 40,
                      width: 200,
                      child: ElevatedButton(
                        onPressed: _login,
                        // ... The rest of the code for the ElevatedButton ...

                        style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: const Color.fromARGB(255, 0, 0, 0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            )),
                        child: _isLoading
                            ? const SizedBox(
                                height: 20.0,
                                width: 20.0,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : const Text(
                                "Login",
                                style: TextStyle(color: Colors.white),
                              ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 160,
                    width: double.infinity,
                  ),
                  // ignore: avoid_print
                  InkWell(
                    onTap: () {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const Signup()));
                    },
                    child: const Text(
                      "SignUp Test",
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                ],
              ),
            )),
      ),
    );
  }

  void _showSnackBar(
    BuildContext context,
    String Message,
    Color backgroundcolor,
  ) {
    final snackbar = SnackBar(
      content: Text(Message),
      duration: const Duration(seconds: 1),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      action: SnackBarAction(
        label: 'Dismiss',
        textColor: Colors.white,
        backgroundColor: Colors.red,
        onPressed: () {
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
        },
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackbar);
  }
}
