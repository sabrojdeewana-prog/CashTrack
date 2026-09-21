import 'package:shared_preferences/shared_preferences.dart';

class AppLockService {
  static const String _enabledKey = 'app_lock_enabled';
  static const String _pinKey = 'app_lock_pin';

  static Future<bool> isEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_enabledKey) ?? false;
  }

  static Future<String?> getPin() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_pinKey);
  }

  static Future<void> enable(String pin) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_pinKey, pin);
    await prefs.setBool(_enabledKey, true);
  }

  static Future<void> disable() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_enabledKey, false);
    await prefs.remove(_pinKey);
  }

  static Future<bool> verify(String pin) async {
    final savedPin = await getPin();
    return savedPin != null && savedPin == pin;
  }
}
