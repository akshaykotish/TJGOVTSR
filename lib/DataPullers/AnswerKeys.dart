

import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:governmentapp/DataPullers/AllPullers.dart';
import 'package:governmentapp/DataPullers/Scrapper.dart';
import 'package:governmentapp/DataPullers/WriteToFirebase.dart';
import 'package:governmentapp/JobData.dart';
import 'package:html/parser.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class AnswerKeys{

  String AnswerKeysLastLink = "";
  String NewAnswerKeysLastLink = "";
  int LastSavedSizes = 0;
  int NewLastSavedSizes = 0;


  WriteToFirebase writeToFirebase = WriteToFirebase();


  Future<void> SaveAnswerKeysLastJobIDCache()
  async {
    (await SharedPreferences.getInstance()).setString("AnswerKeysLastLink", NewAnswerKeysLastLink);
  }

  Future<String?> ReadAnswerKeysLastJobIDCache()
  async {
    return (await SharedPreferences.getInstance()).getString("AnswerKeysLastLink");
  }

  Future<String> GetAnswerKeysLastJobLink() async {
    String value = "";
    try {
      value = (await FirebaseFirestore.instance.collection("Logs").doc(
          "LastSavedID").get()).data()!["AnswerKeysLastLink"];
    }
    catch(e){
      value = "";
    }
    return value;
  }

  Future<void> UpdateAnswerKeysLastJobLink() async {
    (await FirebaseFirestore.instance.collection("Logs").doc("LastSavedID").set({"AnswerKeysLastLink" : NewAnswerKeysLastLink}));
  }


  Future<int> GetAnswerKeysLastJobsSize() async {
    String value = "0";
    try {
      value = (await FirebaseFirestore.instance.collection("Logs").doc(
          "LastSavedSizes").get()).data()!["AnswerKeysLastSize"].toString();
    }
    catch(E){value = "0";}

    if(value != "null" && value != "")
    {
      return int.parse(value);
    }
    return 0;
  }


  Future<void> UpdateAnswerKeysLastJobsSize() async {
    FirebaseFirestore.instance.collection("Logs").doc("LastSavedSizes").update({"AnswerKeysLastSize" : NewLastSavedSizes});
  }



  Future<void> ReadAnswerKeysURLs(String pagedata) async {
    var Table = parse(pagedata).getElementsByTagName("table");
    var Links = Table[0].getElementsByTagName("a");

    int NetDataSize = Links.length;
    NewLastSavedSizes = LastSavedSizes;


    if(NetDataSize == LastSavedSizes){
      return;
    }

    int l = 0;
    for(int i=(NetDataSize - LastSavedSizes) - 1; i>=0 /*&& l < 10*/; i--)
    {
      String link = Links[i].attributes["href"].toString();

      Scrapper scrapper = Scrapper();
      await scrapper.Start(link).then((JobData jobData) async {
        await WriteToFirebase.WriteToJob(jobData);
        await WriteToFirebase.WriteIndexToFirebase(jobData);
        NewLastSavedSizes++;
        await UpdateAnswerKeysLastJobsSize();
        print("NewLastSavedSizes ${NewLastSavedSizes}");
      });
      l++;
    }

  }

  Future<void> Execute() async {
    LastSavedSizes = await GetAnswerKeysLastJobsSize();
    AnswerKeysLastLink = await GetAnswerKeysLastJobLink();
//    String pagedata = await http.read(Uri.parse("https://www.sarkariresult.com/answerkey/"));

    Uri uri = Uri.parse("https://www.sarkariresult.com/answerkey/");
    var res = await http.get(uri);

    int lastbyte = 0;
    try{
      lastbyte = res.bodyBytes.length;
    }
    catch(e)
    {
      int lastindex = e.toString().lastIndexOf("Unexpected extension byte (at offset ") + "Unexpected extension byte (at offset ".length;
      String str = e.toString().substring(lastindex, e.toString().length-1);

      lastbyte = int.parse(str);
    }

    String pagedata = "";
    try {
      var data = res.bodyBytes.sublist(0, lastbyte-1);
      pagedata = String.fromCharCodes(data);

    }
    catch(e){
      print(e);
    }

    //print(pagedata);
    await ReadAnswerKeysURLs(pagedata).then((value){
      print("After");
    });
  }
}