import 'package:flutter/material.dart';
import 'package:shahan/controllers/main_controller.dart';
import 'package:shahan/controllers/request_from_controller.dart';
import 'package:shahan/widgets/custom_button.dart';
import 'package:shahan/widgets/custom_text_field.dart';

class RequestFormScreen extends StatefulWidget {
  const RequestFormScreen({Key? key}) : super(key: key);

  @override
  State<RequestFormScreen> createState() => _RequestFormScreenState();
}

class _RequestFormScreenState extends State<RequestFormScreen> {
  final RequestFormController _controller = RequestFormController();
  final MainController _maincontroller = MainController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Account Request Screen'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              _maincontroller.signOut(context);
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            CustomTextField(
              controller: _controller.titleController,
              hintText: 'Title',
            ),
            const SizedBox(height: 16.0),
            CustomTextField(
              controller: _controller.descriptionController,
              hintText: 'Description',
            ),
            const SizedBox(height: 32.0),
            CustomButton(
                title: 'Create Request',
                isLoading: _controller.isLoading,
                onPressed: () {
                  if (_controller.titleController.text.isEmpty ||
                      _controller.descriptionController.text.isEmpty) {
                    _showSnackBar(
                        context, 'please fill the required field', Colors.red);
                  } else {
                    _controller.createRequest(context);
                  }
                }),
          ],
        ),
      ),
    );
  }
}

void _showSnackBar(
    BuildContext context, String message, Color backgroundColor) {
  final snackBar = SnackBar(
    content: Text(message),
    backgroundColor: backgroundColor,
  );
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
