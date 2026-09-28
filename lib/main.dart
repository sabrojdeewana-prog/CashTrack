import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'app.dart';
import 'services/firebase_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Firebase.initializeApp();
    await FirebaseService.initializeUserActivity();
    runApp(const CashTrackApp());
  } catch (e) {
    runApp(
      CashTrackApp(
        firebaseError: e.toString(),
      ),
    );
  }
}
