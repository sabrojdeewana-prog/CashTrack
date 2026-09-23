import 'package:flutter/material.dart';

class CashTrackApp extends StatelessWidget {
  const CashTrackApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'CashTrack',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('CashTrack'),
        ),
        body: const Center(
          child: Text(
            'CashTrack Test Screen',
            style: TextStyle(fontSize: 22),
          ),
        ),
      ),
    );
  }
}
