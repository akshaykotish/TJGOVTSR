import 'dart:core';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:governmentapp/DataLoadingSystem/JobDisplayManagement.dart';
import 'package:governmentapp/DataLoadingSystem/RequiredDataLoading.dart';
import 'package:governmentapp/Graphics/PostGraphic.dart';
import 'package:governmentapp/JobData.dart';
import 'package:governmentapp/Notifcations.dart';
import 'dart:ui' as ui;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:governmentapp/PostOnSocialMedia.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;


class JobDisplayDatas{
  static List<JobDisplayData> jobDisplayDatas = <JobDisplayData>[];
}


class JobDisplayData {
  String Designation = "";
  int Count = 0;
  String Department = "";
  String Path = "";
  String JobString = "";
  String AboutJob = "";
  String Location = "";

  late JobData jobData;

  PostOnSocialMedia postOnSocialMedia = PostOnSocialMedia();

  void LoadFromSearchString(String jobString) {
    JobString = jobString;
  }

  Future<void> CheckPostLog(String ID, String UpdateName, String UpdateDate) async {
    var Log = await FirebaseFirestore.instance.doc(Path).collection("Logs").doc(ID).get();
    if(Log.exists == false)
      {
        print("$ID is here");
        if(JobDisplayManagement.NotificationPosted == false) {
          await postOnSocialMedia.UploadPhoto(UpdateName, UpdateDate);

          await FirebaseFirestore.instance.doc(Path).collection("Logs")
              .doc(ID)
              .set({
            "ID": ID,
            "URL": postOnSocialMedia.URL,
            "TimeStamp": DateTime.now().toIso8601String(),
          });
          JobDisplayManagement.NotificationPosted = true;
        }
      }
  }


  Future<void> CheckForNotifications() async {
    try {
      print("IM in Notifications");
      var parts = Path.split(";");
      if (parts.length == 4) {
        var Job = await FirebaseFirestore.instance.doc(Path).get();
        var Dates = Job.exists ? Job.data()!["Important_Dates"] as Map<
            String,
            dynamic> : null;

        if (Dates != null) {
          for (var key in Dates.keys) {
            var parts = Dates[key].toString().split("/");

            if (parts.length == 3) {
              int day = int.parse(parts[0]);
              int month = int.parse(parts[1]);
              int year = int.parse(parts[2].substring(0, 4));

              DateTime dateTime = DateTime.now();

              if (day == dateTime.day && month == dateTime.month &&
                  year == dateTime.year) {
                String DateKey = Dates[key].toString()
                    .replaceAll("/", "")
                    .replaceAll("-", "")
                    .replaceAll(":", "");
                await CheckPostLog(DateKey, key, Dates[key]);
                print("Reached Here");
                Notifications.notifications.add(
                    Path + ";" + Designation + ";" + key);
                Notifications.NOTIFJOBSC.add(Notifications.notifications);
              }
            }
          }
        }
      }
    }
    catch(e)
    {
      print(e);
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
      // Department = Parts[1];
      // Designation = Parts[2];
      // Location = Parts[0].split("/")[2];
      // AboutJob = Parts[3];
      //

      postOnSocialMedia.Department = Department = Parts[1];
      postOnSocialMedia.Designation = Designation = Parts[2];
      postOnSocialMedia.Location = Location = Parts[0].split("/")[2];
      postOnSocialMedia.AboutJob = AboutJob = Parts[3];

      int l = Designation.indexOf("Online Form");
      if(l >= 0) {
        Designation = Designation.substring(0, l);
      }
      Path = Parts[0];
    }
    CheckForNotifications();

  }
}
