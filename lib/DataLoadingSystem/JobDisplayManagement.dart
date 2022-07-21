

import 'dart:async';

import '../JobData.dart';

class JobDisplayManagement{
  static List<JobData> jobstoshow = <JobData>[];

  static StreamController<List<JobData>> jobstoshowstreamcontroller = StreamController<List<JobData>>();
  static Stream jobstoshowstream = jobstoshowstreamcontroller.stream;
  static late Function jobstoshowstreamToCall;

  static void init(){
    jobstoshowstream.listen((event) async {
      if(jobstoshowstreamToCall != null)
      {
        jobstoshowstreamToCall(event);
      }
    });
  }


  static void Execute()
  {
    init();
  }

}