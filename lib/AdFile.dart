

import 'dart:async';

import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TJSNInterstitialAd
{

  static late InterstitialAd interstitialAd;

  static Future<void> init()
  async {
    await InterstitialAd.load(
        adUnitId: 'ca-app-pub-3701741585114162/9498222392',
        request: AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(
          onAdLoaded: (InterstitialAd ad) {
            print("Ad Loaded");
            // Keep a reference to the ad so you can show it later.
            interstitialAd = ad;


            interstitialAd.fullScreenContentCallback = FullScreenContentCallback(
              onAdShowedFullScreenContent: (InterstitialAd ad) =>
                  print('%ad onAdShowedFullScreenContent.'),
              onAdDismissedFullScreenContent: (InterstitialAd ad) {
                print('$ad onAdDismissedFullScreenContent.');
                ad.dispose();
              },
              onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
                print('$ad onAdFailedToShowFullScreenContent: $error');
                ad.dispose();
              },
              onAdImpression: (InterstitialAd ad) => print('$ad impression occurred.'),
            );

            interstitialAd.show();
          },
          onAdFailedToLoad: (LoadAdError error) {
            print('InterstitialAd failed to load: $error');
          },
        ));
  }

  static Future<void> LoadAnAd() async {


    final prefs = await SharedPreferences.getInstance();
    String? AdsEnable = prefs.getString("AdsEnable");
    if(AdsEnable == "TRUE") {
      await init();
    }
  }

  static Future<void> AdManager() async {
    final prefs = await SharedPreferences.getInstance();
    String? AdsEnable = prefs.getString("AdsEnable");
    if(AdsEnable == "TRUE") {
      Timer.periodic(
          const Duration(minutes: 2),
              (timer) async {
            await init();
          }
      );
    }
  }
}

//ca-app-pub-3701741585114162/9498222392