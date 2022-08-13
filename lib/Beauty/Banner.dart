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
      height: 200,
      width: MediaQuery.of(context).size.width,
      decoration: const BoxDecoration(
        color: Colors.white,
      ),
      child: Container(

      ),
    );
  }
}
