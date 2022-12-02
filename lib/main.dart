import 'dart:async';

import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:governmentapp/AdFile.dart';
import 'package:governmentapp/Animations/BrandSplashScreen.dart';
import 'package:governmentapp/Animations/SplashScreen.dart';
import 'package:governmentapp/Beauty/Home.dart';
import 'package:governmentapp/ChatDatas.dart';
import 'package:governmentapp/DataLoadingSystem/JobDisplayManagement.dart';
import 'package:governmentapp/DataLoadingSystem/RequiredDataLoading.dart';
import 'package:governmentapp/DataPullers/GKPullers.dart';
import 'package:governmentapp/DataPullers/ScrapperController.dart';
import 'package:governmentapp/Files/CurrentJob.dart';
import 'package:governmentapp/Graphics/PostGraphic.dart';
import 'package:governmentapp/JobDisplayData.dart';
import 'package:governmentapp/Materials/MaterialData.dart';
import 'package:workmanager/workmanager.dart';
import 'BackgroundController.dart';
import 'DataLoadingSystem/SearchAbleDataLoading.dart';

Future<void> RequiredLoads() async {
   await TJSNInterstitialAd.AdManager();
    await CurrentJob.Listen();
    JobDisplayManagement.Execute();

    ScrapperController scrapperController = ScrapperController();
    await scrapperController.Execute();
    await SearchAbleDataLoading.Execute();

     GKPullers.Execute();
    Timer(Duration(seconds: 5), () async {
      await RequiredDataLoading.Execute();
      Timer(Duration(seconds: 4), () async {
        await ChatDatas.CreateNotifications();
        await ChatDatas.CreateNotifications();
        JobDisplayManagement.HOTJOBSC.add([]);
      });
    });

  await GetTheIMage.getUiImage("./assets/branding/graphicbg.png", 1080, 1080);
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await MobileAds.instance.initialize();
  await Firebase.initializeApp();
  await FirebaseAppCheck.instance.activate();
  runApp(MyApp());
  RequiredLoads();
  await GetTheIMage.getUiImage("./assets/branding/graphicbg.png", 1080, 1080);
  Workmanager().initialize(callbackDispatcher, isInDebugMode: false,);
  Workmanager().registerPeriodicTask("notifications", "notifications", frequency: Duration(hours: 1), initialDelay: Duration(minutes: 30), constraints: Constraints(networkType: NetworkType.connected, ));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);



  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    mycontext  = context;
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        // home:  WillPopScope(
        //     onWillPop: () {
        //       CurrentJob.HideJobSheetData.add("a");
        //       Navigator.of(context).pushAndRemoveUntil(
        //           MaterialPageRoute(
        //           builder: (context) => Home()), (Route route) => false);
        //       return Future.value(true);
        //     },
        //     child: Home()),
      home: Home(),
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
      body: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: SingleChildScrollView(
          child: Container(
            width: 1080,
            height: 1080,
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
        ),
      ),
    );
  }
}
