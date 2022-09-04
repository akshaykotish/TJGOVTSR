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


  late AnimationController color1controller;
  late AnimationController color2controller;
  late AnimationController color3controller;
  late AnimationController color4controller;
  late Animation color1;
  late Animation color2;
  late Animation color3;
  late Animation color4;


  int isadded = -1;

  Future<void> SubmitAnswer(String Question, String UserAnswer, String Answer, String Hint, int ia, int x) async {
    if (!Questions.contains(Question)) {
      Questions.add(Question);
      UserAnswers.add(UserAnswer);
      Answers.add(Answer);
      Hints.add(Hint);

      print("is added = ${isadded}");
      controller.forward();
    }

    _Quizes.removeAt(ia);
    isadded--;


    if (isadded < 0) {
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
      Timer(const Duration(milliseconds: 200), () {
        controller.reverse();
        setState(() {
          Quizes = _Quizes;
        });
      });
    }
  }

  Future<void> QuizContainer(String Q, List<dynamic> O, String A, String H) async {
    isadded++;
    _Quizes.add(
        Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
              color: ColorFromHexCode("#E2E2E2"),
              image: const DecorationImage(
                image: AssetImage(
                  "./assets/branding/Background.jpg",
                ),
                fit: BoxFit.fill,
              )
          ),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              margin: EdgeInsets.only(
                top: MediaQuery.of(context).padding.top + 50,
                left: 20,
                right: 20,
                bottom: 100,
              ),
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(20)),
                color: Colors.grey.withOpacity(0.1),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text("TJ's Quiz", textAlign: TextAlign.start, style: TextStyle(fontSize: 35, fontWeight: FontWeight.w900,),),
                  SizedBox(height: 40,),
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
                          color: color1.value,
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
                          color: color2.value,
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
                          color: color3.value,
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
                        color: color4.value,
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
      print("ASAF");
      await QuizContainer(quiz.data()["Question"].toString(), quiz.data()["Options"], quiz.data()["Answer"].toString(), quiz.data()["Hint"].toString());
      setState(() {
        Quizes = _Quizes;
      });
    });
  }

  @override
  void initState() {
    controller =  AnimationController(vsync: this, duration: Duration(milliseconds: 200));
    opacityanim = Tween<double>(begin: 1.0, end: 0.0).animate(controller);

    color1controller = AnimationController(vsync: this, duration: Duration(milliseconds: 300));
    color2controller = AnimationController(vsync: this, duration: Duration(milliseconds: 300));
    color3controller = AnimationController(vsync: this, duration: Duration(milliseconds: 300));
    color4controller = AnimationController(vsync: this, duration: Duration(milliseconds: 300));
    color1 = ColorTween(begin: Colors.white.withOpacity(0.1), end: Colors.orange.withOpacity(1)).animate(color1controller);
    color2 = ColorTween(begin: Colors.white.withOpacity(0.1), end: Colors.orange.withOpacity(1)).animate(color2controller);
    color3 = ColorTween(begin: Colors.white.withOpacity(0.1), end: Colors.orange.withOpacity(1)).animate(color3controller);
    color4 = ColorTween(begin: Colors.white.withOpacity(0.1), end: Colors.orange.withOpacity(1)).animate(color4controller);

    controller.addListener(() {
      setState(() {

      });
    });

    color1controller.addListener(() {
      setState(() {

      });
    });

    color2controller.addListener(() {
      setState(() {

      });
    });

    color3controller.addListener(() {
      setState(() {

      });
    });

    color4controller.addListener(() {
      setState(() {

      });
    });

    print("ASAF");
    LoadQuiz();
    super.initState();
    TJSNInterstitialAd.myBanner.load();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Opacity(
          opacity: opacityanim.value,
          child: Stack(
            children: <Widget>[
              Positioned(
                top: 0,
                left: 0,
                bottom: 60,
                right: 0,
                child: Container(
                  child: Center(
                    child: Text("Loading...", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700,),),
                  ),
                ),
              ),
              Stack(
                children: Quizes,
              ),
              Positioned(
                  left: 0,
                  bottom: 0,
                  right: 0,
                  height: 60,
                  child: Container(
                    color: Colors.white,
                child: AdWidget(
                  ad: TJSNInterstitialAd.myBanner,
                ),
                width: TJSNInterstitialAd.myBanner.size.width.toDouble(),
                height: TJSNInterstitialAd.myBanner.size.height.toDouble(),
              ))
            ],
          ),
        ),
      ),
    );
  }
}
