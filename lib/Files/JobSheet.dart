import 'package:flutter/material.dart';
import 'package:governmentapp/Files/CurrentJob.dart';
import 'package:governmentapp/JobData.dart';

class JobSheet extends StatefulWidget {
  JobData jobData;
  JobSheet({required this.jobData});

  @override
  State<JobSheet> createState() => _JobSheetState();
}

class _JobSheetState extends State<JobSheet> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child:  Column(
        children: <Widget>[
          Container(

          ),
          Text(widget.jobData.Title.toString()),
        ],
      ),
    );
  }
}
