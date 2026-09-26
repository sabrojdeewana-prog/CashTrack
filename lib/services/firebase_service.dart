import 'package:firebase_analytics/firebase_analytics.dart';

class FirebaseService {
  static final analytics = FirebaseAnalytics.instance;

  static Future<void> _recordEvent(
    String eventName, {
    Map<String, dynamic>? data,
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
