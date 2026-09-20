import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleAuthService {
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final GoogleSignIn _googleSignIn = GoogleSignIn.instance;

  static bool _initialized = false;

  static Future<void> initialize() async {
    if (_initialized) return;

    await _googleSignIn.initialize(
      serverClientId:
          '85634229200-litehps7csgknvc3nvbrhcii75nodftj.apps.googleusercontent.com',
    );

    _initialized = true;
  }

  static Future<UserCredential> signInWithGoogle() async {
    try {
      await initialize();

      final GoogleSignInAccount googleUser =
          await _googleSignIn.authenticate();

      final GoogleSignInAuthentication googleAuth =
          googleUser.authentication;

      final String? idToken = googleAuth.idToken;

      if (idToken == null || idToken.isEmpty) {
        throw Exception(
          'GOOGLE_ID_TOKEN_MISSING: Google did not return an ID token.',
        );
      }

      final credential = GoogleAuthProvider.credential(
        idToken: idToken,
      );

      return await _auth.signInWithCredential(credential);
    } on GoogleSignInException catch (e) {
      throw Exception(
        'GOOGLE_SIGN_IN_ERROR: code=${e.code}, message=${e.description}',
      );
    } on FirebaseAuthException catch (e) {
      throw Exception(
        'FIREBASE_AUTH_ERROR: code=${e.code}, message=${e.message}',
      );
    } catch (e) {
      throw Exception('GOOGLE_LOGIN_ERROR: $e');
    }
  }

  static Future<void> signOut() async {
    await _auth.signOut();

    try {
      await _googleSignIn.signOut();
    } catch (_) {}
  }

  static User? get currentUser => _auth.currentUser;

  static bool get isAdmin =>
      currentUser?.email?.toLowerCase() ==
      'sabrojalam54321@gmail.com';
}
