import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:governmentapp/Beauty/Home.dart';

class Disclaimer extends StatefulWidget {
  const Disclaimer({Key? key}) : super(key: key);

  @override
  State<Disclaimer> createState() => _DisclaimerState();
}

class _DisclaimerState extends State<Disclaimer> {

  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 2), (){
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
        color: Colors.black,
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text("Disclaimer", style: GoogleFonts.poppins(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w500),),
            SizedBox(height: 50,),
            Text("TJSN is a private app created by Aksahy Kotish & Co. This app is not affiliated to any government entity. All the data is sourced from different Government & Non-Government websites. All the information is placed manually by the team members etc. If you have any issue with any content you can write us on connect@trackjobs.in", style: GoogleFonts.poppins(color: Colors.white, fontSize: 12, ),),
            Text("~ Team TJSN", style: GoogleFonts.poppins(color: Colors.white, fontSize: 10, ),),
          ],
        ),
      ),
    );
  }
}
