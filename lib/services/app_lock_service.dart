import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:local_auth/local_auth.dart';

class AppLockService {
  static const String _enabledKey = 'app_lock_enabled';
  static const FlutterSecureStorage _storage = FlutterSecureStorage();
  static final LocalAuthentication _auth = LocalAuthentication();

  static Future<bool> isEnabled() async {
    final value = await _storage.read(key: _enabledKey);
    return value == 'true';
  }

  static Future<void> enable() async {
    await _storage.write(key: _enabledKey, value: 'true');
  }

  static Future<void> disable() async {
    await _storage.delete(key: _enabledKey);
  }

  static Future<bool> authenticate() async {
    try {
      final supported = await _auth.isDeviceSupported();
      if (!supported) return false;

      return await _auth.authenticate(
        localizedReason: 'Unlock CashTrack to view your financial data',
        options: const AuthenticationOptions(
          biometricOnly: false,
          stickyAuth: true,
          useErrorDialogs: true,
          sensitiveTransaction: true,
        ),
      );
    } catch (_) {
      return false;
    }
  }
}
