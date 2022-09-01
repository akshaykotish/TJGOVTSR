

import 'dart:async';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:governmentapp/DataLoadingSystem/JobDisplayManagement.dart';
import 'package:governmentapp/DataLoadingSystem/SearchAbleDataLoading.dart';
import 'package:governmentapp/JobData.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../DataPullers/HotJobs.dart';

class RequiredDataLoading{


  static var States = <String>[
    "India",
    "Delhi",
    "Andaman and Nicobar",
    "Andaman and Nicobar",
    "Andhra Pradesh",
    "Arunachal Pradesh",
    "Assam",
    "Bihar",
    "Chandigarh",
    "Chhattisgarh",
    "Dadra and Nagar Haveli",
    "Daman and Diu",
    "Delhi",
    "Goa",
    "Gujarat",
    "Haryana",
    "Himachal Pradesh",
    "Jammu and Kashmir",
    "Jharkhand",
    "Karnataka",
    "Kerala",
    "Lakshadweep",
    "Madhya Pradesh",
    "Maharashtra",
    "Manipur",
    "Meghalaya",
    "Mizoram",
    "Nagaland",
    "Orissa",
    "Puducherry",
    "Punjab",
    "Rajasthan",
    "Sikkim",
    "Tamil Nadu",
    "Telangana",
    "Tripura",
    "Uttar Pradesh",
    "Uttarakhand",
    "West Bengal"
  ];

  static var UserDepartments = <String>[];
  static var UserStates = <String>[];
  static var UserIntrests = <String>[];
  static var AllDepartmentsList = <Widget>[];
  static var LovedJobs = <String>[];
  static var RequiredData = <String>[];
  static var HotsCache = <String>[];

  static Future<void> init() async {
    JobDisplayManagement.jobstoshow.clear();

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

  static Future<List<String>> CreateRequiredPaths()
  async {
    List<String> Paths = <String>[];

    await Future.forEach(UserDepartments, (String department) async {
      if(UserStates.isEmpty)
        {
          Paths.add("Jobs/" + department + "/INDIA");
        }
      else{
        await Future.forEach(UserStates, (String location) async {
          Paths.add("Jobs/" + department + "/" + location.toUpperCase());
        });
      }
    });

    if(UserDepartments.length == 0) {
      await Future.forEach(UserStates, (String states) async {
        await Future.forEach(
            SearchAbleDataLoading.SearchAbleCache, (String SearchString) {
          if (SearchString.toLowerCase().contains(states.toLowerCase())) {
            String path = SearchString.split(";")[0];
            if (!Paths.contains(path)) {
              Paths.add(path);
            }
          }
        });
      });
    }

    if(UserDepartments.length == 0) {
      await Future.forEach(UserIntrests, (String intrest) async {
        await Future.forEach(
            SearchAbleDataLoading.SearchAbleCache, (String SearchString) {
          if (SearchString.toLowerCase().contains(intrest.toLowerCase())) {
            String path = SearchString.split(";")[0];
            if (!Paths.contains(path)) {
              Paths.add(path);
            }
          }
        });
      });
    }



    return Paths;
  }

  static Future<void> Fire(var job) async {


      JobData jobData = JobData();
      await jobData.LoadFromFireStoreValues(job);


      if(JobDisplayManagement.ismoreloadingjobs)
        {
          JobDisplayManagement.ismoreloadingjobs = false;
        }
      JobDisplayManagement.jobstoshow.add(jobData);

      JobDisplayManagement.jobstoshowstreamcontroller.add(JobDisplayManagement.jobstoshow);

      SaveCookiesForRequriedData(jobData);
  }

  static Future<void> SaveCookiesForRequriedData(JobData jobData) async {

    String jsonString = await jsonEncode(await jobData.toJson());

    RequiredData.add(jsonString);

    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setStringList("RequiredData", RequiredData);
  }

  static Future<void> DownloadRequiredData() async {

    var Reference = FirebaseFirestore.instance;

    List<String> Paths = await CreateRequiredPaths();

    JobDisplayManagement.ismoreloadingjobs = true;
    await Future.forEach(Paths, (String path) async {
      if(path.split("/").length == 3) {
        var RequiredJobs = await Reference.collection(path).get();

        RequiredJobs.docs.forEach((job) async {
          JobData jobData = JobData();

          bool istoadd = false;

          JobDisplayManagement.HideJobsLoading();
          if (UserIntrests.isEmpty) {
            Fire(job);
          }
          else {
            await Future.forEach(UserIntrests, (String intrest) {
              if (job.data()["Designation"].toString().toLowerCase().contains(
                  intrest.toLowerCase()) ||
                  job.data()["Short_Details"].toString().toLowerCase().contains(
                      intrest.toLowerCase()) ||
                  job.data()["Title"].toString().toLowerCase().contains(
                      intrest.toLowerCase()) ||
                  job.data()["Short_Details"].toString().toLowerCase().contains(
                      intrest.toLowerCase()) ||
                  job.data()["Designation"].toString().toLowerCase().contains(
                      intrest.toLowerCase()) ||
                  job.data()["AgeLimits"].toString().toLowerCase().contains(
                      intrest.toLowerCase())) {
                istoadd = true;
              }
            });
            istoadd == true ? Fire(job) : null;
          }
        });
      }
      else if(path.split("/").length == 4){
        var job = await Reference.doc(path).get();
        JobDisplayManagement.HideJobsLoading();
        Fire(job);
      }
    });
    JobDisplayManagement.ismoreloadingjobs = false;
  }


  static void LoadCachedRequiredData(){
    print("Loaded from Cache");


    JobDisplayManagement.ismoreloadingjobs = true;
    RequiredData.forEach((job) async {
      JobData jobData = JobData();
      print(job);
      await jobData.fromJson(job);

      if(JobDisplayManagement.isloadingjobs || JobDisplayManagement.ismoreloadingjobs)
      {
        JobDisplayManagement.ismoreloadingjobs = false;
        JobDisplayManagement.isloadingjobs = false;
      }
      JobDisplayManagement.jobstoshow.add(jobData);
      JobDisplayManagement.jobstoshowstreamcontroller.add(JobDisplayManagement.jobstoshow);

      print(JobDisplayManagement.jobstoshow.length);
    });
    JobDisplayManagement.ismoreloadingjobs = false;
    JobDisplayManagement.isloadingjobs = false;
  }

  static Future<void> LoadHotJobs()
  async {
    print("Loading Hot Jobs Started");

        List<String> pathadded = <String>[];
        JobDisplayManagement.jobstoshow.clear();
        JobDisplayManagement.ismoreloadingjobs = true;

        var hotJobs;
        hotJobs = await FirebaseFirestore.instance.collection("Logs").doc("Hots").get();

        List<dynamic> jobs = hotJobs.data()!["Hots"];
        for(int i=jobs.length - 1; i>=0; i--)
          {
            if(JobDisplayManagement.isloadingjobs)
            {
              JobDisplayManagement.isloadingjobs = false;
            }

            String path = jobs[i].toString();
            if(pathadded.contains(path) == false && path.split("/").length == 4 && path.split("/")[0] != "" && path.split("/")[1] != "" && path.split("/")[2] != "" && path.split("/")[3] != "")
              {
                pathadded.add(path);
                print(i);
                var job = await FirebaseFirestore.instance.doc(path).get();
                JobData jobData = JobData();
                jobData.count = 50;
                await jobData.LoadFromFireStoreValues(job);
                JobDisplayManagement.jobstoshow.add(jobData);
                if(i % 5 == 0 || i == 0) {
                  if(HotJobs.isfirstjobloaded == true) {
                    JobDisplayManagement.jobstoshowstreamcontroller.add(
                        JobDisplayManagement.jobstoshow);
                  }
                }
              }
          }

  }


  static Future<void> Execute() async {
    await init();
    print("Required Caches are = ${UserDepartments.length}");

      if(UserDepartments.isNotEmpty) {
        RequiredData.isEmpty ?
        DownloadRequiredData() : LoadCachedRequiredData();

        JobDisplayManagement.HideJobsLoading();
        JobDisplayManagement.isloadingjobs = false;

        print("Hurry! We did it.... ${JobDisplayManagement.jobstoshow.length}");
      }
      else{
        print("Loading Hot Jobs");

        if(HotJobs.isfirstjobloaded) {
          LoadHotJobs();
        }
        if(!HotJobs.isfirstjobloaded)
        {
          HotJobs.isfirstjobloaded = true;

          JobDisplayManagement.jobstoshowstreamcontroller.add(
              JobDisplayManagement.jobstoshow);
        }
      }
  }

  //--------------------------------------------------------------------------


  static Future<void> LoadLovedJobs() async {
    JobDisplayManagement.jobstoshow.clear();
    await Future.forEach(LovedJobs, (String lovedjob) async {
      if(JobDisplayManagement.isloadingjobs == true)
        {
          JobDisplayManagement.isloadingjobs = false;
        }
      JobData jobData = JobData();
      jobData.count = 78;
      await jobData.fromJson(lovedjob);

      JobDisplayManagement.isloadingjobs = false;
      JobDisplayManagement.jobstoshow.add(jobData);
      JobDisplayManagement.jobstoshowstreamcontroller.add(JobDisplayManagement.jobstoshow);
    });
  }

  static Future<void> LoadLovedCache() async {

    final prefs = await SharedPreferences.getInstance();
    var l = prefs.getStringList('lovedjobs');
    if(l != null)
      {
        LovedJobs = l;
      }

  }

}