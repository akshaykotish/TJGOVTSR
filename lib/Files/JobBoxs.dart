import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:governmentapp/AdFile.dart';
import 'package:governmentapp/Ads/HomeAd.dart';
import 'package:governmentapp/Beauty/ShowSkeleton.dart';
import 'package:governmentapp/DataLoadingSystem/JobDisplayManagement.dart';
import 'package:governmentapp/DataLoadingSystem/RequiredDataLoading.dart';
import 'package:governmentapp/DataLoadingSystem/SearchAbleDataLoading.dart';
import 'package:governmentapp/Files/CurrentJob.dart';
import 'package:governmentapp/Files/DepartmentBox.dart';
import 'package:governmentapp/Files/JobBox.dart';
import 'package:governmentapp/ForUsers/ChooseDepartment.dart';
import 'package:governmentapp/HexColors.dart';
import 'package:governmentapp/JobDisplayData.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../JobDisplayData.dart';


class JobBoxs extends StatefulWidget {
  const JobBoxs({Key? key}) : super(key: key);

  @override
  State<JobBoxs> createState() => _JobBoxsState();
}


class _JobBoxsState extends State<JobBoxs> {

  var AdContainer = HomeAd(adkey: "ca-app-pub-3701741585114162/6132005649",);

  Map<String, List<JobBox>> _ToShowJobs = Map<String, List<JobBox>>();
  var AllDepartments = <Widget>[];

  int counts = 0;
  Future<void> Display(List<JobDisplayData> jobs) async {
    final prefs = await SharedPreferences.getInstance();
    String? AdsEnable = prefs.getString("AdsEnable");
    var _AllDepartments = <Widget>[];
    _AllDepartments.clear();
    AllDepartments.clear();
    if(jobs.isEmpty)
      {
        _AllDepartments.add(ShowSkeleton());
        Timer(Duration(seconds: 5), (){
          print("Ended");
          if(AllDepartments.length <= 1)
            {
              _AllDepartments.clear();
              _AllDepartments.add(Center(child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SizedBox(height: 20,),
                  Text("Required Results Not Available.",
                  style: TextStyle(fontFamily: "uber",fontWeight: FontWeight.w400,
                  fontSize: 16,
                    color: Colors.grey.shade700
                  ),),
                  SizedBox(height: 10,),
                  Text("Click the icon below to find some more jobs.",
                    style: TextStyle(fontFamily: "uber",fontWeight: FontWeight.w200,
                      fontSize: 12,
                      color: Colors.grey.shade400
                  ),),
                  SizedBox(height: 10,),
                  GestureDetector(
                    onTap: (){
                      Navigator.push(context, PageRouteBuilder(
                          transitionDuration: const Duration(milliseconds: 300),
                          transitionsBuilder: (BuildContext context, Animation<double> animation, Animation<double> secAnimation, Widget child){
                            const begin = Offset(1, 0.0);
                            const end = Offset.zero;
                            const curve = Curves.ease;

                            var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

                            return SlideTransition(
                              position: animation.drive(tween),
                              child: child,
                            );
                          },
                          pageBuilder: (BuildContext context, Animation<double> animation, Animation<double> secAnimation){
                            return const ChooseDepartment();
                          }));
                    },
                    child: Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                          color: Colors.grey.shade400.withOpacity(0.5),
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.grey.withOpacity(0.2), width: 1),
                          boxShadow: [
                            BoxShadow(
                              offset: Offset(2, 2),
                              color: Colors.grey.shade400.withOpacity(0.2),
                              blurRadius: 3,
                              spreadRadius: 4,
                            )
                          ]
                      ),
                      child: Icon(Icons.work, size: 25, color: ColorFromHexCode("#383C39"),),
                    ),
                  ),
                ],
              )));
              setState(() {
                AllDepartments = _AllDepartments;
              });
            }
        });
      }
    else {
      if (JobDisplayManagement.IsMoreLoading == true) {
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

      counts = 0;
      _ToShowJobs.forEach((key, value) async {
        if (counts == 9 && AdsEnable == "TRUE" && TJSNInterstitialAd.adWidget3 != null && TJSNInterstitialAd.adWidget3Loaded == false) {
          try {
            print("INAD3");
            _AllDepartments.add(
                AdContainer
            );
          }
          catch(e){print("AD3 =  + $e");}
        }
        else{
          _AllDepartments.add(
              DepartmentBox(DepartmentName: key, jobboxes: value));
          setState(() {
            AllDepartments = _AllDepartments;
          });
        }
        counts++;
      });
    }

    setState(() {
      AllDepartments = _AllDepartments;
    });
  }

  Future<void> InitFunctions()
  async {
    JobDisplayManagement.HOTJOBSF = (List<JobDisplayData> list){
      if(JobDisplayManagement.WhichShowing == 1)
        {
          print("HOTJOBS");
          JobDisplayManagement.EASEBTNC.add("");
          Display(list);
        }
    };
    JobDisplayManagement.CHOOSEJOBSF = (List<JobDisplayData> list){
      if(JobDisplayManagement.WhichShowing == 2)
      {
        print("CHOOSEJOBS");
        JobDisplayManagement.EASEBTNC.add("");
        Display(list);
      }
    };
    JobDisplayManagement.SEARCHJOBSF = (List<JobDisplayData> list){
      if(JobDisplayManagement.WhichShowing == 3)
      {
        print("SEARCHJOBS");
        JobDisplayManagement.EASEBTNC.add("");
        Display(list);
      }
    };
    JobDisplayManagement.FAVJOBSF = (List<JobDisplayData> list){
      if(JobDisplayManagement.WhichShowing == 4)
      {
        print("FAVJOBS");
        JobDisplayManagement.EASEBTNC.add("");
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
      RequiredDataLoading.LoadLikedJobs();
    };
  }


  @override
  void initState() {
    InitFunctions();
    InitCurrents();
    super.initState();
    //RequiredDataLoading.Execute();
   // ChatDatas.CreateHotJobs();
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