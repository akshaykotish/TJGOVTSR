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
        width: 20,
          height: 20,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("./assets/icons/hot.png"),
            )
          ),)  : Icon(Icons.search, color: Colors.grey[400], size: 12,),
      Text(widget.jobData.count >= 50 ? " Trending Job" : widget.jobData.count >= 3 ? "Result" : "Suggestion", style: TextStyle(fontSize: 10, fontWeight: FontWeight.w400, color: Colors.grey[400]),),
    ],
    ));
  }

  @override
  void initState() {
    widget.jobData.Designation == "" ? widget.jobData.Designation = widget.jobData.Title : null;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {

        if(CurrentJob.currentjobStreamToCall != null)
          {
            widget.jobData.Designation == "" ? widget.jobData.Designation = widget.jobData.Title : null;
            CurrentJob.currentjobStreamToCall(widget.jobData);
             CurrentJob.currentjobStreamForVacanciesToCall(widget.jobData);
          }
      },
      child: Container(
        margin: const EdgeInsets.only(
          left: 20,
          top: 15,
          bottom:5,
        ),
        decoration: const BoxDecoration(
          borderRadius:  BorderRadius.only(
            bottomLeft: Radius.circular(20),
            topLeft: Radius.circular(20),
          ),
        ),
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: <Widget>[
            ClipRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.1),
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(20),
                      topLeft: Radius.circular(20),
                    ),
                  ),
                  padding: EdgeInsets.all(10),
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
                              child: Center(child: Text(widget.jobData.Department.toShortForm().replaceAll("(", "").replaceAll(")", "").length > 4 ? widget.jobData.Department.toShortForm().replaceAll("(", "").replaceAll(")", "").substring(0, 4) : widget.jobData.Designation == "" ? widget.jobData.Designation = widget.jobData.Title : widget.jobData.Department.toShortForm().replaceAll("(", "").replaceAll(")", ""), style: TextStyle(fontSize: 20, color: Colors.grey[700], fontWeight: FontWeight.w600),))),
                              const SizedBox(width: 10,),
                              GetJobType(),
                        ],
                      ),
                      const SizedBox(width: 20,),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            width: MediaQuery.of(context).size.width - 50,
                            child: Text(widget.jobData.Designation.length > 75 ? widget.jobData.Designation.substring(0, 75) + "..." : widget.jobData.Designation, style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w500,
                              color: widget.isClicked ? Colors.white : ColorFromHexCode("#2A2500"),
                            ),),
                          ),
                          Text(widget.jobData.Short_Details.length > 30 ? widget.jobData.Short_Details.substring(0, 30) : widget.jobData.Short_Details, style: TextStyle(
                              fontSize: 14,
                            color:  widget.isClicked ? Colors.white60 : Colors.grey[700],
                          ),),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
