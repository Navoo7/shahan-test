import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CollectionScreen extends StatelessWidget {
  const CollectionScreen({Key? key, required this.role}) : super(key: key);

  final String role;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Collection: $role'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection(role).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            // Print error details for debugging
            print('Error: ${snapshot.error}');
            return Text('Error: ${snapshot.error}');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No data available'));
          }

          // Print document count for debugging
          print('Document count: ${snapshot.data!.docs.length}');

          return ListView(
            children: snapshot.data!.docs.map((DocumentSnapshot document) {
              Map<String, dynamic> data =
                  document.data() as Map<String, dynamic>;
              return ListTile(
                title: Text(data['name'] ?? ''), // Change to 'name'
                subtitle: Text(data['time'] ?? ''), // Change to 'time'
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
