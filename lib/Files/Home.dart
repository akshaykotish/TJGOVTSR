import 'dart:async';
import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:governmentapp/Animations/Loading.dart';
import 'package:governmentapp/DataLoadingSystem/JobDisplayManagement.dart';
import 'package:governmentapp/DataLoadingSystem/RequiredDataLoading.dart';
import 'package:governmentapp/DataPullers/AllPullers.dart';
import 'package:governmentapp/Files/CurrentJob.dart';
import 'package:governmentapp/Files/Header.dart';
import 'package:governmentapp/Files/JobBoxs.dart';
import 'package:governmentapp/Files/JobSheet.dart';
import 'package:governmentapp/Files/PositionedSearchArea.dart';
import 'package:governmentapp/Files/SearchArea.dart';
import 'package:governmentapp/Filtration/FilterPage.dart';
import 'package:governmentapp/ForUsers/ChooseDepartment.dart';
import 'package:governmentapp/HexColors.dart';
import 'package:governmentapp/JobData.dart';
import 'package:governmentapp/JobObject.dart';

import '../JobData.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {

  var initialchildsize = .0;
  late DraggableScrollableController draggableScrollableController;

  late Animation _animation;
  late AnimationController _animationController;
  double AnimatedDrawer = 400;

  bool PositionedSearchArea_Visible = false;
  ScrollController scrollController = new ScrollController();


  StreamController<List<JobData>> jobdatacontroller = StreamController<List<JobData>>();


  Stream Get_JobsData_In_RealTime() {
    //GetJobData();
    return jobdatacontroller.stream;
  }

  var SelectedDepartments = ["", ""];
  var SelectedStates = ["", ""];
  var selectedIntrest = ["", ""];



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


  JobData SheetjobData = JobData();


    @override
  void initState() {
      JobDisplayManagement.isloadingjobs = true;
      RequiredDataLoading.Execute();
      draggableScrollableController = DraggableScrollableController();

      CurrentJob.currentjobStreamToCall = (value) {
        setState(() {
          initialchildsize = .9;
          draggableScrollableController.animateTo(0.9, duration: Duration(milliseconds: 500), curve: Curves.easeIn);
          SheetjobData = value;
        });
      };

      super.initState();
//      GetJobData();
    scrollController.addListener(() {

      if(scrollController.offset.ceil() > 250)
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


      //WidgetsBinding.instance?.addPostFrameCallback((_) => Animate());

    }


    void Animate(){
      _animationController = AnimationController(
        vsync: this,
        duration: Duration(seconds: 3),
      );


      _animation = Tween(begin: 100.0, end: MediaQuery.of(context).size.height.toDouble()).animate(_animationController);


      _animationController.addStatusListener((AnimationStatus status) {
        setState(() {
          AnimatedDrawer = _animation.value;
        });
        if (status == AnimationStatus.completed) {

        }
      });
    }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: ColorFromHexCode("#F4F6F7"),
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Stack(
          children: <Widget>[
            SingleChildScrollView(
              controller: scrollController,
              child: Column(
                children: <Widget>[
                  Header(),
                  Visibility(visible: !PositionedSearchArea_Visible ,child: SearchArea()),
                  GestureDetector(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>ChooseDepartment()));
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      alignment: Alignment.center,
                      child: Column(
                        children: <Widget>[
                          JobDisplayManagement.ismoreloadingjobs == true ? Column(
                            children: <Widget>[
                              SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Container(
                                  width: MediaQuery.of(context).size.width,
                                  height: 250,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: const <Widget>[
                                      SkeletonDeptCard(),
                                      SkeltonCard(),
                                      SizedBox(height: 20,),
                                    ],
                                  ),
                                ),
                              ),

                              Container(
                                child: Image.asset("assets/images/loading.gif"),
                                width: 100,
                                height: 50,
                              ),
                            ],
                          ) : Container(),
                          SizedBox(height: 10,),
                        ],
                      ),
                    ),
                  ),
                  const JobBoxs(),
                  SizedBox(height: 10,),
                  JobDisplayManagement.ismoreloadingjobs == false ? Container(
                      width: MediaQuery.of(context).size.width,
                      child: Text("If you don't find what are you looking for", style: TextStyle(color: Colors.grey[400], fontWeight: FontWeight.bold,), textAlign: TextAlign.center,)) : Container(),
                  JobDisplayManagement.ismoreloadingjobs == false ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        child: Text("click to ", style: TextStyle(color: Colors.black.withOpacity(0.4), fontWeight: FontWeight.bold,), textAlign: TextAlign.center,),
                      ),
                      Container(
                          child: Text("try with some more filters", style: TextStyle(color: Colors.grey[400], fontWeight: FontWeight.bold,), textAlign: TextAlign.center,)),
                      SizedBox(width: 5,),
                      Icon(Icons.filter_list_outlined, color: Colors.grey[400],)
                    ],
                  ) : Container(),
                  const SizedBox(height: 350,),
                ],
              ),
            ),

            Positioned(
              left: 0,
              top: 0,
              right: 0,
              child: AnimatedOpacity(
                duration: Duration(milliseconds: 100,),
                opacity: PositionedSearchArea_Visible ? 1 : 0,
                child: Visibility(
                    visible: PositionedSearchArea_Visible,
                    child: PositionedSearchArea()),
              ),),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              height: MediaQuery.of(context).size.height,
              child: DraggableScrollableSheet(
                  controller: draggableScrollableController,
                    initialChildSize: initialchildsize,
                    minChildSize: 0,
                    maxChildSize: .9,
                    builder: (BuildContext context, ScrollController scrollController) {
                      return Container(
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20),
                          ),
                          boxShadow: [
                            BoxShadow(
                              offset: -const Offset(1, 1),
                              blurRadius: 1,
                              spreadRadius: 1,
                              color: Colors.grey.shade300,
                            ),
                          ],
                        ),
                        child: SingleChildScrollView(
                          controller: scrollController,
                          child: JobSheet(jobData: SheetjobData,)
                        ),
                      );
                    }),
                    ),
          ],
        ),
      ),
    );
  }
}
