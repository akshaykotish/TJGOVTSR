import 'dart:ui';

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
          Container(
            width: widget.DepartmentName.toTitleCase().length * 10 <= MediaQuery.of(context).size.width - 20 ? widget.DepartmentName.toTitleCase().length * 10 : MediaQuery.of(context).size.width - 20,
            alignment: Alignment.centerLeft,
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  offset: Offset(1, 1),
                  blurRadius: 6,
                  spreadRadius: 5,
                  color: Colors.white.withOpacity(0.1),
                ),
                BoxShadow(
                  offset: Offset(1, 1),
                  blurRadius: 6,
                  spreadRadius: 5,
                  color: Colors.grey.shade100.withOpacity(0.1),
                ),
              ],
            ),
            child: Container(
              margin: const EdgeInsets.all(5),
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade500.withOpacity(0.1), width: 1),
                borderRadius: BorderRadius.all(Radius.circular(5)),
                color: Colors.amberAccent.withOpacity(0.4),
              ),
              child: Text(
                widget.DepartmentName.toTitleCase(),
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 12,
                  color: Colors.black.withOpacity(0.7),
                ),
              ),
            ),
          ),
          Column(
            children: widget.jobboxes,
          ),
          SizedBox(height: 10,),
        ],
      ),
    );
  }
}
