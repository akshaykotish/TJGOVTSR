import 'dart:async';

import 'package:flutter/material.dart';
import 'package:governmentapp/Animations/Disclaimer.dart';
import 'package:governmentapp/Beauty/Home.dart';
import 'package:governmentapp/Files/CurrentJob.dart';
import 'package:governmentapp/HexColors.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 5), () {
      Navigator.pop(context);
      Navigator.push(context, MaterialPageRoute(builder: (context) => Disclaimer()));
    });
    Timer(Duration(seconds: 12), (){
      Navigator.pop(context);
      Navigator.push(context, PageRouteBuilder(
          transitionDuration: const Duration(seconds: 1),
          transitionsBuilder: (BuildContext context, Animation<double> animation, Animation<double> secAnimation, Widget child){

            animation = CurvedAnimation(parent: animation, curve: Curves.elasticInOut);

            return ScaleTransition(
              scale: animation,
              alignment: Alignment.center,
              child: child,
            );
          },
          pageBuilder: (BuildContext context, Animation<double> animation, Animation<double> secAnimation){
            return Home();
          }));
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        color: ColorFromHexCode("393E46"),
        child: Center(
          child:  Container(
            alignment: Alignment.center,
            child: Image.asset("./assets/branding/Logo.gif", fit: BoxFit.fill,),
            height: 100,
          ) ,
        ),
      ),
    );
  }
}
