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
            print('Error: ${snapshot.error}');
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No data available'));
          }

          print('Document count: ${snapshot.data!.docs.length}');

          return ListView(
            children: snapshot.data!.docs.map((DocumentSnapshot document) {
              Map<String, dynamic> data =
                  document.data() as Map<String, dynamic>;

              return Card(
                color: Colors.black87,
                margin: EdgeInsets.all(10),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            'Document ID:',
                            style: TextStyle(
                                fontWeight: FontWeight.w700,
                                color: Colors.blue.shade700),
                          ),
                          SizedBox(width: 15),
                          Text(
                            '${document.id}',
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                color: Colors.grey),
                          ),
                        ],
                      ),
                      ...data.entries.map((entry) {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              '${entry.key}:',
                              style: TextStyle(
                                  fontWeight: FontWeight.normal,
                                  color: Colors.blueAccent.shade100),
                            ),
                            SizedBox(width: 15),
                            Text(
                              '${entry.value}',
                              style: TextStyle(
                                  fontWeight: FontWeight.normal,
                                  color: Colors.white),
                            ),
                          ],
                        );

                        //  Text(
                        //   '${entry.key}: ${entry.value}',
                        //   style: TextStyle(
                        //       fontWeight: FontWeight.normal,
                        //       color: Colors.white),
                        // );
                      }).toList(),
                    ],
                  ),
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
