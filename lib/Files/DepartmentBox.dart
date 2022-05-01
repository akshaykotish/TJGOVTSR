import 'package:flutter/material.dart';
import 'package:governmentapp/Files/JobBox.dart';
import 'package:governmentapp/HexColors.dart';
import 'package:governmentapp/JobData.dart';


class DepartmentBox extends StatefulWidget {



  String DepartmentName = "";
  var jobDatas;

  DepartmentBox({required this.DepartmentName, required this.jobDatas});

  @override
  State<DepartmentBox> createState() => _DepartmentBoxState();
}

class _DepartmentBoxState extends State<DepartmentBox> {

  var AllJobs = <JobBox>[];

  void LoadJobs(){
    var _AllJobs = <JobBox>[];

    print("Last: " + widget.jobDatas.length.toString());

    for(var i=0; i<widget.jobDatas.length; i++)
    {
      _AllJobs.add(
          JobBox(isClicked: false, jobData: widget.jobDatas[i],)
      );
    }

    setState(() {
      AllJobs = _AllJobs;
    });
  }

  @override
  void initState() {
    LoadJobs();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Container(
            padding: const EdgeInsets.only(
              left: 0,
              right: 10
            ),
            width: MediaQuery.of(context).size.width - 50,
            alignment: Alignment.centerLeft,
            child: Text(
              widget.DepartmentName.toTitleCase(),
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 14,
                color: Colors.grey.shade900,
              ),
            ),
          ),
          Column(
            children: AllJobs,
          ),
        ],
      ),
    );
  }
}
