

import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:governmentapp/DataLoadingSystem/JobDisplayManagement.dart';
import 'package:governmentapp/JobData.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  static Future<List<String>> CreateRequiredPaths()
  async {
    List<String> Paths = <String>[];

    await Future.forEach(UserDepartments, (String department) async {
      if(UserStates.isEmpty)
        {
          Paths.add("Jobs/" + department + "/INDIA");
        }
      else{
        await Future.forEach(UserStates, (String location) {
          Paths.add("Jobs/" + department + "/" + location.toUpperCase());
        });
      }
    });
    return Paths;
  }

  static Future<void> Fire(var job) async {

      JobData jobData = JobData();
      await jobData.LoadFromFireStoreValues(job);

      print("Fired" + jobData.Title);

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
    print("Loaded from Web");

    var Reference = FirebaseFirestore.instance;

    List<String> Paths = await CreateRequiredPaths();

    Future.forEach(Paths, (String path) async {
      var RequiredJobs = await Reference.collection(path).get();

        RequiredJobs.docs.forEach((job) async {
            JobData jobData = JobData();

            bool istoadd = false;

            if(UserIntrests.isEmpty)
              {
                Fire(job);
              }
            else{
              await Future.forEach(UserIntrests, (String intrest){
                if(job.data()["Title"].toString().toLowerCase().contains(intrest.toLowerCase()) || job.data()["Short_Details"].toString().toLowerCase().contains(intrest.toLowerCase()))
                  {
                    istoadd = true;
                  }
              });
              istoadd == true ? Fire(job) : null;
            }

        });
    });
  }


  static void LoadCachedRequiredData(){
    print("Loaded from Cache");

    RequiredData.forEach((job) async {
      JobData jobData = JobData();
      await jobData.fromJson(job);

      JobDisplayManagement.jobstoshow.add(jobData);
      JobDisplayManagement.jobstoshowstreamcontroller.add(JobDisplayManagement.jobstoshow);

    });
  }


  static Future<void> Execute() async {
    await init();
    print("Required Caches are = ${UserDepartments.length}");

    RequiredData.isEmpty ?
    await DownloadRequiredData() : LoadCachedRequiredData();

    print("Hurry! We did it.... ${JobDisplayManagement.jobstoshow.length}");
  }

  //--------------------------------------------------------------------------


  void SaveRequiredDataAsCache(){

  }
}