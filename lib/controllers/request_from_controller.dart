import 'package:flutter/material.dart';
import 'package:shahan/models/request_model.dart';
import 'package:shahan/services/request_service.dart';

class RequestFormController {
  final RequestService _requestService = RequestService();
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  bool isLoading = false;

  Future<void> createRequest(BuildContext context) async {
    isLoading = true;
    try {
      // Validate input (if needed)
      if (titleController.text.isEmpty || descriptionController.text.isEmpty) {
        _showSnackBar(context, 'Please fill in all fields', Colors.red);
        return;
      }

      // Prepare request data
      RequestModel requestData = RequestModel(
        id: '', // Firestore will assign an ID
        title: titleController.text,
        description: descriptionController.text,
        userId: 'current_user_id', // Replace with actual user ID logic
      );

      // Call service to create request
      await _requestService.createRequest(requestData);

      // Navigate back or perform other actions after request creation
      Navigator.pop(context, true);
    } catch (e) {
      _showSnackBar(context, 'Failed to create request', Colors.red);
    } finally {
      isLoading = false;
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
}






// class RequestModel {
//   final String id;
//   final String name;
//   final String email;
//   final String task;
//   final String details;
//   final String workerType;
//   final bool approved;

//   RequestModel({
//     required this.id,
//     required this.name,
//     required this.email,
//     required this.task,
//     required this.details,
//     required this.workerType,
//     required this.approved,
//     required String userId,
//   });

//   factory RequestModel.fromMap(Map<String, dynamic> data, String id) {
//     return RequestModel(
//       id: id,
//       name: data['name'] ?? '',
//       email: data['email'] ?? '',
//       task: data['task'] ?? '',
//       details: data['details'] ?? '',
//       workerType: data['workerType'] ?? '',
//       approved: data['approved'] ?? false,
//       userId: '',
//     );
//   }

//   Map<String, dynamic> toMap() {
//     return {
//       'name': name,
//       'email': email,
//       'task': task,
//       'details': details,
//       'workerType': workerType,
//       'approved': approved,
//     };
//   }
// }
