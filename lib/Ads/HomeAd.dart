import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:governmentapp/HexColors.dart';

class HomeAd extends StatefulWidget {
  HomeAd({required this.adkey, this.smallbanner = false});
  bool smallbanner = false;
  String adkey = "ca-app-pub-3701741585114162/6271853860";
  @override
  State<HomeAd> createState() => _HomeAdState();
}

class _HomeAdState extends State<HomeAd> {
  late BannerAd homeAd;

  String testad = "ca-app-pub-3940256099942544/6300978111";

  void LoadHomeAd(){
    homeAd = BannerAd(
      adUnitId: widget.adkey,
      size: widget.smallbanner ? AdSize.banner :  AdSize.mediumRectangle,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (Ad ad) {homeAd.load();},
        onAdFailedToLoad: (Ad ad, LoadAdError error) {ad.dispose();},
        onAdOpened: (Ad ad) => print('Ad3 opened.'),
        onAdClosed: (Ad ad) => print('Ad3 closed.'),
        onAdImpression: (Ad ad) => print('Ad3 impression.'),
      ),
    );

    homeAd.load();
  }

  @override
  void dispose() {
    homeAd.dispose();
    super.dispose();
  }

  @override
  void initState() {
    LoadHomeAd();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: ColorFromHexCode("#404752"),
      ),
      width: homeAd.size.width.toDouble(),
      height: homeAd.size.height.toDouble(),
      child: AdWidget(
        ad: homeAd,
      ),
    );
  }
}
