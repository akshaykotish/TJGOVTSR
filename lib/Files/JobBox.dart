import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:governmentapp/DataLoadingSystem/RequiredDataLoading.dart';
import 'package:governmentapp/Files/CurrentJob.dart';
import 'package:governmentapp/HexColors.dart';
import 'package:governmentapp/JobData.dart';
import 'package:governmentapp/JobDisplayData.dart';
import '../JobDisplayData.dart';

extension StringCasingExtension on String {
  String toCapitalized() => length > 0 ?'${this[0].toUpperCase()}${substring(1).toLowerCase()}':'';
  String toTitleCase() => replaceAll(RegExp(' +'), ' ').split(' ').map((str) => str.toCapitalized()).join(' ');

  String toShortForm()
  {
    String output = "";
    for(int i=0; i<this.length; i++)
    {
      if(i == 0)
      {
        output += this[i];
      }
      else if(this[i-1] == ' ' && this[i].toUpperCase() == this[i])
      {
        output += this[i];
      }
      else if(this[i] == ',' || this[i] == '(' || this[i] == ')')
      {
        break;
      }
    }
    return output;
  }
}


class JobBox extends StatefulWidget {

  JobDisplayData jobDisplayData;
  bool isClicked = false;
  JobBox({required this.isClicked, required this.jobDisplayData});



  @override
  State<JobBox> createState() => _JobBoxState();
}

class _JobBoxState extends State<JobBox> with TickerProviderStateMixin {

  late AnimationController animationController;
  late Animation animation;

  String GetShortForm(String text){
    var output = "";

    for(int i=0; i<text.length; i++)
    {
      if(i == 0)
      {
        output += text[i];
      }
      else if(text[i-1] == ' ')
      {
        output += text[i];
      }
      else if(text[i] == ',' || text[i] == '(' || text[i] == ')')
      {
        break;
      }
    }

    return output;
  }

  Widget GetJobType(){
    return Container(child: Row(
      children: <Widget>[
      widget.jobDisplayData.Count >= 50 ? Container(
        width: 15,
          height: 15,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("./assets/icons/hot.png"),
            )
          ),)  : Icon(Icons.search, color: Colors.grey[400], size: 15,),
      Text(widget.jobDisplayData.Count == 50 ? " Trending Job" : widget.jobDisplayData.Count == 78 ? "Favourite" : widget.jobDisplayData.Count >= 3 ? "Result" : "Suggestion",
        style: TextStyle(fontFamily: "uber",
            fontSize: 10,
            color: Colors.grey[400],
            letterSpacing: 3,
            fontWeight: FontWeight.w500),),
    ],
    ));
  }

  bool opcity = false;
  @override
  void initState() {
    animationController = AnimationController(vsync: this, duration: Duration(seconds: 3));
    animation = Tween<double>(begin: 0, end: 200).animate(animationController);

    animationController.addListener(() {
      setState(() {

      });
    });

    super.initState();

    Future.delayed((Duration(seconds: 1)), (){
      setState(() {
        opcity = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: opcity == true ? 1 : 0.1,
      duration: Duration(microseconds: 1500),
      child: GestureDetector(
        onTap: () async {
          animationController.forward();
          JobData jobData = JobData();
          jobData.path = widget.jobDisplayData.Path;
          await RequiredDataLoading.LoadJobFromPath(widget.jobDisplayData.Path, jobData).asStream().listen((event) {
            CurrentJob.currentjobStreamToCall(jobData);
            CurrentJob.currentjobStreamForVacanciesToCall(jobData);
            animationController.reverse();
          });
        },
        child: Container(
          height: 180,
          margin: EdgeInsets.all(20),
          decoration: BoxDecoration(
              color: ColorFromHexCode("#FFFFFF"),
              borderRadius: BorderRadius.all(Radius.circular(10)),
//            border: Border.all(color: ColorFromHexCode("#FFBB00"), width: 1)
          boxShadow: [
            BoxShadow(
              offset: -Offset(3, 3),
              blurRadius: 5,
              spreadRadius: 1,
              color: Colors.grey.shade400,
            ),
            BoxShadow(
              offset: Offset(3, 3),
              blurRadius: 5,
              spreadRadius: 1,
              color: Colors.grey.shade400,
            ),
          ]
          ),
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                height: 60,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(topLeft:  Radius.circular(10), topRight:  Radius.circular(10)),
                  image: DecorationImage(
                    image: NetworkImage("https://firebasestorage.googleapis.com/v0/b/trackjobs-27c7b.appspot.com/o/Departments%2FWestern%20Coalfields%2Fcoald.jpg?alt=media&token=3d340dba-64ae-480a-9a32-2002086b3809"),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Container(
                height: 25,
                decoration: BoxDecoration(
                  color: Colors.grey.shade900,
                ),
                padding: const EdgeInsets.only(left: 10, right: 10, top: 3, bottom:3),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                        alignment: Alignment.centerLeft,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: Center(
                            child: Text(
                              widget.jobDisplayData.Department.toShortForm().replaceAll("(", "").replaceAll(")", "").length > 4 ? widget.jobDisplayData.Department.toShortForm().replaceAll("(", "").replaceAll(")", "").substring(0, 4) : widget.jobDisplayData.Department.toShortForm().replaceAll("(", "").replaceAll(")", ""),
                          style:
                          TextStyle(fontFamily: "uber",
                              fontSize: 13,
                              letterSpacing: 3,
                              color: Colors.grey[400],
                              fontWeight: FontWeight.w500,
                          ),))),
                    const SizedBox(width: 10,),
                    GetJobType(),
                  ],
                ),
              ),
              const SizedBox(width: 20, height: 5,),
              Container(
                height: 70,
                alignment: Alignment.center,
                padding: const EdgeInsets.only(left: 10, right: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      width: MediaQuery.of(context).size.width - 50,
                      child: Text(widget.jobDisplayData.Designation.length > 100 ? widget.jobDisplayData.Designation.substring(0, 100).replaceAll("Online", "").replaceAll("Form", "") + "..." : widget.jobDisplayData.Designation.replaceAll("Online", "").replaceAll("Form", ""),
                        style: TextStyle(
                          fontFamily: "uber",
                        fontSize: 18,
                        fontWeight: FontWeight.w300,
                          color: ColorFromHexCode("#202B22"),
                          shadows:<Shadow>[
                            Shadow(
                              color: Colors.grey.shade100,
                              offset: Offset(2,2),
                              blurRadius: 4,
                            ),
                            Shadow(
                              color: Colors.grey.shade100,
                              offset: Offset(2,2),
                              blurRadius: 3,
                            ),
                          ],
                      ),),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 3,),
              Container(
                margin: EdgeInsets.only(bottom: 5),
                width: animation.value,
                height: 2,
                decoration: const BoxDecoration(
                  color: Colors.deepOrangeAccent,
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
