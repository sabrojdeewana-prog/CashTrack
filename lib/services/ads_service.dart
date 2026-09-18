import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdsService {
  // Google test IDs. Replace with your production AdMob IDs before release.
  static const bannerId = 'ca-app-pub-3940256099942544/6300978111';
  static const rewardedId = 'ca-app-pub-3940256099942544/5224354917';

  BannerAd createBanner({required VoidCallback onLoaded}) {
    final ad = BannerAd(
      adUnitId: bannerId,
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (_) => onLoaded(),
        onAdFailedToLoad: (ad, _) => ad.dispose(),
      ),
    );
    ad.load();
    return ad;
  }

  void showRewarded({required VoidCallback onComplete}) {
    RewardedAd.load(
      adUnitId: rewardedId,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) {
          ad.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad) {
              ad.dispose();
              onComplete();
            },
            onAdFailedToShowFullScreenContent: (ad, _) {
              ad.dispose();
            },
          );
          ad.show(onUserEarnedReward: (_, __) {});
        },
        onAdFailedToLoad: (_) {
          // If the ad is unavailable, allow the requested report action.
          onComplete();
        },
      ),
    );
  }
}
