import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdsService {
  static const String bannerAdUnitId =
      'ca-app-pub-7879218515632096/1974915813';

  BannerAd createBannerAd({
    required void Function(BannerAd ad) onLoaded,
    void Function(LoadAdError error)? onFailed,
  }) {
    final ad = BannerAd(
      adUnitId: bannerAdUnitId,
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: onLoaded,
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
          onFailed?.call(error);
        },
      ),
    );

    ad.load();
    return ad;
  }

  void showRewarded({required void Function() onComplete}) {
    onComplete();
  }
}
