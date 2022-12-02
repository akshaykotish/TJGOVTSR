

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:governmentapp/Animations/SplashScreen.dart';

import '../JobDisplayData.dart';

class JobDisplayManagement{

  static bool HomeToShow = false;
  static int WhichShowing = 0;

  static List<JobDisplayData> HOTJOBS = <JobDisplayData>[];
  static List<JobDisplayData> SEARCHJOBS = <JobDisplayData>[];
  static List<JobDisplayData> CHOOSEJOBS = <JobDisplayData>[];
  static List<JobDisplayData> FAVJOBS = <JobDisplayData>[];

  static List<String> SEARCHEDPATHS = <String>[];

  static StreamController<List<JobDisplayData>> HOTJOBSC = StreamController<List<JobDisplayData>>();
  static Stream HOTJOBSS = HOTJOBSC.stream;
  static late Function HOTJOBSF;

  static StreamController<List<JobDisplayData>> SEARCHJOBSC = StreamController<List<JobDisplayData>>();
  static Stream SEARCHJOBSS = SEARCHJOBSC.stream;
  static late Function SEARCHJOBSF;

  static StreamController<List<JobDisplayData>> CHOOSEJOBSC = StreamController<List<JobDisplayData>>();
  static Stream CHOOSEJOBSS = CHOOSEJOBSC.stream;
  static late Function CHOOSEJOBSF;

  static StreamController<List<JobDisplayData>> FAVJOBSC = StreamController<List<JobDisplayData>>();
  static Stream FAVJOBSS = FAVJOBSC.stream;
  static late Function FAVJOBSF;

  static StreamController<String> EASEBTNC = StreamController<String>();
  static Stream EASEBTNS = EASEBTNC.stream;
  static late Function EASEBTNF;


  static StreamController<String> ChatBoxQueryC = StreamController<String>();
  static Stream ChatBoxQueryS = ChatBoxQueryC.stream;
  static late Function ChatBoxQueryF;


  static StreamController<String> LanguageChange = StreamController<String>();
  static Stream LanguageChangeS = LanguageChange.stream;
  static late Function LanguageChangeF;


  static bool ISLoading = false;
  static bool IsMoreLoading = false;

  static void init(){
    SEARCHJOBSS.listen((event) async {
      SEARCHJOBSF(event);
    });
    HOTJOBSS.listen((event) async {
      HOTJOBSF(event);
    });
    CHOOSEJOBSS.listen((event) async {
      CHOOSEJOBSF(event);
    });
    FAVJOBSS.listen((event) async {
      FAVJOBSF(event);
    });
    ChatBoxQueryS.listen((event) async {
      ChatBoxQueryF(event);
    });

    LanguageChangeS.listen((event) async {
      LanguageChangeF(event);
    });

    // EASEBTNS.listen((event) async {
    //   EASEBTNF(event);
    // });
  }


  static Future<void> Execute() async
  {
    init();
  }

}