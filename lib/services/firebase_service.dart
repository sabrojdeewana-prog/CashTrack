import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseService {
  static final analytics = FirebaseAnalytics.instance;
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static Future<void> initializeUserActivity() async {
    try {
      User? user = _auth.currentUser;

      if (user == null) {
        final credential = await _auth.signInAnonymously();
        user = credential.user;
      }

      if (user == null) return;

      final now = DateTime.now().toUtc();
      final dayId =
          '${now.year.toString().padLeft(4, '0')}-'
          '${now.month.toString().padLeft(2, '0')}-'
          '${now.day.toString().padLeft(2, '0')}';

      await _firestore
          .collection('user_activity')
          .doc(user.uid)
          .set({
        'lastActiveAt': FieldValue.serverTimestamp(),
        'createdAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      await _firestore
          .collection('user_activity')
          .doc(user.uid)
          .collection('days')
          .doc(dayId)
          .set({
        'activeAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    } catch (_) {
      // Analytics/activity tracking must never break the app.
    }
  }

  static Future<void> _recordEvent(
    String eventName, {
    Map<String, Object>? data,
  }) async {
    try {
      await analytics.logEvent(
        name: eventName,
        parameters: data,
      );
    } catch (_) {
      // Analytics must not break the app.
    }
  }

  static Future<void> transactionAdded(String type) =>
      _recordEvent(
        'transaction_added',
        data: {'type': type},
      );

  static Future<void> reportDownloaded() =>
      _recordEvent('report_downloaded');

  static Future<void> adminPanelOpened() =>
      _recordEvent('admin_panel_opened');

  static Future<void> calculatorToolUsed(String tool) =>
      _recordEvent(
        'calculator_tool_used',
        data: {'tool': tool},
      );
}
