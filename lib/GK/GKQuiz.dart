import 'dart:async';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:governmentapp/AdFile.dart';
import 'package:governmentapp/GK/GKQuizScore.dart';
import 'package:governmentapp/HexColors.dart';

class GKQuiz extends StatefulWidget {
  const GKQuiz({Key? key}) : super(key: key);

  @override
  State<GKQuiz> createState() => _GKQuizState();
}

class _GKQuizState extends State<GKQuiz> with TickerProviderStateMixin {

  int index = 0;
  var Quizes = <Widget>[];
  var _Quizes = <Widget>[];
  List<String> Questions = <String>[];
  List<String> UserAnswers = <String>[];
  List<String> Answers = <String>[];
  List<String> Hints = <String>[];

  late AnimationController controller;
  late Animation opacityanim;
  int isadded = -1;

  Future<void> SubmitAnswer(String Question, String UserAnswer, String Answer, String Hint, int ia, int x) async {
    controller.forward();

    if(isadded > 0) {
      Timer(Duration(milliseconds: 500), () {
        if(Quizes.length > 0) {
          Quizes.removeAt(ia);
        }
        isadded--;
        controller.reverse();
      });
    }

    if (!Questions.contains(Question)) {
      Questions.add(Question);
      UserAnswers.add(UserAnswer);
      Answers.add(Answer);
      Hints.add(Hint);
    }

    if (isadded <= 0) {
      print("Come here");
      await TJSNInterstitialAd.LoadAnAd();
      Navigator.push(context, PageRouteBuilder(
          transitionDuration: const Duration(milliseconds: 300),
          transitionsBuilder: (BuildContext context,
              Animation<double> animation,
              Animation<double> secAnimation, Widget child) {
            animation =
                CurvedAnimation(parent: animation, curve: Curves.elasticInOut);

            return ScaleTransition(
              scale: animation,
              alignment: Alignment.center,
              child: child,
            );
          },
          pageBuilder: (BuildContext context, Animation<double> animation,
              Animation<double> secAnimation) {
            return GKQuizScore(Hints: Hints,
                Questions: Questions,
                UserAnswers: UserAnswers,
                Answers: Answers);
          }));
    }
    else {

    }
  }

  Future<void> QuizContainer(String Q, List<dynamic> O, String A, String H) async {
    isadded++;
    _Quizes.add(
        Container(
          padding: EdgeInsets.all(20),
          margin: EdgeInsets.only(top: 200, bottom: 200, left: 10, right: 10),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.all(Radius.circular(20)),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.shade600,
                offset: Offset(2, 2),
                blurRadius: 5,
                spreadRadius: 5
              )
            ]
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(Q,
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 20,),
              ),
              SizedBox(height: 20,),
              Text("Click on your answer: ", style: TextStyle(fontSize: 12),),
              SizedBox(height: 5,),
              GestureDetector(
                onTap: (){
                  int abc = int.parse(isadded.toString());
                  SubmitAnswer(Q, O[0], A, H, abc, 1);
                },
                child: Container(
                  width: MediaQuery.of(context).size.width-50,
                  decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.1),
                      border: Border.all(color: Colors.grey.shade400, width: 1),
                      borderRadius: BorderRadius.all(Radius.circular(10)),

                  ),
                  padding: EdgeInsets.all(10),
                  margin: EdgeInsets.all(5),
                  child: Text(O[0], style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),),
                ),
              ),
              GestureDetector(
                onTap: (){
                  int abc = int.parse(isadded.toString());
                  SubmitAnswer(Q, O[1], A, H, abc, 2);
                },
                child: Container(
                  width: MediaQuery.of(context).size.width-50,
                  decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.1),
                      border: Border.all(color: Colors.grey.shade400, width: 1),
                      borderRadius: BorderRadius.all(Radius.circular(10)),

                  ),
                  padding: EdgeInsets.all(10),
                  margin: EdgeInsets.all(5),
                  child: Text(O[1], style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),),
                ),
              ),
              GestureDetector(
                onTap: (){
                  int abc = int.parse(isadded.toString());
                  SubmitAnswer(Q, O[2], A, H, abc, 3);
                },
                child: Container(
                  width: MediaQuery.of(context).size.width-50,
                  decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.1),
                      border: Border.all(color: Colors.grey.shade400, width: 1),
                      borderRadius: BorderRadius.all(Radius.circular(10)),

                  ),
                  padding: EdgeInsets.all(10),
                  margin: EdgeInsets.all(5),
                  child: Text(O[2], style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),),
                ),
              ),
              GestureDetector(
                onTap: (){
                  int abc = int.parse(isadded.toString());
                  SubmitAnswer(Q, O[3], A, H, abc, 4);
                },
                child: Container(
                  width: MediaQuery.of(context).size.width-50,
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.1),
                    border: Border.all(color: Colors.grey.shade400, width: 1),
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  padding: EdgeInsets.all(10),
                  margin: EdgeInsets.all(5),
                  child: Text(O[3], style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),),
                ),
              ),
            ],
          ),
        ),
    );
    setState(() {
      Quizes = _Quizes;
    });
  }

  Future<void> LoadQuiz() async {
    //_Quizes = <Widget>[];
    //_Quizes.add(Container(child: Center(child: Text("Quiz Over", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500,),),)));

    String ThisMonth = DateTime.now().month.toString() + DateTime.now().year.toString();
    var quizes = await FirebaseFirestore.instance.collection("GKTodayQuiz").doc(ThisMonth).collection("Questions").get();
    quizes.docs.forEach((quiz) async {
      QuizContainer(quiz.data()["Question"].toString(), quiz.data()["Options"], quiz.data()["Answer"].toString(), quiz.data()["Hint"].toString());
    });
    setState(() {
      Quizes = _Quizes;
    });
  }

  Container LoadADWidget()
  {
//    TJSNInterstitialAd.LoadBannerAd2();
  TJSNInterstitialAd.myBanner2.load();
    return Container(
      child: AdWidget(
        ad: TJSNInterstitialAd.myBanner2,
      ),
      width: TJSNInterstitialAd.myBanner2.size.width.toDouble(),
      height: TJSNInterstitialAd.myBanner2.size.height.toDouble(),
    );
  }

  @override
  void initState() {
    TJSNInterstitialAd.LoadBannerAd2();

    controller =  AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    opacityanim = Tween<double>(begin: 1.0, end: 0.0).animate(controller);
    //
    // color1controller = AnimationController(vsync: this, duration: Duration(milliseconds: 300));
    // color2controller = AnimationController(vsync: this, duration: Duration(milliseconds: 300));
    // color3controller = AnimationController(vsync: this, duration: Duration(milliseconds: 300));
    // color4controller = AnimationController(vsync: this, duration: Duration(milliseconds: 300));
    // color1 = ColorTween(begin: Colors.white.withOpacity(0.1), end: Colors.orange.withOpacity(1)).animate(color1controller);
    // color2 = ColorTween(begin: Colors.white.withOpacity(0.1), end: Colors.orange.withOpacity(1)).animate(color2controller);
    // color3 = ColorTween(begin: Colors.white.withOpacity(0.1), end: Colors.orange.withOpacity(1)).animate(color3controller);
    // color4 = ColorTween(begin: Colors.white.withOpacity(0.1), end: Colors.orange.withOpacity(1)).animate(color4controller);

    controller.addListener(() {
      setState(() {

      });
    });


    //
    // color1controller.addListener(() {
    //   setState(() {
    //
    //   });
    // });
    //
    // color2controller.addListener(() {
    //   setState(() {
    //
    //   });
    // });
    //
    // color3controller.addListener(() {
    //   setState(() {
    //
    //   });
    // });
    //
    // color4controller.addListener(() {
    //   setState(() {
    //
    //   });
    // });

    LoadQuiz();
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
            Opacity(
              opacity: opacityanim.value,
              child: Stack(
                children: Quizes,
              ),
            ),
            Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: LoadADWidget()
            )
          ],
        ),
      ),
    );
  }
}
