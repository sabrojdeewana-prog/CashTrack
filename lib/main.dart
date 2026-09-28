import 'package:firebase_core/firebase_core.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:flutter/material.dart';

import 'app.dart';
import 'services/firebase_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await MobileAds.instance.initialize();

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
