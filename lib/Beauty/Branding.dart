import 'dart:async';

import 'package:flutter/material.dart';
import 'package:governmentapp/Beauty/Buttons.dart';
import 'package:governmentapp/Files/AnimatedFlips.dart';
import 'package:governmentapp/HexColors.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:governmentapp/Notifcations.dart';


class Branding extends StatefulWidget {
  const Branding({Key? key}) : super(key: key);

  @override
  State<Branding> createState() => _BrandingState();
}

class _BrandingState extends State<Branding> with
    TickerProviderStateMixin {

  bool abc = true, efg = false, ijk = false;

  late AnimationController controller;
  late Animation sizeAnimation;
  late Animation colorAnimation;


  late AnimationController removetextcontroller;
  late Animation removetextAnimation;


  late AnimationController loadflipscontroller;
  late Animation loadflipsAnimation;
  late Animation loadflipcolorAnimation;


  late AnimationController notifscontroller;
  late Animation notifsAnimation;
  bool notifshow = false;
  String notiftext = "";


  @override
  void initState() {

    Notifications.NOTIFJOBSF = (notifs){

    };
    // TODO: implement initState
    super.initState();

    controller =  AnimationController(vsync: this, duration: Duration(seconds: 2));
    sizeAnimation = Tween<double>(begin: 40.0, end: 50.0).animate(controller);
    controller.forward();
    Timer(Duration(seconds: 3), ()=>controller.reverse());


    removetextcontroller =  AnimationController(vsync: this, duration: Duration(seconds: 2));
    removetextAnimation = Tween<double>(begin: 9, end: 0.0).animate(removetextcontroller);

    loadflipscontroller =  AnimationController(vsync: this, duration: Duration(milliseconds: 300));
    loadflipsAnimation = Tween<double>(begin: 150, end: 70.0).animate(loadflipscontroller);
    loadflipcolorAnimation = ColorTween(begin: ColorFromHexCode("#383C39").withOpacity(1), end: ColorFromHexCode("#383C39").withOpacity(0.1)).animate(loadflipscontroller);

    notifscontroller =  AnimationController(vsync: this, duration: Duration(seconds: 1));
    notifsAnimation = Tween<double>(begin: 150, end: 190.0).animate(notifscontroller);

    controller.addListener(() {
      setState(() {

      });
    });

    controller.addStatusListener((status) {
      if(status == AnimationStatus.completed)
        {
          Timer(Duration(seconds: 3), ()=>removetextcontroller.forward());
        }
    });

    removetextcontroller.addListener(() {
      setState(() {

      });
    });

    removetextcontroller.addStatusListener((status) {
      if(status == AnimationStatus.completed)
        {
          print("FTTFTF");
          setState(() {
            abc = false;
          });
          loadflipscontroller.forward();
          Timer(Duration(milliseconds: 550), (){loadflipscontroller.reverse(); setState(() {
            efg = true;
          });});
        }
    });

    loadflipscontroller.addListener(() {
      setState(() {

      });
    });

    loadflipscontroller.addStatusListener((status) {
      if(status == AnimationStatus.completed)
        {
          if(Notifications.notifications.length != 0) {
            Timer(Duration(seconds: 10), () {
              notifscontroller.forward();
            });
          }
        }
    });

    notifscontroller.addListener(() {
      setState(() {

      });
    });

    notifscontroller.addStatusListener((status) {
      if(status == AnimationStatus.completed)
        {
          if(notifshow)
            {
              notifshow = false;
              Timer(Duration(seconds: 10), ()=>notifscontroller.reverse());
            }
          else{
            notifshow = true;
            notiftext = Notifications.notifications[Notifications.notifcs];
            Notifications.notifcs++;
            Timer(Duration(seconds: 10), ()=>notifscontroller.reverse());
          }
        }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      margin: EdgeInsets.only(top: MediaQuery.of(context).viewPadding.top,),
      child: Container(
        padding: EdgeInsets.all(10),
        width: MediaQuery.of(context).size.width - 20,
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(15)),
        ),
        child: abc ? Visibility(
          visible: abc,
          child: Container(
            alignment: Alignment.centerLeft,
            margin: const EdgeInsets.only(top: 10),
            child: Text("TrackJobs".substring(0, double.parse(removetextAnimation.value.toString()).toInt()), style: GoogleFonts.msMadi(
              fontSize: sizeAnimation.value,
              color: Colors.brown.shade100,
              fontWeight: FontWeight.bold,
              shadows: [
                Shadow(color: Colors.brown.shade900, offset: Offset(1, 1), blurRadius: 1),
                Shadow(color: Colors.brown.shade900, offset: Offset(1, 1), blurRadius: 1),
              ]
            ),
            textAlign: TextAlign.start,),
          ),
        ) : Visibility(
            visible: !abc,
            child: !abc ? Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: loadflipcolorAnimation.value,
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
                height: !ijk ? loadflipsAnimation.value : notifsAnimation.value,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    AnimatedFlips(),
                    efg ? AnimatedOpacity(
                        duration: Duration(milliseconds: 600),
                        opacity: efg ? 1 : 0,
                        child: Buttons()) : Container(),
                    notifshow ? Container(
                      child: Text(notiftext),
                    ) : Container(),
                  ],
                )) : Container()),
      ),
    );
  }
}