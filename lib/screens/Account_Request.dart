import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AccountRequestForm extends StatefulWidget {
  @override
  _AccountRequestFormState createState() => _AccountRequestFormState();
}

class _AccountRequestFormState extends State<AccountRequestForm> {
  final _formKey = GlobalKey<FormState>();
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> _submitRequest() async {
    if (_formKey.currentState!.validate()) {
      try {
        await _db
            .collection('admin')
            .doc('accountrequest')
            .collection('requests')
            .add({
          'name': _nameController.text,
          'email': _emailController.text,
          'location': _locationController.text,
          'password': _passwordController.text,
          'approved': false,
          'timestamp': FieldValue.serverTimestamp(),
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Account request submitted successfully')),
        );

        _nameController.clear();
        _emailController.clear();
        _locationController.clear();
        _passwordController.clear();
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to submit account request: $e')),
        );
      }
    }
  }

  Widget _buildTextField(
      TextEditingController controller, String hintText, bool obscureText) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        style: const TextStyle(color: Colors.black, fontSize: 15),
        decoration: InputDecoration(
          counterText: '',
          contentPadding:
              const EdgeInsets.symmetric(vertical: 25, horizontal: 20),
          hintText: hintText,
          hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.black54, width: 2),
            borderRadius: BorderRadius.circular(10),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.grey, width: 1.5),
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        validator: (value) {
          if (value!.isEmpty) {
            return 'Please enter your $hintText';
          }
          return null;
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Account Request')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              _buildTextField(_nameController, 'Name', false),
              _buildTextField(_emailController, 'Email', false),
              _buildTextField(_locationController, 'Location', false),
              _buildTextField(_passwordController, 'Password', true),
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: ElevatedButton(
                  onPressed: _submitRequest,
                  child: Text('Submit Request'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
