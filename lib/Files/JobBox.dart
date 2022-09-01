import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:governmentapp/Files/CurrentJob.dart';
import 'package:governmentapp/HexColors.dart';
import 'package:governmentapp/JobData.dart';


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

  JobData jobData;
  bool isClicked = false;
  JobBox({required this.isClicked, required this.jobData});



  @override
  State<JobBox> createState() => _JobBoxState();
}

class _JobBoxState extends State<JobBox> {

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
      widget.jobData.count >= 50 ? Container(
        width: 15,
          height: 15,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("./assets/icons/hot.png"),
            )
          ),)  : Icon(Icons.search, color: Colors.grey[400], size: 12,),
      Text(widget.jobData.count == 50 ? " Trending Job" : widget.jobData.count == 78 ? "Favourite" : widget.jobData.count >= 3 ? "Result" : "Suggestion", style: TextStyle(fontSize: 10, fontWeight: FontWeight.w400, color: Colors.grey[400]),),
    ],
    ));
  }

  bool opcity = false;
  @override
  void initState() {
    widget.jobData.Designation == "" ? widget.jobData.Designation = widget.jobData.Title : null;
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
        onTap: () {

          if(CurrentJob.currentjobStreamToCall != null)
            {
              widget.jobData.Designation == "" ? widget.jobData.Designation = widget.jobData.Title : null;
              CurrentJob.currentjobStreamToCall(widget.jobData);
               CurrentJob.currentjobStreamForVacanciesToCall(widget.jobData);
            }
        },
        child: Container(
          padding: EdgeInsets.all(10),
          margin: EdgeInsets.only(left: 10, top: 5, bottom: 5, right: 0),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [
                ColorFromHexCode("#8F00FF").withOpacity(0.1),
                ColorFromHexCode("#4B0082").withOpacity(0.1),
                ColorFromHexCode("#0000FF").withOpacity(0.1),
                ColorFromHexCode("#00FF00").withOpacity(0.1),
                ColorFromHexCode("#FFFF00").withOpacity(0.1),
                ColorFromHexCode("#FFA500").withOpacity(0.1),
                ColorFromHexCode("#FF0000").withOpacity(0.1),
              ],
            ),
            border: Border.all(color: Colors.grey.shade500.withOpacity(0.1), width: widget.jobData.count == 51 ? 2 : 1),
            boxShadow: [
              BoxShadow(
                offset: Offset(2, 2),
                blurRadius: 5,
                spreadRadius: 5,
                color: Colors.blue.shade200.withOpacity(0.1),

              ),

            ],
            color: Colors.white70.withOpacity(.1),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(10),
              bottomLeft: Radius.circular(10),
            ),
          ),
          alignment: Alignment.center,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                      alignment: Alignment.centerLeft,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: Center(child: Text(widget.jobData.Department.toShortForm().replaceAll("(", "").replaceAll(")", "").length > 4 ? widget.jobData.Department.toShortForm().replaceAll("(", "").replaceAll(")", "").substring(0, 4) : widget.jobData.Designation == "" ? widget.jobData.Designation = widget.jobData.Title : widget.jobData.Department.toShortForm().replaceAll("(", "").replaceAll(")", ""),
                        style: TextStyle(fontSize: 12, color: Colors.grey[700], fontWeight: FontWeight.w600),))),
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
                    child: Text(widget.jobData.Designation.length > 108 ? widget.jobData.Designation.substring(0, 108) + "..." : widget.jobData.Designation, style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: widget.isClicked ? Colors.white : ColorFromHexCode("#2A2500"),
                    ),),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
