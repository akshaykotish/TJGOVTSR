import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';


class AnimatedFlips extends StatefulWidget {
  const AnimatedFlips({Key? key}) : super(key: key);

  @override
  State<AnimatedFlips> createState() => _AnimatedFlipsState();
}

class _AnimatedFlipsState extends State<AnimatedFlips> {

  bool isback = false;
  double angle = 0;

  int index = 0;
  var strigs = ["My", "Name", "is", "Akshay Kotish"];


  void Flip()
  {
  }

  void StartAnimation()
  {
    Timer.periodic(Duration(seconds: 5), (timer) {

      if(angle == pi) {
        setState(() {
          angle = 0; //(angle + pi) % (2 * pi);
          if(index == 2)
          {
            index = 0;
          }
          else{
            index++;
          }

        });
      }
      else{
        setState(() {
          angle = (angle + pi) % (2 * pi);
        });
      }
    });
  }


  @override
  void initState() {
    StartAnimation();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
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
                    width: 200,
                    height: 100,
                    child: isback == false ? Container(
                        child: Text(strigs[index])) :
                    Container(
                      child: Transform(
                        alignment: Alignment.center,
                          transform: Matrix4.identity()
                            ..rotateX(pi),
                          child: Text(strigs[index+1])),
                    ),
                  ),
                ));
              }, duration: Duration(seconds: 1),
            ),
          )
        ),
      ),
    );
  }
}
