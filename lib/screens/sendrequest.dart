import 'package:flutter/material.dart';
import 'package:shahan/auth_services/Send_Request_Services.dart';

class SendAccountRequestScreen extends StatefulWidget {
  const SendAccountRequestScreen({Key? key}) : super(key: key);

  @override
  State<SendAccountRequestScreen> createState() =>
      _SendAccountRequestScreenState();
}

class _SendAccountRequestScreenState extends State<SendAccountRequestScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _issueController = TextEditingController();
  final TextEditingController _floorController = TextEditingController();
  final RequestService _requestService = RequestService();
  bool _isLoading = false;

  Future<void> _AccountRequest() async {
    if (_nameController.text.isEmpty ||
        _emailController.text.isEmpty ||
        _issueController.text.isEmpty ||
        _floorController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill in all fields')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      await _requestService.sendUserRequest({
        'name': _nameController.text,
        'email': _emailController.text,
        'issue': _issueController.text,
        'floor': _floorController.text,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Request sent successfully')),
      );

      _nameController.clear();
      _emailController.clear();
      _issueController.clear();
      _floorController.clear();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error sending request: $e')),
      );
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Send Request'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        reverse: true,
        child: Column(
          children: [
            const Padding(
              padding:
                  EdgeInsets.only(top: 40, left: 40, right: 40, bottom: 15),
              child: Text(
                "Fill Your Data",
                style: TextStyle(
                    color: Colors.black87,
                    fontSize: 24,
                    fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
              child: TextField(
                style: const TextStyle(color: Colors.black, fontSize: 15),
                keyboardType: TextInputType.text,
                cursorColor: Colors.black,
                controller: _nameController,
                decoration: InputDecoration(
                  counterText: '',
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 25,
                    horizontal: 20,
                  ),
                  hintText: 'Name',
                  hintStyle: const TextStyle(
                    color: Colors.grey,
                    fontSize: 14,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide:
                        const BorderSide(color: Colors.black54, width: 2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide:
                        const BorderSide(color: Colors.grey, width: 1.5),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
              child: TextField(
                style: const TextStyle(color: Colors.black, fontSize: 15),
                keyboardType: TextInputType.emailAddress,
                cursorColor: Colors.black,
                controller: _emailController,
                decoration: InputDecoration(
                  counterText: '',
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 25,
                    horizontal: 20,
                  ),
                  hintText: 'Email',
                  hintStyle: const TextStyle(
                    color: Colors.grey,
                    fontSize: 14,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide:
                        const BorderSide(color: Colors.black54, width: 2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide:
                        const BorderSide(color: Colors.grey, width: 1.5),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
              child: TextField(
                style: const TextStyle(color: Colors.black, fontSize: 15),
                keyboardType: TextInputType.text,
                cursorColor: Colors.black,
                controller: _issueController,
                decoration: InputDecoration(
                  counterText: '',
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 25,
                    horizontal: 20,
                  ),
                  hintText: 'Issue',
                  hintStyle: const TextStyle(
                    color: Colors.grey,
                    fontSize: 14,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide:
                        const BorderSide(color: Colors.black54, width: 2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide:
                        const BorderSide(color: Colors.grey, width: 1.5),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
              child: TextField(
                style: const TextStyle(color: Colors.black, fontSize: 15),
                keyboardType: TextInputType.text,
                cursorColor: Colors.black,
                controller: _floorController,
                decoration: InputDecoration(
                  counterText: '',
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 25,
                    horizontal: 20,
                  ),
                  hintText: 'Floor',
                  hintStyle: const TextStyle(
                    color: Colors.grey,
                    fontSize: 14,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide:
                        const BorderSide(color: Colors.black54, width: 2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide:
                        const BorderSide(color: Colors.grey, width: 1.5),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 30),
              child: SizedBox(
                height: 40,
                width: 200,
                child: ElevatedButton(
                  onPressed: _AccountRequest,
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: const Color.fromARGB(255, 0, 0, 0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          height: 20.0,
                          width: 20.0,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Text(
                          "Send Report",
                          style: TextStyle(color: Colors.white),
                        ),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
