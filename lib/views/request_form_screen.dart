import 'package:flutter/material.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Request'),
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
              onPressed: () => _controller.createRequest(context),
            ),
          ],
        ),
      ),
    );
  }
}
