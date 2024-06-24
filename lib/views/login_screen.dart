import 'package:flutter/material.dart';
import 'package:shahan/controllers/login_controller.dart';
import 'package:shahan/widgets/custom_button.dart';
import 'package:shahan/widgets/custom_text_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final LoginController _controller = LoginController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(FocusNode());
          },
          child: SingleChildScrollView(
            reverse: true,
            child: Column(
              children: [
                const Padding(
                  padding: EdgeInsets.only(
                    top: 160,
                    left: 40,
                    right: 40,
                    bottom: 15,
                  ),
                  child: Text(
                    "Login Test",
                    style: TextStyle(
                      color: Colors.black87,
                      fontSize: 50,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    top: 40,
                    left: 40,
                    right: 40,
                    bottom: 0,
                  ),
                  child: CustomTextField(
                    controller: _controller.emailController,
                    hintText: 'EMAIL',
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    top: 20,
                    left: 40,
                    right: 40,
                    bottom: 0,
                  ),
                  child: CustomTextField(
                    controller: _controller.passwordController,
                    hintText: 'PASSWORD',
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 30),
                  child: CustomButton(
                    title: 'Login',
                    isLoading: _controller.isLoading,
                    onPressed: () => _controller.login(context),
                  ),
                ),
                const SizedBox(height: 160, width: double.infinity),
                InkWell(
                  onTap: () => _controller.navigateToSignUp(context),
                  child: const Text(
                    "SignUp Test",
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
