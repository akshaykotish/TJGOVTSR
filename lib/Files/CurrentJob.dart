import 'dart:async';
import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:governmentapp/JobData.dart';

class CurrentJob{
  static JobData currrentjobData = JobData();
  static StreamController<JobData> CurrentJobStreamController = StreamController<JobData>();
  static Stream currentjobStream = CurrentJobStreamController.stream;
  static late Function currentjobStreamToCall;


  static StreamController<List<String>> CurrentSearchData = StreamController<List<String>>();
  static Stream currentSearchDataStream = CurrentSearchData.stream;
  static late Function currentSearchDataStreamToCall;

  static late Function currentjobStreamForVacanciesToCall;


  static StreamController<String> LovedJobsData = StreamController<String>();
  static Stream lovedjobDataStream = LovedJobsData.stream;
  static late Function lovedjobDataStreamToCall;


  static void Listen(){
    currentjobStream.listen((event) async {
      if(currentjobStreamToCall != null)
      {
        currentjobStreamToCall(event);
      }
      if(currentjobStreamForVacanciesToCall != null)
        {
          currentjobStreamForVacanciesToCall(event);
        }
    });

    currentSearchDataStream.listen((event) {
      if(currentSearchDataStreamToCall != null)
      {
         currentSearchDataStreamToCall(event);
      }
    });

    lovedjobDataStream.listen((event) {
      if(lovedjobDataStreamToCall != null)
        {
          lovedjobDataStreamToCall();
        }
    });
  }



  CurrentJob(jdata){
    currrentjobData = jdata;
  }


}