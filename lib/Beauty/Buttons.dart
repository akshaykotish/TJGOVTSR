import 'package:flutter/material.dart';
import 'package:governmentapp/Encyclopedia/EncyclopediaRead.dart';
import 'package:governmentapp/Files/CurrentJob.dart';

class Buttons extends StatefulWidget {
  const Buttons({Key? key}) : super(key: key);

  @override
  State<Buttons> createState() => _ButtonsState();
}

class _ButtonsState extends State<Buttons> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          GestureDetector(
            onTap: (){
              CurrentJob.LovedJobsData.add("Loved");
            },
            child: Container(
              width: 80,
              height: 80,
              margin: EdgeInsets.all(5),
              decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                  image: DecorationImage(
                    image: AssetImage("./assets/branding/favouritebtn.jpg"),
                  )
              ),
            ),
          ),
          GestureDetector(
            onTap: (){
              Navigator.push(context, PageRouteBuilder(
                  transitionDuration: const Duration(milliseconds: 300),
                  transitionsBuilder: (BuildContext context, Animation<double> animation, Animation<double> secAnimation, Widget child){

                    animation = CurvedAnimation(parent: animation, curve: Curves.elasticInOut);

                    return ScaleTransition(
                      scale: animation,
                      alignment: Alignment.center,
                      child: child,
                    );
                  },
                  pageBuilder: (BuildContext context, Animation<double> animation, Animation<double> secAnimation){
                    return EncyclopediaRead();
                  }));
            },
            child: Container(
              width: 80,
              height: 80,
              margin: EdgeInsets.all(5),
              decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                  image: DecorationImage(
                    image: AssetImage("./assets/branding/encycolpediabtn.jpg"),
                  )
              ),
            ),
          ),
          Container(
            width: 80,
            height: 80,
            margin: EdgeInsets.all(5),
            decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(15)),
                image: DecorationImage(
                  image: AssetImage("./assets/branding/materialbtn.jpg"),
                )
            ),
          ),
          Container(
            width: 80,
            height: 80,
            margin: EdgeInsets.all(5),
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(15)),
                image: DecorationImage(
                  image: AssetImage("./assets/branding/gkbutton.jpg"),
                )
            ),
          ),
        ],
      ),
    );
  }
}
