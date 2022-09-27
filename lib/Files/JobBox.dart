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
          ),)  : Icon(Icons.search, color: Colors.grey[400], size: 5,),
      Text(widget.jobDisplayData.Count == 50 ? " Trending Job" : widget.jobDisplayData.Count == 78 ? "Favourite" : widget.jobDisplayData.Count >= 3 ? "Result" : "Suggestion",
        style: GoogleFonts.quicksand(fontSize: 10, fontWeight: FontWeight.w500, color: Colors.grey[600]),),
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
          padding: EdgeInsets.all(10),
          height: 70,
          margin: EdgeInsets.only(left: 20, top: 5, bottom: 5, right: 0),
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(15),
              bottomLeft: Radius.circular(15),
            ),
            color: ColorFromHexCode("#FFFCF5"),
//            border: Border.all(color: ColorFromHexCode("#FFBB00"), width: 1)
          boxShadow: [
            BoxShadow(
              offset: -Offset(3, 3),
              blurRadius: 5,
              spreadRadius: 1,
              color: Colors.grey.shade200,
            ),
            BoxShadow(
              offset: Offset(3, 3),
              blurRadius: 5,
              spreadRadius: 1,
              color: Colors.grey.shade200,
            ),
          ]
          ),
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Container(
                      alignment: Alignment.centerLeft,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: Center(child: Text(widget.jobDisplayData.Department.toShortForm().replaceAll("(", "").replaceAll(")", "").length > 4 ? widget.jobDisplayData.Department.toShortForm().replaceAll("(", "").replaceAll(")", "").substring(0, 4) : widget.jobDisplayData.Department.toShortForm().replaceAll("(", "").replaceAll(")", ""),
                        style: GoogleFonts.quicksand(fontSize: 12, color: Colors.grey[700], fontWeight: FontWeight.w700),))),
                  const SizedBox(width: 10,),
                  GetJobType(),
                ],
              ),
              const SizedBox(width: 20, height: 5,),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    width: MediaQuery.of(context).size.width - 50,
                    child: Text(widget.jobDisplayData.Designation.length > 40 ? widget.jobDisplayData.Designation.substring(0, 40).replaceAll("Online", "").replaceAll("Form", "") + "..." : widget.jobDisplayData.Designation.replaceAll("Online", "").replaceAll("Form", ""),
                      style: GoogleFonts.quicksand(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                        color: ColorFromHexCode("#202B22"),
                        shadows:<Shadow>[
                          Shadow(
                            color: Colors.grey.shade200,
                            offset: Offset(4,4),
                            blurRadius: 4,
                          ),
                          Shadow(
                            color: Colors.grey.shade200,
                            offset: Offset(2,2),
                            blurRadius: 3,
                          ),
                        ],
                    ),),
                  ),
                ],
              ),
              const SizedBox(height: 3,),
              Container(
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
