import 'package:firebase_auth/firebase_auth.dart';

class AuthModel {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<String?> login(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      return null;
    } on FirebaseAuthException catch (e) {
      return getErrorMessage(e);
    }
  }

  Future<String?> signUp(String email, String password) async {
    try {
      await _auth.createUserWithEmailAndPassword(email: email, password: password);
      return null;
    } on FirebaseAuthException catch (e) {
      return getErrorMessage(e);
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  Stream<User?> authStateChanges() => _auth.authStateChanges();

  User? get currentUser => _auth.currentUser;

  String getErrorMessage(FirebaseAuthException e) {
    switch (e.code) {
      case 'invalid-email':
        return 'This email address is not valid.';
      
      case 'user-not-found':
      case 'wrong-password':
      case 'invalid-credential':
        return 'Invalid email or password.';

      case 'email-already-in-use':
        return 'An account with this email is already in use.';

      default:
        return 'An unknown error occurred. Please try again.';
    }
  }
}