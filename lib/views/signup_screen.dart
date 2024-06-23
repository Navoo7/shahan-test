import 'package:flutter/material.dart';
import 'package:shahan/controllers/signup_controller.dart';
import 'package:shahan/widgets/custom_button.dart';
import 'package:shahan/widgets/custom_text_field.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final SignUpController _controller = SignUpController();

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
                      top: 160, left: 40, right: 40, bottom: 15),
                  child: Text(
                    "SignUp Test",
                    style: TextStyle(
                      color: Colors.black87,
                      fontSize: 50,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      top: 40, left: 40, right: 40, bottom: 0),
                  child: CustomTextField(
                    controller: _controller.emailController,
                    hintText: 'EMAIL',
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      top: 20, left: 40, right: 40, bottom: 0),
                  child: CustomTextField(
                    controller: _controller.passwordController,
                    hintText: 'PASSWORD',
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      top: 20, left: 40, right: 40, bottom: 0),
                  child: CustomTextField(
                    controller: _controller.confirmPasswordController,
                    hintText: 'CONFIRM PASSWORD',
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 30),
                  child: CustomButton(
                    title: 'Sign Up',
                    isLoading: _controller.isLoading,
                    onPressed: () => _controller.signUp(context),
                  ),
                ),
                const SizedBox(height: 160, width: double.infinity),
                InkWell(
                  onTap: () => _controller.navigateToLogin(context),
                  child: const Text(
                    "Login Test",
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
