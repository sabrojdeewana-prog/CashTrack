import 'package:flutter/material.dart';
import 'app.dart';
import 'services/ads_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await AdsService.initialize();
  } catch (_) {}

  runApp(const CashTrackApp());
}
