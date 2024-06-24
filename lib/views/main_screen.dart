import 'package:flutter/material.dart';
import 'package:shahan/controllers/main_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shahan/views/account_request_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key, required this.userRole}) : super(key: key);

  final String userRole;

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final MainController _controller =
      MainController(); // Use your main controller instance
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onControllerUpdate); // Add listener for updates
  }

  @override
  void dispose() {
    _controller
        .removeListener(_onControllerUpdate); // Remove listener on dispose
    super.dispose();
  }

  void _onControllerUpdate() {
    setState(() {}); // Refresh UI on controller updates
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Main Screen'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              _controller.signOut(context);
            },
          ),
        ],
      ),
      body: _buildBody(widget.userRole),
      floatingActionButton: widget.userRole == 'worker'
          ? null
          : FloatingActionButton(
              onPressed: () {
                // Example of using currentUser:
                print(_controller.currentUser?.email);
              },
              child: const Icon(Icons.add),
            ),
    );
  }

  Widget _buildBody(String userRole) {
    switch (userRole) {
      case 'admin':
        return ListView(
          children: [
            _buildCard(
                'Account Requests', Icons.account_box, _viewAccountRequests),
            _buildCard(
                'Other Requests', Icons.request_page, _viewOtherRequests),
            _buildCard('Send Notifications', Icons.notification_important,
                _sendNotifications),
            _buildCard(
                'Notifications', Icons.notifications, _viewNotifications),
            _buildCard('Add Alert', Icons.add_alert, _addAlert),
          ],
        );
      case 'user':
        return ListView(
          children: [
            _buildCard('My Orders', Icons.shopping_cart, _viewUserOrders),
            _buildCard(
                'Account Requests', Icons.account_box, _viewAccountRequests),
            _buildCard('Send Request', Icons.send, _sendRequest),
            _buildCard(
                'Notifications', Icons.notifications, _viewNotifications),
          ],
        );
      case 'worker':
        return StreamBuilder<QuerySnapshot>(
          stream: _db
              .collection('workers')
              .doc(_controller.currentUser?.uid)
              .collection('orders')
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }
            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return Center(child: Text('No orders found.'));
            }

            List<DocumentSnapshot> docs = snapshot.data!.docs;

            return ListView.builder(
              itemCount: docs.length,
              itemBuilder: (context, index) {
                Map<String, dynamic> data =
                    docs[index].data() as Map<String, dynamic>;
                String docId = docs[index].id;
                return _buildOrderCard(data, docId);
              },
            );
          },
        );
      default:
        return Center(child: Text('Unsupported user role: $userRole'));
    }
  }

  Widget _buildCard(String title, IconData icon, VoidCallback onTap) {
    return Card(
      margin: const EdgeInsets.all(10),
      child: ListTile(
        leading: Icon(icon, size: 40),
        title: Text(title,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        onTap: onTap,
      ),
    );
  }

  Widget _buildOrderCard(Map<String, dynamic> data, String docId) {
    return Card(
      margin: const EdgeInsets.all(10),
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Order ID: $docId',
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                Text('Customer: ${data['customerName']}',
                    style: TextStyle(fontSize: 16)),
              ],
            ),
            Container(
              height: 40,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.green),
                borderRadius: BorderRadius.circular(20),
              ),
              child: TextButton(
                onPressed: () => _viewOrderDetails(data, docId),
                child: Text(
                  'Open',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                      fontSize: 14),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _viewAccountRequests() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AcccountRequestScreen()),
    );
  }

  void _viewOtherRequests() {
    // Implement navigation to other requests screen
  }

  void _sendNotifications() {
    // Implement navigation to send notifications screen
  }

  void _viewNotifications() {
    // Implement navigation to view notifications screen
  }

  void _addAlert() {
    // Implement adding alert functionality
  }

  void _viewUserOrders() {
    // Implement navigation to user's orders screen
  }

  void _sendRequest() {
    // Implement navigation to send request screen
  }

  void _viewOrderDetails(Map<String, dynamic> data, String docId) {
    // Implement navigation to order details screen
  }
}
