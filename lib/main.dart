

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:governmentapp/BackgroundFuncs.dart';
import 'package:governmentapp/DataLoadingSystem/JobDisplayManagement.dart';
import 'package:governmentapp/DataLoadingSystem/RequiredDataLoading.dart';
import 'package:governmentapp/DataPullers/AllPullers.dart';
import 'package:governmentapp/DataPullers/HeaderIdentifiers.dart';
import 'package:governmentapp/DataPullers/JobsManager.dart';
import 'package:governmentapp/DataPullers/Sumi.dart';
import 'package:governmentapp/DataPullers/TempAllJobs.dart';
import 'package:governmentapp/Files/AnimatedFlips.dart';
import 'package:governmentapp/Files/CurrentJob.dart';
import 'package:governmentapp/Files/Home.dart';
import 'package:governmentapp/Filtration/FilterPage.dart';
import 'package:governmentapp/Filtration/SearchSheet.dart';
import 'package:governmentapp/ForUsers/ChooseDepartment.dart';
import 'package:governmentapp/Temp.dart';

import 'DataLoadingSystem/SearchAbleDataLoading.dart';
import 'Files/Major.dart';
import 'ForUsers/ChooseDepartment.dart';
import 'ForUsers/ChooseInterest.dart';
import 'ForUsers/ChooseState.dart';


Future<void> main() async {

  await WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  SearchAbleDataLoading.Execute();

  JobsFetcher jobsFetcher = new JobsFetcher();
  jobsFetcher.Load();


  CurrentJob.Listen();

  //JobsManager.init();
  //JobsManager.LoadJobsData();

  JobDisplayManagement.Execute();

  //BackgroundFuncs.Load();

  //Sumi sumi = new Sumi();
  //sumi.Execute();

  runApp(const MyApp());
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
        fontFamily: 'Poppins',
        primarySwatch: Colors.blue,
      ),
      home: const Home(),
    );
  }
}


