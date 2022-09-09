import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:governmentapp/Files/CurrentJob.dart';
import 'package:governmentapp/Filtration/SearchSheet.dart';
import 'package:governmentapp/ForUsers/ChooseDepartment.dart';
import 'package:governmentapp/HexColors.dart';
import 'package:governmentapp/User/WriteALog.dart';

class SearchArea extends StatefulWidget {
  const SearchArea({Key? key}) : super(key: key);

  @override
  State<SearchArea> createState() => _SearchAreaState();
}

class _SearchAreaState extends State<SearchArea> with
    SingleTickerProviderStateMixin  {



  late AnimationController controller;
  late Animation colorAnimation1;
  late Animation colorAnimation2;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
try {
  controller = AnimationController(vsync: this, duration: Duration(seconds: 1));
  colorAnimation1 = ColorTween(
      begin: Colors.grey.withOpacity(0.7), end: Colors.white.withOpacity(0.5))
      .animate(controller);
  colorAnimation2 = ColorTween(
      begin: Colors.white.withOpacity(0.5), end: Colors.grey.withOpacity(0.7))
      .animate(controller);
  controller.forward();
  controller.addListener(() {
    setState(() {

    });
  });

  controller.addStatusListener((status) {
    if (status == AnimationStatus.completed) {
      controller.reverse();
    }
    else if (status == AnimationStatus.dismissed) {
      controller.forward();
    }
  });
}
catch(e){}
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(10),
      child: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
          child: Container(
            decoration: BoxDecoration(
                // border: Border.all(color: Colors.black.withOpacity(0.2), width: 1),
                gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [
                    colorAnimation1.value,
                    colorAnimation2.value,
                  ],
                ),
              borderRadius: const BorderRadius.all(Radius.circular(15))
            ),
            child: Container(
              margin: EdgeInsets.all(5),
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(15)),
                color: Colors.white.withOpacity(0.4),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.shade400,
                    offset: Offset(2, 2),
                    blurRadius: 2,
                    spreadRadius: 2,
                  )
                ]
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    padding: const EdgeInsets.only(
                      top: 10,
                      left: 20,
                      bottom: 10,
                      right: 20,
                    ),
                    child: GestureDetector(
                      onTap: () async {
                        var ToSearches = await Navigator.push(context, PageRouteBuilder(
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
                              return SearchSheet();
                            }));
                        print("ToSearches: " + ToSearches.toString());
                        WriteALog.Write("Search Run", ToSearches.toString(), DateTime.now().toString());
                        CurrentJob.CurrentSearchData.add(ToSearches);
                      },
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            width: 30,
                            height: 30,
                            child: Icon(Icons.search, size: 25, color: ColorFromHexCode("#383C39"),),
                          ),
                          const SizedBox(width: 20,),
                          Text("Search your job", style: GoogleFonts.yantramanav(fontSize: 20, color: Colors.black, fontWeight: FontWeight.w400,),),
                        ],
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: (){
                      Navigator.push(context, PageRouteBuilder(
                          transitionDuration: const Duration(milliseconds: 300),
                          transitionsBuilder: (BuildContext context, Animation<double> animation, Animation<double> secAnimation, Widget child){
                            const begin = Offset(1, 0.0);
                            const end = Offset.zero;
                            const curve = Curves.ease;

                            var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

                            return SlideTransition(
                              position: animation.drive(tween),
                              child: child,
                            );
                          },
                          pageBuilder: (BuildContext context, Animation<double> animation, Animation<double> secAnimation){
                            return ChooseDepartment();
                          }));
                    },
                    child: Container(
                      width: 60,
                      height: 60,
                      padding: const EdgeInsets.all(10),
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                      child: Center(
                        child: Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                              color: Colors.grey.shade400.withOpacity(0.5),
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
                          child: Icon(Icons.work, size: 25, color: ColorFromHexCode("#383C39"),),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
