import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:governmentapp/DataLoadingSystem/Locations.dart';
import 'package:governmentapp/DataPullers/WriteToFirebase.dart';
import 'package:governmentapp/JobData.dart';
import 'package:governmentapp/VacancyDetails.dart';
import 'package:html/parser.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' show parse;

class Scrapper{


  JobData jobData = JobData();
  String link = "";

  bool importantdatessts = false, feessts = false, examcenterssts = false, correctioneditssts = false, agests = false, howtosts = false, vdetailssts = false;

  String VDetailsHeader = "";
  VacancyDetails vacancyDetails = VacancyDetails();
  VacancyDetailsData vacancyDetailsData = VacancyDetailsData();
  bool isReadingVdetailsData = false;
  int index_to_note = 0;

  bool isImportantLinks = false;

  Future<String> GetWebHTML() async {
    Uri url = Uri.parse(link);
    String page = await http.read(url);
    return page;
  }

  Future<void> ScrapTable1(String Table1) async {
    var table1 = await parse(Table1);
    if(table1.getElementsByTagName("td").length == 4)
      {
        jobData.Designation = table1.getElementsByTagName("td")[1].text;
        jobData.LastUpdate = table1.getElementsByTagName("td")[5].text;
        jobData.Short_Details = table1.getElementsByTagName("td")[7].text;
      }
    else {
      jobData.Designation = table1.getElementsByTagName("td")[1].text;
      jobData.LastUpdate = table1.getElementsByTagName("td")[3].text;
      jobData.Short_Details = table1.getElementsByTagName("td")[5].text;
    }
  }

  Future<void> ScrapTable2(String Table2)
  async {
    try {
      var table2 = await parse(Table2);

      String T2HP = table2.getElementsByTagName("tr")[0].innerHtml;
      await Table2HeaderPart(T2HP);
    }catch(e){
      print(e);
    }
  }

  Future<void> Table2HeaderPart(String T2HP) async
  {
    //print(T2HP);
    var t2hp = await parse(T2HP);

    var h2s = t2hp.getElementsByTagName("span");

    for(int i=0; i<h2s.length; i++)
      {
        if(i == 0)
          {
            jobData.Department = h2s[i].text;
          }
        else if(i == 1)
        {
          jobData.Title = h2s[i].text;
        }
        else if(i == 2)
        {
          jobData.AdvertisementNumber = h2s[i].text;
        }
      }
  }

  Future<void> T2TRManager(String TRs) async {
    var trs = await parse(TRs).getElementsByTagName("tr");

    int i = 0;
    await Future.forEach(trs, (e) async {
      if(i < trs.length) {
        if (trs[i].text.toLowerCase().contains("dates") && !importantdatessts) {
          await ImportantDates(trs[i].getElementsByTagName("td")[0].innerHtml);

          if (trs[i].text.toLowerCase().contains("fee") && !feessts) {
            await Fees(trs[i].getElementsByTagName("td")[1].innerHtml);
          }
        }
        else if (trs[i].text.toLowerCase().contains("vacancy") == false && trs[i].text.toLowerCase().contains("age") && !agests) {
          await AgeLimit(trs[i].getElementsByTagName("td")[0].innerHtml);
        }
        else if (trs[i].text.toLowerCase().contains("exam district") ||
            trs[i].text.toLowerCase().contains("center") && !examcenterssts) {
          await ExamCenters(trs[i].getElementsByTagName("td")[0].innerHtml);
        }
        else if (trs[i].text.toLowerCase().contains("correction") ||
            trs[i].text.toLowerCase().contains("edit") && !correctioneditssts) {
          await CorrectionEdits(trs[i].getElementsByTagName("td")[0].innerHtml);
        }
        else if (trs[i].text.toLowerCase().contains("how to") && !howtosts) {
          await HowTo(trs[i].getElementsByTagName("td")[0].innerHtml);
          await SaveVDetails();
          vdetailssts = true;
        }
        else if (trs[i].text.toLowerCase().contains(
            "download mobile apps for latest updates") ||
            trs[i].text.toLowerCase().contains("android apps") ||
            trs[i].text.toLowerCase().contains("apple ios apps") ||
            trs[i].text.toLowerCase().contains("interested candidates can read the full notification") ||
            trs[i].text.toLowerCase().contains("download sarkariresult.com")) {
          await SaveVDetails();
          vdetailssts = true;
        }
        else if (trs[i].text.toLowerCase().contains("important links") ||
            trs[i].text.toLowerCase().contains("useful important") ||
            trs[i].text.toLowerCase().contains("some useful important links")) {
          isImportantLinks = true;
          i++;
        }
        else if (importantdatessts && feessts && !vdetailssts) {
          await VDetails(TRs, i);
          jobData.Location = await FindLocation();
        }

        if (isImportantLinks) {
          await ImportantLinks(trs[i].innerHtml);
        }
        i++;
      }
    });
  }

  Future<void> ImportantDates(String ImportantDates) async {
    importantdatessts = true;
    var importantdates = parse(ImportantDates).getElementsByTagName("li");

    int i = 0;
    await Future.forEach(importantdates, (importantdate){
      var parts = importantdates[i].text.split(":");
      jobData.Important_Dates[parts[0]] = parts[1];
      i++;
    });
  }

  Future<void> Fees(String Fees) async
  {
    feessts = true;
    var fees = parse(Fees).getElementsByTagName("li");

    int i = 0;
    await Future.forEach(fees, (element)
    {
      var parts = fees[i].text.split(":");
      if(parts.length == 2)
        {
          jobData.ApplicationFees[parts[0]] = parts[1];
        }
      else{
        jobData.ApplicationFees["Other"] = fees[i].text;
      }
      i++;
    });
  }

  Future<void> AgeLimit(String AgeLimits) async
  {
    agests = true;
    var agelimits = parse(AgeLimits).getElementsByTagName("li");


    int i=0;
    await Future.forEach(agelimits, (element){
    {
      var parts = agelimits[i].text.split(":");
      if(parts.length != 2){
        jobData.AgeLimits["Other"] = agelimits[i].text;
      }
      else{
        jobData.AgeLimits[parts[0]] = parts[1];
      }
      i++;
    }
    });
  }

  Future<void> ExamCenters(String ExamCenter) async
  {
    examcenterssts = true;
    var examcenter = parse(ExamCenter).getElementsByTagName("li");

    int i = 0;
    await Future.forEach(examcenter, (element) {
      var parts = examcenter[i].text.split(":");
      if(parts.length == 2)
        {
          jobData.ExamCenters[parts[0]] = parts[1];
        }
      else{
        jobData.ExamCenters["Other"] = examcenter[i].text;
      }
      i++;
    });
  }

  Future<void> CorrectionEdits(String CorrectionEdits) async
  {
    correctioneditssts = true;
    var correctionedits = parse(CorrectionEdits).getElementsByTagName("li");

    int i =0;
    await Future.forEach(correctionedits, (element)
      {
        jobData.Corrections.add(correctionedits[i].text);
        i++;
      });
  }

  Future<void> HowTo(String HowTo) async
  {
    howtosts = true;
    var howto = parse(HowTo).getElementsByTagName("li");

    int i = 0;
    await Future.forEach(howto, (element)
    {
      jobData.HowTo.add(howto[i].text);
      i++;
    });
  }

  Future<void> SaveVDetails() async {
    if(vacancyDetails.headers.length != 0 && vacancyDetails.datas.length != 0)
    {
      jobData.VDetails.add(vacancyDetails);

      jobData.VDetails.forEach((VDetails) {
        //print(VDetails.headers.toString());
        VDetails.datas.forEach((Datas) {
          //print(Datas.data.toString());
        });
        //print("\n\n");
      });

      vacancyDetails = VacancyDetails();
    }
  }

  Future<void> VDetails(String TRs, int i) async
  {
    try {
      var tr = parse(TRs).getElementsByTagName("tr")[i];

      ////print(link + " = TRs " + TR);

      var bolds = tr.getElementsByTagName("b");
      var td = tr.getElementsByTagName("td");

      if (bolds.length == 1) {
        await SaveVDetails();
        vacancyDetails = new VacancyDetails();
        isReadingVdetailsData = true;
        vacancyDetails.Title = bolds[0].text;
      }
      else if (bolds.length != 0) {
        await SaveVDetails();
        bolds.forEach((element) {
          vacancyDetails.headers.add(element.text.replaceAll("\n", ""));
        });
      }
      else if (td.length != 0) {
        vacancyDetailsData = new VacancyDetailsData();
        td.forEach((element) {
          vacancyDetailsData.data.add(
              element.text.replaceAll("\n", "").replaceAll(
                  "Sarkariresult.com", ""));
        });
        vacancyDetails.datas.add(vacancyDetailsData);
      }


      // {
      //   if(vacancyDetails.datas.length != 0)
      //   {
      //     jobData.VDetails.add(vacancyDetails);
      //   }
      //   isReadingVdetailsData = true;
      //   vacancyDetails = VacancyDetails();
      //   vacancyDetailsData = VacancyDetailsData();
      //   index_to_note = i;
      //   vacancyDetails.Title = trs[i].getElementsByTagName("td")[0].text.replaceAll("\n", "");
      //   //print("TITLE ${vacancyDetails.Title} and index to note ${index_to_note}");
      // }
      // else if(index_to_note + 1 == i)
      // {
      //   int j = 0;
      //   await Future.forEach(trs[i].getElementsByTagName("td"), (e) {
      //    vacancyDetails.headers.add(trs[i].getElementsByTagName("td")[j].text);
      //    if (kDebugMode) {
      //      //print("Headers ${vacancyDetails.headers[j]}");
      //    }
      //     j++;
      //   });
      // }
      // else{
      //   vacancyDetailsData = VacancyDetailsData();
      //   int j = 0;
      //   await Future.forEach(trs[i].getElementsByTagName("td"), (e) {
      //     vacancyDetailsData.data.add(trs[i].getElementsByTagName("td")[j].text);
      //     vacancyDetails.datas.add(vacancyDetailsData);
      //     if (kDebugMode) {
      //       //print("Datas ${vacancyDetails.datas[j].data.toString()}");
      //     }
      //     j++;
      //   });
      // }
    }
    catch(e)
    {
      //print(e);
    }
  }

  Future<void> ImportantLinks(String ImportantLinks) async
  {
    try {
      var importantlinks = await parse(ImportantLinks);

      String Name = importantlinks.getElementsByTagName("span")[0].text;
      String Link = importantlinks.getElementsByTagName("a")[0]
          .attributes["href"].toString();

      if (Link != null && Name != "" && Link != "") {
        jobData.ButtonsName.add(Name);
        jobData.ButtonsURL.add(Link);
        SomeDefaultLinks(Name, Link);
      }
    }
    catch(e)
    {
      //print(e);
    }
  }

  Future<void> SomeDefaultLinks(String Name, String Url) async {
    if(Name.toLowerCase().contains("apply"))
      {
        jobData.ApplyLink = Url;
      }
    else if(Name.toLowerCase().contains("notification"))
    {
      jobData.NotificationLink = Url;
    }
    else if(Name.toLowerCase().contains("website"))
    {
      jobData.WebsiteLink = Url;
    }
  }

  Future<String> FindLocation() async {
    String Location = "India";

    var States = Locations.locations;
    for (int i = 0; i < States.length; i++) {
      if (jobData.Short_Details.toLowerCase().toLowerCase().contains(States[i].toLowerCase()) ||
          jobData.Title.toLowerCase().contains(States[i].toLowerCase()) ||
          jobData.Department.toLowerCase().contains(States[i].toLowerCase()) ||
          jobData.VDetails.toString().toLowerCase().contains(States[i].toLowerCase()) ||
          jobData.DocumentRequired.toLowerCase().contains(States[i].toLowerCase()) ||
          jobData.Total_Vacancies.toLowerCase().contains(States[i].toLowerCase()) ||
          jobData.Designation.toLowerCase().contains(States[i].toLowerCase()) ||
          jobData.Important_Dates.keys.toString().toLowerCase().contains(States[i].toLowerCase())
      ) {
        Location = States[i];
        jobData.Location = Location;
        break;
      }
    }

    return Location;
  }
  
  Future<void> ExtractData() async {
    try {
      String page = await GetWebHTML();
      var Table1 = await parse(page).getElementsByTagName("table")[1].outerHtml;
      await ScrapTable1(Table1);
      await FindLocation();

      var Table2 = await parse(page).getElementsByTagName("table")[2].text
          .replaceAll("\n", "");
      if (Table2 != "" && Table2.length >= 10) {
        Table2 = parse(page).getElementsByTagName("table")[2].outerHtml;
      }
      else {
        Table2 = parse(page).getElementsByTagName("table")[3].outerHtml;
      }
      //print(Table2);
      await ScrapTable2(Table2);
      await FindLocation();

      await T2TRManager(Table2);
      await FindLocation();
    }
    catch(e){}
  }

  Future<JobData> Start(String URL) async{
    jobData = JobData();
    link = URL.replaceAll(" ", "");
    jobData.url = link;
    await ExtractData();
    jobData.GenerateKey();
    return jobData;
  }
}