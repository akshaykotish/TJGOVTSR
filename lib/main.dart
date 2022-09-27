import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:governmentapp/AdFile.dart';
import 'package:governmentapp/Animations/BrandSplashScreen.dart';
import 'package:governmentapp/Animations/Loading.dart';
import 'package:governmentapp/Beauty/DummyCheck.dart';
import 'package:governmentapp/Beauty/Home.dart';
import 'package:governmentapp/DataLoadingSystem/FilterIndex.dart';
import 'package:governmentapp/DataLoadingSystem/JobDisplayManagement.dart';
import 'package:governmentapp/DataLoadingSystem/RequiredDataLoading.dart';
import 'package:governmentapp/DataPullers/GKPullers.dart';
import 'package:governmentapp/DataPullers/MakeIndexAgain.dart';
import 'package:governmentapp/DataPullers/MaterialsPusher.dart';
import 'package:governmentapp/DataPullers/ScrapperController.dart';
import 'package:governmentapp/Encyclopedia/EncyclopediaRead.dart';
import 'package:governmentapp/Files/CurrentJob.dart';
import 'package:governmentapp/GK/CurrentAffairs.dart';
import 'package:governmentapp/GK/GKQuiz.dart';
import 'package:governmentapp/Graphics/PostGraphic.dart';
import 'package:governmentapp/Materials/MaterialData.dart';
import 'package:governmentapp/User/Login.dart';
import 'DataLoadingSystem/SearchAbleDataLoading.dart';
import 'package:http/http.dart' as http;

Future<void> RequiredLoads() async {
  await TJSNInterstitialAd.AdManager();

  await CurrentJob.Listen();
  JobDisplayManagement.Execute();

   SearchAbleDataLoading.Execute().then((e) {
     ScrapperController scrapperController = ScrapperController();
     scrapperController.Execute();
   });

   MaterialDatas.GetData();

  ScrapperController scrapperController = ScrapperController();
  scrapperController.Execute();

  await GetTheIMage.getUiImage("./assets/branding/graphicbg.png", 1080, 1080);
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await MobileAds.instance.initialize();
  await Firebase.initializeApp();
  await FirebaseAppCheck.instance.activate();
  await TJSNInterstitialAd.LoadBannerAd();

  runApp(MyApp());

  //MakeIndexAgain.Execute();
  //FilterIndexes.RemoveOlds();
  RequiredLoads();
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home:  WillPopScope(
            onWillPop: () {
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


class PW extends StatefulWidget {
  const PW({Key? key}) : super(key: key);

  @override
  State<PW> createState() => _PWState();
}

class _PWState extends State<PW> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: CustomPaint(
          painter: PostGraphic(
            PostName: 'Allahabad University Admission 2020 Result',
            Department: "Allahabad University Admission 2020 Result",
            Location: "INDIA",
            AboutJob: "Allahabad University AU CRET Admti Card 2021;10 January 2021 | 10:53 AM",
            UpdateDate: "Today",
            UpdateName: "Testing",
          ),
        ),
      ),
    );
  }
}
