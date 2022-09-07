import 'dart:async';
import 'package:flutter/material.dart';
import 'package:governmentapp/Beauty/ShowSkeleton.dart';
import 'package:governmentapp/DataLoadingSystem/JobDisplayManagement.dart';
import 'package:governmentapp/DataLoadingSystem/RequiredDataLoading.dart';
import 'package:governmentapp/DataLoadingSystem/SearchAbleDataLoading.dart';
import 'package:governmentapp/Files/CurrentJob.dart';
import 'package:governmentapp/Files/DepartmentBox.dart';
import 'package:governmentapp/Files/JobBox.dart';
import 'package:governmentapp/JobDisplayData.dart';

import '../JobDisplayData.dart';


class JobBoxs extends StatefulWidget {
  const JobBoxs({Key? key}) : super(key: key);

  @override
  State<JobBoxs> createState() => _JobBoxsState();
}


class _JobBoxsState extends State<JobBoxs> {

  Map<String, List<JobBox>> _ToShowJobs = Map<String, List<JobBox>>();
  var AllDepartments = <Widget>[];

  void Display(List<JobDisplayData> jobs){
    var _AllDepartments = <Widget>[];
    _AllDepartments.clear();
    AllDepartments.clear();
    if(jobs.isEmpty)
      {
        _AllDepartments.add(ShowSkeleton());
        Timer(Duration(seconds: 15), (){
          print("Ended");
          if(jobs.isEmpty)
            {
              _AllDepartments.add(Text("Empty"));
              setState(() {
                AllDepartments = _AllDepartments;
              });
            }
        });
      }
    else{
      if(JobDisplayManagement.IsMoreLoading == true) {
        _AllDepartments.add(ShowSkeleton());
      }
      _ToShowJobs.clear();
      for (var job in jobs) {
        if (!_ToShowJobs.containsKey(job.Department)) {
          _ToShowJobs[job.Department] = <JobBox>[];
        }

        _ToShowJobs[job.Department]!.add(
            JobBox(isClicked: false, jobDisplayData: job));
      }
      _ToShowJobs.forEach((key, value) {
        _AllDepartments.add(DepartmentBox(DepartmentName: key, jobboxes: value));
        setState(() {
          AllDepartments = _AllDepartments;
        });

      });
    }

    setState(() {
      AllDepartments = _AllDepartments;
    });
  }

  void InitFunctions()
  {
    JobDisplayManagement.HOTJOBSF = (List<JobDisplayData> list){
      if(JobDisplayManagement.WhichShowing == 1)
        {
          print("HOTJOBS");
          Display(list);
        }
    };
    JobDisplayManagement.CHOOSEJOBSF = (List<JobDisplayData> list){
      if(JobDisplayManagement.WhichShowing == 2)
      {
        print("CHOOSEJOBS");
        Display(list);
      }
    };
    JobDisplayManagement.SEARCHJOBSF = (List<JobDisplayData> list){
      if(JobDisplayManagement.WhichShowing == 3)
      {
        print("SEARCHJOBS");
        Display(list);
      }
    };
    JobDisplayManagement.FAVJOBSF = (List<JobDisplayData> list){
      if(JobDisplayManagement.WhichShowing == 4)
      {
        print("FAVJOBS");
        Display(list);
      }
    };


  }

  void InitCurrents()
  {
    CurrentJob.currentSearchDataStreamToCall = (search) async {
      SearchAbleDataLoading.FastestSearchSystem(search);
    };

    CurrentJob.lovedjobDataStreamToCall = () async {
      RequiredDataLoading.LoadLovedJobs();
    };
  }

  @override
  void initState() {
    InitFunctions();
    InitCurrents();
    super.initState();
    RequiredDataLoading.Execute();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: AllDepartments,
      ),
    );
  }
}



/*
*
    jobs.forEach((job) {
      index++;
      if (!_ToShowJobs.containsKey(job.Department)) {
        _ToShowJobs[job.Department] = <JobBox>[];
      }

      _ToShowJobs[job.Department]!.add(
          JobBox(isClicked: false, JobDisplayData: job));


      if(index == jobs.length)
      {
        _ToShowJobs.forEach((key, value) {
          _AllDepartmentsList.add(DepartmentBox(DepartmentName: key, jobboxes: value));

          setState(() {
            JobDisplayManagement.isloadingjobs = false;
            JobDisplayManagement.ismoreloadingjobs = false;
            AllDepartmentsList = _AllDepartmentsList;
          });

        });
      }
    });
    * */