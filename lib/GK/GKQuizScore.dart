import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class GKQuizScore extends StatefulWidget {

  List<String> Questions = <String>[];
  List<String> UserAnswers = <String>[];
  List<String> Answers = <String>[];
  List<String> Hints = <String>[];
  GKQuizScore({required this.Hints, required this.Questions, required this.UserAnswers, required this.Answers});

  @override
  State<GKQuizScore> createState() => _GKQuizScoreState();
}

class _GKQuizScoreState extends State<GKQuizScore> {

  var Results = <Widget>[];

  int correct = 0;
  int total = 0;

  void CheckSheet(){
    var _Results = <Widget>[];

    total = widget.Questions.length;
  for(int i=0; i<widget.Questions.length; i++)
      {
        String q = widget.Questions[i];
        String ua = widget.UserAnswers[i];
        String a = widget.Answers[i];
        String h = widget.Hints[i];

        print("Reacehed Here $q $ua $a $h");

        if(ua == a)
          {
            correct++;
          }

        _Results.add(
          Container(
            margin: EdgeInsets.all(10),
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              border: Border.all(color: Colors.grey.shade400, width: 1),
            ),
            child: Column(
              children: <Widget>[
                Text(q,
                  style: GoogleFonts.quicksand(fontWeight: FontWeight.w700, fontSize: 20,),
                ),
                Text("Your answer: ", style: GoogleFonts.quicksand(fontSize: 12),),
                Container(
                  decoration: BoxDecoration(
                    color: ua == a ? Colors.green.withOpacity(0.5) : Colors.red.withOpacity(0.5),
                    border: Border.all(color: Colors.grey.shade100, width: 1),
                    borderRadius: BorderRadius.all(Radius.circular(10)),

                  ),
                  padding: EdgeInsets.all(10),
                  margin: EdgeInsets.all(5),
                  child: Text(ua, style: GoogleFonts.quicksand(fontSize: 15, fontWeight: FontWeight.w500),),
                ),
                SizedBox(height: 10,),
                Text("Correct answer: ", style: GoogleFonts.quicksand(fontSize: 12),),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.5),
                    border: Border.all(color: Colors.grey.shade100, width: 1),
                    borderRadius: BorderRadius.all(Radius.circular(10)),

                  ),
                  padding: EdgeInsets.all(10),
                  margin: EdgeInsets.all(5),
                  child: Text(a, style: GoogleFonts.quicksand(fontSize: 15, fontWeight: FontWeight.w500),),
                ),
                Text("Explanation: ", style: GoogleFonts.quicksand(fontSize: 12),),
                Text(h, style: GoogleFonts.quicksand(fontSize: 13, fontWeight: FontWeight.w500,),)
              ],
            ),
          )
        );

      }

    setState(() {
      Results = _Results;
    });
  }

  @override
  void initState() {
    CheckSheet();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.only(left: 10, right: 10, bottom: 20, top: 70),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text("Result", style: GoogleFonts.quicksand(fontSize: 25, fontWeight: FontWeight.bold),),
              SizedBox(height: 40,),
              Text("Your Score is ${correct}/${total}", style: GoogleFonts.quicksand(fontSize: 20, fontWeight: FontWeight.w700,),),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: Results,
              )
            ],
          ),
        ),
      ),
    );
  }
}
