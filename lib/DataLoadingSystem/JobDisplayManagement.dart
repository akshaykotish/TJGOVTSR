

import 'dart:async';

import '../JobDisplayData.dart';

class JobDisplayManagement{

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
  }


  static Future<void> Execute() async
  {
    init();
  }

}