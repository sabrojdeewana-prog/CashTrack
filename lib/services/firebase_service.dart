import 'package:firebase_analytics/firebase_analytics.dart';

class FirebaseService {
  static final analytics = FirebaseAnalytics.instance;

  static Future<void> transactionAdded(String type) =>
      analytics.logEvent(name: 'transaction_added', parameters: {'type': type});

  static Future<void> reportDownloaded() =>
      analytics.logEvent(name: 'report_downloaded');

  static Future<void> adminPanelOpened() =>
      analytics.logEvent(name: 'admin_panel_opened');
}
