import 'package:flutter/material.dart';
import 'package:governmentapp/JobData.dart';

class ShowJob extends StatefulWidget {

  JobData jobData = new JobData();
  ShowJob({required this.jobData});

  @override
  _ShowJobState createState() => _ShowJobState();
}

class _ShowJobState extends State<ShowJob> {

  void Load_ImportantDates(){

    Container();
    Text("Department", style: TextStyle(
      fontSize: 15, ),),
    Text(widget.jobData.Department, style: TextStyle(fontWeight: FontWeight.bold,
    fontSize: 18, ),),
    SizedBox(height: 5,)
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text("Department", style: TextStyle(
              fontSize: 15, ),),
            Text(widget.jobData.Department, style: TextStyle(fontWeight: FontWeight.bold,
              fontSize: 18, ),),
            SizedBox(height: 5,),
            Text("Title", style: TextStyle(
              fontSize: 15, ),),
            Text(widget.jobData.Title, style: TextStyle(fontWeight: FontWeight.bold,
              fontSize: 18, ),),
            SizedBox(height: 5,),

            Text("Important Dates", style: TextStyle(
              fontSize: 15, ),),
            Text(widget.jobData.Department, style: TextStyle(fontWeight: FontWeight.bold,
              fontSize: 18, ),),
            ListView.builder(itemBuilder: ),
            SizedBox(height: 5,),
          ],
        ),
      ),
    );
  }
}
