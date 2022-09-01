import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:governmentapp/AdFile.dart';
import 'package:governmentapp/Animations/BrandSplashScreen.dart';
import 'package:governmentapp/Animations/Loading.dart';
import 'package:governmentapp/Beauty/DummyCheck.dart';
import 'package:governmentapp/Beauty/Home.dart';
import 'package:governmentapp/DataLoadingSystem/JobDisplayManagement.dart';
import 'package:governmentapp/DataLoadingSystem/RequiredDataLoading.dart';
import 'package:governmentapp/DataPullers/MaterialsPusher.dart';
import 'package:governmentapp/DataPullers/ScrapperController.dart';
import 'package:governmentapp/Encyclopedia/EncyclopediaRead.dart';
import 'package:governmentapp/Files/CurrentJob.dart';
import 'package:governmentapp/User/Login.dart';
import 'DataLoadingSystem/SearchAbleDataLoading.dart';


Future<void> RequiredLoads() async {

  MaterialPusher.Execute();

  await TJSNInterstitialAd.AdManager();

  await SearchAbleDataLoading.Execute().then((e) {
    print("Writers Started");
    ScrapperController scrapperController = ScrapperController();
    scrapperController.Execute();
  });


  await CurrentJob.Listen();

  JobDisplayManagement.isloadingjobs = true;

  await JobDisplayManagement.Execute();

  await RequiredDataLoading.LoadHotJobs();
}

Future<void> main() async {

  await WidgetsFlutterBinding.ensureInitialized();
  await MobileAds.instance.initialize();
  await Firebase.initializeApp();

  runApp(MyApp());

  RequiredLoads();
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          fontFamily: 'EBGaramond',
          primarySwatch: Colors.blue,
        ),
        home:  WillPopScope(
            onWillPop: () {
              print("CAlled");
              CurrentJob.HideJobSheetData.add("a");

              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                  builder: (context) => Home()), (Route route) => false);
              return Future.value(true);
            },
            child: BrandSplashScreen()),
    );
  }
}


