import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:governmentapp/Animations/Loading.dart';
import 'package:governmentapp/DataLoadingSystem/JobDisplayManagement.dart';
import 'package:governmentapp/DataLoadingSystem/RequiredDataLoading.dart';
import 'package:governmentapp/DataLoadingSystem/SearchAbleDataLoading.dart';
import 'package:governmentapp/DataPullers/JobsManager.dart';
import 'package:governmentapp/Files/CurrentJob.dart';
import 'package:governmentapp/Files/DepartmentBox.dart';
import 'package:governmentapp/Files/JobBox.dart';
import 'package:governmentapp/JobData.dart';
import 'package:governmentapp/VacancyDetails.dart';
import 'package:shared_preferences/shared_preferences.dart';


class JobBoxs extends StatefulWidget {
  const JobBoxs({Key? key}) : super(key: key);

  @override
  State<JobBoxs> createState() => _JobBoxsState();
}

class _JobBoxsState extends State<JobBoxs> {

  var States = <String>["India", "Delhi","Andaman and Nicobar", "Andaman and Nicobar", "Andhra Pradesh", "Arunachal Pradesh", "Assam", "Bihar", "Chandigarh", "Chhattisgarh", "Dadra and Nagar Haveli", "Daman and Diu", "Delhi", "Goa", "Gujarat", "Haryana", "Himachal Pradesh", "Jammu and Kashmir", "Jharkhand", "Karnataka", "Kerala", "Lakshadweep", "Madhya Pradesh", "Maharashtra", "Manipur", "Meghalaya", "Mizoram", "Nagaland", "Orissa", "Puducherry", "Punjab", "Rajasthan", "Sikkim", "Tamil Nadu", "Telangana", "Tripura", "Uttar Pradesh", "Uttarakhand", "West Bengal"];
  var UserDepartments = <String>[];
  var UserStates = <String>[];
  var UserIntrests = <String>[];
  var AllDepartmentsList = <Widget>[];
  var LovedJobs = <String>[];
  bool isloved = false;


  Future<void> LoadPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    print("Loading Pref Run1");
    UserDepartments = (await prefs.getStringList('UserDepartments'))!;
    UserStates = (await prefs.getStringList('UserStates'))!;
    UserIntrests = (await prefs.getStringList('UserInterest'))!;
    LovedJobs = (await prefs.getStringList('lovedjobs'))!;
    print("Loading Pref Run2");
  }


  void DisplayJobs(List<JobData> jobs)
  {
    AllDepartmentsList.clear();
    var _AllDepartmentsList = <Widget>[];
    Map<String, List<JobBox>> _ToShowJobs = Map<String, List<JobBox>>();

    int index = 0;

    if(jobs.isEmpty)
      {
        _AllDepartmentsList.add(
          Container(
            child: Text(JobDisplayManagement.WhatToShow, style: TextStyle(color: Colors.red),),
          )
        );
      }

    jobs.forEach((job) {
      index++;
      if (!_ToShowJobs.containsKey(job.Department)) {
        _ToShowJobs[job.Department] = <JobBox>[];
      }

      _ToShowJobs[job.Department]!.add(
          JobBox(isClicked: false, jobData: job));


      if(index == jobs.length)
      {
        print("INDEX REACHED" + _ToShowJobs.length.toString());
        _ToShowJobs.forEach((key, value) {
          _AllDepartmentsList.add(DepartmentBox(DepartmentName: key, jobboxes: value));

          setState(() {
            AllDepartmentsList = _AllDepartmentsList;
          });
        });
      }
    });

    setState(() {
      AllDepartmentsList = _AllDepartmentsList;
    });
  }

  @override
  void initState() {
    // JobsManager.loadingjobsDataStreamToCall = (jobs){
    //   DisplayJobs(jobs);
    // };

    JobDisplayManagement.jobstoshowstreamToCall = (jobs)
    {
      DisplayJobs(jobs);
    };

    CurrentJob.currentSearchDataStreamToCall = (search) async {
      JobDisplayManagement.jobstoshow.clear();
      JobDisplayManagement.jobstoshowstreamcontroller.add(JobDisplayManagement.jobstoshow);

      print("CALELD SEARCH");

      JobDisplayManagement.isloadingjobs = true;
      await SearchAbleDataLoading.FastestSearchSystem(search);
      Timer(Duration(seconds: 1), (){
        setState(() {
          JobDisplayManagement.isloadingjobs = false;
        });
      });
    };

    CurrentJob.lovedjobDataStreamToCall = () async {

      JobDisplayManagement.jobstoshow.clear();
      JobDisplayManagement.jobstoshowstreamcontroller.add(JobDisplayManagement.jobstoshow);

      AllDepartmentsList.clear();
      print("Loved Click");
      setState(() {
        JobDisplayManagement.isloadingjobs = true;
      });
      print("LOading LovedJobs");
      await RequiredDataLoading.LoadLovedJobs();
      Timer(Duration(seconds: 1), (){
        setState(() {
          JobDisplayManagement.isloadingjobs = false;
        });
      });
    };
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return  Container(
      child: JobDisplayManagement.isloadingjobs == true ?
          SingleChildScrollView(child: LoadingAnim())
          :  Column(
        children:AllDepartmentsList,
      ),
    );
  }
}
