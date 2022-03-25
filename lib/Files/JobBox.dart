import 'package:flutter/material.dart';

class JobBox extends StatefulWidget {
  const JobBox({Key? key}) : super(key: key);

  @override
  State<JobBox> createState() => _JobBoxState();
}

class _JobBoxState extends State<JobBox> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(
        left: 30,
        top: 20,
        bottom: 20,
      ),
      padding: const EdgeInsets.only(
        left: 30,
        top: 10,
        bottom: 10,
      ),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(20),
          topLeft: Radius.circular(20),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.1),
            offset: const Offset(1, 1),
            blurRadius: 1,
            spreadRadius: 1,
          ),
          BoxShadow(
            color: Colors.black.withOpacity(.1),
            offset: -const Offset(1, 1),
            blurRadius: 1,
            spreadRadius: 1,
          ),
        ],
        color: Colors.white,
      ),
      width: MediaQuery.of(context).size.width,
      child: Row(
        children: <Widget>[
          Container(
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(25),
              ),
              child: const Center(child: Text("SBI", style: TextStyle(fontSize: 20,),))),
          ClipOval(
            child: Container(
              margin: const EdgeInsets.only(
                left: 15,
                bottom: 15,
                top: 15,
                right: 20,
              ),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.shade300,
                    spreadRadius: 1,
                    blurRadius: 1,
                    offset: Offset(1, 1),
                  ),
                ]
              ),
              width: 3,
              height: 50,
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width/2 + 20,
                child: Text("Senior branch manager", style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[800],
                ),),
              ),
              Text("Kaithal", style: TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.w600,
                color: Colors.grey[700]
              ),),
            ],
          )
        ],
      ),
    );
  }
}
