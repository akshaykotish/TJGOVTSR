import 'package:flutter/material.dart';
import 'package:governmentapp/Files/JobBox.dart';

class JobBoxs extends StatefulWidget {
  const JobBoxs({Key? key}) : super(key: key);

  @override
  State<JobBoxs> createState() => _JobBoxsState();
}

class _JobBoxsState extends State<JobBoxs> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            JobBox(isClicked: false,),
            JobBox(isClicked: false,),
            JobBox(isClicked: false,),
            JobBox(isClicked: false,),
            JobBox(isClicked: false,),
            JobBox(isClicked: false,),
            JobBox(isClicked: true,),
            JobBox(isClicked: false,),
            JobBox(isClicked: false,),
          ],
        ),
      ),
    );
  }
}
