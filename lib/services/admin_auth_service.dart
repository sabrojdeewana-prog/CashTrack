import 'package:firebase_auth/firebase_auth.dart';

class AdminAuthService {
  static final FirebaseAuth _auth = FirebaseAuth.instance;

  static const String adminEmail = 'sabrojalam54321@gmail.com';

  static User? get currentUser => _auth.currentUser;

  static bool get isSignedIn => currentUser != null;

  static bool get isAdmin =>
      currentUser?.email?.toLowerCase() == adminEmail;

  static Future<UserCredential> signIn({
    required String email,
    required String password,
  }) async {
    final normalizedEmail = email.trim().toLowerCase();

    if (normalizedEmail != adminEmail) {
      throw FirebaseAuthException(
        code: 'admin-only',
        message: 'This account is not authorized for Admin Dashboard.',
      );
    }

    return await _auth.signInWithEmailAndPassword(
      email: normalizedEmail,
      password: password,
    );
  }

  static Future<void> signOut() async {
    await _auth.signOut();
  }
}
