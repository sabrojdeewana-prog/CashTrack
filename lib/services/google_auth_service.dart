import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleAuthService {
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final GoogleSignIn _googleSignIn = GoogleSignIn.instance;

  static Future<void> initialize() async {
    await _googleSignIn.initialize(serverClientId: '85634229200-litehps7csgknvc3nvbrhcii75nodftj.apps.googleusercontent.com');
  }

  static Future<UserCredential?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount googleUser =
          await _googleSignIn.authenticate();

      final GoogleSignInAuthentication googleAuth =
          googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
      );

      return await _auth.signInWithCredential(credential);
    } on GoogleSignInException catch (e) { print("GOOGLE_SIGN_IN_ERROR: $e");
      return null;
    } on FirebaseAuthException {
      return null;
    } catch (_) {
      return null;
    }
  }

  static Future<void> signOut() async {
    await _auth.signOut();
    await _googleSignIn.signOut();
  }

  static User? get currentUser => _auth.currentUser;

  static bool get isAdmin =>
      currentUser?.email?.toLowerCase() ==
      'sabrojalam54321@gmail.com';
}
