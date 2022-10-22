// @dart=2.12

import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

const int maxFailedLoadAttempts = 3;

class AdsConfig {
  static final AdsConfig _instance = AdsConfig._();

  static AdsConfig get instance => _instance;
  final AdRequest request = AdRequest(
    nonPersonalizedAds: true,
  );

  InterstitialAd? _interstitialAd;
  int _numInterstitialLoadAttempts = 0;

  // RewardedAd? _rewardedAd;
  // int _numRewardedLoadAttempts = 0;
  //
  // RewardedInterstitialAd? _rewardedInterstitialAd;
  // int _numRewardedInterstitialLoadAttempts = 0;

  AdsConfig._();

  void initialize() async {
    await MobileAds.instance.initialize();
    _createInterstitialAd();
    // _createRewardedAd();
    // _createRewardedInterstitialAd();
  }

  void _createInterstitialAd() {
    InterstitialAd.load(
        adUnitId: kDebugMode
            ? 'ca-app-pub-3940256099942544/1033173712'
            : 'ca-app-pub-2089873880879307/5162045036',
        request: request,
        adLoadCallback: InterstitialAdLoadCallback(
          onAdLoaded: (InterstitialAd ad) {
            if (kDebugMode) print('$ad loaded');
            _interstitialAd = ad;
            _numInterstitialLoadAttempts = 0;
            _interstitialAd!.setImmersiveMode(true);
          },
          onAdFailedToLoad: (LoadAdError error) {
            if (kDebugMode) print('InterstitialAd failed to load: $error.');
            _numInterstitialLoadAttempts += 1;
            _interstitialAd = null;
            if (_numInterstitialLoadAttempts < maxFailedLoadAttempts) {
              _createInterstitialAd();
            }
          },
        ));
  }

  void showInterstitialAd(Function onClose) {
    if (_interstitialAd == null) {
      if (kDebugMode)
        print('Warning: attempt to show interstitial before loaded.');
      onClose();
      return;
    }
    _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (InterstitialAd ad) {
        if (kDebugMode) print('ad onAdShowedFullScreenContent.');
      },
      onAdDismissedFullScreenContent: (InterstitialAd ad) {
        if (kDebugMode) print('$ad onAdDismissedFullScreenContent.');
        ad.dispose();
        onClose();
        _createInterstitialAd();
      },
      onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
        if (kDebugMode) print('$ad onAdFailedToShowFullScreenContent: $error');
        ad.dispose();
        onClose();
        _createInterstitialAd();
      },
    );
    _interstitialAd!.show();
    _interstitialAd = null;
  }
/*
  void _createRewardedAd() {
    RewardedAd.load(
        adUnitId: kDebugMode
            ? RewardedAd.testAdUnitId
            : 'ca-app-pub-2089873880879307/1561096082',
        request: request,
        rewardedAdLoadCallback: RewardedAdLoadCallback(
          onAdLoaded: (RewardedAd ad) {
            if (kDebugMode) print('$ad loaded.');
            _rewardedAd = ad;
            _numRewardedLoadAttempts = 0;
          },
          onAdFailedToLoad: (LoadAdError error) {
            if (kDebugMode) print('RewardedAd failed to load: $error');
            _rewardedAd = null;
            _numRewardedLoadAttempts += 1;
            if (_numRewardedLoadAttempts < maxFailedLoadAttempts) {
              _createRewardedAd();
            }
          },
        ));
  }

  void showRewardedAd(Function onRewarded) {
    if (_rewardedAd == null) {
      if (kDebugMode) print('Warning: attempt to show rewarded before loaded.');
      onRewarded();
      return;
    }
    _rewardedAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (RewardedAd ad) {
        if (kDebugMode) print('ad onAdShowedFullScreenContent.');
      },
      onAdDismissedFullScreenContent: (RewardedAd ad) {
        if (kDebugMode) print('$ad onAdDismissedFullScreenContent.');
        ad.dispose();
        onRewarded();
        _createRewardedAd();
      },
      onAdFailedToShowFullScreenContent: (RewardedAd ad, AdError error) {
        if (kDebugMode) print('$ad onAdFailedToShowFullScreenContent: $error');
        ad.dispose();
        onRewarded();
        _createRewardedAd();
      },
    );

    _rewardedAd!.setImmersiveMode(true);
    _rewardedAd!.show(
        onUserEarnedReward: (AdWithoutView ad, RewardItem reward) {
      if (kDebugMode)
        print('$ad with reward $RewardItem(${reward.amount}, ${reward.type})');
    });
    _rewardedAd = null;
  }

  void _createRewardedInterstitialAd() {
    RewardedInterstitialAd.load(
        adUnitId: kDebugMode
            ? 'ca-app-pub-3940256099942544/5354046379'
            : 'ca-app-pub-2089873880879307/5124850852',
        request: request,
        rewardedInterstitialAdLoadCallback: RewardedInterstitialAdLoadCallback(
          onAdLoaded: (RewardedInterstitialAd ad) {
            if (kDebugMode) print('$ad loaded.');
            _rewardedInterstitialAd = ad;
            _numRewardedInterstitialLoadAttempts = 0;
          },
          onAdFailedToLoad: (LoadAdError error) {
            if (kDebugMode)
              print('RewardedInterstitialAd failed to load: $error');
            _rewardedInterstitialAd = null;
            _numRewardedInterstitialLoadAttempts += 1;
            if (_numRewardedInterstitialLoadAttempts < maxFailedLoadAttempts) {
              _createRewardedInterstitialAd();
            }
          },
        ));
  }

  void showRewardedInterstitialAd(Function onRewarded) {
    if (_rewardedInterstitialAd == null) {
      if (kDebugMode)
        print('Warning: attempt to show rewarded interstitial before loaded.');
      _createRewardedInterstitialAd();
      onRewarded();
      return;
    }
    _rewardedInterstitialAd!.fullScreenContentCallback =
        FullScreenContentCallback(
      onAdShowedFullScreenContent: (RewardedInterstitialAd ad) {
        print('$ad onAdShowedFullScreenContent.');
      },
      onAdDismissedFullScreenContent: (RewardedInterstitialAd ad) {
        if (kDebugMode) print('$ad onAdDismissedFullScreenContent.');
        ad.dispose();
        onRewarded();
        _createRewardedInterstitialAd();
      },
      onAdFailedToShowFullScreenContent:
          (RewardedInterstitialAd ad, AdError error) {
        if (kDebugMode) print('$ad onAdFailedToShowFullScreenContent: $error');
        ad.dispose();
        onRewarded();
        _createRewardedInterstitialAd();
      },
    );

    _rewardedInterstitialAd!.setImmersiveMode(true);
    _rewardedInterstitialAd!.show(
        onUserEarnedReward: (AdWithoutView ad, RewardItem reward) {
      if (kDebugMode)
        print('$ad with reward $RewardItem(${reward.amount}, ${reward.type})');
    });
    _rewardedInterstitialAd = null;
  }*/

  void dispose() {
    _interstitialAd?.dispose();
    // _rewardedAd?.dispose();
    // _rewardedInterstitialAd?.dispose();
  }
}
