import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:governmentapp/AdFile.dart';
import 'package:governmentapp/Ads/HomeAd.dart';
import 'package:governmentapp/DataLoadingSystem/JobDisplayManagement.dart';
import 'package:governmentapp/DataPullers/GKPullers.dart';
import 'package:governmentapp/GK/GKPage.dart';
import 'package:governmentapp/GK/GKQuiz.dart';
import 'package:governmentapp/HexColors.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:translator/translator.dart';


class CurrentAffairs extends StatefulWidget {
  const CurrentAffairs({Key? key}) : super(key: key);

  @override
  State<CurrentAffairs> createState() => _CurrentAffairsState();
}

class _CurrentAffairsState extends State<CurrentAffairs> {
  bool isloading = true;
  final translator = GoogleTranslator();

  String Language = "English";
  var GKs = <Widget>[];
  PageController pageController = PageController();

  Future<void> LoadCurrentAffairs() async {
    var _GKs = <Widget>[];
    List<GKTodayData> _GkTodayDatas = <GKTodayData>[];
    var CurrentAffairs = await FirebaseFirestore.instance.collection("GKToday").get();
    CurrentAffairs.docs.forEach((element) async {
      if(element.exists) {
        if(element.data()["Heading"].toString().contains("Current Affairs") || element.data()["Heading"].toString().contains("Headlines")){

        }else {
          GKTodayData gktoday = GKTodayData(
              element.data()["Heading"].toString(),
              element.data()["Date"].toString(),
              element.data()["Image"].toString(),
              element.data()["Content"].toString(),
              element.data()["URL"].toString(),
              element.id
          );
          _GKs.add(
            GKPage(gkTodayData: gktoday),
          );
        }

        setState(() {
          GKs = _GKs;
          isloading = false;
        });
      }
    });


  }
  
  int loadPI = 0;

  Future<void> LoadPageIndex()
  async {
    final prefs = await SharedPreferences.getInstance();
    loadPI = prefs.getInt("LastCAPage")!;

    pageController.animateToPage(loadPI, duration: Duration(milliseconds: 300,), curve: Curves.bounceIn);
  }

  Future<void> SavePageIndex(int e) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt("LastCAPage", e);

    print("GO TO FLOW ${e}");
  }

  Container adCntnr = Container();
  Future<void> LoadADWidget()
  async {
    await TJSNInterstitialAd.LoadBannerAd();
    adCntnr = Container(
      child: TJSNInterstitialAd.adWidget6,
    );
    setState(() {

    });
  }

  Future<void> GetLanguage()
  async {
    final prefs = await SharedPreferences.getInstance();
    var x = prefs.getString("Language");
    if(x != null)
      {
        Language = x;
      }
    else{
      Language = "English";
    }
    GKTodayData.CurrentLanguage = Language;
    setState(() {

    });
  }

  @override
  void initState() {
    LoadCurrentAffairs();
    LoadADWidget();
    GetLanguage();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: ColorFromHexCode("#404752"),
        child: Stack(
            children: <Widget>[
              Positioned(child: Container(
                child: Center(
                  child: isloading == true ? Container(
        margin: EdgeInsets.only(
        top: 10,
          bottom: 10,
        ),
        alignment: Alignment.center,
        child: Image.asset("./assets/branding/waiting.gif", fit: BoxFit.fill,),
        height: 40,
      ) : null,
                ),
              )),
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                bottom:  TJSNInterstitialAd.adWidget6 != null ? 50 : 0,
                child: PageView(
                  controller: pageController,
                  scrollDirection: Axis.vertical,
                  allowImplicitScrolling: true,
                  children: GKs,
                ),
              ),
              Positioned(
                right: 50,
                bottom: 80,
                child: GestureDetector(
                  onTap: () async {
                    if(Language == "English") {
                      Language = "Hindi";
                      final prefs = await SharedPreferences.getInstance();
                      prefs.setString("Language", "Hindi");
                    }
                    else{
                      Language = "English";
                      final prefs = await SharedPreferences.getInstance();
                      prefs.setString("Language", "English");
                    }
                    GKTodayData.CurrentLanguage = Language;
                    JobDisplayManagement.LanguageChange.add(Language);
                    LoadCurrentAffairs();
                    Timer(Duration(milliseconds: 500), (){
                      setState(() {

                      });
                    });
                  },
                  child: Container(
                    child: Text(Language == "English" ? "हिंदी भाषा में पढ़ें" : "Read in english language.",
                      style:
                      GoogleFonts.poppins(
                        decoration:  TextDecoration.underline,
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),),
                  ),
                ),
              ),
              Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  height: 50,
                  child: Container(
                    child:  Visibility(
                      visible:  TJSNInterstitialAd.AdsEnabled,
                      child: Container(
                        height: TJSNInterstitialAd.AdsEnabled ? 50 : 0,
                        child:  TJSNInterstitialAd.AdsEnabled ? HomeAd(adkey: "ca-app-pub-3701741585114162/7553732677", smallbanner: true,) : Container(child: Text(""),),
                      ),
                    ),
              ),
              ),
            ],
          ),
      )
    );
  }
}
