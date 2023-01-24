import 'dart:async';

import 'package:flutter/material.dart';
import 'package:governmentapp/Animations/Disclaimer.dart';
import 'package:governmentapp/Animations/SplashScreen.dart';
import 'package:governmentapp/Beauty/BottomBar.dart';
import 'package:governmentapp/Beauty/Chat.dart';
import 'package:governmentapp/Beauty/TopBar.dart';
import 'package:governmentapp/DataLoadingSystem/JobDisplayManagement.dart';
import 'package:governmentapp/Files/CurrentJob.dart';
import 'package:governmentapp/Files/JobSheet.dart';
import 'package:governmentapp/HexColors.dart';
import 'package:governmentapp/JobData.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  late DraggableScrollableController draggableScrollableController;
  JobData SheetjobData = JobData();
  var initialchildsize = .0;


  @override
  void initState() {
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

    draggableScrollableController = DraggableScrollableController();

    CurrentJob.HideJobSheetDataStreamToCall = (){
      draggableScrollableController.animateTo(0.0, duration: Duration(milliseconds: 500), curve: Curves.easeOutBack).then((value){setState(() {
        initialchildsize = 0;
      });});
      setState(() {

      });
    };
    super.initState();

    if(JobDisplayManagement.HomeToShow == false) {
      JobDisplayManagement.HomeToShow = true;
      Timer(Duration(milliseconds: 50), () {
        Navigator.pop(context);
        Navigator.push(context, MaterialPageRoute(builder: (context) => SplashScreen()));
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Stack(
          children: <Widget>[
            Positioned(
                top: 0,
                left: 0,
                right: 0,
                height: MediaQuery.of(context).padding.top + 60,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        offset: Offset(3, 3),
                        color: Colors.black,
                        blurRadius: 3,
                        spreadRadius: 5,
                      )
                    ]
                  ),
                  child: TopBar(),
                )
            ),
            Positioned(
              top: MediaQuery.of(context).padding.top + 60,
                bottom: 60,
                left: 0,
                right: 0,
                child: Container(
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey,
                        offset: Offset(4, 4),
                        blurRadius: 2,
                        spreadRadius: 2,
                      )
                    ],
                    color: ColorFromHexCode("#393E46"),
                  ),
                  child: Chat(),
            )),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              height: 60,
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        offset: Offset(3, 3),
                        color: Colors.black,
                        blurRadius: 3,
                        spreadRadius: 5,
                      )
                    ]
                ),
                child: BottomBar(),
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
                          child: WillPopScope(
                              onWillPop: () {
                                //Navigator.of(context).pop(false);
                                CurrentJob.HideJobSheetData.add("a");

//                                Navigator.pop(context);
                                // Navigator.of(context).pushAndRemoveUntil(
                                //     MaterialPageRoute(
                                //         builder: (context) => Home()), (Route route) => false);
                                return Future.value(false);
                              },
                              child: JobSheet(jobData: SheetjobData,)),
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
