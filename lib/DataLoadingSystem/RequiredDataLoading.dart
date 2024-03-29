

import 'dart:async';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:governmentapp/ChatDatas.dart';
import 'package:governmentapp/DataLoadingSystem/JobDisplayManagement.dart';
import 'package:governmentapp/DataLoadingSystem/SearchAbleDataLoading.dart';
import 'package:governmentapp/JobData.dart';
import 'package:governmentapp/JobDisplayData.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../DataPullers/HotJobs.dart';

class RequiredDataLoading{
  static List<dynamic> Indexs = <dynamic>[];

  static var UserDepartments = <String>[];
  static var UserStates = <String>[];
  static var UserIntrests = <String>[];
  static var AllDepartmentsList = <Widget>[];
  static var LovedJobs = <String>[];
  static var RequiredData = <String>[];
  static var HotsCache = <String>[];

  static Future<void> LoadIndexs() async {
    Indexs = <dynamic>[];
    print("Hhu");
    var Indxs = await FirebaseFirestore.instance.collection("Indexs").doc("Jobs").get();
    if(Indxs.exists)
      {
        Indexs = Indxs.data()!["SearchAbleCache"] as List<dynamic>;
        print("LOad Index ${Indexs.length}");
      }
  }

  static Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();

    var ud = (prefs.getStringList(
        'UserDepartments')); //Loading Department Caches
    ud != null ? UserDepartments = ud : null;

    var us = (prefs.getStringList(
        'UserStates')); //Loading State Caches
    us != null ? UserStates = us : null;

    var ui = (prefs.getStringList(
        'UserInterest')); //Loading Interest Caches
    ui != null ? UserIntrests = ui : null;

    var lj = (prefs.getStringList(
        'lovedjobs')); //Loading LovedJobs Caches
    lj != null ? LovedJobs = lj : null;


    var rd = (prefs.getStringList(
        'RequiredData')); //Loading LovedJobs Caches
    rd != null ? RequiredData = rd : null;
  }


  static Future<JobData> LoadJobFromPath(String path, jobData) async {
    print(path);
    var Jobe = await FirebaseFirestore.instance.doc(path).get();
    if(Jobe.exists)
    {
      jobData.LoadFromFireStoreValues(Jobe);
      print("YES");
    }
    else{
      path = path.replaceAll(" /", "/");
      Jobe = await FirebaseFirestore.instance.doc(path).get();
      if(Jobe.exists) {
        jobData.LoadFromFireStoreValues(Jobe);
      }
      else{
        jobData.Designation = "This job is no longer exist.";
      }
      print("NO");
    }
   return jobData;
  }



  static Future<void> LoadChoosedJobs() async {
    JobDisplayManagement.WhichShowing = 2;

    if(JobDisplayManagement.CHOOSEJOBS.isEmpty) {
      JobDisplayManagement.CHOOSEJOBSC.add(
          JobDisplayManagement.CHOOSEJOBS);
      if (Indexs.isNotEmpty) {
        for (var element in Indexs) {
          String JobString = element.toString();
          String JobStringLW = element.toString().toLowerCase();

          bool isUD = false;
          bool isUS = false;

          for (var ud in UserDepartments) {
            if (JobStringLW.contains(ud.toLowerCase())) {
              isUD = true;
            }
          }

          for (var us in UserStates) {
            if (JobStringLW.contains(us.toLowerCase())) {
              isUS = true;
            }
          }
          UserStates.isEmpty ? isUS = true : null;

          if (isUD && isUS) {
            JobDisplayManagement.CHOOSEJOBS.add(JobDisplayData(JobString));
            JobDisplayManagement.CHOOSEJOBSC.add(
                JobDisplayManagement.CHOOSEJOBS);
          }
        }
      }
    }
    else{
      JobDisplayManagement.CHOOSEJOBSC.add(
          JobDisplayManagement.CHOOSEJOBS);
    }
  }


  static Future<void> LoadLikedJobs() async {
    await init();
    JobDisplayManagement.WhichShowing = 4;

    print("IMHERE");
      if (Indexs.isNotEmpty) {
        print("IMHEREINSIDE");
        for (var element in Indexs) {
          for(int i=0; i < LovedJobs.length; i++)
            {
              if(element.toString().contains(LovedJobs[i]))
                {
                  JobDisplayManagement.FAVJOBS.add(JobDisplayData(element, 4));
                }
            }
        }
        print("FAVIS${JobDisplayManagement.FAVJOBS.length}");
        JobDisplayManagement.FAVJOBSC.add(JobDisplayManagement.FAVJOBS);
      }
  }

  static Future<void> LoadHotJobs() async {
    JobDisplayManagement.WhichShowing = 1;
    if(JobDisplayManagement.HOTJOBS.isEmpty) {
      JobDisplayManagement.HOTJOBSC.add(JobDisplayManagement.HOTJOBS);
      var Hots = await FirebaseFirestore.instance.collection("Logs")
          .doc("Hots")
          .get();
      if (Hots.exists) {
        var HotJobs = await (Hots.data()!["Hots"] as List<dynamic>).reversed;
        for (var value in HotJobs) {
          String JobString = value.toString();
          JobDisplayManagement.HOTJOBS.add(JobDisplayData(JobString, 50));
        }
        JobDisplayManagement.HOTJOBSC.add(JobDisplayManagement.HOTJOBS);

      }
    }
  }

  static Future<void> CheckJobsNotification() async {
    await Future.forEach(JobDisplayManagement.HOTJOBS, (JobDisplayData jobDisplayData) async {
      await jobDisplayData.CheckForNotifications();
      print("Notifications" + jobDisplayData.Designation);
    });

    await ChatDatas.CreateNotifications();
  }


  static Future<void> LoadLikedNotifications() async {

    if (Indexs.isNotEmpty) {
      for (var element in Indexs) {
        for(int i=0; i < LovedJobs.length; i++)
        {
          if(element.toString().contains(LovedJobs[i]))
          {
            var jobData = JobData();
            jobData = await RequiredDataLoading.LoadJobFromPath(LovedJobs[i], jobData);
            await jobData.CheckForNotifications();

          }
        }
      }
    }
  }


  static Future<void> Execute() async {
    await LoadIndexs();
    await init();
    await LoadHotJobs();
    await LoadLikedJobs();
    await CheckJobsNotification();
//    await LoadLikedNotifications();

    // if(UserDepartments.isNotEmpty)
    //   {
    //     LoadChoosedJobs();
    //   }
    // else{
    //}
  }
}