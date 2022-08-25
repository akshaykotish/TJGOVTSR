import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:governmentapp/Beauty/Banner.dart';
import 'package:governmentapp/Beauty/Branding.dart';
import 'package:governmentapp/Beauty/Buttons.dart';
import 'package:governmentapp/Beauty/ShowSkeleton.dart';
import 'package:governmentapp/Beauty/ToolSection.dart';
import 'package:governmentapp/DataLoadingSystem/JobDisplayManagement.dart';
import 'package:governmentapp/DataLoadingSystem/RequiredDataLoading.dart';
import 'package:governmentapp/Files/CurrentJob.dart';
import 'package:governmentapp/Files/JobBoxs.dart';
import 'package:governmentapp/Files/JobSheet.dart';
import 'package:governmentapp/HexColors.dart';
import 'package:governmentapp/JobData.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {


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
        print("AHSI");
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
        decoration: BoxDecoration(
            color: ColorFromHexCode("#E2E2E2"),
            image: const DecorationImage(
              image: AssetImage(
                "./assets/branding/Background.png",
              ),
              fit: BoxFit.fill,
            )
        ),
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Stack(
          children: <Widget>[
            SingleChildScrollView(
              child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const <Widget>[
                    Branding(),
                    // BannerForAds(),
                    ToolSection(),
                    JobBoxs(),
                    SizedBox(height: 100,)
                  ],
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              height: MediaQuery.of(context).size.height,
              child: DraggableScrollableSheet(
                  controller: draggableScrollableController,
                  initialChildSize: initialchildsize,
                  minChildSize: 0.0,
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

