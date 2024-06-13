import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  Future<User?> signIn(String email, String password) async {
    UserCredential userCredential = await _firebaseAuth
        .signInWithEmailAndPassword(email: email, password: password);
    return userCredential.user;
  }

  Future<void> saveUserData(User user) async {
    DocumentSnapshot userDoc =
        await _firebaseFirestore.collection('Accounts').doc(user.uid).get();

    if (userDoc.exists) {
      Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('email', userData['email']);
      await prefs.setString('name', userData['name']);
      await prefs.setString('role', userData['role']);
    }
  }

  Future<Map<String, String?>> getUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? email = prefs.getString('email');
    String? name = prefs.getString('name');
    String? role = prefs.getString('role');
    return {'email': email, 'name': name, 'role': role};
  }

  Future<void> addWorker(
      String name, String email, String password, String role) async {
    try {
      UserCredential userCredential =
          await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      await _firebaseFirestore
          .collection('Accounts')
          .doc(userCredential.user!.uid)
          .set({
        'name': name,
        'email': email,
        'role': role,
        'password': password
      });
    } catch (e) {
      throw Exception('Error adding worker: $e');
    }
  }

  Future<Map<String, dynamic>?> getWorkerDetails(String workerId) async {
    try {
      DocumentSnapshot workerSnapshot =
          await _firebaseFirestore.collection('Accounts').doc(workerId).get();
      if (workerSnapshot.exists) {
        return workerSnapshot.data() as Map<String, dynamic>;
      }
      return null;
    } catch (e) {
      throw Exception('Error fetching worker details: $e');
    }
  }
}
