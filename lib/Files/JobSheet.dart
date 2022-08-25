import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:governmentapp/DataLoadingSystem/RequiredDataLoading.dart';
import 'package:governmentapp/Files/CurrentJob.dart';
import 'package:governmentapp/Files/Loved.dart';
import 'package:governmentapp/HexColors.dart';
import 'package:governmentapp/JobData.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:zoom_widget/zoom_widget.dart';


class JobSheet extends StatefulWidget {
  JobData jobData;
  JobSheet({required this.jobData});

  @override
  State<JobSheet> createState() => _JobSheetState();
}

class _JobSheetState extends State<JobSheet> {

  String applybtntxt = "Apply";
  String lovebtntxt = "Love";
  String noticebtntxt = "Notice";

  late JobData jobData;
  var All_Vacancies = <Widget>[];
  var All_Dates = <Widget>[];
  var All_Fees = <Widget>[];
  var All_Ages = <Widget>[];
  var All_Centers = <Widget>[];
  var All_HowTo = <Widget>[];
  var All_Corrections = <Widget>[];


  var Clicks = <Widget>[];


  void LoadDates(JobData jobData){
    var _All_Dates = <Widget>[];

    _All_Dates.add(Padding(
      padding: const EdgeInsets.only(left: 0, top: 10, bottom: 10),
      child: Text("Dates", style: TextStyle(color: Colors.grey[800], fontWeight: FontWeight.w600),),
    ));
    if(jobData.Important_Dates.length == 0)
      {
        _All_Dates.add(const Center(child:Text("Refresh to check important dates.")));
      }
    else {
      for (var index = 0; index <
          jobData.Important_Dates.length; index++) {
        if (!jobData.Important_Dates.keys.elementAt(index).contains(
            "Credit")) {
          _All_Dates.add(
            Text(jobData.Important_Dates.keys.elementAt(index), style: TextStyle(fontWeight: FontWeight.w300,),),
          );
          _All_Dates.add(
            Text(jobData.Important_Dates.values.elementAt(index), style: TextStyle(),),
          );
          _All_Dates.add(SizedBox(height: 10,));
        }
        setState(() {
          All_Dates = _All_Dates;
        });
      }
    }
  }



  void LoadAges(JobData jobData){
    var _All_Ages = <Widget>[];

    _All_Ages.add(Padding(
      padding: const EdgeInsets.only(left: 0, top: 10, bottom: 10),
      child: Text("Age Limits", style: TextStyle(color: Colors.grey[800], fontWeight: FontWeight.w600),),
    ));
    if(jobData.AgeLimits.length == 0)
    {
      _All_Ages.add(const Center(child:Text("Refresh to check important dates.")));
    }
    else {
      for (var index = 0; index <
          jobData.AgeLimits.length; index++) {
        if (!jobData.AgeLimits.keys.elementAt(index).contains(
            "Credit")) {
          _All_Ages.add(
            Text(jobData.AgeLimits.keys.elementAt(index), style: TextStyle(fontWeight: FontWeight.w300,),),
          );
          _All_Ages.add(
            Text(jobData.AgeLimits.values.elementAt(index), style: TextStyle(),),
          );
          _All_Ages.add(SizedBox(height: 10,));
        }
        setState(() {
          All_Ages = _All_Ages;
        });
      }
    }
  }


  void LoadCenters(JobData jobData){
    var _All_Centers = <Widget>[];

    _All_Centers.add(Padding(
      padding: const EdgeInsets.only(left: 0, top: 10, bottom: 10),
      child: Text("Exam Centers", style: TextStyle(color: Colors.grey[800], fontWeight: FontWeight.w600),),
    ));
    if(jobData.AgeLimits.length == 0)
    {
      _All_Centers.add(const Center(child:Text("Refresh to check important dates.")));
    }
    else {
      for (var index = 0; index <
          jobData.ExamCenters.length; index++) {
        if (!jobData.ExamCenters.keys.elementAt(index).contains(
            "Credit")) {
          _All_Centers.add(
            Text(jobData.ExamCenters.keys.elementAt(index), style: TextStyle(fontWeight: FontWeight.w300,),),
          );
          _All_Centers.add(
            Text(jobData.ExamCenters.values.elementAt(index), style: TextStyle(),),
          );
          _All_Centers.add(SizedBox(height: 10,));
        }
        setState(() {
          All_Centers = _All_Centers;
        });
      }
    }
  }


  void LoadHowTo(JobData jobData){
    var _All_HowTo = <Widget>[];

    _All_HowTo.add(Padding(
      padding: const EdgeInsets.only(left: 0, top: 10, bottom: 10),
      child: Text("How To Steps", style: TextStyle(color: Colors.grey[800], fontWeight: FontWeight.w600),),
    ));
    if(jobData.AgeLimits.length == 0)
    {
      _All_HowTo.add(const Center(child:Text("Refresh to check important dates.")));
    }
    else {
      for (var index = 0; index <
          jobData.HowTo.length; index++) {
          _All_HowTo.add(
            Text(jobData.HowTo[index], style: TextStyle(),),
          );
          _All_HowTo.add(SizedBox(height: 10,));

        setState(() {
          All_HowTo = _All_HowTo;
        });
      }
    }
  }


  void LoadCorrections(JobData jobData){
    var _All_Corrections = <Widget>[];

    _All_Corrections.add(Padding(
      padding: const EdgeInsets.only(left: 0, top: 10, bottom: 10),
      child: Text("Corrections", style: TextStyle(color: Colors.grey[800], fontWeight: FontWeight.w600),),
    ));
    if(jobData.Corrections.length == 0)
    {
      _All_Corrections.add(const Center(child:Text("Refresh to check important correction.")));
    }
    else {
      for (var index = 0; index <
          jobData.Corrections.length; index++) {
        _All_Corrections.add(
          Text(jobData.Corrections[index], style: TextStyle(),),
        );
        _All_Corrections.add(SizedBox(height: 10,));

        setState(() {
          All_Corrections = _All_Corrections;
        });
      }
    }
  }


  void LoadFees(JobData jobData){
    var _All_Fees = <Widget>[];

    _All_Fees.add(Padding(
      padding: const EdgeInsets.only(left: 0, top: 10, bottom: 10),
      child: Text("Fees", style: TextStyle(color: Colors.grey[800], fontWeight: FontWeight.w600),),
    ));

    for(int index =0; index <  jobData.ApplicationFees.keys.length; index++) {
      if (!jobData.ApplicationFees.keys.elementAt(index).contains(
          "Credit")) {
        _All_Fees.add(
          Text(jobData.ApplicationFees.keys.elementAt(index), style: TextStyle(fontWeight: FontWeight.w300,),),
        );

        if(jobData.ApplicationFees.values.elementAt(index).toString().contains("/-")){
          _All_Fees.add(
            Text("₹ ${jobData.ApplicationFees.values.elementAt(index)}", style: TextStyle(),),
          );
        }
        else{
          _All_Fees.add(
            Text(jobData.ApplicationFees.values.elementAt(index), style: TextStyle(),),
          );
        }

        _All_Fees.add(SizedBox(height: 10,));
      }
      setState(() {
        All_Fees = _All_Fees;
      });
    }
  }

  Future<void> LoadClicks() async
  {
    var _Clicks = <Widget>[];
    for(int i=0; i<jobData.ButtonsName.length; i++) {
      if (jobData.ButtonsName[i].toString().contains("Telegram")) {
        continue;
      }
      else {
        _Clicks.add(
            GestureDetector(
              onTap: () async {
                if (await canLaunch(jobData.ButtonsURL[i])) {
                  await launch(jobData.ButtonsURL[i]);
                }
                else {
                  print("Can't launch ${jobData.ButtonsURL[i]}");
                }
              },
              child: Container(
                padding: const EdgeInsets.only(left: 15, right: 15),
                child: Text(jobData.ButtonsName[i], style: TextStyle(
                  fontSize: 12,
                    color: Colors.grey[900],
                    fontWeight: FontWeight.w500,
                ),
                ),
              ),
            )
        );
        if (i == jobData.ButtonsName.length - 1) {
          setState(() {
            Clicks = _Clicks;
          });
        }
      }
    }
  }


  @override
  void initState() {

    this.jobData = widget.jobData;

    CurrentJob.currentjobStreamForVacanciesToCall = (JobData jobData) async {
      this.jobData = jobData;
        await OnJobLoad();
        await LoadClicks();
        LoadDates(jobData);
        LoadFees(jobData);
        LoadAges(jobData);
        LoadHowTo(jobData);
        LoadCenters(jobData);
        LoadCorrections(jobData);
    };
    super.initState();
  }

  Future<void> OnJobLoad() async {

    String jobString = await jsonEncode(await jobData.toJson());

    final prefs = await SharedPreferences.getInstance();
    List<String>? appliedjobs = prefs.getStringList('appliedjobs');

    if(appliedjobs != null && appliedjobs.contains(jobData.Key)){
      setState(() {
        applybtntxt = "Applied";
      });
    }
    else{
      setState(() {
        applybtntxt = "Apply";
      });
    }

    List<String>? lovedjobs = prefs.getStringList('lovedjobs');

    if(lovedjobs != null && lovedjobs.contains(jobString)){
      setState(() {
        lovebtntxt = "Loved";
      });
    }
    else{
      setState(() {
        lovebtntxt = "Love";
      });
    }
  }


  Future<void> OnApplyJob() async {
    String Title = jobData.Key;
    final prefs = await SharedPreferences.getInstance();
    List<String>? appliedjobs = prefs.getStringList('appliedjobs');

    appliedjobs ??= <String>[];

    if(!appliedjobs.contains(Title))
      {
        appliedjobs.add(Title);
      }
    await prefs.setStringList('appliedjobs', appliedjobs);

    setState(() {
      applybtntxt = "Applied";
    });

    String url = jobData.ApplyLink;

    if(await canLaunch(url))
    {
      await launch(url);
    }
    else{
      print("Can't launch ${url}");
    }
  }

  Future<void> OnLikeJob() async {
    final prefs = await SharedPreferences.getInstance();
    List<String>? lovedjobs = prefs.getStringList('lovedjobs');

    lovedjobs ??= <String>[];

    String jobString = await jsonEncode(await jobData.toJson());
    print(jobString);

    if(!lovedjobs.contains(jobString))
    {
      lovedjobs.add(jobString);

      setState(() {
        lovebtntxt = "Loved";
      });
    }
    else{
      lovedjobs.remove(jobString);

      setState(() {
        lovebtntxt = "Love";
      });
    }
    await prefs.setStringList('lovedjobs', lovedjobs);
    RequiredDataLoading.LoadLovedCache();

    print("APlly");
  }

  void OnNoticeClick() async {
    String url = jobData.NotificationLink;

    if(await canLaunch(url))
    {
      await launch(url);
    }
  }

  void OnNeedHelp() async {
    String url = jobData.NotificationLink;

    if(await canLaunch(url))
    {
    await launch(url);
    }
  }

  double zoomvalue = 500;


  @override
  Widget build(BuildContext context)  {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(image: AssetImage("./assets/branding/dbg.png"),
        fit: BoxFit.fill)
      ),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 35, sigmaY: 35),
        child: Container(
          color: Colors.white.withOpacity(0.1),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Container(
                height: 25,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10),
                  ),
                ),
                child: Center(
                  child: Icon(Icons.drag_handle, color: Colors.grey[400],),
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height - 120,
                margin: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.5),
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                child: Column(
                  children: <Widget>[
                    Container(
                      height: MediaQuery.of(context).size.height - 120 - 50,
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            // Container(
                            //   width: MediaQuery.of(context).size.width,
                            //   height: 180,
                            //   decoration: const BoxDecoration(
                            //     color: Colors.white,
                            //     borderRadius: BorderRadius.all(Radius.circular(10)),
                            //     image: DecorationImage(
                            //       image: AssetImage("./assets/images/jobpage.jpg"),
                            //       fit: BoxFit.contain,
                            //     ),
                            //   ),
                            //   child: ClipRect(
                            //     child: BackdropFilter(
                            //     filter: ImageFilter.blur(sigmaX: 1, sigmaY: 1),
                            //     child: Container(
                            //       decoration: BoxDecoration(
                            //         color: Colors.white.withOpacity(0.1),
                            //         borderRadius: BorderRadius.all(Radius.circular(15)),
                            //       ),
                            //     ),
                            //     ),
                            //   ),
                            // ),
                            SizedBox(height: 25,),
                            Container(
                              width: MediaQuery.of(context).size.width,
                              alignment: Alignment.center,
                              padding: EdgeInsets.all(10),
                              child: Text(widget.jobData.Department.toString(),
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey[800],
                                ),
                              ),
                            ),
                            SizedBox(height: 5,),
                            Container(
                              width: MediaQuery.of(context).size.width,
                              alignment: Alignment.center,
                              padding: EdgeInsets.all(10),
                              child: Text("Information letter regarding vacancies in Government",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.grey[800],
                                ),
                              ),
                            ),
                            SizedBox(height: 5,),
                            Container(
                              width: MediaQuery.of(context).size.width,
                              padding: const EdgeInsets.only(left: 10, top: 4, bottom: 4),
                              child: Text("Date: ${widget.jobData.LastUpdate}",
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.grey[800],
                                ),
                              ),
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width,
                              padding: const EdgeInsets.only(left: 10, top: 4, bottom: 4),
                              child: Text("No.: ${widget.jobData.AdvertisementNumber.replaceAll("Short Details of Notification", "")}",
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.grey[800],
                                ),
                              ),
                            ),
                            SizedBox(height: 20,),
                            Container(
                              padding: const EdgeInsets.only(left: 10, top: 4, bottom: 4),
                              child: Text(widget.jobData.Designation.toString(),
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey[800]
                              ),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.only(left: 10, top: 4, bottom: 4),
                              child: Text(widget.jobData.Short_Details.toString(),
                                style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.grey[800]
                                ),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.only(left: 10, top: 4, bottom: 4),
                              child: Text(
                                "Location: ${widget.jobData.Location}".toString(),
                                style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.grey[800]
                                ),
                              ),
                            ),
                            widget.jobData.DocumentRequired != "" ? Container(
                              padding: const EdgeInsets.only(left: 10, top: 4, bottom: 4),
                              child: Text(
                                "Document Required: ${widget.jobData.DocumentRequired}".toString(),
                                style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.grey[800]
                                ),
                              ),
                            ):Container(),
                            widget.jobData.Total_Vacancies != "" ? Container(
                              padding: const EdgeInsets.only(left: 10, top: 4, bottom: 4),
                              child: Text(
                                "Total Vacancies: ${widget.jobData.Total_Vacancies}".toString(),
                                style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.grey[800]
                                ),
                              )
                            ):Container(),
                            widget.jobData.Total_Vacancies != "" ? Container(
                              padding: const EdgeInsets.only(left: 10, top: 4, bottom: 4),
                              child: Text(
                                "Total Vacancies: ${widget.jobData.Total_Vacancies}".toString(),
                                style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.grey[800]
                                ),
                              )
                            ) : Container(),
                            widget.jobData.WebsiteLink != "" ? Container(
                              padding: const EdgeInsets.only(left: 10, top: 4, bottom: 4),
                              child:Text(
                                "Website: ${widget.jobData.WebsiteLink}".toString(),
                                style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.grey[800]
                                ),
                              )
                            ) : Container(),

                            SizedBox(height: 20,),
                            jobData.Important_Dates.isNotEmpty ? Container(
                              padding: const EdgeInsets.only(left: 10, top: 4, bottom: 4),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: All_Dates,
                              ),
                            ) : Container(),

                            SizedBox(height: 20,),
                            jobData.ApplicationFees.isNotEmpty ? Container(
                              padding: const EdgeInsets.only(left: 10, top: 4, bottom: 4),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: All_Fees,
                              ),
                            ) : Container(),

                            SizedBox(height: 20,),
                            jobData.AgeLimits.isNotEmpty ? Container(
                              padding: const EdgeInsets.only(left: 10, top: 4, bottom: 4),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: All_Ages,
                              ),
                            ) : Container(),

                            SizedBox(height: 20,),
                            jobData.ExamCenters.isNotEmpty ? Container(
                              padding: const EdgeInsets.only(left: 10, top: 4, bottom: 4),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: All_Centers,
                              ),
                            ) : Container(),

                            SizedBox(height: 20,),
                            jobData.HowTo.isNotEmpty ? Container(
                              padding: const EdgeInsets.only(left: 10, top: 4, bottom: 4),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: All_HowTo,
                              ),
                            ) : Container(),


                            SizedBox(height: 20,),
                            jobData.Corrections.isNotEmpty ? Container(
                              padding: const EdgeInsets.only(left: 10, top: 4, bottom: 4),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: All_Corrections,
                              ),
                            ) : Container(),


                            SizedBox(height: 2000,),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(bottomRight: Radius.circular(10), bottomLeft: Radius.circular(10))
                      ),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            GestureDetector(
                              onTap: () async {
                                OnLikeJob();
                                setState(() {

                                });
                              },
                              child: Container(
                                padding: const EdgeInsets.only(left: 15, right: 15),
                                child: lovebtntxt == "Loved" ? Row(
                                  children: [
                                    Text( "Favourite", style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey[900],
                                      fontWeight: FontWeight.w500,
                                    ),
                                    ),
                                    SizedBox(width: 5,),
                                    Icon(Icons.check),
                                  ],
                                ) : Text( "Add to Favourite", style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[900],
                                  fontWeight: FontWeight.w500,
                                ),
                                ),
                              ),
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: Clicks,
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}


class GreyLine extends StatelessWidget {
  const GreyLine({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  Container(
      margin: const EdgeInsets.only(
        left: 0,
        top: 20,
        bottom: 20,
        right: 20,
      ),
      height: 5,
      width: 250,
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
      ),
    );
  }
}


Widget HeaderTexts(String text){
  return Text(text, style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20,  color: Colors.black),);
}


Widget StylishBox(context, widget, String Header, String Content, String Img){
  return Container(
    padding: EdgeInsets.all(20),
    width: MediaQuery.of(context).size.width,
    child: Stack(
      children: <Widget>[

        Container(
          margin: const EdgeInsets.only(
            left: 30
          ),
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.only(
              left: 30,
              top: 20,
              bottom: 20,
              right: 20
            ),
            decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.shade200,
                    spreadRadius: 6,
                    blurRadius: 13.0,
                    offset:Offset(5, 5),
                  ),
                ],
                borderRadius: BorderRadius.circular(20)
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                HeaderTexts(Header),
                Text(
                  Content.toString(),
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black,
                  ),
                ),
              ],
            )
        ),
        Positioned(
            child: Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(Img),
                )
              ),
              width: 50,
              height: 50,
            )),
      ],
    )
  );

}

/*

Container(
                        child: Container(
                          child: SingleChildScrollView(
                            child: Column(
                              children: <Widget>[
                                Container(
                                    width: MediaQuery.of(context).size.width,
                                    padding: const EdgeInsets.only(
                                      left: 15,
                                      right: 15,
                                      top: 15,
                                    ),
                                    child: Text(
                                      widget.jobData.Title.toString(),
                                      style: TextStyle(fontSize: 25, fontWeight: FontWeight.w700,
                                          color: Colors.grey[900]
                                      ),
                                    )
                                ),
                                Container(
                                    width: MediaQuery.of(context).size.width,
                                    padding: const EdgeInsets.only(
                                      left: 15,
                                      right: 15,
                                    ),
                                    child: Text(
                                      widget.jobData.Department.toString(),
                                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700,
                                          color: Colors.blueAccent[200]
                                      ),
                                    )
                                ),
                                SizedBox(height: 10,),
                                Container(
                                  padding: EdgeInsets.all(20),
                                  child: Row(
                                    children: <Widget>[
                                      GestureDetector(
                                        onTap: (){
                                          OnApplyJob();
                                        },
                                        child: Container(
                                          width: 120,
                                          height: 50,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.all(Radius.circular(10)),
                                            color: applybtntxt == "Apply" ? ColorFromHexCode("#F4F6F7") : ColorFromHexCode("#3498DB"),
                                          ),
                                          padding: const EdgeInsets.all(5),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Icon(
                                                  Icons.task_alt,
                                                  color: applybtntxt == "Apply" ? ColorFromHexCode("#3498DB") : ColorFromHexCode("#F4F6F7")
                                              ),
                                              const SizedBox(width: 5,),
                                              Text(applybtntxt, style: TextStyle(color: applybtntxt == "Apply" ? ColorFromHexCode("#3498DB") : ColorFromHexCode("#F4F6F7") , fontWeight: FontWeight.w500),)
                                            ],
                                          ),

                                        ),
                                      ),

                                      const SizedBox(width: 20,),

                                      GestureDetector(
                                        onTap: (){
                                          OnLikeJob();
                                        },
                                        child: Container(
                                          width: 50,
                                          height: 50,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.all(Radius.circular(10)),
                                            color: lovebtntxt == "Love" ? ColorFromHexCode("#F4F6F7") : ColorFromHexCode("#3498DB"),
                                          ),
                                          padding: const EdgeInsets.all(5),
                                          child: Icon(
                                              Icons.favorite,
                                              color: lovebtntxt == "Love" ? ColorFromHexCode("#3498DB") : ColorFromHexCode("#F4F6F7")
                                          ),
                                        ),
                                      ),

                                      const SizedBox(width: 20,),

                                      GestureDetector(
                                        onTap: (){
                                          OnNoticeClick();
                                        },
                                        child: Container(
                                          width: 120,
                                          height: 50,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.all(Radius.circular(10)),
                                            color: ColorFromHexCode("#F4F6F7"),
                                          ),
                                          padding: const EdgeInsets.all(5),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Icon(
                                                  Icons.file_copy_sharp,
                                                  color: ColorFromHexCode("#3498DB")
                                              ),
                                              const SizedBox(width: 5,),
                                              Text("Notice", style: TextStyle(color: ColorFromHexCode("#3498DB"), fontWeight: FontWeight.w500),)
                                            ],
                                          ),

                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                GestureDetector(
                                    onTap: () async {
                                      String url = jobData.WebsiteLink;
                                      if(await canLaunch(url))
                                      {
                                      await launch(url);
                                      }
                                      else{
                                        print("Can't launch ${url}");
                                      }
                                    },
                                    child: StylishBox(context, widget, "Website", widget.jobData.WebsiteLink, "assets/images/website.png")),
                                StylishBox(context, widget, "Brief", widget.jobData.Short_Details == "" ? "Brief information not available" : widget.jobData.Short_Details.toString(), "assets/images/brief.png"),
                                StylishBox(context, widget, "Total Post", widget.jobData.Total_Vacancies == "" ? "Brief information not available" : widget.jobData.Total_Vacancies.toString(), "assets/images/vacancies.png"),
                                StylishBox(context, widget, "Location", widget.jobData.Location == "" ? "Location information not available" : widget.jobData.Location.toString(), "assets/images/location.png"),

                                Container(
                                    padding: EdgeInsets.all(20),
                                    width: MediaQuery.of(context).size.width,
                                    child: Stack(
                                      children: <Widget>[

                                        Container(
                                            margin: const EdgeInsets.only(
                                                left: 30
                                            ),
                                            width: MediaQuery.of(context).size.width,
                                            padding: const EdgeInsets.only(
                                                left: 30,
                                                top: 20,
                                                bottom: 20,
                                                right: 20
                                            ),
                                            decoration: BoxDecoration(
                                                color: Colors.white,
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors.grey.shade200,
                                                    spreadRadius: 6,
                                                    blurRadius: 13.0,
                                                    offset:Offset(5, 5),
                                                  ),
                                                ],
                                                borderRadius: BorderRadius.circular(20)
                                            ),
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              children: <Widget>[
                                                HeaderTexts("Fees"),
                                                Column(
                                                  children: All_Fees,
                                                )
                                              ],
                                            )
                                        ),
                                        Positioned(
                                            child: Container(
                                              alignment: Alignment.center,
                                              decoration: const BoxDecoration(
                                                  image: DecorationImage(
                                                    image: AssetImage("./assets/images/fees.png"),
                                                  )
                                              ),
                                              width: 50,
                                              height: 50,
                                            )),
                                      ],
                                    )
                                ),


                                Container(
                                    padding: EdgeInsets.all(20),
                                    width: MediaQuery.of(context).size.width,
                                    child: Stack(
                                      children: <Widget>[

                                        Container(
                                            margin: const EdgeInsets.only(
                                                left: 30
                                            ),
                                            width: MediaQuery.of(context).size.width,
                                            padding: const EdgeInsets.only(
                                                left: 30,
                                                top: 20,
                                                bottom: 20,
                                                right: 20
                                            ),
                                            decoration: BoxDecoration(
                                                color: Colors.white,
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors.grey.shade200,
                                                    spreadRadius: 6,
                                                    blurRadius: 13.0,
                                                    offset:Offset(5, 5),
                                                  ),
                                                ],
                                                borderRadius: BorderRadius.circular(20)
                                            ),
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              children: <Widget>[
                                                HeaderTexts("Dates"),
                                                Column(
                                                  children: All_Dates,
                                                )
                                              ],
                                            )
                                        ),
                                        Positioned(
                                            child: Container(
                                              alignment: Alignment.center,
                                              decoration: const BoxDecoration(
                                                  image: DecorationImage(
                                                    image: AssetImage("./assets/images/date.png"),
                                                  )
                                              ),
                                              width: 50,
                                              height: 50,
                                            )),
                                      ],
                                    )
                                ),


                                const GreyLine(),

                                Container(
                                    width: MediaQuery.of(context).size.width,
                                    padding: const EdgeInsets.only(
                                      left: 15,
                                      right: 15,
                                    ),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: <Widget>[
                                        HeaderTexts("Vacancies"),
                                        SingleChildScrollView(
                                          scrollDirection: Axis.horizontal,
                                          child: Container(
                                            child: SingleChildScrollView(
                                              scrollDirection: Axis.horizontal,
                                              child: Row(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                children: All_Vacancies,
                                              ),
                                            ),
                                          ),
                                        ),

                                      ],
                                    )
                                ),

                                const GreyLine(),

                                Container(
                                    width: MediaQuery.of(context).size.width,
                                    padding: const EdgeInsets.only(
                                      left: 15,
                                      right: 15,

                                    ),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: <Widget>[
                                        Row(
                                          children: <Widget>[
                                            HeaderTexts("How to Apply"),
                                            SizedBox(width: 10,),
                                            GestureDetector(
                                              onTap: (){
                                                OnNeedHelp();
                                              },
                                              child: Container(
                                                width: 120,
                                                height: 50,
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.all(Radius.circular(10)),
                                                  color: ColorFromHexCode("#F4F6F7"),
                                                ),
                                                padding: const EdgeInsets.all(5),
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [
                                                    Icon(
                                                        Icons.task_alt,
                                                        color: ColorFromHexCode("#3498DB")
                                                    ),
                                                    const SizedBox(width: 5,),
                                                    Text("Need help?", style: TextStyle(color: ColorFromHexCode("#3498DB"), fontWeight: FontWeight.w500),)
                                                  ],
                                                ),

                                              ),
                                            ),
                                          ],
                                        ),
                                        Text(
                                          widget.jobData.HowToApply == "" ? "How to Apply information not available" : widget.jobData.HowToApply.toString(),
                                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.grey.shade800
                                          ),
                                        ),
                                      ],
                                    )
                                ),
                                SizedBox(height: 100,),
                              ],
                            ),
                          ),
                        ),
                      ),

 */