import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:governmentapp/DataLoadingSystem/RequiredDataLoading.dart';
import 'package:governmentapp/Files/CurrentJob.dart';
import 'package:governmentapp/HexColors.dart';
import 'package:governmentapp/JobData.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher.dart';

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


  void LoadDates(JobData jobData){
    var _All_Dates = <Widget>[];

    if(jobData.Important_Dates.length == 0)
      {
        _All_Dates.add(const Center(child:Text("Refresh to check important dates.")));
      }
    else {
      for (var index = 0; index <
          jobData.Important_Dates.length; index++) {
        if (!jobData.Important_Dates.keys.elementAt(index).contains(
            "Credit")) {
          _All_Dates.add(Container(
            //color: index % 2 == 0 ? Colors.grey[100] : Colors.white,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  child: Text(
                    jobData.Important_Dates.keys
                        .elementAt(index), style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey.shade800),),
                  width: MediaQuery
                      .of(context)
                      .size
                      .width / 2.8,
                ),
                Container(
                    alignment: Alignment.centerRight,
                    width: MediaQuery
                        .of(context)
                        .size
                        .width / 3,
                    child: Text(
                      jobData.Important_Dates.values.elementAt(index),
                      style: const TextStyle(
                        fontSize: 15, fontWeight: FontWeight.w400,),
                      textAlign: TextAlign.end,)),
              ],
            ),
          ));
        }
        setState(() {
          All_Dates = _All_Dates;
        });
      }
    }
  }

  void LoadFees(JobData jobData){
    var _All_Fees = <Widget>[];

    for(int index =0; index <  jobData.ApplicationFees.keys.length; index++) {
      if (!jobData.ApplicationFees.keys.elementAt(index).contains(
          "Credit")) {
        _All_Fees.add(Container(
          //color: index % 2 == 0 ? Colors.grey[100] : Colors.white,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                child: Text(
                  jobData.ApplicationFees.keys
                      .elementAt(index), style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey.shade800),),
                width: MediaQuery
                    .of(context)
                    .size
                    .width / 2.2,
              ),
              Container(
                width: MediaQuery
                    .of(context)
                    .size
                    .width / 4 - 20,
                child: Text(
                  (jobData.ApplicationFees.values
                      .elementAt(index) != ""
                      ? "₹ "
                      : "") +
                      jobData.ApplicationFees
                          .values.elementAt(index), style: const TextStyle(
                  fontSize: 15, fontWeight: FontWeight.w400,),
                  textAlign: TextAlign.end,),),
            ],
          ),
        ));
      }
      setState(() {
        All_Fees = _All_Fees;
      });
    }
  }


  @override
  void initState() {

    this.jobData = widget.jobData;

    CurrentJob.currentjobStreamForVacanciesToCall = (JobData jobData) {

      OnJobLoad();
      this.jobData = jobData;

        LoadDates(jobData);
        LoadFees(jobData);

      var _All_Vacancies = <Widget>[];
      jobData.VDetails.forEach((VDetail) {

        var d = <Widget>[];
        VDetail.datas.forEach((row) {
          var cRow = <Widget>[];

          int indx = 0;
          row.data.forEach((txtvalues) {
            if(txtvalues.toString().contains("Sarkari Result") || txtvalues.toString().contains("Click Here") || txtvalues.toString().contains("Apps") || txtvalues.toString().contains("Card") || txtvalues.toString().contains("google"))
              {

              }
            else if(indx == 0){
              if(indx < VDetail.headers.length) {
                cRow.add(Container(
                    alignment: Alignment.centerLeft,
                    child: Text(VDetail.headers[indx], style: TextStyle(fontSize: 12, fontWeight: FontWeight.w300, color: Colors.grey.shade500),)));
              }
              cRow.add(Container(
                  alignment: Alignment.centerLeft,
                  child: Text(txtvalues, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.grey.shade800),)));
              indx++;
            }
            else{
              if(indx < VDetail.headers.length) {
                cRow.add(Container(
                    alignment: Alignment.centerLeft,
                    child: Text(VDetail.headers[indx], style: TextStyle(fontSize: 12, fontWeight: FontWeight.w300, color: Colors.grey.shade500,),)));
              }
              cRow.add(Container(
                  alignment: Alignment.centerLeft,
                  child: Text(txtvalues, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400,), textAlign: TextAlign.start,),));
              indx++;
            }
          });
          d.add(Container(
            margin: EdgeInsets.all(5),
            padding: EdgeInsets.all(20),
            width: MediaQuery.of(context).size.width - 100,
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
              children: cRow,
            ),
          ));

          cRow.add(const SizedBox(height: 20,));
        });

        var c = Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Text(VDetail.Title),
            Container(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: d,
              ),
            )
          ],
        );

        _All_Vacancies.add(c);

        setState(() {
          All_Vacancies = _All_Vacancies;
        });
      });


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



  @override
  Widget build(BuildContext context)  {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage(
            "./assets/branding/dbg.png",
          )
        )
      ),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
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
              height: MediaQuery.of(context).size.height - 105,
              child: SingleChildScrollView(
                child: Column(
                  children: [
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
                  ],
                ),
              ),
            )
          ],
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