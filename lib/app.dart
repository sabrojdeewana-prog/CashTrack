import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'services/app_lock_service.dart';

class CashTrackApp extends StatelessWidget {
  const CashTrackApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CashTrack',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const AppLockGate(),
    );
  }
}

class AppLockGate extends StatefulWidget {
  const AppLockGate({super.key});

  @override
  State<AppLockGate> createState() => _AppLockGateState();
}

class _AppLockGateState extends State<AppLockGate> {
  bool _loading = true;
  bool _unlocked = false;

  @override
  void initState() {
    super.initState();
    _checkLock();
  }

  Future<void> _checkLock() async {
    final enabled = await AppLockService.isEnabled();

    if (!enabled) {
      if (!mounted) return;
      setState(() {
        _loading = false;
        _unlocked = true;
      });
      return;
    }

    final authenticated = await AppLockService.authenticate();

    if (!mounted) return;
    setState(() {
      _loading = false;
      _unlocked = authenticated;
    });
  }

  Future<void> _unlock() async {
    final authenticated = await AppLockService.authenticate();

    if (!mounted) return;
    setState(() => _unlocked = authenticated);
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (!_unlocked) {
      return Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.lock_outline,
                  size: 64,
                ),
                const SizedBox(height: 16),
                const Text(
                  'CashTrack Locked',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Authenticate to access your financial data.',
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                FilledButton.icon(
                  onPressed: _unlock,
                  icon: const Icon(Icons.fingerprint),
                  label: const Text('Unlock CashTrack'),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return const HomeScreen();
  }
}
