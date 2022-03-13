import 'package:flutter/material.dart';
import 'package:governmentapp/JobData.dart';

class ShowJob extends StatefulWidget {

  JobData jobData = new JobData();
  ShowJob({required this.jobData});

  @override
  _ShowJobState createState() => _ShowJobState();
}

class _ShowJobState extends State<ShowJob> {

  Widget Load_ImportantDates(){

    var ImportantDates = <Widget>[];

    for(var key in widget.jobData.Important_Dates.keys)
      {
        ImportantDates.add(
          Container(

            child: Row(
              children: <Widget>[
                Container(
                  width: MediaQuery.of(context).size.width/1.8,
                  child: Text(key, style: TextStyle(
                      fontSize: 15, fontWeight: FontWeight.bold ),),
                ),
                Text(" - "),
                Container(
                  width: MediaQuery.of(context).size.width/3.5,
                  child: Text(widget.jobData.Important_Dates[key].toString(), style: TextStyle(
                    fontSize: 15, fontWeight: FontWeight.bold, color: Colors.grey[800]),),
                )
              ],
            ),
          )
        );
      }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text("Important Dates", style: TextStyle(
          fontSize: 15, ),),
        Container(
          child: Column(
            children: ImportantDates
        )),
      ],
    );
  }


  Widget Load_ApplicationFees(){

    var ApplicationFees = <Widget>[];

    for(var key in widget.jobData.ApplicationFees.keys)
    {
      ApplicationFees.add(
          Container(

            child: Row(
              children: <Widget>[
                Container(
                  width: MediaQuery.of(context).size.width/1.6,
                  child: Text(key, style: const TextStyle(
                      fontSize: 15, fontWeight: FontWeight.bold ),),
                ),
                const Text(" - "),
                Text(widget.jobData.ApplicationFees[key].toString(), style: TextStyle(
                    fontSize: 15, fontWeight: FontWeight.bold, color: Colors.grey[800]),)
              ],
            ),
          )
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const Text("Application Fees", style: TextStyle(
          fontSize: 15, ),),
        Column(
            children: ApplicationFees
        ),
      ],
    );
  }


  Widget Load_VDetails(){

    var VDetails = <Widget>[];

    for(int i=0; i<widget.jobData.VDetails.length; i++)
      {
        for(int j=0; j<widget.jobData.VDetails[i].datas.length; j++)
          {
            VDetails.add(Text(widget.jobData.VDetails[i].Title));
            var Datas = <Widget>[];

            for(int k=0; k<widget.jobData.VDetails[i].datas[j].data.length; k++)
              {
                Datas.add(
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                        k < widget.jobData.VDetails[i].headers.length ? Text(widget.jobData.VDetails[i].headers[k]) : Text(""),
                        Text(widget.jobData.VDetails[i].datas[j].data[k]
                        , style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                        )
                    ],
                  )
                );
              }

            VDetails.add(
              Container(
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.all(10),
                color: Colors.grey[200],
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: Datas,
                ),
              )
            );
          }
      }


    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const Text("Vacancy Details", style: TextStyle(
          fontSize: 15, ),),
        Column(
            children: VDetails
        ),
      ],
    );
  }


  Widget Load_HowToApply(){

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const Text("How to Apply", style: TextStyle(
          fontSize: 14, ),),
        Container(
            child: Text(
              widget.jobData.HowToApply,
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              textAlign: TextAlign.justify,
            )
        ),
      ],
    );
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Container(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.only(
                    top: 50,
                    bottom: 5,
                  ),
                  child: Text("TJ Job", style: TextStyle(fontSize: 55, fontWeight: FontWeight.w900),)
              ),
              Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.only(
                    top: 5,
                    bottom: 5,
                  ),
                  child: Text("www.trackjobs.in", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),)
              ),
              Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.only(
                    top: 5,
                    bottom: 40,
                  ),
                  child: Text("AAPKE SAPNE KA SATHI", style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),)
              ),
              Row(
                children: <Widget>[
                  FlatButton(onPressed: (){

                  }, child: Text("Apply"),
                    color: Colors.grey[300],),
                  FlatButton(onPressed: (){

                  }, child: Text("Notification"),
                    color: Colors.grey[300],),
                  FlatButton(onPressed: (){

                  }, child: Text("Website"),
                    color: Colors.grey[300],
                   ),
                ],
              ),
              const SizedBox(height: 10,),
              const Text("Department", style: TextStyle(
                fontSize: 14, ),),
              Text(widget.jobData.Department, style: const TextStyle(fontWeight: FontWeight.bold,
                fontSize: 15, ),),
              const SizedBox(height: 10,),
              const Text("Title", style: TextStyle(
                fontSize: 14, ),),
              Text(widget.jobData.Title, style: const TextStyle(fontWeight: FontWeight.bold,
                fontSize: 15, ),),
              const SizedBox(height: 10,),
              Load_ImportantDates(),
              const SizedBox(height: 10,),
              Load_ApplicationFees(),
              const SizedBox(height: 10,),
              const Text("Vacancies", style: TextStyle(
                fontSize: 14, ),),
              Text(widget.jobData.Total_Vacancies, style: const TextStyle(fontWeight: FontWeight.bold,
                fontSize: 15, ),),
              const SizedBox(height: 10,),
              Load_VDetails(),
              const SizedBox(height: 10,),
              const Text("Document Required", style: TextStyle(
                fontSize: 14, ),),
              Text(widget.jobData.DocumentRequired, style: const TextStyle(fontWeight: FontWeight.bold,
                fontSize: 15, ),),
              const SizedBox(height: 10,),
              Load_HowToApply(),
              const SizedBox(height: 10,),
              Row(
                children: <Widget>[
                  FlatButton(onPressed: (){

                  }, child: Text("Apply"),
                    color: Colors.grey[300],),
                  FlatButton(onPressed: (){

                  }, child: Text("Notification"),
                    color: Colors.grey[300],),
                  FlatButton(onPressed: (){

                  }, child: Text("Website"),
                    color: Colors.grey[300],),
                ],
              )
            ],
          ),
        ),
      ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.grey[900],
        onPressed: () {},
    child: const Icon(
    Icons.share,
    color: Colors.white,
    ),
    ),
    floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
