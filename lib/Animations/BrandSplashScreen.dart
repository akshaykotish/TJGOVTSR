import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:governmentapp/Beauty/Home.dart';
import 'package:governmentapp/HexColors.dart';
import 'package:governmentapp/Materials/MaterialData.dart';
import 'package:governmentapp/User/Login.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BrandSplashScreen extends StatefulWidget {
  const BrandSplashScreen({Key? key}) : super(key: key);

  @override
  State<BrandSplashScreen> createState() => _BrandSplashScreenState();
}

class _BrandSplashScreenState extends State<BrandSplashScreen> with
    TickerProviderStateMixin{


  late AnimationController controller;
  late Animation topAnimation;
  late Animation widthAnimation;


  late AnimationController opacitycontroller;
  late Animation opacityAnimation;

  late AnimationController textcontroller;
  late Animation textAnimation;

  late AnimationController bttcontroller;
  late Animation bttAnimation;

  late AnimationController bbcontroller;
  late Animation bbAnimation;

  late AnimationController attsycontroller;
  late Animation attsyAnimation;

  Future<void> InitializeAnimations()
  async {
    print("islogin yoyo $islogin");

    opacitycontroller = AnimationController(vsync: this, duration: const Duration(milliseconds: 500));
    opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(opacitycontroller);
    print("A");

    textcontroller = AnimationController(vsync: this, duration: const Duration(milliseconds: 500));
    textAnimation = Tween<double>(begin: 0.0, end: 9.0).animate(textcontroller);
    print("B");

    bttcontroller = AnimationController(vsync: this, duration: const Duration(milliseconds: 500));
    bttAnimation = Tween<double>(begin: 400.0, end: 50.0).animate(bttcontroller);
    print("C");

    bbcontroller = AnimationController(vsync: this, duration: const Duration(milliseconds: 500));
    bbAnimation = Tween<double>(begin: 0.0, end: 10.0).animate(bttcontroller);
    print("D");

    attsycontroller = AnimationController(vsync: this, duration: const Duration(milliseconds: 500));
    attsyAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(bttcontroller);
    print("E");

    await LoadProfile();
    OpacityAnimation();

  }

  void OpacityAnimation(){
    opacitycontroller.forward();
    opacitycontroller.addListener(() {
      setState(() {

      });
    });
    opacitycontroller.addStatusListener((status) {
      if(status == AnimationStatus.completed)
        {
          TextAnimation();
        }
    });
  }

  void TextAnimation(){
    textcontroller.forward();
    textcontroller.addListener(() {
      setState(() {

      });
    });
    textcontroller.addStatusListener((status) {
      if(status == AnimationStatus.completed)
      {
        BottomToTopAnimation();
      }
    });
  }

  void BottomToTopAnimation(){
    bttcontroller.forward();
    bttcontroller.addListener(() {
      setState(() {

      });
    });

    bttcontroller.addStatusListener((status) {
      if(status == AnimationStatus.completed)
      {
        if(!islogin) {
          BackgroundBlurAnimation();
        }
      }
    });
  }

  void BackgroundBlurAnimation(){
    bbcontroller.forward();
    bbcontroller.addListener(() {
      setState(() {

      });
    });

    bbcontroller.addStatusListener((status) {
      if(status == AnimationStatus.completed)
      {
        ATTSYAnimation();
      }
    });
  }


  void ATTSYAnimation(){
    attsycontroller.forward();
    attsycontroller.addListener(() {
      setState(() {

      });
    });

    attsycontroller.addStatusListener((status) {
      if(status == AnimationStatus.completed)
      {
        LoadHomePage();
      }
    });
  }

  void LoadHomePage(){
    print("LoadHomePage");
    Navigator.of(context).pushAndRemoveUntil(PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 500),
        transitionsBuilder: (BuildContext context, Animation<double> animation, Animation<double> secAnimation, Widget child){
          return FadeTransition(
            opacity: Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(parent: animation, curve: Curves.fastOutSlowIn)),
            child: child,
          );
        },
        pageBuilder: (BuildContext context, Animation<double> animation, Animation<double> secAnimation){
          return Home();
        }), (Route route) => false
    );
  }

  static bool islogin = true;
  Future<void> LoadProfile() async {
    final prefs = await SharedPreferences.getInstance();
    String? Contact = prefs.getString("LoginContact");
    String? AdsEnable = prefs.getString("AdsEnable");
    if(Contact != null)
      {
        prefs.setString("AdsEnable", "TRUE");
        print("Ads enabled");
        var User = await FirebaseFirestore.instance.collection("Users").doc(
            Contact).get();
          String? Expiry = User.data()!["Expiry"];
          if(Expiry != null) {
            print("Expiry ${Expiry}");
            DateTime expiryDate = DateTime.parse(Expiry);
            print("Expiry => ${!expiryDate
                .difference(DateTime.now())
                .isNegative}");
            if (!expiryDate
                .difference(DateTime.now())
                .isNegative) {

              prefs.setString("AdsEnable", "FALSE");
              print("Ads disabled");

            }
            else{
              prefs.setString("AdsEnable", "TRUE");
              print("Ads enabled");
            }
          }

        print("Contact is " + Contact);
        setState(() {
          islogin = false;
        });
      }
    else{
      setState(() {
        islogin = true;
      });
    }
  }

  @override
  void initState() {
    InitializeAnimations().then((value){
    });
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
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
          child: ClipRect(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: bbAnimation.value, sigmaY: bbAnimation.value),
              child: Container(
                color: Colors.grey.withOpacity(0.1),
                child: Stack(
                  children: <Widget>[
                    Positioned(
                      top: 180,
                      child: Opacity(
                        opacity: attsyAnimation.value,
                        child: islogin ? Container(
                          width: MediaQuery.of(context).size.width,
                          height: 800,
                          child: SingleChildScrollView(child: LoginArea()),
                        ) :
                          Container(
                            width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height - 200,
                          child:
                          Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: <Widget>[
                                  Container(
                                    child: Text(
                                      "LKS",
                                      style: TextStyle(
                                        fontWeight: FontWeight.w800,
                                        fontSize: 40,
                                        color: Colors.grey.shade900.withOpacity(0.5),
                                        letterSpacing: 30,
                                      ),
                                    ),
                                  ),
                                  SizedBox(height:10,),
                                  Container(
                                    child: Text(
                                      "Brand Signature",
                                      style: TextStyle(
                                        fontWeight: FontWeight.w800,
                                        fontSize: 10,
                                        color: Colors.grey.shade900.withOpacity(0.1),
                                        letterSpacing:4.5,
                                      ),
                                    ),
                                  ),
                                  SizedBox(height:150,),
                                  Opacity(
                                    opacity: 0.4,
                                    child: Container(
                                      width: 200,
                                      height: 50,
                                      decoration: const BoxDecoration(
                                        image: DecorationImage(
                                          image: AssetImage("./assets/branding/flute.png"),
                                        )
                                      ),
                                    ),
                                  ),
                                  Container(
                                    child: Text(
                                      "Love My God, MK & AB",
                                      style: TextStyle(
                                        fontWeight: FontWeight.w800,
                                        fontSize: 10,
                                        color: Colors.grey.shade500.withOpacity(0.2),
                                        letterSpacing: 5,
                                      ),
                                    ),
                                  ),
                                  SizedBox(height:50,),
                                  Container(
                                    child: Text(
                                      "An Akshay Kotish & Co. Product",
                                      style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 12,
                                        color: Colors.grey.shade800,
                                        letterSpacing: 2,
                                      ),
                                    ),
                                  ),
                                  SizedBox(height:10,),
                                  Container(
                                    child: Text(
                                      "Made for India",
                                      style: TextStyle(
                                        fontWeight: FontWeight.w300,
                                        fontSize: 10,
                                        color: Colors.grey.shade600,
                                        letterSpacing: 5,
                                      ),
                                    ),
                                  )
                                ],
                              )
                          ),
                ),
                      ),
                    ),
                    Positioned(
                      top: bttAnimation.value,
                      left: 10,
                      child: Opacity(
                        opacity: opacityAnimation.value,
                        child: Container(
                          padding: EdgeInsets.all(10),
                          width: MediaQuery.of(context).size.width - 20,
                          height: 90,
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(15)),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Container(
                                child: Text("TrackJobs".substring(0, double.parse(textAnimation.value.toString()).toInt()), style: GoogleFonts.msMadi(
                                  fontSize: 65,
                                  color: Colors.brown.shade100,
                                  fontWeight: FontWeight.bold,
                                    shadows: [
                                      Shadow(color: Colors.brown.shade900, offset: Offset(1, 1), blurRadius: 1),
                                      Shadow(color: Colors.brown.shade900, offset: Offset(1, 1), blurRadius: 1),
                                    ]),),
                              ),
                            ],
                          ),
                        )
                        ,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
