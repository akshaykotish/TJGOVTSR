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


  static StreamController<String> HideJobSheetData = StreamController<String>();
  static Stream HideJobSheetStream = HideJobSheetData.stream;
  static late Function HideJobSheetDataStreamToCall;

  static Future<void> Listen() async {


    HideJobSheetStream.listen((event) {
      if(HideJobSheetDataStreamToCall != null)
      {
        print("Listening");
        HideJobSheetDataStreamToCall();
      }
    });

    currentjobStream.listen((event) async {
      print("CAlled1");
      if(currentjobStreamToCall != null)
      {
        print("CAlled2");
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