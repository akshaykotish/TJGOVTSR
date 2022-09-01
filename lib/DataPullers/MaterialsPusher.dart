import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:html/parser.dart';
import 'package:http/http.dart' as http;

class MaterialPusher{
  static void Execute()
  {
    NitinGuptaScrapper.LoadCategories();
    ExamForo.LoadCategories();
  }
}


class NitinGuptaScrapper{

  static Future<void> ClassifyLinksAndTitles(String PageData) async {
    var data = parse(PageData);
    var anchors = data.getElementsByTagName("a");

    var lastsavedids, LastSavedPDFsDate;
    try {
       lastsavedids = await FirebaseFirestore.instance.collection("Logs")
          .doc("LastSavedPDFs")
          .get();

       LastSavedPDFsDate = await FirebaseFirestore.instance.collection(
          "Logs")
          .doc("LastSavedPDFsDate")
          .get();
    }
    catch(e)
    {
      print("Errroe ${e}");
    }

    String NG = lastsavedids.exists ? lastsavedids.data()!["NG"] : "";
    String NGDate = LastSavedPDFsDate.exists ? LastSavedPDFsDate
        .data()!["LastSavedPDFsDateNG"] : "";

    print("NG is ${NGDate}");
    if (NGDate != "${DateTime
        .now()
        .year}-${DateTime
        .now()
        .month}-${DateTime
        .now()
        .day}") {
      for (int i = 49; i < anchors.length; i++) {
        if (anchors[i].text == "telegram" || anchors[i].text == NG) {

          print("CCC");
          FirebaseFirestore.instance.collection("Logs").doc(
              "LastSavedPDFsDate").update({
            "LastSavedPDFsDateNG": "${DateTime
                .now()
                .year}-${DateTime
                .now()
                .month}-${DateTime
                .now()
                .day}",
          });

          break;
        }
        else {
          if (anchors[i].text.isNotEmpty) {
            if (i == 49) {
              print("AAA");
              FirebaseFirestore.instance.collection("Logs")
                  .doc("LastSavedPDFs")
                  .update({
                "NG": anchors[i].text,
              });
              NG = anchors[i].text;
            }
            print("BBB");
            FirebaseFirestore.instance.collection("PDFs")
                .doc(anchors[i].text)
                .set({
              "Source": "Nipun-Gupta.com",
              "Title": anchors[i].text,
              "PDFLink": anchors[i].attributes["href"].toString(),
            });
          }
        }
      }
    }
  }


  static Future<void> LoadCategories() async {
    Uri uri = Uri.parse("https://nitin-gupta.com/all-most-importance-pdf-collection-in-hindi-and-english-for-all-competitive-exams/");
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

    ClassifyLinksAndTitles(pagedata);
  }
}

class ExamForo{

  static Future<void> ClassifyLinksAndTitles(String PageData) async {
    var data = parse(PageData);
    var anchors = data.getElementsByTagName("a");

    var lastsavedids, LastSavedPDFsDate;
    try {
      lastsavedids = await FirebaseFirestore.instance.collection("Logs")
          .doc("LastSavedPDFs")
          .get();

      LastSavedPDFsDate = await FirebaseFirestore.instance.collection(
          "Logs")
          .doc("LastSavedPDFsDate")
          .get();
    }
    catch(e)
    {
      print("Errroe ${e}");
    }

    String EF = lastsavedids.exists ? lastsavedids.data()!["EF"] : "";
    String EFDate = LastSavedPDFsDate.exists ? LastSavedPDFsDate
        .data()!["LastSavedPDFsDateEF"] : "";

    print("EF is ${EFDate}");
    if (EFDate != "${DateTime
        .now()
        .year}-${DateTime
        .now()
        .month}-${DateTime
        .now()
        .day}") {
      for (int i = 1; i < anchors.length; i++) {
        if (anchors[i].text == " UPSC Books Google Drive Link" || anchors[i].text == EF) {

          print("CCC");
          FirebaseFirestore.instance.collection("Logs").doc(
              "LastSavedPDFsDate").update({
            "LastSavedPDFsDateEF": "${DateTime
                .now()
                .year}-${DateTime
                .now()
                .month}-${DateTime
                .now()
                .day}",
          });

          break;
        }
        else {
          if (anchors[i].text.isNotEmpty) {
            if (i == 1) {
              print("AAA");
              FirebaseFirestore.instance.collection("Logs")
                  .doc("LastSavedPDFs")
                  .update({
                "EF": anchors[i].text,
              });
              EF = anchors[i].text;
            }
            print("BBB");
            FirebaseFirestore.instance.collection("PDFs")
                .doc(anchors[i].text)
                .set({
              "Source": "examforo.com/",
              "Title": anchors[i].text,
              "PDFLink": anchors[i].attributes["href"].toString(),
            });
          }
        }
      }
    }
  }


  static Future<void> LoadCategories() async {
    Uri uri = Uri.parse("https://www.examforo.com/pdfdrive/google-drive-link-of-all-government-job-preparation-books-upsc-ssc-railway-banking-defence-and-state-government-job/#Important_Study_Materials_PDF_For_All_Competitive_Exams_in_Hindi_and_English");
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

    ClassifyLinksAndTitles(pagedata);
  }
}