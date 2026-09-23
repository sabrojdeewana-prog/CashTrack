import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

class CashTrackApp extends StatelessWidget {
  final String? firebaseError;

  const CashTrackApp({super.key, this.firebaseError});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CashTrack',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
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
                    'Firebase initialization failed:\n\n$firebaseError',
                    style: const TextStyle(fontSize: 15),
                  ),
                ),
              ),
            )
          : const HomeScreen(),
    );
  }
}
