import 'package:flutter/material.dart';

import 'screens/home_screen.dart';
import 'services/app_lock_service.dart';

class CashTrackApp extends StatelessWidget {
  final String? firebaseError;

  const CashTrackApp({
    super.key,
    this.firebaseError,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CashTrack',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
        ),
        useMaterial3: true,
      ),
      home: firebaseError != null
          ? Scaffold(
              appBar: AppBar(
                title: const Text('CashTrack Error'),
              ),
              body: Padding(
                padding: const EdgeInsets.all(20),
                child: SingleChildScrollView(
                  child: Text(
                    'Firebase initialization failed:\n\n'
                    '$firebaseError',
                    style: const TextStyle(fontSize: 15),
                  ),
                ),
              ),
            )
          : const AppLockGate(),
    );
  }
}

class AppLockGate extends StatefulWidget {
  const AppLockGate({super.key});

  @override
  State<AppLockGate> createState() => _AppLockGateState();
}

class _AppLockGateState extends State<AppLockGate>
    with WidgetsBindingObserver {
  bool _checking = true;
  bool _unlocked = false;
  bool _authenticating = false;
  bool _firstResumeIgnored = false;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addObserver(this);

    _checkLock();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(
    AppLifecycleState state,
  ) {
    if (state == AppLifecycleState.resumed) {
      if (_firstResumeIgnored) {
        _checkLock();
      } else {
        _firstResumeIgnored = true;
      }
    }
  }

  Future<void> _checkLock() async {
    if (_authenticating) return;

    final enabled = await AppLockService.isEnabled();

    if (!enabled) {
      if (!mounted) return;

      setState(() {
        _checking = false;
        _unlocked = true;
      });

      return;
    }

    if (!mounted) return;

    setState(() {
      _checking = false;
      _unlocked = false;
      _authenticating = true;
    });

    final authenticated =
        await AppLockService.authenticate();

    if (!mounted) return;

    setState(() {
      _authenticating = false;
      _unlocked = authenticated;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_checking) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (!_unlocked) {
      return Scaffold(
        body: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.fingerprint,
                    size: 80,
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'CashTrack Locked',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Use your fingerprint to unlock CashTrack.',
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  FilledButton.icon(
                    onPressed:
                        _authenticating ? null : _checkLock,
                    icon: const Icon(Icons.fingerprint),
                    label: const Text('Unlock'),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    return const HomeScreen();
  }
}
