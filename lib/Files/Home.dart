import 'dart:async';
import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:governmentapp/DataPullers/AllPullers.dart';
import 'package:governmentapp/Files/Header.dart';
import 'package:governmentapp/Files/JobBoxs.dart';
import 'package:governmentapp/Files/PositionedSearchArea.dart';
import 'package:governmentapp/Files/SearchArea.dart';
import 'package:governmentapp/HexColors.dart';
import 'package:governmentapp/JobData.dart';
import 'package:governmentapp/JobObject.dart';

import '../JobData.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  bool PositionedSearchArea_Visible = false;
  ScrollController scrollController = new ScrollController();


  StreamController<List<JobData>> jobdatacontroller = StreamController<List<JobData>>();

  Stream Get_JobsData_In_RealTime() {
    GetJobData();
    return jobdatacontroller.stream;
  }

  var SelectedDepartments = ["", ""];
  var SelectedStates = ["", ""];
  var selectedIntrest = ["", ""];


  var Departments = <Widget>[];
  var Jobs = <Widget>[];
  var Saved = [1,5,6];

  Map<String, List<JobData>> department_wise_jobs = Map<String, List<JobData>>();


  String GetShortName(String v){
    var i = v.indexOf("(");
    var j = v.indexOf(")");

    String output = "";
    if(i != null && i !=0 && j != null && j != 0)
      {
        var parts = v.split(" ");

        for(int l=0; l<parts.length; l++)
          {
            if(parts[l][0] == "(" || parts[l][0] == ")"){
              break;
            }
            output += parts[l][0].toUpperCase();
          }
      }
    else{
      output = v.substring(i, j);
    }

    return output;
  }

  void GetJobData(){
    FirebaseFirestore.instance.collection("Jobs").snapshots().listen((event) {

      int i = 0;
      var jobs = <Widget>[];
      event.docs.forEach((element) {
        JobData jobData = new JobData();
        jobData.Title = element.data()["Title"];
        jobData.Department = element.data()["Department"];
        jobData.Short_Details = element.data()["Short_Details"];
        jobData.isSave = false;

        if(department_wise_jobs.containsKey(jobData.Department) == false)
          {
            department_wise_jobs[jobData.Department] = <JobData>[];
          }

        department_wise_jobs[jobData.Department]?.add(jobData);
        //print(department_wise_jobs[jobData.Department]?.length);
      });

      print("Hello");
      var _Departments = <Widget>[];
      for(var v in department_wise_jobs.keys)
      {
        var AllJobs = <Widget>[];


        for(int l=0; l<department_wise_jobs[v]!.length; l++)
          {
            AllJobs.add(

                Container(
                  width: MediaQuery.of(context).size.width,
                  margin: const EdgeInsets.all(15),
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(
                      Radius.circular(15),
                    ),
                    boxShadow: [
                      BoxShadow(
                        //color: Colors.grey.shade400,
                        color: Colors.grey.shade400.withOpacity(1),
                        offset: const Offset(1, 1),
                        blurRadius: 1,
                        spreadRadius: 1,
                      ),
                      BoxShadow(
                        //color: Colors.grey.shade400,
                        color: Colors.grey.shade300.withOpacity(1),
                        offset: const Offset(-1, 1),
                        blurRadius: 1,
                        spreadRadius: 1,
                      ),
                      BoxShadow(
                        //color: Colors.grey.shade400,
                        color: Colors.grey.shade200.withOpacity(1),
                        offset: const Offset(1, -1),
                        blurRadius: 1,
                        spreadRadius: 1,
                      ),
                      BoxShadow(
                        //color: Colors.grey.shade400,
                        color: Colors.grey.shade100.withOpacity(1),
                        offset: const Offset(-1, -1),
                        blurRadius: 1,
                        spreadRadius: 1,
                      ),
                    ],
                    color: Colors.white,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(
                        width: MediaQuery.of(context).size.width - 40,
                        child: Text(department_wise_jobs[v]![l].Title,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width - 40,
                        child: Text(department_wise_jobs[v]![l].Department,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Color.fromRGBO(88, 88, 88, 1),
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width - 40,
                        child: Text(department_wise_jobs[v]![l].Short_Details,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Color.fromRGBO(88, 88, 88, 1),
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        children:  <Widget>[
                          Row(
                            children: const <Widget>[
                              Icon(Icons.thumb_up_outlined),
                              SizedBox(width: 5,),
                              Text("0 Liked")
                            ],
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Row(
                            children: const <Widget>[
                              Icon(Icons.remove_red_eye_outlined),
                              SizedBox(width: 5,),
                              Text("0 Views")
                            ],
                          )
                        ],
                      )
                    ],
                  ),
                ),
            );
          }

        _Departments.add(
          Column(
            children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width,
                margin: const EdgeInsets.only(left: 15, right: 15, top: 15),
                child: Row(
                  children: <Widget>[
                    const Text("Jobs in ",
                      style: TextStyle(
                        fontSize: 15,
                      ),),
                    Text(GetShortName(v),
                      style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold
                      ),),
                    const Text(" at ",
                      style: TextStyle(
                        fontSize: 15,
                      ),),
                    const Icon(
                      Icons.location_on_outlined,
                    ),
                    const Text("India ",
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold
                      ),),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: AllJobs,
              )
            ],
          )
        );


        setState(() {
          Departments = _Departments;
        });
      }


    });


  }

    @override
  void initState() {
    scrollController.addListener(() {
      print(scrollController.offset );

      if(scrollController.offset.ceil() > 350)
        {
          setState(() {
            PositionedSearchArea_Visible = true;
          });
        }
      else{
        setState(() {
          PositionedSearchArea_Visible = false;
        });
      }
    });
    GetJobData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Stack(
          children: <Widget>[
            SingleChildScrollView(
              controller: scrollController,
              child: Column(
                children: <Widget>[
                  Visibility(visible: !PositionedSearchArea_Visible ,child: Header()),
                  Visibility(visible: !PositionedSearchArea_Visible ,child: SearchArea()),
                  JobBoxs(),
                  Container(
                    color: Colors.white,
                    height: 1700,
                    width: 300,
                  )
                ],
              ),
            ),

            Positioned(
              left: 0,
              top: 0,
              right: 0,
              child: AnimatedOpacity(
                duration: Duration(seconds: 1,),
                opacity: PositionedSearchArea_Visible ? 1 : 0,
                child: Visibility(
                    visible: PositionedSearchArea_Visible,
                    child: PositionedSearchArea()),
              ),),
          ],
        ),
      ),
    );
  }
}
