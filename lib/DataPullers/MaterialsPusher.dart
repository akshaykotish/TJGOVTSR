import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:html/parser.dart';
import 'package:http/http.dart' as http;
import 'package:translator/translator.dart';


class MaterialPusher{
  static List<String> allbooks = <String>[];

  static Future<void> LoadALlBooks() async {
    var docs = await FirebaseFirestore.instance.collection("PDFs").get();
    docs.docs.forEach((element) {
      allbooks.add(element.id.toLowerCase());
    });
//    docs.docs[0].id
  }

  static Future<void> Execute()
  async {
    await LoadALlBooks();

    var LastSavedPDFsDateEF;
    try {
      LastSavedPDFsDateEF = await FirebaseFirestore.instance.collection(
          "Logs")
          .doc("LastSavedPDFsDate")
          .get();
    }
    catch(e)
    {
      print(e);
    }

    String EFDate = LastSavedPDFsDateEF.exists ? LastSavedPDFsDateEF
        .data()!["LastSavedPDFsDateEF"] : "";
    if (EFDate != "${DateTime
        .now()
        .year}-${DateTime
        .now()
        .month}-${DateTime
        .now()
        .day}") {
      ExamForo.LoadCategories();
    }

    var LastSavedPDFsDateNG;
    try {
      LastSavedPDFsDateNG = await FirebaseFirestore.instance.collection(
          "Logs")
          .doc("LastSavedPDFsDate")
          .get();
    }
    catch(e)
    {
      print(e);
    }

    String NGDate = LastSavedPDFsDateNG.exists ? LastSavedPDFsDateNG
        .data()!["LastSavedPDFsDateNG"] : "";

    if (NGDate != "${DateTime
        .now()
        .year}-${DateTime
        .now()
        .month}-${DateTime
        .now()
        .day}") {
      NitinGuptaScrapper.LoadCategories();
    }
  }
}
class NitinGuptaScrapper{
  final translator = GoogleTranslator();

  static Future<void> ClassifyLinksAndTitles(String PageData) async {
    var data = parse(PageData);
    var anchors = data.getElementsByTagName("a");

    for (int i = 49; i < anchors.length; i++) {
      if (anchors[i].text == "telegram") {
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
            FirebaseFirestore.instance.collection("Logs")
                .doc("LastSavedPDFs")
                .update({
              "NG": anchors[i].text,
            });
          }


          String Title = anchors[i].text;
          String URL = anchors[i].attributes["href"].toString();

          if (!MaterialPusher.allbooks.contains(
              anchors[i].text.toLowerCase())) {
            FirebaseFirestore.instance.collection("PDFs")
                .doc(anchors[i].text)
                .set({
              "Source": "https://nitin-gupta.com/",
              "Title": Title,
              "PDFLink": URL,
            });
          }
        }
      }
    }
  }


  static Future<void> LoadCategories() async {
  var pagedata = await http.read(Uri.parse("https://nitin-gupta.com/all-most-importance-pdf-collection-in-hindi-and-english-for-all-competitive-exams"));
    ClassifyLinksAndTitles(pagedata);
  }
}
class ExamForo{
  final translator = GoogleTranslator();


  static Future<void> ClassifyLinksAndTitles(String PageData) async {
    var data = parse(PageData);
    var anchors = data.getElementsByTagName("a");


    for (int i = 1; i < anchors.length; i++) {
      if (anchors[i].text == "UPSC Books Google Drive Link" || anchors[i].text.contains("Google Drive Link")) {
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
            FirebaseFirestore.instance.collection("Logs")
                .doc("LastSavedPDFs")
                .update({
              "EF": anchors[i].text,
            });
          }
          String Title = anchors[i].text;
          String URL = anchors[i].attributes["href"].toString();

          if (!MaterialPusher.allbooks.contains(
              anchors[i].text.toLowerCase())) {
            FirebaseFirestore.instance.collection("PDFs")
                .doc(anchors[i].text)
                .set({
              "Source": "examforo.com/",
              "Title": Title,
              "PDFLink": URL,
            });
          }
        }
      }
    }
  }


  static Future<void> LoadCategories() async {
    var pagedata = await http.read(Uri.parse("https://www.examforo.com/pdfdrive/google-drive-link-of-all-government-job-preparation-books-upsc-ssc-railway-banking-defence-and-state-government-job/#Important_Study_Materials_PDF_For_All_Competitive_Exams_in_Hindi_and_English"));
    ClassifyLinksAndTitles(pagedata);
  }
}