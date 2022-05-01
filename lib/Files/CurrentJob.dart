import 'dart:async';
import 'dart:async';

import 'package:governmentapp/JobData.dart';

class CurrentJob{
  static JobData currrentjobData = JobData();
  static StreamController<JobData> CurrentJobStreamController = StreamController<JobData>();
  static Stream currentjobStream = CurrentJobStreamController.stream;


  static StreamController<List<String>> CurrentSearchData = StreamController<List<String>>();
  static Stream CurrentSearchDataStream = CurrentSearchData.stream;

  CurrentJob(jdata){
    currrentjobData = jdata;
  }
}