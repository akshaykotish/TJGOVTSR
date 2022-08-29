import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:governmentapp/DataLoadingSystem/JobDisplayManagement.dart';
import 'package:governmentapp/Files/CurrentJob.dart';
import 'package:governmentapp/Filtration/FilterPage.dart';
import 'package:governmentapp/Filtration/SearchSheet.dart';
import 'package:governmentapp/ForUsers/ChooseDepartment.dart';
import 'package:governmentapp/HexColors.dart';

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

    controller =  AnimationController(vsync: this, duration: Duration(seconds: 1));
    colorAnimation1 = ColorTween(begin: Colors.grey.withOpacity(0.7), end: Colors.white.withOpacity(0.5)).animate(controller);
    colorAnimation2 = ColorTween(begin:  Colors.white.withOpacity(0.5), end: Colors.grey.withOpacity(0.7)).animate(controller);
    controller.forward();
    controller.addListener(() {
      setState(() {

      });
    });

    controller.addStatusListener((status) {
      if(status == AnimationStatus.completed)
      {
        controller.reverse();
      }
      else if(status == AnimationStatus.dismissed){
        controller.forward();
      }
    });
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
                      JobDisplayManagement.isloadingjobs = true;
                      JobDisplayManagement.ismoreloadingjobs = true;
                      JobDisplayManagement.jobstoshow.clear();
                      var ToSearches = await Navigator.push(context, PageRouteBuilder(
                          transitionDuration: const Duration(seconds: 3),
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
                      CurrentJob.CurrentSearchData.add(ToSearches);
                    },
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          width: 30,
                          height: 30,
                          decoration: const BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage("./assets/icons/search.png"),
                            )
                          ),
                        ),
                        const SizedBox(width: 20,),
                        Text("Search your job", style: TextStyle(fontSize: 20, color: Colors.grey[600], fontWeight: FontWeight.w500, fontFamily: "EBGaramond"),),
                      ],
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: (){
                    Navigator.push(context, PageRouteBuilder(
                        transitionDuration: const Duration(seconds: 1),
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
                    padding: EdgeInsets.all(10),
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    child: Center(
                      child: Container(
                        width: 30,
                        height: 30,
                        decoration: const BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage("./assets/icons/filter-results-button.png"),
                            )
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
