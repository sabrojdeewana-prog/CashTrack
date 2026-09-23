import 'package:flutter/material.dart';
import 'app.dart';
import 'services/ads_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // AdMob is optional. Any AdMob failure must not stop CashTrack.
  await AdsService.initialize();

  runApp(const CashTrackApp());
}
