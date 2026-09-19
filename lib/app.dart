import 'package:flutter/material.dart';

class CashTrackApp extends StatelessWidget {
  const CashTrackApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CashTrack',
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('CashTrack'),
        ),
        body: const Center(
          child: Text(
            'CashTrack is working!',
            style: TextStyle(fontSize: 24),
          ),
        ),
      ),
    );
  }
}
