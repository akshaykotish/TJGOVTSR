import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:governmentapp/AdFile.dart';
import 'package:governmentapp/Beauty/Branding.dart';
import 'package:governmentapp/Beauty/EaseButtons.dart';
import 'package:governmentapp/Beauty/ToolSection.dart';
import 'package:governmentapp/DataLoadingSystem/JobDisplayManagement.dart';
import 'package:governmentapp/DataLoadingSystem/RequiredDataLoading.dart';
import 'package:governmentapp/DataPullers/HotJobs.dart';
import 'package:governmentapp/Files/CurrentJob.dart';
import 'package:governmentapp/Files/JobBoxs.dart';
import 'package:governmentapp/Files/JobSheet.dart';
import 'package:governmentapp/HexColors.dart';
import 'package:governmentapp/JobData.dart';
import 'package:governmentapp/Payment.dart';
import 'package:governmentapp/User/WriteALog.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  bool isToGoAdFree = false;

  Future<void> GoAdFree() async {
    final prefs = await SharedPreferences.getInstance();
    String? adisenable = prefs.getString("AdsEnable");

    if(adisenable == "TRUE")
      {
        setState(() {
          isToGoAdFree = true;
        });
      }
    else{
      setState(() {
        isToGoAdFree = false;
      });
    }
  }

  @override
  void initState() {
    GoAdFree();
    WriteALog.Write("App Opened", "Normal Login", DateTime.now().toString());
    draggableScrollableController = DraggableScrollableController();

    CurrentJob.currentjobStreamToCall = (JobData value) {
      setState(() {
        draggableScrollableController.animateTo(0.9, duration: Duration(milliseconds: 500), curve: Curves.easeInBack).then((value){
          setState(() {
            initialchildsize = .9;
          });
        });
        SheetjobData = value;
      });
    };

    scrollController.addListener(() {
      setState(() {

      });
    });

    CurrentJob.HideJobSheetDataStreamToCall = (){
      draggableScrollableController.animateTo(0.0, duration: Duration(milliseconds: 500), curve: Curves.easeOutBack).then((value){setState(() {
        initialchildsize = 0;
      });});
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
    return WillPopScope(
      onWillPop: () {
        CurrentJob.HideJobSheetData.add("a");
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
                builder: (context) => Home()), (Route route) => false);
        return Future.value(true);
      },
      child: Scaffold(
        body: RefreshIndicator(
          onRefresh: (){
            return Future.delayed(const Duration(milliseconds: 1), (){
              RequiredDataLoading.Execute();
            });
          },
          child: Container(
            decoration: BoxDecoration(
                color: ColorFromHexCode("#E2E2E2"),
                image: const DecorationImage(
                  image: AssetImage(
                    "./assets/branding/Background.jpg",
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
                    child: Container(
                      color: Colors.white.withOpacity(0.1),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          const Branding(),
                          // BannerForAds(),
                          const ToolSection(),
                          Container(child: isToGoAdFree ? PaymentPage() : null),
                          const EaseButtons(),
                          const JobBoxs(),
                          const SizedBox(height: 100,)
                        ],
                      ),
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
        ),
      ),
    );
  }
}

