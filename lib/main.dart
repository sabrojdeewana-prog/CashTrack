import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Firebase.initializeApp();
    runApp(const CashTrackApp());
  } catch (e) {
    runApp(
      CashTrackApp(
        firebaseError: e.toString(),
      ),
    );
  }
}
