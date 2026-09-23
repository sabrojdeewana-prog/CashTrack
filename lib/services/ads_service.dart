import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdsService {
  static const String testBannerAdUnitId =
      'ca-app-pub-3940256099942544/6300978111';

  static BannerAd? _bannerAd;

  static Future<void> initialize() async {
    try {
      await MobileAds.instance.initialize();
    } catch (_) {
      // AdMob failure must never crash CashTrack.
    }
  }

  static Future<BannerAd?> loadTestBanner() async {
    try {
      final ad = BannerAd(
        adUnitId: testBannerAdUnitId,
        size: AdSize.banner,
        request: const AdRequest(),
        listener: BannerAdListener(
          onAdFailedToLoad: (ad, error) {
            ad.dispose();
            if (identical(_bannerAd, ad)) {
              _bannerAd = null;
            }
          },
          onAdLoaded: (ad) {
            _bannerAd = ad as BannerAd;
          },
        ),
      );

      await ad.load();
      return _bannerAd;
    } catch (_) {
      return null;
    }
  }

  static BannerAd? get bannerAd => _bannerAd;

  static void disposeBanner() {
    _bannerAd?.dispose();
    _bannerAd = null;
  }

  void showRewarded({required void Function() onComplete}) {
    onComplete();
  }
}
