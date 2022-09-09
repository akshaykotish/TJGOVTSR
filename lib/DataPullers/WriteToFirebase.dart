

import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:governmentapp/DataPullers/HotJobs.dart';
import 'package:governmentapp/JobData.dart';
import 'package:governmentapp/VacancyDetails.dart';

import '../DataLoadingSystem/SearchAbleDataLoading.dart';

class WriteToFirebase{
  static Future<String> GenerateRandomID() async {
    Random random = Random();
    String RID = DateTime.now().toString().replaceAll("/", "").replaceAll(
        ":", "").replaceAll("-", "").replaceAll(" ", "").replaceAll(".", "") +
        random.nextInt(5000).toString();
    return RID;
  }


  static Future<void> WriteToJob(JobData jobData) async
  {
    try {
      if (jobData.Location.isEmpty || jobData.Location == "") {
        jobData.Location = "INDIA";
      }
      jobData.path =  FirebaseFirestore.instance.collection("Jobs").doc(
          jobData.Department).collection(jobData.Location.toUpperCase()).doc(
          jobData.Key).path;
      await FirebaseFirestore.instance.collection("Jobs").doc(jobData.Department).set({"LastUpdate": DateTime.now().toString()});
      await FirebaseFirestore.instance.collection("Jobs").doc(
          jobData.Department).collection(jobData.Location.toUpperCase()).doc(
          jobData.Key).set({
        "Key": jobData.Key,
        "Department": jobData.Department,
        "Title": jobData.Title,
        "Short_Details": jobData.Short_Details,
        "DocumentRequired": jobData.DocumentRequired,
        "DataProviderUrl": jobData.DataProviderUrl,
        "Important_Dates": jobData.Important_Dates,
        "ApplicationFees": jobData.ApplicationFees,
        "Total_Vacancies": jobData.Total_Vacancies,
        "HowToApply": jobData.HowToApply,
        "ApplyLink": jobData.ApplyLink,
        "NotificationLink": jobData.NotificationLink,
        "WebsiteLink": jobData.WebsiteLink,
        "url": jobData.url,
        "Location": jobData.Location,
        "ButtonsName": jobData.ButtonsName,
        "ButtonsURL": jobData.ButtonsURL,
        "Designation": jobData.Designation,
        "LastUpdate": jobData.LastUpdate,
        "AdvertisementNumber": jobData.AdvertisementNumber,
        "ExamCenters": jobData.ExamCenters,
        "Corrections": jobData.Corrections,
        "AgeLimits": jobData.AgeLimits,
        "HowTo": jobData.HowTo,
      });

      for (int i = 0; i < jobData.VDetails.length; i++) {
        String ID = await GenerateRandomID();
        await FirebaseFirestore.instance.collection("Jobs").doc(
            jobData.Department).collection(jobData.Location.toUpperCase()).doc(
            jobData.Key).collection("VDetails").doc(ID).set({
          "TotalVacancies": jobData.VDetails[i].TotalVacancies,
          "Title": jobData.VDetails[i].Title,
          "headers": jobData.VDetails[i].headers.map((e) => e.toString())
              .toList(),
        });

        await Future.forEach(
            jobData.VDetails[i].datas, (VacancyDetailsData element) async {
          String subID = await GenerateRandomID();
          FirebaseFirestore.instance.collection("Jobs").doc(jobData.Department)
              .collection(jobData.Location.toUpperCase()).doc(jobData.Key)
              .collection("VDetails").doc(ID).collection("VacancyDetailsData")
              .doc(subID)
              .set({
            "data": element.data,
          });
        });
      }
    }
    catch(e){

    }
  }

  static Future<void> WriteIndexToFirebase(JobData jobData) async {
    try {
      await SearchAbleDataLoading.LoadJobIndex();
      String Path = "";
      if(jobData.path != "") {
        Path = jobData.path;
      }
      else{
        Path = "Jobs/${jobData.Department}/${jobData.Location}/${jobData.Key}";
      }
      String toStore = Path + ";" + jobData.Department + ";" +
          jobData.Designation + ";" + jobData.Short_Details;

      HotJobs.UpdateHotJobs(toStore);

      (SearchAbleDataLoading.SearchAbleCache.contains(toStore) == false
          ? SearchAbleDataLoading.SearchAbleCache.add(toStore)
          : null);
      await SearchAbleDataLoading.Fire();
      await SearchAbleDataLoading.JobIndexSaveToFirebase();
      print("New Job Added ${jobData.Key} and Length = " + SearchAbleDataLoading.SearchAbleCache.length.toString());
    }
    catch(e){
      print(e);
    }
  }
}