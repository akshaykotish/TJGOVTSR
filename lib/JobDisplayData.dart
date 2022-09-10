import 'dart:core';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:governmentapp/JobData.dart';
import 'package:governmentapp/Notifcations.dart';

class JobDisplayDatas{
  static List<JobDisplayData> jobDisplayDatas = <JobDisplayData>[];
}


class JobDisplayData {
  String Designation = "";
  int Count = 0;
  String Department = "";
  String Path = "";
  String JobString = "";
  late JobData jobData;

  void LoadFromSearchString(String jobString) {
    JobString = jobString;
  }

  Future<void> CheckForNotifications() async {
    var Job = await FirebaseFirestore.instance.doc(Path).get();
    var Dates = Job.exists ? Job.data()!["Important_Dates"] as Map<String, dynamic> : null;

    if(Dates != null){
      for (var key in Dates.keys) {
        var parts = Dates[key].toString().split("/");

        if(parts.length == 3)
        {
          int day = int.parse(parts[0]);
          int month = int.parse(parts[1]);
          int year = int.parse(parts[2]);

          DateTime dateTime = DateTime.now();

          if(day == dateTime.day && month == dateTime.month && year == dateTime.year)
          {
            Notifications.notifications.add("${Designation}'s ${key}");
            Notifications.NOTIFJOBSC.add(Notifications.notifications);
          }
        }
      }
    }
  }

  JobDisplayData(String jobString, [this.Count = 0])
  {
    //ASRBAgricultureAO&F&AORecruitment2021;ASRB Agriculture AO & F&AO Recruitment 2021;Jobs/Agricultural Scientists Recruitment Board (ASRB) /INDIA/ASRBAgricultureAO&F&AORecruitment2021
    //Jobs/Steel Authority of India Limited (Sail)/INDIA/SailBokaroSteelPlantAttendantCumTechnicianRecruitment2022;Steel Authority of India Limited (Sail);Sail Bokaro Steel Plant Attendant-Cum Technician Recruitment 2022 Apply Online for 146 Post;Steel Authority of India Limited (Sail) Bokaro Steel Plant Attendant-Cum Technician Vacancy 2022 has released the Detailed Notification for the recruitment of 146 posts. Any candidate who is interested in this recruitment and fulfills the eligibility can apply online from 25 August 2022 to 15 September 2022. For eligibility, age limit, training center, pay scale, selection procedure and all other information in recruitment, read the Attendant Cum Technician notification issued by Sail Bokaro Steel Plant and then apply.
    JobString = jobString;

    var Parts = JobString.split(";");
    if(Parts.length == 3)
      {
        Department = Parts[2].split("/")[1];
        Designation = Parts[1];
        int l = Designation.indexOf("Online Form");
        if(l>=0) {
          Designation = Designation.substring(0, l);
        }
        Path = Parts[2];

      }
    else{
      Department = Parts[1];
      Designation = Parts[2];
      int l = Designation.indexOf("Online Form");
      if(l >= 0) {
        Designation = Designation.substring(0, l);
      }
      Path = Parts[0];
    }
    CheckForNotifications();
  }
}
