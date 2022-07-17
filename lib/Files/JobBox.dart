import 'dart:async';

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


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        //CurrentJob.currrentjobData = widget.jobData;
        CurrentJob.CurrentJobStreamController.add(widget.jobData);

        if(CurrentJob.currentjobStreamToCall != null)
          {
            CurrentJob.currentjobStreamToCall(widget.jobData);
            CurrentJob.currentjobStreamForVacanciesToCall(widget.jobData);
            print("AOAKDOAODPKFOF");
          }
        print("AOAKDOAODPKFOF");
      },
      child: Container(
        margin: const EdgeInsets.only(
          left: 30,
          top: 20,
          bottom: 20,
        ),
        padding: const EdgeInsets.only(
          left: 10,
          top: 10,
          bottom: 10,
        ),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(20),
            topLeft: Radius.circular(20),
          ),
          color: widget.isClicked ? Colors.blue : Colors.grey[200],
        ),
        width: MediaQuery.of(context).size.width,
        child: Row(
          children: <Widget>[
            Container(
                width: 85,
                height: 85,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Center(child: Text(widget.jobData.Department.toShortForm().length > 4 ? widget.jobData.Department.toShortForm().substring(0, 4) : widget.jobData.Department.toShortForm(), style: TextStyle(fontSize: 25, color: ColorFromHexCode("#3498DB"), fontWeight: FontWeight.bold),))),
            const SizedBox(width: 20,),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  width: MediaQuery.of(context).size.width/2 + 20,
                  child: Text(widget.jobData.Title.length > 75 ? widget.jobData.Title.substring(0, 75) + "..." : widget.jobData.Title, style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: widget.isClicked ? Colors.white : Colors.grey[800],
                  ),),
                ),
                Text(widget.jobData.Short_Details.length > 30 ? widget.jobData.Short_Details.substring(0, 30) : widget.jobData.Short_Details, style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  color:  widget.isClicked ? Colors.white60 : Colors.grey[700],
                ),),
              ],
            )
          ],
        ),
      ),
    );
  }
}
