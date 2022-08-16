import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:governmentapp/HexColors.dart';


class AnimatedFlips extends StatefulWidget {
  const AnimatedFlips({Key? key}) : super(key: key);

  @override
  State<AnimatedFlips> createState() => _AnimatedFlipsState();
}

class _AnimatedFlipsState extends State<AnimatedFlips> {

  static bool isrunning = false;
  bool isback = false;
  double angle = 0;

  int index = 0;
  var strigs = [
    "Change the world by being yourself",
    "Every moment is a fresh beginning",
    "When nothing goes right, go left",
    "Success is the child of audacity",
    "Never regret anything that made you smile",
    "Impossible is for the unwilling",
  ];


  void Flip()
  {
  }

  void StartAnimation()
  {
    try {
      isrunning = true;
      Timer.periodic(Duration(seconds: 5), (timer) {
        if (angle == pi) {
          setState(() {
            angle = 0; //(angle + pi) % (2 * pi);
            if (index == 2) {
              index = 0;
            }
            else {
              index++;
            }
          });
        }
        else {
          setState(() {
            angle = (angle + pi) % (2 * pi);
          });
        }
      });
    }
    catch(e){}
  }


  @override
  void initState() {
    isrunning == false ? StartAnimation() : null;
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Container(
        child: Center(
          child: GestureDetector(
            onTap: Flip,
            child: TweenAnimationBuilder(
              tween: Tween<double>(begin: 0, end: angle),
              builder: (BuildContext context, double val, _)
              {
                if(val >= (pi/2))
                  {
                    isback = true;
                  }
                else{
                  isback = false;
                }



                return (
                    Transform(
                      alignment: Alignment.center,
                  transform: Matrix4.identity()
                    ..setEntry(3, 2, 0.0001)
                    ..rotateX(val)
                  ,
                  child: Container(
                    alignment: Alignment.center,
                    child: isback == false ? Container(
                        child: Text(strigs[index], style: TextStyle(fontFamily: "Amatic_SC", fontSize: 17, color: ColorFromHexCode("#DADADA"), fontWeight: FontWeight.bold,)))
                        :
                    Container(
                      child: Transform(
                        alignment: Alignment.center,
                          transform: Matrix4.identity()
                            ..rotateX(pi),
                          child: Text(strigs[index+1], style: TextStyle(fontFamily: "Amatic_SC", fontSize: 17, color: ColorFromHexCode("#DADADA"), fontWeight: FontWeight.bold,),)),
                    ),
                  ),
                ));
              }, duration: Duration(seconds: 1),
            ),
          )
        ),
      );
  }
}
