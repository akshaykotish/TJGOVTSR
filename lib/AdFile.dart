

import 'dart:async';

import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TJSNInterstitialAd
{

  static late InterstitialAd interstitialAd;
  static late BannerAd myBanner;
  static late BannerAd myBanner2;
  static late BannerAd JobBoxs1;
  static late BannerAd JobBoxs2;
  static late BannerAd JobBoxs3;
  static late BannerAd Encyclopedia;


  static Future<void> LoadBannerAd() async {
    myBanner = await BannerAd(
      adUnitId: 'ca-app-pub-3701741585114162/3797552586',
      size: AdSize.banner,
      request: AdRequest(),
      listener: BannerAdListener(
        // Called when an ad is successfully received.
        onAdLoaded: (Ad ad) {
          print('Ad loaded.');
          myBanner.load();
        },
        // Called when an ad request failed.
        onAdFailedToLoad: (Ad ad, LoadAdError error) {
          // Dispose the ad here to free resources.
          ad.dispose();
          print('Ad failed to load: $error');
        },
        // Called when an ad opens an overlay that covers the screen.
        onAdOpened: (Ad ad) => print('Ad opened.'),
        // Called when an ad removes an overlay that covers the screen.
        onAdClosed: (Ad ad) => print('Ad closed.'),
        // Called when an impression occurs on the ad.
        onAdImpression: (Ad ad) => print('Ad impression.'),
      ),
    );
    final prefs = await SharedPreferences.getInstance();
    String? AdsEnable = prefs.getString("AdsEnable");
    if(AdsEnable == "TRUE") {
      myBanner.load();
    }
  }


  static Future<void> LoadBannerAd2() async {
    myBanner2 = await BannerAd(
      adUnitId: 'ca-app-pub-3701741585114162/4270225689',
      size: AdSize.mediumRectangle,
      request: AdRequest(),
      listener: BannerAdListener(
        // Called when an ad is successfully received.
        onAdLoaded: (Ad ad) {
          print('Ad loaded.');
          myBanner2.load();
        },
        // Called when an ad request failed.
        onAdFailedToLoad: (Ad ad, LoadAdError error) {
          // Dispose the ad here to free resources.
          ad.dispose();
          print('Ad failed to load: $error');
        },
        // Called when an ad opens an overlay that covers the screen.
        onAdOpened: (Ad ad) => print('Ad opened.'),
        // Called when an ad removes an overlay that covers the screen.
        onAdClosed: (Ad ad) => print('Ad closed.'),
        // Called when an impression occurs on the ad.
        onAdImpression: (Ad ad) => print('Ad impression.'),
      ),
    );
    final prefs = await SharedPreferences.getInstance();
    String? AdsEnable = prefs.getString("AdsEnable");
    if(AdsEnable == "TRUE") {
      myBanner2.load();
    }
  }

  static Future<void> LoadJobBoxs1() async {
    JobBoxs1 = await BannerAd(
      adUnitId: 'ca-app-pub-3701741585114162/6132005649',
      size: AdSize.mediumRectangle,
      request: AdRequest(),
      listener: BannerAdListener(
        // Called when an ad is successfully received.
        onAdLoaded: (Ad ad) {
          print('Ad loaded.');
          JobBoxs1.load();
        },
        // Called when an ad request failed.
        onAdFailedToLoad: (Ad ad, LoadAdError error) {
          // Dispose the ad here to free resources.
          ad.dispose();
          print('Ad failed to load: $error');
        },
        // Called when an ad opens an overlay that covers the screen.
        onAdOpened: (Ad ad) => print('Ad opened.'),
        // Called when an ad removes an overlay that covers the screen.
        onAdClosed: (Ad ad) => print('Ad closed.'),
        // Called when an impression occurs on the ad.
        onAdImpression: (Ad ad) => print('Ad impression.'),
      ),
    );
    final prefs = await SharedPreferences.getInstance();
    String? AdsEnable = prefs.getString("AdsEnable");
    if(AdsEnable == "TRUE") {
      JobBoxs1.load();
    }
  }


  static Future<void> LoadJobBoxs2() async {
    JobBoxs2 = await BannerAd(
      adUnitId: 'ca-app-pub-3701741585114162/6271853860',
      size: AdSize.mediumRectangle,
      request: AdRequest(),
      listener: BannerAdListener(
        // Called when an ad is successfully received.
        onAdLoaded: (Ad ad) {
          print('Ad loaded.');
          JobBoxs2.load();
        },
        // Called when an ad request failed.
        onAdFailedToLoad: (Ad ad, LoadAdError error) {
          // Dispose the ad here to free resources.
          ad.dispose();
          print('Ad failed to load: $error');
        },
        // Called when an ad opens an overlay that covers the screen.
        onAdOpened: (Ad ad) => print('Ad opened.'),
        // Called when an ad removes an overlay that covers the screen.
        onAdClosed: (Ad ad) => print('Ad closed.'),
        // Called when an impression occurs on the ad.
        onAdImpression: (Ad ad) => print('Ad impression.'),
      ),
    );
    final prefs = await SharedPreferences.getInstance();
    String? AdsEnable = prefs.getString("AdsEnable");
    if(AdsEnable == "TRUE") {
      JobBoxs2.load();
    }
  }


  static Future<void> LoadJobBoxs3() async {
    JobBoxs3 = await BannerAd(
      adUnitId: 'ca-app-pub-3701741585114162/3438393693',
      size: AdSize.mediumRectangle,
      request: AdRequest(),
      listener: BannerAdListener(
        // Called when an ad is successfully received.
        onAdLoaded: (Ad ad) {
          print('Ad loaded.');
          JobBoxs3.load();
        },
        // Called when an ad request failed.
        onAdFailedToLoad: (Ad ad, LoadAdError error) {
          // Dispose the ad here to free resources.
          ad.dispose();
          print('Ad failed to load: $error');
        },
        // Called when an ad opens an overlay that covers the screen.
        onAdOpened: (Ad ad) => print('Ad opened.'),
        // Called when an ad removes an overlay that covers the screen.
        onAdClosed: (Ad ad) => print('Ad closed.'),
        // Called when an impression occurs on the ad.
        onAdImpression: (Ad ad) => print('Ad impression.'),
      ),
    );
    final prefs = await SharedPreferences.getInstance();
    String? AdsEnable = prefs.getString("AdsEnable");
    if(AdsEnable == "TRUE") {
      JobBoxs3.load();
    }
  }


  static Future<void> LoadEncyclopedia() async {
    Encyclopedia = await BannerAd(
      adUnitId: 'ca-app-pub-3701741585114162/7553732677',
      size: AdSize.largeBanner,
      request: AdRequest(),
      listener: BannerAdListener(
        // Called when an ad is successfully received.
        onAdLoaded: (Ad ad) {
          print('Ad loaded.');
          Encyclopedia.load();
        },
        // Called when an ad request failed.
        onAdFailedToLoad: (Ad ad, LoadAdError error) {
          // Dispose the ad here to free resources.
          ad.dispose();
          print('Ad failed to load: $error');
        },
        // Called when an ad opens an overlay that covers the screen.
        onAdOpened: (Ad ad) => print('Ad opened.'),
        // Called when an ad removes an overlay that covers the screen.
        onAdClosed: (Ad ad) => print('Ad closed.'),
        // Called when an impression occurs on the ad.
        onAdImpression: (Ad ad) => print('Ad impression.'),
      ),
    );
    final prefs = await SharedPreferences.getInstance();
    String? AdsEnable = prefs.getString("AdsEnable");
    if(AdsEnable == "TRUE") {
      Encyclopedia.load();
    }
  }


  static Future<void> LoadMaterial() async {
    Encyclopedia = await BannerAd(
      adUnitId: 'ca-app-pub-3701741585114162/1630773412',
      size: AdSize.largeBanner,
      request: AdRequest(),
      listener: BannerAdListener(
        // Called when an ad is successfully received.
        onAdLoaded: (Ad ad) {
          print('Ad loaded.');
          Encyclopedia.load();
        },
        // Called when an ad request failed.
        onAdFailedToLoad: (Ad ad, LoadAdError error) {
          // Dispose the ad here to free resources.
          ad.dispose();
          print('Ad failed to load: $error');
        },
        // Called when an ad opens an overlay that covers the screen.
        onAdOpened: (Ad ad) => print('Ad opened.'),
        // Called when an ad removes an overlay that covers the screen.
        onAdClosed: (Ad ad) => print('Ad closed.'),
        // Called when an impression occurs on the ad.
        onAdImpression: (Ad ad) => print('Ad impression.'),
      ),
    );
    final prefs = await SharedPreferences.getInstance();
    String? AdsEnable = prefs.getString("AdsEnable");
    if(AdsEnable == "TRUE") {
      Encyclopedia.load();
    }
  }

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
    await LoadBannerAd();
    await LoadBannerAd2();
    await LoadJobBoxs1();
    await LoadJobBoxs2();
    await LoadJobBoxs3();
    await LoadEncyclopedia();

    final prefs = await SharedPreferences.getInstance();
    String? AdsEnable = prefs.getString("AdsEnable");
    if(AdsEnable == "TRUE") {
      Timer.periodic(
          const Duration(minutes: 1),
              (timer) async {
            await init();
          }
      );
    }
  }
}

//ca-app-pub-3701741585114162/9498222392