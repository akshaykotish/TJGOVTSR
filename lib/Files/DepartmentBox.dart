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
          SizedBox(height: 50,),
          ClipRect(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
              child: Container(
                padding: EdgeInsets.all(10),
                width: widget.DepartmentName.toTitleCase().length * 10 <= MediaQuery.of(context).size.width - 20 ? widget.DepartmentName.toTitleCase().length * 10 : MediaQuery.of(context).size.width - 20,
                alignment: Alignment.centerLeft,
                decoration: BoxDecoration(
                  color: ColorFromHexCode("#E9DDA7").withOpacity(0.3),
                  borderRadius: const BorderRadius.only(
                    bottomRight: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                child: Text(
                  widget.DepartmentName.toTitleCase(),
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    color: Colors.grey[700],
                  ),
                ),
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
