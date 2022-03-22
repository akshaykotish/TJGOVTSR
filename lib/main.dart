

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:governmentapp/DataPullers/AllPullers.dart';
import 'package:governmentapp/Files/Home.dart';
import 'package:governmentapp/ForUsers/ChooseDepartment.dart';
import 'package:governmentapp/Temp.dart';

import 'Files/Major.dart';
import 'ForUsers/ChooseDepartment.dart';
import 'ForUsers/ChooseInterest.dart';
import 'ForUsers/ChooseState.dart';

Future<void> main() async {
  //JobsFetcher jobsFetcher = new JobsFetcher();
  //jobsFetcher.Load();

  await WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        fontFamily: 'Poppins',
        primarySwatch: Colors.blue,
      ),
      home: const Home(),
    );
  }
}


