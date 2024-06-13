import 'package:flutter/material.dart';
import 'package:shahan/auth_services/auth_services.dart';
import 'package:shahan/screens/AccountRequest.dart';
import 'package:shahan/screens/AddWorkers.dart';
import 'package:shahan/screens/BarberRequest.dart';
import 'package:shahan/screens/CollectionScreen.dart';
import 'package:shahan/screens/sendrequest.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthService _authService = AuthService();

    return Scaffold(
      body: Center(
        child: FutureBuilder<Map<String, String?>>(
          future: _authService.getUserData(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return SizedBox(
                height: 80,
                width: 80,
                child: CircularProgressIndicator(
                  color: Colors.black,
                ),
              );
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else if (snapshot.hasData) {
              final userData = snapshot.data!;
              final userRole = userData['role'] ?? '';
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Login Successful',
                    style: TextStyle(fontSize: 24, color: Colors.black),
                  ),
                  SizedBox(height: 20),
                  Text('Email: ${userData['email'] ?? 'N/A'}'),
                  Text('Name: ${userData['name'] ?? 'N/A'}'),
                  Text('Role: ${userData['role'] ?? 'N/A'}'),
                  SizedBox(
                    height: 20,
                    width: double.infinity,
                  ),
                  if (userRole != 'user')
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                CollectionScreen(role: userRole),
                          ),
                        );
                      },
                      child: Text('Notificastion'),
                    ),
                  SizedBox(
                    height: 20,
                    width: double.infinity,
                  ),
                  if (userRole == 'admin')
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AccountRequestScreen(),
                          ),
                        );
                      },
                      child: Text('Account Request'),
                    ),
                  SizedBox(
                    height: 20,
                    width: double.infinity,
                  ),
                  if (userRole == 'admin')
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AddWorkerScreen(),
                          ),
                        );
                      },
                      child: Text('Worker Account Add'),
                    ),
                  SizedBox(
                    height: 20,
                    width: double.infinity,
                  ),
                  if (userRole == 'user')
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SendAccountRequestScreen(),
                          ),
                        );
                      },
                      child: Text('Account Rerquest Report'),
                    ),
                  if (userRole == 'user')
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SendBarberRequestScreen(),
                          ),
                        );
                      },
                      child: Text('Barber Request'),
                    ),
                ],
              );
            } else {
              return Text('No data available');
            }
          },
        ),
      ),
    );
  }
}
