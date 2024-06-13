import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class Na extends StatefulWidget {
  const Na({super.key});

  @override
  State<Na> createState() => _NaState();
}

class _NaState extends State<Na> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    var collection = FirebaseFirestore.instance.collection('programmer');
    collection.doc('B6SxXDkff8e3tWjZM7IN').update({
      'VSFDAVRWEA': FieldValue.delete(),
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text('deleting'),
    );
  }
}
