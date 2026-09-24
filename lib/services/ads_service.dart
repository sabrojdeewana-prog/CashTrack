import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdsService {
  static const String testBannerId =
      'ca-app-pub-3940256099942544/9214589741';

  static Future<void> initialize() async {
    try {
      await MobileAds.instance.initialize();
    } catch (_) {}
  }
}
