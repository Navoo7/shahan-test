import 'package:flutter/material.dart';
import 'package:shahan/models/request_model.dart';

class RequestCard extends StatelessWidget {
  final RequestModel request;

  const RequestCard({required this.request, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              request.title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8.0),
            Text(request.description),
          ],
        ),
      ),
    );
  }
}
