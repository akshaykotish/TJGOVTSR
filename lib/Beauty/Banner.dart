import 'package:flutter/material.dart';

class BannerForAds extends StatefulWidget {
  const BannerForAds({Key? key}) : super(key: key);

  @override
  State<BannerForAds> createState() => _BannerForAdsState();
}

class _BannerForAdsState extends State<BannerForAds> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      height: 215,
      width: MediaQuery.of(context).size.width,
      child: Container(
        decoration: BoxDecoration(
          image: const DecorationImage(
            image: AssetImage("./assets/branding/adbanner.png"),
          ),
          color: Colors.brown.withOpacity(0.6),
          borderRadius: const BorderRadius.all(Radius.circular(15)),
        ),

      ),
    );
  }
}
