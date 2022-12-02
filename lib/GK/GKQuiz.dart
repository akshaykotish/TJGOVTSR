import 'dart:async';
import 'dart:math';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:governmentapp/AdFile.dart';
import 'package:governmentapp/Ads/HomeAd.dart';
import 'package:governmentapp/DataLoadingSystem/JobDisplayManagement.dart';
import 'package:governmentapp/DataPullers/GKPullers.dart';
import 'package:governmentapp/GK/GKQuizScore.dart';
import 'package:governmentapp/HexColors.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:translator/translator.dart';

class GKQuiz extends StatefulWidget {
  const GKQuiz({Key? key}) : super(key: key);

  @override
  State<GKQuiz> createState() => _GKQuizState();
}

class _GKQuizState extends State<GKQuiz> with TickerProviderStateMixin {
  String Language = "English";
  int correct = 0;
  int noofques = 0;
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
      if(UserAnswer == Answer)
      {
        correct++;
        setState(() {

        });
      }

      Questions.add(Question);
      UserAnswers.add(UserAnswer);
      Answers.add(Answer);
      Hints.add(Hint);
    }

    if (isadded <= 0) {
      isadded--;
      print("Come here");
      await TJSNInterstitialAd.LoadAnAd();
      Navigator.pop(context);
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
  final translator = GoogleTranslator();

  Future<void> QuizContainer(String Q, List<dynamic> O, String A, String H) async {
    
    // String QuesHindi =  "", O1H = "", O2H = "", O3H = "", O4H = "";
    //
    // QuesHindi  =  (await translator.translate(Q, from: 'en', to: 'hi')).text;
    // O1H  =  (await translator.translate(O[0], from: 'en', to: 'hi')).text;
    // O2H  =  (await translator.translate(O[1], from: 'en', to: 'hi')).text;
    // O3H  =  (await translator.translate(O[2], from: 'en', to: 'hi')).text;
    // O4H  =  (await translator.translate(O[3], from: 'en', to: 'hi')).text;


    isadded++;
    noofques++;
    _Quizes.add(
        Container(
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
          color: ColorFromHexCode("#404752"),
            borderRadius: BorderRadius.all(Radius.circular(15)),
          ),
          height: TJSNInterstitialAd.adWidget7 != null ? MediaQuery.of(context).size.height - 250 - 100 : MediaQuery.of(context).size.height - 250,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(height: 50,),
                Text(Q,
                style: GoogleFonts.poppins(color: Colors.white,fontWeight: FontWeight.w700, fontSize: 15,),
                ),
                SizedBox(height: 20,),
                Text("Click on your answer: ", style: TextStyle(color: Colors.white,fontSize: 12),),
                SizedBox(height: 5,),
                GestureDetector(
                  onTap: (){
                    int abc = int.parse(isadded.toString());
                    SubmitAnswer(Q, O[0], A, H, abc, 1);
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width-100,
                    decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(0.1),
                        border: Border.all(color: Colors.grey.shade400, width: 1),
                        borderRadius: BorderRadius.all(Radius.circular(10)),

                    ),
                    padding: EdgeInsets.all(10),
                    margin: EdgeInsets.all(5),
                    child: Text(O[0], style: TextStyle(color: Colors.white,fontSize: 15, fontWeight: FontWeight.w500),),
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
                    child: Text(O[1], style: TextStyle(color: Colors.white,fontSize: 15, fontWeight: FontWeight.w500),),
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
                    child: Text(O[2], style: TextStyle(color: Colors.white,fontSize: 15, fontWeight: FontWeight.w500),),
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
                    child: Text(O[3], style: TextStyle(color: Colors.white,fontSize: 15, fontWeight: FontWeight.w500),),
                  ),
                ),
              ],
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
    //_Quizes.add(Container(child: Center(child: Text("Quiz Over", style: TextStyle(color: Colors.white,fontSize: 20, fontWeight: FontWeight.w500,),),)));

    var rnd = Random();
    int rndm = rnd.nextInt(10);
    String ThisMonth = DateTime.now().month.toString() + DateTime.now().year.toString();
    var quizes = await FirebaseFirestore.instance.collection("GKTodayQuiz").doc(ThisMonth).collection("Questions").get();

    if(quizes.docs.length == 0)
      {
        String ThisMonth = (DateTime.now().month-1).toString() + DateTime.now().year.toString();
        quizes = await FirebaseFirestore.instance.collection("GKTodayQuiz").doc(ThisMonth).collection("Questions").get();
      }

    quizes.docs.forEach((quiz) async {
      rndm = rnd.nextInt(20);
      print("Loading...$rndm");
      if(rndm%3 == 0 &&  Quizes.length < 10 && _Quizes.length < 10) {
        print("Loading...");
        QuizContainer(
            quiz.data()["Question"].toString(), quiz.data()["Options"],
            quiz.data()["Answer"].toString(), quiz.data()["Hint"].toString()
        );
      }
      });
    setState(() {
      Quizes = _Quizes;
    });
  }

  @override
  void initState() {
    controller =  AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    opacityanim = Tween<double>(begin: 1.0, end: 0.0).animate(controller);
    controller.addListener(() {
      setState(() {

      });
    });

    LoadQuiz();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: ColorFromHexCode("#404752"),
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Stack(
          children: <Widget>[
            Container(
              color: ColorFromHexCode("#404752"),
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: 10,),
                  Container(
                    margin: EdgeInsets.only(
                      top: 10,
                      bottom: 10,
                    ),
                    alignment: Alignment.center,
                    child: Image.asset("./assets/branding/waiting.gif", fit: BoxFit.fill,),
                    height: 40,
                  ) ,
                ],
              ),
            ),
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Opacity(
                opacity: opacityanim.value,
                child: Stack(
                  children: Quizes,
                ),
              ),
            ),
            // Positioned(
            //     top: MediaQuery.of(context).padding.top + 20,
            //     right: 30,
            //     child: GestureDetector(
            //       onTap: () async {
            //         if(Language == "English") {
            //           Language = "Hindi";
            //           final prefs = await SharedPreferences.getInstance();
            //           prefs.setString("Language", "Hindi");
            //         }
            //         else{
            //           Language = "English";
            //           final prefs = await SharedPreferences.getInstance();
            //           prefs.setString("Language", "English");
            //         }
            //         GKTodayData.CurrentLanguage = Language;
            //         JobDisplayManagement.LanguageChange.add(Language);
            //         setState(() {});
            //       },
            //       child: Container(
            //         child: Text(Language == "English" ? "हिंदी भाषा में पढ़ें" : "Read in english language.",
            //           style:
            //           GoogleFonts.poppins(
            //             decoration:  TextDecoration.underline,
            //             color: Colors.white,
            //             fontSize: 12,
            //             fontWeight: FontWeight.bold,
            //           ),),
            //       ),
            //     ),
            // ),
            Positioned(
                bottom: 50,
                left: 0,
                right: 0,
                child:  TJSNInterstitialAd.AdsEnabled ? HomeAd(adkey: "ca-app-pub-3701741585114162/1630773412",) : Container(child: Text("NO Ads"),),
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: TJSNInterstitialAd.adWidget7 != null ? 250 : 0,
                child: Container(
                  height: 50,
                  width: MediaQuery.of(context).size.width,
                  color: ColorFromHexCode("#6D9886"),
                  padding: EdgeInsets.all(10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Attempted: ${noofques - isadded-1}/${noofques}", style: TextStyle(color: Colors.white,fontSize: 14, fontWeight: FontWeight.w600),),
                      Text("Correct: ${correct}/${noofques - isadded-1}", style: TextStyle(color: Colors.white,fontSize: 14, fontWeight: FontWeight.w600),),
                    ],
                  ),
            ))
          ],
        ),
      ),
    );
  }
}
