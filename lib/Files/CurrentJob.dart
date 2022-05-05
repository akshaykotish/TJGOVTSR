import 'dart:async';
import 'dart:async';

import 'package:governmentapp/JobData.dart';

class CurrentJob{
  static JobData currrentjobData = JobData();
  static StreamController<JobData> CurrentJobStreamController = StreamController<JobData>();
  static Stream currentjobStream = CurrentJobStreamController.stream;
  static late Function currentjobStreamToCall;


  static StreamController<List<String>> CurrentSearchData = StreamController<List<String>>();
  static Stream currentSearchDataStream = CurrentSearchData.stream;
  static late Function currentSearchDataStreamToCall;


  static void Listen(){
    currentjobStream.listen((event) {
      if(currentjobStreamToCall != null)
      {
        currentjobStreamToCall(event);
      }
    });

    currentSearchDataStream.listen((event) {
      if(currentSearchDataStreamToCall != null)
      {
        currentSearchDataStreamToCall(event);
      }
    });
  }



  CurrentJob(jdata){
    currrentjobData = jdata;
  }
}