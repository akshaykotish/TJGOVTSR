import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:governmentapp/Beauty/Home.dart';
import 'package:governmentapp/HexColors.dart';

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

  void InitializeAnimations()
  {
    opacitycontroller = AnimationController(vsync: this, duration: const Duration(seconds: 1));
    opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(opacitycontroller);

    textcontroller = AnimationController(vsync: this, duration: const Duration(seconds: 1));
    textAnimation = Tween<double>(begin: 0.0, end: 9.0).animate(textcontroller);


    bttcontroller = AnimationController(vsync: this, duration: const Duration(seconds: 1));
    bttAnimation = Tween<double>(begin: 400.0, end: 50.0).animate(bttcontroller);


    bbcontroller = AnimationController(vsync: this, duration: const Duration(seconds: 1));
    bbAnimation = Tween<double>(begin: 0.0, end: 10.0).animate(bttcontroller);


    attsycontroller = AnimationController(vsync: this, duration: const Duration(seconds: 1));
    attsyAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(bttcontroller);
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
        BackgroundBlurAnimation();
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
    Navigator.of(context).pushAndRemoveUntil(PageRouteBuilder(
        transitionDuration: const Duration(seconds: 3),
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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    InitializeAnimations();
    OpacityAnimation();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
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
          filter: ImageFilter.blur(sigmaX: bbAnimation.value, sigmaY: bbAnimation.value),
          child: Stack(
            children: <Widget>[
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
                      image: DecorationImage(
                        image: AssetImage("./assets/branding/BrandingBackground.jpg"),
                        fit: BoxFit.fill,
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          child: Text("TrackJobs".substring(0, double.parse(textAnimation.value.toString()).toInt()), style: TextStyle(fontFamily: "CAMPUS", fontSize: 25, color: ColorFromHexCode("#DBDBDB"), letterSpacing: 15),),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 500,
                left: 10,
                child: Opacity(
                  opacity: attsyAnimation.value,
                  child: Container(
                    padding: EdgeInsets.all(10),
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: const <Widget>[
                        Text("Always Together To Serve Nation"),
                        Text("Made by Akshay Kotish & Co."),
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
