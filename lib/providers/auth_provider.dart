import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class BlogAuthProvider with ChangeNotifier {
  FirebaseAuth _auth = FirebaseAuth.instance;

  Stream<User?> get authStateChanges => _auth.authStateChanges();

  Future<User?> signUp(String email, String password) async {
    try {
      final cred = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return cred.user;
    } catch (e) {
      debugPrint("Signup error: $e");
      return null;
    }
  }

  Future<User?> login(String email, String password) async {
    try {
      final cred = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return cred.user;
    } catch (e) {
      debugPrint("Login error: $e");
      return null;
    }
  }

  Future<void> logout() async {
    await _auth.signOut();
  }
}
