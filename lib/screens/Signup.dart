// ignore_for_file: unused_local_variable, unnecessary_new

import 'package:flutter/material.dart';
// ignore: unnecessary_import
import 'package:flutter/rendering.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final TextEditingController emailcontroller = TextEditingController();
  final TextEditingController passcontroller = TextEditingController();

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
                  Column(
                    children: [
                      const Padding(
                        padding: const EdgeInsets.only(
                            top: 160, left: 40, right: 40, bottom: 15),
                        child: Text(
                          "Signup Test",
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
                          style: const TextStyle(
                              color: Colors.black, fontSize: 15),
                          keyboardType: TextInputType.emailAddress,
                          cursorColor: Colors.black,
                          controller: emailcontroller,
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
                              borderSide: const BorderSide(
                                  color: Colors.black54, width: 2),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            floatingLabelStyle: const TextStyle(
                              color: Colors.black,
                              fontSize: 18.0,
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: Colors.grey, width: 1.5),
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 20, left: 40, right: 40, bottom: 0),
                        child: TextField(
                          style: const TextStyle(
                              color: Colors.black, fontSize: 15),
                          keyboardType: TextInputType.emailAddress,
                          cursorColor: Colors.black,
                          controller: passcontroller,
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
                              borderSide: const BorderSide(
                                  color: Colors.black54, width: 2),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            floatingLabelStyle: const TextStyle(
                              color: Colors.black,
                              fontSize: 18.0,
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: Colors.grey, width: 1.5),
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
                            onPressed: () async {
                              String email = emailcontroller.text;
                              String password = passcontroller.text;
                            },
                            // ... The rest of the code for the ElevatedButton ...

                            style: ElevatedButton.styleFrom(
                                foregroundColor: Colors.white,
                                backgroundColor:
                                    const Color.fromARGB(255, 0, 0, 0),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                )),
                            child: const Text(
                              "Signup",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: double.infinity,
                        height: 60,
                      ),
                      // ignore: avoid_print
                    ],
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
        onPressed: () {
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
        },
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackbar);
  }
}
