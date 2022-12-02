import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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

  String DeptName = "Department";

  int currentcolor = 0;

  List<Color> colors = <Color>[
    ColorFromHexCode("#FF5D5D"),
    ColorFromHexCode("#FFA85D"),
    ColorFromHexCode("#5DFF8E"),
    ColorFromHexCode("#5DA2FF"),
    ColorFromHexCode("#735DFF"),
  ColorFromHexCode("#FF5DA8"),
  ];
  
  void EditDepartment(){
    DeptName = widget.DepartmentName;
    int a  = DeptName.indexOf("(");
    int b = DeptName.indexOf(")");
    b = b == -1  ? DeptName.length - 1 : b;

    if(a != -1 && b != -1) {
      DeptName = "${DeptName.substring(0, a)} (${DeptName.substring(a + 1, b).toUpperCase()})";
    }
    setState(() {

    });
  }
  
  @override
  void initState() {
    Random random = Random();
    currentcolor = random.nextInt(colors.length);
    EditDepartment();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      alignment: Alignment.centerLeft,
      padding: EdgeInsets.only(
        top: 40,
      ),
      decoration: BoxDecoration(
         // color: colors[currentcolor].withOpacity(0.1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Container(
            alignment: Alignment.centerLeft,
            child: Container(

              height: 40,
              margin: EdgeInsets.only(
                left: 20, right: 20,
              ),
              padding: EdgeInsets.all(5),
              alignment: Alignment.centerLeft,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade500.withOpacity(0.1), width: 1),
                borderRadius: BorderRadius.all(Radius.circular(5)),
                color: colors[currentcolor].withOpacity(1),
                  boxShadow: [
                    BoxShadow(
                      offset: -Offset(3, 3),
                      blurRadius: 1,
                      spreadRadius: 1,
                      color: Colors.grey.shade200,
                    ),
                    BoxShadow(
                      offset: Offset(3, 3),
                      blurRadius: 1,
                      spreadRadius: 1,
                      color: Colors.grey.shade300,
                    ),
                  ]
              ),
              child: Text(
                  DeptName.length > 40 ? DeptName.substring(0, 40).replaceAll("\n", "") + "..." :
                DeptName.replaceAll("\n", ""),
                style: TextStyle(fontFamily: "uber",
                  fontWeight: FontWeight.w800,
                  fontSize: 15,
                  color: Colors.white,
                  shadows:<Shadow>[
                    Shadow(
                      color: Colors.grey.shade700,
                      offset: Offset(1,1),
                      blurRadius: 2,
                    ),
                    Shadow(
                      color: Colors.grey.shade700,
                      offset: Offset(1,1),
                      blurRadius: 2,
                    ),
                  ],
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
