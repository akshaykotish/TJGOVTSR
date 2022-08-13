import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:governmentapp/Beauty/Home.dart';
import 'package:governmentapp/DataLoadingSystem/JobDisplayManagement.dart';
import 'package:governmentapp/DataPullers/ScrapperController.dart';
import 'package:governmentapp/Files/CurrentJob.dart';
import 'DataLoadingSystem/SearchAbleDataLoading.dart';


Future<void> main() async {

  await WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  await SearchAbleDataLoading.Execute().then((e){
      print("Writers Started");
      ScrapperController scrapperController = ScrapperController();
      scrapperController.Execute();
  });

  // ScrapperController scrapperController = ScrapperController();
  // scrapperController.Execute();


  CurrentJob.Listen();

  JobDisplayManagement.isloadingjobs = true;
  JobDisplayManagement.Execute();


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


