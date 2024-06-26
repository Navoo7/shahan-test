import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shahan/models/user_model.dart';
import 'package:shahan/services/NotificationController.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final NotificationServices _notificationServices = NotificationServices();

  Future<UserModel?> signIn(String email, String password) async {
    try {
      UserCredential userCredential =
          await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      await _saveLoginState(true);
      return _userFromFirebase(userCredential.user);
    } catch (e) {
      rethrow;
    }
  }

  Future<User?> getCurrentUser() async {
    return _firebaseAuth.currentUser;
  }

  Future<UserModel?> signUp(String name, String email, String password) async {
    try {
      UserCredential userCredential =
          await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Save user data to Firestore
      await _firestore
          .collection('accounts')
          .doc(userCredential.user!.uid)
          .set({
        'name': name,
        'email': email,
        'role': 'user',
      });

      await _saveLoginState(true);
      return _userFromFirebase(userCredential.user);
    } catch (e) {
      rethrow;
    }
  }

  Future<UserModel?> _userFromFirebase(User? firebaseUser) async {
    if (firebaseUser == null) return null;

    DocumentSnapshot userDoc =
        await _firestore.collection('accounts').doc(firebaseUser.uid).get();

    if (userDoc.exists) {
      Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;
      return UserModel(
        uid: firebaseUser.uid,
        email: userData['email'],
        name: userData['name'],
        role: userData['role'],
      );
    }

    return null;
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
    await _notificationServices.unsubscribeFromTopics();
    await _saveLoginState(false);
  }

  Future<void> _saveLoginState(bool isLoggedIn) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', isLoggedIn);
  }
}
