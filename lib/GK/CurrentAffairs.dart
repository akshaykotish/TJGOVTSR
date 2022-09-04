import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:governmentapp/AdFile.dart';
import 'package:governmentapp/DataPullers/GKPullers.dart';
import 'package:governmentapp/GK/GKPage.dart';
import 'package:governmentapp/GK/GKQuiz.dart';


class CurrentAffairs extends StatefulWidget {
  const CurrentAffairs({Key? key}) : super(key: key);

  @override
  State<CurrentAffairs> createState() => _CurrentAffairsState();
}

class _CurrentAffairsState extends State<CurrentAffairs> {

  var GKs = <Widget>[];

  Future<void> LoadCurrentAffairs() async {
    var _GKs = <Widget>[];
    List<GKTodayData> _GkTodayDatas = <GKTodayData>[];
    var CurrentAffairs = await FirebaseFirestore.instance.collection("GKToday").get();
    CurrentAffairs.docs.forEach((element) {
      if(element.exists) {
        print("Loading ${element.id}");
        GKTodayData gktoday = GKTodayData(element.data()["Heading"].toString(), element.data()["Date"].toString(), element.data()["Image"].toString(), element.data()["Content"].toString(), element.data()["URL"].toString());
        _GKs.add(
          GKPage(gkTodayData: gktoday),
        );

        setState(() {
          GKs = _GKs;
        });
      }
    });


  }

  @override
  void initState() {
    GKPullers.Execute();
    LoadCurrentAffairs();
    super.initState();
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
                bottom: 120,
                child: PageView(
                  scrollDirection: Axis.vertical,
                  allowImplicitScrolling: true,
                  children: GKs,
                ),
              ),
              Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  height: 110,
                  child: Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        GestureDetector(
                          child: Container(
                            padding: EdgeInsets.all(15),
                            color: Colors.grey[900],
                            width: MediaQuery.of(context).size.width,
                            child: Text("Give a Quiz on Current Affairs.", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w300, color: Colors.white), textAlign: TextAlign.center,),
                          ),
                          onTap: (){
                            Navigator.push(context, PageRouteBuilder(
                                transitionDuration: const Duration(milliseconds: 300),
                                transitionsBuilder: (BuildContext context, Animation<double> animation, Animation<double> secAnimation, Widget child){

                                  animation = CurvedAnimation(parent: animation, curve: Curves.elasticInOut);

                                  return ScaleTransition(
                                    scale: animation,
                                    alignment: Alignment.center,
                                    child: child,
                                  );
                                },
                                pageBuilder: (BuildContext context, Animation<double> animation, Animation<double> secAnimation){
                                  return const GKQuiz();
                                }));
                          },
                        ),
                        Container(
                          child: AdWidget(
                            ad: TJSNInterstitialAd.myBanner,
                          ),
                          width: TJSNInterstitialAd.myBanner.size.width.toDouble(),
                          height: TJSNInterstitialAd.myBanner.size.height.toDouble(),
                        )
                      ],
                    ),
              ),
              )
            ],
          ),
      )
    );
  }
}
