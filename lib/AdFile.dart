

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
  static late BannerAd MaterialAd;

  static bool AdsEnabled = true;


  static var adWidget1;
  static var adWidget2;
  static var adWidget3;
  static bool adWidget3Loaded = false;

  static var adWidget4;
  static var adWidget5;


  static var adWidget6;
  static var adWidget7;



  static Future<void> LoadBannerAd() async {
    if(AdsEnabled) {
      print("AMDKMSKD");
      myBanner = BannerAd(
        adUnitId: 'ca-app-pub-3701741585114162/3797552586',
        size: AdSize.banner,
        request: AdRequest(),
        listener: BannerAdListener(
          // Called when an ad is successfully received.
          onAdLoaded: (Ad ad) async {
            print('LoadBannerAd loaded.');
            await myBanner.load();
            adWidget6 = AdWidget(ad: myBanner);
          },
          // Called when an ad request failed.
          onAdFailedToLoad: (Ad ad, LoadAdError error) {
            // Dispose the ad here to free resources.
            ad.dispose();
            print('LoadBannerAd failed to load: $error');
          },
          // Called when an ad opens an overlay that covers the screen.
          onAdOpened: (Ad ad) => print('Ad opened.'),
          // Called when an ad removes an overlay that covers the screen.
          onAdClosed: (Ad ad) => print('Ad closed.'),
          // Called when an impression occurs on the ad.
          onAdImpression: (Ad ad) => print('Ad impression.'),
        ),
      );
      print("Banner AD");
      await myBanner.load();
      adWidget6 = AdWidget(
          ad: myBanner
      );
    }
  }


  static Future<void> LoadBannerAd2() async {
    if(AdsEnabled) {
      myBanner2 = BannerAd(
        adUnitId: 'ca-app-pub-3701741585114162/4270225689',
        size: AdSize.mediumRectangle,
        request: AdRequest(),
        listener: BannerAdListener(
          // Called when an ad is successfully received.
          onAdLoaded: (Ad ad) async {
            print('LoadBannerAd2 loaded.');
            await myBanner2.load();
            adWidget7 = AdWidget(ad: myBanner2);
          },
          // Called when an ad request failed.
          onAdFailedToLoad: (Ad ad, LoadAdError error) {
            // Dispose the ad here to free resources.
            ad.dispose();
            print('LoadBannerAd2 failed to load: $error');
          },
          // Called when an ad opens an overlay that covers the screen.
          onAdOpened: (Ad ad) => print('Ad opened.'),
          // Called when an ad removes an overlay that covers the screen.
          onAdClosed: (Ad ad) => print('Ad closed.'),
          // Called when an impression occurs on the ad.
          onAdImpression: (Ad ad) => print('Ad impression.'),
        ),
      );
      print("Quiz AD");
      await myBanner2.load();
      adWidget7 = AdWidget(
          ad: myBanner2
      );
    }
  }

  static Future<void> LoadJobBoxs1() async {
    if(AdsEnabled) {
      JobBoxs1 = BannerAd(
        adUnitId: 'ca-app-pub-3701741585114162/6132005649',
        size: AdSize.mediumRectangle,
        request: AdRequest(),
        listener: BannerAdListener(
          // Called when an ad is successfully received.
          onAdLoaded: (Ad ad) async {
            print('LoadJobBoxs1 loaded.');
            await JobBoxs1.load();
            adWidget1 = AdWidget(
                ad: JobBoxs1
            );
          },
          // Called when an ad request failed.
          onAdFailedToLoad: (Ad ad, LoadAdError error) {
            // Dispose the ad here to free resources.
            ad.dispose();
            print('LoadJobBoxs1 failed to load: $error');
          },
          // Called when an ad opens an overlay that covers the screen.
          onAdOpened: (Ad ad) => print('Ad opened.'),
          // Called when an ad removes an overlay that covers the screen.
          onAdClosed: (Ad ad) => print('Ad closed.'),
          // Called when an impression occurs on the ad.
          onAdImpression: (Ad ad) => print('Ad impression.'),
        ),
      );
      print("JobBox1 AD");
      await JobBoxs1.load();
      adWidget1 = AdWidget(
          ad: JobBoxs1
      );
    }
  }


  static Future<void> LoadJobBoxs2() async {
    if(AdsEnabled) {
      JobBoxs2 = BannerAd(
        adUnitId: 'ca-app-pub-3701741585114162/6271853860',
        size: AdSize.mediumRectangle,
        request: AdRequest(),
        listener: BannerAdListener(
          // Called when an ad is successfully received.
          onAdLoaded: (Ad ad) async {
            print('LoadJobBoxs2 loaded2.');
            await JobBoxs2.load();
            adWidget2 = AdWidget(
                ad: JobBoxs2
            );
          },
          // Called when an ad request failed.
          onAdFailedToLoad: (Ad ad, LoadAdError error) {
            // Dispose the ad here to free resources.
            ad.dispose();
            print('LoadJobBoxs2 failed to load: $error');
          },
          // Called when an ad opens an overlay that covers the screen.
          onAdOpened: (Ad ad) => print('Ad opened.'),
          // Called when an ad removes an overlay that covers the screen.
          onAdClosed: (Ad ad) => print('Ad closed.'),
          // Called when an impression occurs on the ad.
          onAdImpression: (Ad ad) => print('Ad impression.'),
        ),
      );
      print("JobBox2 AD");
      await JobBoxs2.load();
      adWidget2 = AdWidget(
          ad: JobBoxs2
      );
    }
  }


  static Future<void> LoadJobBoxs3() async {
    if (AdsEnabled) {
      JobBoxs3 = await BannerAd(
        adUnitId: 'ca-app-pub-3940256099942544/6300978111',//'ca-app-pub-3701741585114162/3438393693',
        size: AdSize.mediumRectangle,
        request: const AdRequest(),
        listener: BannerAdListener(
          onAdLoaded: (Ad ad) async {
            print("LoadJobBoxs3 JOB Ad Loaded");
            await JobBoxs3.load();
            adWidget3 = AdWidget(
                ad: JobBoxs3
            );
          },
          // Called when an ad request failed.
          onAdFailedToLoad: (Ad ad, LoadAdError error) {
            // Dispose the ad here to free resources.
            ad.dispose();
            print('LoadJobBoxs3 failed to load: $error');
          },
          // Called when an ad opens an overlay that covers the screen.
          onAdOpened: (Ad ad) => print('Ad3 opened.'),
          // Called when an ad removes an overlay that covers the screen.
          onAdClosed: (Ad ad) => print('Ad3 closed.'),
          // Called when an impression occurs on the ad.
          onAdImpression: (Ad ad) => print('Ad3 impression.'),
        ),
      );
      print("JobBox3 AD");
      await JobBoxs3.load();
      if (adWidget3 != null) {
        adWidget3 = AdWidget(
            ad: JobBoxs3
        );
        print("ADWIDGET ${adWidget3.runtimeType}");

      }
    }
  }


  static Future<void> LoadEncyclopedia() async {
    if(AdsEnabled) {
      Encyclopedia = BannerAd(
        adUnitId: 'ca-app-pub-3701741585114162/7553732677',
        size: AdSize.largeBanner,
        request: AdRequest(),
        listener: BannerAdListener(
          // Called when an ad is successfully received.
          onAdLoaded: (Ad ad) async {
            print('LoadEncyclopedia loaded.');
            await Encyclopedia.load();
            adWidget4 = AdWidget(
                ad: Encyclopedia
            );
          },
          // Called when an ad request failed.
          onAdFailedToLoad: (Ad ad, LoadAdError error) {
            // Dispose the ad here to free resources.
            ad.dispose();
            print('LoadEncyclopedia failed to load: $error');
          },
          // Called when an ad opens an overlay that covers the screen.
          onAdOpened: (Ad ad) => print('Ad opened.'),
          // Called when an ad removes an overlay that covers the screen.
          onAdClosed: (Ad ad) => print('Ad closed.'),
          // Called when an impression occurs on the ad.
          onAdImpression: (Ad ad) => print('Ad impression.'),
        ),
      );
      print("Encyclopedia AD");
      await Encyclopedia.load();
      adWidget4 = AdWidget(
          ad: Encyclopedia
      );
    }
  }


  static Future<void> LoadMaterial() async {
    if(AdsEnabled) {
      MaterialAd = BannerAd(
        adUnitId: 'ca-app-pub-3701741585114162/1630773412',
        size: AdSize.largeBanner,
        request: AdRequest(),
        listener: BannerAdListener(
          // Called when an ad is successfully received.
          onAdLoaded: (Ad ad) async {
            print('LoadMaterial loaded.');
            await MaterialAd.load();
            adWidget5 = AdWidget(
                ad: MaterialAd
            );
          },
          // Called when an ad request failed.
          onAdFailedToLoad: (Ad ad, LoadAdError error) {
            // Dispose the ad here to free resources.
            ad.dispose();
            print('LoadMaterial failed to load: $error');
          },
          // Called when an ad opens an overlay that covers the screen.
          onAdOpened: (Ad ad) => print('Ad opened.'),
          // Called when an ad removes an overlay that covers the screen.
          onAdClosed: (Ad ad) => print('Ad closed.'),
          // Called when an impression occurs on the ad.
          onAdImpression: (Ad ad) => print('Ad impression.'),
        ),
      );
      print("Material AD");
      await MaterialAd.load();
      adWidget5 = AdWidget(
          ad: MaterialAd
      );
    }
  }

  static Future<void> init()
  async {
    print("Main Ad loaded.");
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
    if(AdsEnabled == "TRUE") {
      await init();
    }
  }

  static Future<void> IsAdEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    String? AdsEnable = prefs.getString("AdsEnable");
    //if(AdsEnable == "TRUE")
      //{
        AdsEnabled = true;
      //}
    //else{
      //AdsEnabled = false;
    //}
  }



  static Future<void> AdManager() async {
    await IsAdEnabled();
    await LoadJobBoxs3();

    print("Ad started");
    //final prefs = await SharedPreferences.getInstance();
    //String? AdsEnable = prefs.getString("AdsEnable");
//    if(AdsEnabled == "TRUE") {
      print("Main Ad is ready to serve.");
      Timer.periodic(
          const Duration(minutes: 3),
              (timer) async {
            await init();
          }
      );
  //  }
  }
}

//ca-app-pub-3701741585114162/9498222392