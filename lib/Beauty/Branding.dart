import 'dart:async';

import 'package:flutter/material.dart';
import 'package:governmentapp/Beauty/Buttons.dart';
import 'package:governmentapp/Files/AnimatedFlips.dart';
import 'package:governmentapp/Files/JobBox.dart';
import 'package:governmentapp/HexColors.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:governmentapp/Notifcations.dart';
import 'package:shared_preferences/shared_preferences.dart';


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

  bool andmore = true;

  @override
  void initState() {

    Notifications.NOTIFJOBSF = (notifs){
      if(andmore == false) {
        andmore = true;
        notifscontroller.forward();
      }
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

    notifscontroller =  AnimationController(vsync: this, duration: Duration(milliseconds: 800));
    notifsAnimation = Tween<double>(begin: 150, end: 240.0).animate(notifscontroller);

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
            setState(() {
              ijk = true;
            });
            Timer(Duration(seconds: 6), () {
              notifshow = false;
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
      if(status == AnimationStatus.reverse){
        print("ADI");
        if(notifshow)
        {
          print("AFJNF");
          notiftext = "";
          notifshow = false;

          if(Notifications.notifcs < Notifications.notifications.length) {
            Timer(Duration(seconds: 6), () {
              notifscontroller.forward();
            });
          }
        }
        else{
          andmore = false;
        }
      }
      if(status == AnimationStatus.completed || status == AnimationStatus.forward)
        {
          if(!notifshow) {
            notifshow = true;
            notiftext = Notifications.notifications[Notifications.notifcs];
            setState(() {});
            Notifications.notifcs++;
            if(Notifications.notifcs <= Notifications.notifications.length) {
              Timer(Duration(seconds: 6), () {
                notiftext = "";
                setState(() {});
                notifscontroller.reverse();
              });
            }
          }
          else{
            andmore = false;
          }
        }
    });

    HelloMessage();
  }

  Future<void> HelloMessage() async {
    final prefs = await SharedPreferences.getInstance();
    String? Contact = prefs.getString("LoginContact");
    String? Name = prefs.getString("LoginName");

    if(Name != null && Name != "") {
      Notifications.notifications.add("Hello ${Name}");
      Notifications.NOTIFJOBSC.add(Notifications.notifications);

      Notifications.notifications.add("${Name}, Hope you are doing well?");
      Notifications.NOTIFJOBSC.add(Notifications.notifications);
    }
    else{
      Notifications.notifications.add("Hello ${Contact}");
      Notifications.NOTIFJOBSC.add(Notifications.notifications);

      Notifications.notifications.add("${Name}, Hope you are doing well.");
      Notifications.NOTIFJOBSC.add(Notifications.notifications);
    }
  }

  @override
  void dispose() {
    notifscontroller.dispose();
    controller.dispose();
    removetextcontroller.dispose();
    loadflipscontroller.dispose();
    notifscontroller.dispose();
    super.dispose();
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
                    notifshow ? AnimatedOpacity(
                      opacity: notifshow ? 1 : 0,
                      duration: Duration(milliseconds: 600),
                      child: Container(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Container(
                              width: 15,
                              height: 15,
                              decoration: const BoxDecoration(
                                image: DecorationImage(
                                  image: AssetImage("./assets/branding/smile.png")
                                )
                              ),
                            ),
                            SizedBox(height: 5,),
                            Container(
                              width: MediaQuery.of(context).size.width - 50,
                              alignment: Alignment.center,
                              child: Text(notiftext.toTitleCase(),
                              textAlign: TextAlign.center,
                              style: GoogleFonts.hindSiliguri(
                                fontSize: notiftext.length < 50 ? 16 : 10,
                                color: ColorFromHexCode("#FFBB00"),
                                fontWeight: FontWeight.w700
                              ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ) : Container(),
                  ],
                )) : Container()),
      ),
    );
  }
}