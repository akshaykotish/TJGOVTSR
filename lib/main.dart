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
import 'package:governmentapp/DataPullers/GKPullers.dart';
import 'package:governmentapp/DataPullers/MaterialsPusher.dart';
import 'package:governmentapp/DataPullers/ScrapperController.dart';
import 'package:governmentapp/Encyclopedia/EncyclopediaRead.dart';
import 'package:governmentapp/Files/CurrentJob.dart';
import 'package:governmentapp/GK/CurrentAffairs.dart';
import 'package:governmentapp/GK/GKQuiz.dart';
import 'package:governmentapp/User/Login.dart';
import 'DataLoadingSystem/SearchAbleDataLoading.dart';
import 'package:http/http.dart' as http;

Future<void> RequiredLoads() async {
  RequiredDataLoading.LoadHotJobs();

  CurrentJob.Listen();

  JobDisplayManagement.isloadingjobs = true;

  JobDisplayManagement.Execute();

  SearchAbleDataLoading.Execute().then((e) {
    ScrapperController scrapperController = ScrapperController();
    scrapperController.Execute();
  });
  TJSNInterstitialAd.AdManager();
}

Future<void> main() async {

  print("TESTINGURL = " + "https://drive.google.com/file/d/1zCVEgm624VTzZnfFmkiZ0tTBXKIlQa6d/view?usp=sharing");
  await WidgetsFlutterBinding.ensureInitialized();
  await MobileAds.instance.initialize();
  await Firebase.initializeApp();
  await TJSNInterstitialAd.LoadBannerAd();

  runApp(MyApp());

  //RequiredLoads();
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
              CurrentJob.HideJobSheetData.add("a");
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                  builder: (context) => Home()), (Route route) => false);
              return Future.value(true);
            },
            child: GKQuiz())//const BrandSplashScreen()),
    );
  }
}


class Tempor extends StatefulWidget {
  const Tempor({Key? key}) : super(key: key);

  @override
  State<Tempor> createState() => _TemporState();
}

class _TemporState extends State<Tempor> {

  String value = "";

  Future<void> Load() async {
    var temp = await http.read(Uri.parse("https://nitin-gupta.com/all-most-importance-pdf-collection-in-hindi-and-english-for-all-competitive-exams/"));
    setState(() {
      value = temp;
    });
  }

  @override
  void initState() {
    Load();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: SingleChildScrollView(
          child: Container(
            child: Text(value),
          ),
        ),
      ),
    );
  }
}


