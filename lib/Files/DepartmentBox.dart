import 'package:flutter/material.dart';
import 'package:governmentapp/Files/JobBox.dart';
import 'package:governmentapp/HexColors.dart';
import 'package:governmentapp/JobData.dart';

class DepartmentBox extends StatefulWidget {



  String DepartmentName = "";
  List<JobBox> jobboxes = <JobBox>[];

  DepartmentBox({required this.DepartmentName, required this.jobboxes});

  @override
  State<DepartmentBox> createState() => _DepartmentBoxState();
}

class _DepartmentBoxState extends State<DepartmentBox> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          SizedBox(height: 50,),
          Container(
            padding: EdgeInsets.all(10),
            width: MediaQuery.of(context).size.width - 50,
            alignment: Alignment.centerLeft,
            decoration: BoxDecoration(
              color: ColorFromHexCode("#9E957C").withOpacity(0.6),
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(15),
                bottomRight: Radius.circular(15),
              ),
              boxShadow: [
                BoxShadow(
                  offset: Offset(1, 1),
                  spreadRadius: 1,
                  blurRadius: 1,
                  color: Colors.grey.shade300,
                )
              ]
            ),
            child: Text(
              widget.DepartmentName.toUpperCase(),
              style: TextStyle(
                fontWeight: FontWeight.w800,
                fontSize: 15,
                color: ColorFromHexCode("#FFFCF1"),
                shadows: [
                  Shadow(color: Colors.grey.shade900)
                ]
              ),
            ),
          ),
          Column(
            children: widget.jobboxes,
          ),
        ],
      ),
    );
  }
}
