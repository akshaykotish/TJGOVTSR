import 'dart:async';

import 'package:flutter/material.dart';
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
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.topRight,
      child: GestureDetector(
        onTap: (){
          if(animation.value == 20) {
            RequiredDataLoading.LoadHotJobs();
            animationController.forward();
          }
          else{
            RequiredDataLoading.LoadChoosedJobs();
            animationController.reverse();
          }
        },
        child: Container(
          width: 250,
          height: 40,
          alignment: Alignment.centerRight,
          child: Stack(
            children: <Widget>[
              Positioned(
                right: 50,
                child: Container(
                  width: 80,
                  padding: EdgeInsets.all(8),
                  child: Text(Showis,
                  textAlign: TextAlign.center
                  , style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                      color: Colors.grey[700],
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
                    border: Border.all(color: Colors.grey.withOpacity(0.2), width: 1),
                    boxShadow: [
                      BoxShadow(
                        offset: Offset(2, 2),
                        color: Colors.grey.shade400.withOpacity(0.2),
                        blurRadius: 3,
                        spreadRadius: 4,
                      )
                    ]
                ),
                child: animation.value < 80 ? Icon(Icons.work, size: 15,) :
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
    );
  }
}
