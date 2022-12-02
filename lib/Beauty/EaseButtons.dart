import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:governmentapp/DataLoadingSystem/JobDisplayManagement.dart';
import 'package:governmentapp/DataLoadingSystem/RequiredDataLoading.dart';

class EaseButtons extends StatefulWidget {
  const EaseButtons({Key? key}) : super(key: key);

  @override
  State<EaseButtons> createState() => _EaseButtonsState();
}

class _EaseButtonsState extends State<EaseButtons> with TickerProviderStateMixin {

  late AnimationController animationController;
  late Animation animation;

  String Showis = "Chosen";

  @override
  void initState() {
    animationController = AnimationController(vsync: this, duration: const Duration(milliseconds: 100));
    animation = Tween<double>(begin: 20, end: 130).animate(animationController);

    JobDisplayManagement.EASEBTNF = (String msg)
    {
      setState(() {

      });
    };

    super.initState();
    animationController.addListener(() {
      print(animation.value);
      if (animation.value < 60) {
        Showis = "Chosen";
      }
      else {
        Showis = "Trending";
      }

      setState(() {

      });
    });

    Timer(
      Duration(milliseconds: 1000), (){
        if(JobDisplayManagement.WhichShowing == 1) {
          animationController.forward();
        }
      }
    );

    setState(() {

    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          width: MediaQuery.of(context).size.width - 180,
          height: 40,
          padding: const EdgeInsets.only(left: 20, top: 10),
          child: Text(
            JobDisplayManagement.WhichShowing == 1 ? "Trending Jobs: ${JobDisplayManagement.HOTJOBS.length}" :
            JobDisplayManagement.WhichShowing == 2 ? "Chosen Jobs: ${JobDisplayManagement.CHOOSEJOBS.length}" :
            JobDisplayManagement.WhichShowing == 3 ? "Searched Results: ${JobDisplayManagement.SEARCHJOBS.length}" :
            JobDisplayManagement.WhichShowing == 4 ? "Favourite Jobs: ${JobDisplayManagement.FAVJOBS.length}" :
            "",
            style: TextStyle(fontFamily: "uber",
              fontWeight: FontWeight.w600,
              fontSize: 15,
              color: Colors.grey[900]
            ),
          ),
        ),
        Container(
          alignment: Alignment.topRight,
          child: GestureDetector(
            onTap: (){
              JobDisplayManagement.IsMoreLoading = false;
              JobDisplayManagement.ISLoading = false;
              if(animation.value == 20) {
                //RequiredDataLoading.LoadHotJobs();
                animationController.forward();
              }
              else{
                RequiredDataLoading.LoadChoosedJobs();
                animationController.reverse();
              }
            },
            child: Container(
              width: 200,
              height: 40,
              alignment: Alignment.centerRight,
              child: Stack(
                children: <Widget>[
                  Positioned(
                    right: 50,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.deepOrange.withOpacity(0.8),
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                        boxShadow: [
                          BoxShadow(color: Colors.grey.shade400, offset: Offset(1,1), spreadRadius: 2, blurRadius: 2,)
                        ]
                      ),
                      width: 80,
                      padding: EdgeInsets.all(8),
                      child: Text(Showis,
                      textAlign: TextAlign.center
                      , style: TextStyle(fontFamily: "uber",
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    right: animation.value,
                    child:
                  Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.deepOrange.withOpacity(0.8), width: 3),
                        boxShadow: [
                          BoxShadow(
                            offset: Offset(2, 2),
                            color: Colors.grey.shade400.withOpacity(0.2),
                            blurRadius: 3,
                            spreadRadius: 4,
                          )
                        ]
                    ),
                    child: animation.value < 80 ? Icon(Icons.work, size: 15, color: Colors.grey.shade800,) :
                    SizedBox(
                      width: 15,
                      height: 15,
                      child: Container(
                        margin: EdgeInsets.all(5),
                        decoration: const BoxDecoration(
                            image: DecorationImage(
                                image: AssetImage("./assets/icons/hot.png"),
                                fit: BoxFit.fitHeight
                            )
                        ),
                      ),
                    ),
                  ),),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
