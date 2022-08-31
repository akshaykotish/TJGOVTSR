



import 'dart:async';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:governmentapp/Files/JobBox.dart';
import 'package:governmentapp/JobData.dart';
import 'package:governmentapp/VacancyDetails.dart';
import 'package:shared_preferences/shared_preferences.dart';

class JobsManager{

  static var States = <String>[
    "India",
    "Delhi",
    "Andaman and Nicobar",
    "Andaman and Nicobar",
    "Andhra Pradesh",
    "Arunachal Pradesh",
    "Assam",
    "Bihar",
    "Chandigarh",
    "Chhattisgarh",
    "Dadra and Nagar Haveli",
    "Daman and Diu",
    "Delhi",
    "Goa",
    "Gujarat",
    "Haryana",
    "Himachal Pradesh",
    "Jammu and Kashmir",
    "Jharkhand",
    "Karnataka",
    "Kerala",
    "Lakshadweep",
    "Madhya Pradesh",
    "Maharashtra",
    "Manipur",
    "Meghalaya",
    "Mizoram",
    "Nagaland",
    "Orissa",
    "Puducherry",
    "Punjab",
    "Rajasthan",
    "Sikkim",
    "Tamil Nadu",
    "Telangana",
    "Tripura",
    "Uttar Pradesh",
    "Uttarakhand",
    "West Bengal"
  ];

  static List<JobData> jobs = <JobData>[];
  static List<JobData> filtered_jobs = <JobData>[];
  static List<String> KeysCache = <String>[];


  static StreamController<List<JobData>> loadingjobs = StreamController<List<JobData>>();
  static Stream loadingjobsDataStream = loadingjobs.stream;
  static late Function loadingjobsDataStreamToCall;


  static void init(){
    loadingjobsDataStream.listen((event) async {
      if(loadingjobsDataStreamToCall != null)
      {
        loadingjobsDataStreamToCall(event);
      }
    });
  }

  static var UserDepartments = <String>[];
  static var UserStates = <String>[];
  static var UserIntrests = <String>[];
  static var AllDepartmentsList = <Widget>[];
  static var LovedJobs = <String>[];


  static Future<void> LoadPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    //////print("Loading Pref Run1");
    var ud = (await prefs.getStringList('UserDepartments'));
    if(ud != null)
      {
        UserDepartments = ud;
      }

    var us = (await prefs.getStringList('UserStates'));
    if(us != null)
      {
        UserStates = us;
      }

    var ui = (await prefs.getStringList('UserInterest'));
    if(ui != null)
      {
        UserIntrests = ui;
      }


    var lj = (await prefs.getStringList('lovedjobs'));
    if(lj != null)
      {
        LovedJobs = lj;
      }

    //////print("Loading Pref Run2");
  }

  static bool isOkayToLoadCache = false;
  static List<String> CacheJobs = <String>[];
  static var CacheDate = "";

  static Future<void> Update_JobsCache() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.setStringList("JobsCache", CacheJobs);
    CacheDate = await DateTime.now().toString();
    await sharedPreferences.setString("JobsCacheDate", CacheDate);
    await sharedPreferences.setStringList("KeysCache", KeysCache);

  }

  static Future<void> LoadDataFromCache() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var cj = (await sharedPreferences.getStringList("JobsCache"));

    if(cj != null)
      {
        CacheJobs = cj;
      }

    if(CacheJobs !=null && CacheJobs.isNotEmpty)
      {
        CacheJobs.forEach((job) async {
          JobData jobData = new JobData();
          jobData.fromJson(job);
          jobs.add(jobData);

          var isOkay= await CheckUserIntrest(jobData);
          if ((UserDepartments.toString().toLowerCase().contains(jobData.Department.toLowerCase()) || UserDepartments.length == 0) && (UserStates.toString().toLowerCase().contains(jobData.Location.toLowerCase()) || UserStates.length == 0) && isOkay) {
            filtered_jobs.add(jobData);
            loadingjobs.add(filtered_jobs);
          }
        });
      }
  }


  static Future<void> SaveSavedKeysJobs() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setStringList("KeysCache", KeysCache);
  }

  static Future<void> LoadSavedKeysJobs() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var c = (await sharedPreferences.getStringList("KeysCache"));
    if(c != null)
      {
        KeysCache = c;
      }
  }


  static Future<void> LoadCacheJobs() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var c = (await sharedPreferences.getStringList("JobsCache"));
    if(c != null)
      {
        CacheJobs = c;
      }
  }

  static Future<void> SaveLastJobID() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var data = await FirebaseFirestore.instance.collection("Logs").doc("LastSavedID").get();

    String lastSavedId = data.data()!["JobId"];
    sharedPreferences.setString("LastSavedID", lastSavedId);
  }


  static Future<List<JobData>> FilteredJobs(List<String> keywords, bool isloved) async {
    filtered_jobs.clear();
    loadingjobs.add(filtered_jobs);
    var LovedJobs = <String>[];
    final prefs = await SharedPreferences.getInstance();
    LovedJobs = (await prefs.getStringList('lovedjobs'))!;

    jobs.forEach((job) {
      if(keywords != null && keywords.isNotEmpty) {
        keywords.forEach((keyword) {
          if (((isloved && LovedJobs.contains(job.Key)) || (!isloved)) &&
              (job.Title.toLowerCase().contains(keyword.toLowerCase()) ||
                  job.Department.toLowerCase().contains(
                      keyword.toLowerCase()))) {
            filtered_jobs.add(job);
            loadingjobs.add(filtered_jobs);
          }
        });
      }
      else {
        if (((isloved && LovedJobs.contains(job.Key)) || (!isloved))) {
          filtered_jobs.add(job);
          loadingjobs.add(filtered_jobs);
        }
      }

    });

    return filtered_jobs;
  }


  static Future<void> LoadJobsData() async {

      await LoadPrefs();
      await LoadSavedKeysJobs();
      await LoadCacheJobs();
      await LoadDataFromCache();

      var _AllDepartmentsList = <Widget>[];
      Map<String, List<JobBox>> _ToShowJobs = new Map<String, List<JobBox>>();

      var ref = FirebaseFirestore.instance;
      var Departments = await ref.collection("Jobs").get();

      int index = 0;
      var AllDocs = await Departments.docs;

      for (var department in Departments.docs) {
        index++;
        var statesToSearch = <String>[];


        await Future.forEach(States, (state) {
          if (department.id.toLowerCase().contains(
              state.toString().toLowerCase())) {
            statesToSearch.add(state.toString().toUpperCase());
          }
        });

        statesToSearch.isEmpty ? statesToSearch.add("INDIA") : statesToSearch;

        await Future.forEach(statesToSearch, (String state) async {
          var Jobs;
          try {
            Jobs = await ref.collection("Jobs" + "/" + department.id + "/" +
                state.toString().toUpperCase()).get();
          }
          catch (e) {}

          for (var job in Jobs.docs) {
            String key = job.id;
            if (!KeysCache.contains(key)) {
              ////print("Loaded from Database ${key}");
              JobData jobData = JobData();
              jobData.LoadFromFireStoreValues(job);
            }
          }
        });
      }
  }

  static Future<bool> CheckUserIntrest(JobData jobData)
  async {
    bool isUserIntrestexist = false;
    if(UserIntrests.length == 0)
    {
      isUserIntrestexist = true;
    }
    await Future.forEach(UserIntrests, (String element){
      if(jobData.Title.toLowerCase().contains(element.toLowerCase()) || jobData.Department.toLowerCase().contains(element.toLowerCase()) || jobData.Location.toLowerCase().contains(element.toLowerCase()) || jobData.Short_Details.toLowerCase().contains(element.toLowerCase()))
        {
          isUserIntrestexist = true;
        }
    });



    return isUserIntrestexist;
  }


  static Future<void> PerformSaveJob(JobData jobData) async {

    //print("ITSOKAY" + jobData.vdetailsquery);
    var isOkay= await CheckUserIntrest(jobData);
    //if ((UserDepartments.toString().toLowerCase().contains(jobData.Department.toLowerCase()) || UserDepartments.length == 0) && (UserStates.toString().toLowerCase().contains(jobData.Location.toLowerCase()) || UserStates.length == 0) && isOkay)  {
      filtered_jobs.add(jobData);
      loadingjobs.add(filtered_jobs);
    //}


    jobs.add(jobData);

    await SaveToCache(jobData);
  }

  static Future<void> SaveToCache(JobData jobData)
  async {
      String jobString = await jsonEncode(await jobData.toJson());
      CacheJobs.add(jobString);
      KeysCache.add(jobData.Key);
      await Update_JobsCache();
  }

  static Future<void> FindJobFromCache(String key) async {

    //print("CacheJobs length is ${CacheJobs.length}");
    if(CacheJobs !=null && CacheJobs.isNotEmpty)
    {
      CacheJobs.forEach((job) async {
        JobData jobData = new JobData();
        await jobData.fromJson(job);

        if(jobData.Key == key) {
          jobs.add(jobData);
          var isOkay= await CheckUserIntrest(jobData);
          if ((UserDepartments.toString().toLowerCase().contains(jobData.Department.toLowerCase()) || UserDepartments.length == 0) && (UserStates.toString().toLowerCase().contains(jobData.Location.toLowerCase()) || UserStates.length == 0) && isOkay) {
            filtered_jobs.add(jobData);
            loadingjobs.add(filtered_jobs);
          }
        }
      });
    }
  }
}



/*jobData.Title = job.data()["Title"];
              jobData.Department = job.data()["Department"];
              jobData.url = job.data()["URL"];
              jobData.Total_Vacancies = job.data()["Total_Vacancies"];
              jobData.WebsiteLink = job.data()["WebsiteLink"];
              jobData.Location = job.data()["Location"];
              jobData.ApplicationFees = job.data()["ApplicationFees"];
              jobData.Important_Dates = job.data()["Important_Dates"];
              jobData.HowToApply = job.data()["HowToApply"];
              jobData.Key = job.id;
              jobData.ApplyLink = job.data()["ApplyLink"];
              jobData.WebsiteLink = job.data()["WebsiteLink"];
              jobData.NotificationLink = job.data()["NotificationLink"];

              jobData.Short_Details =
                  job.data()["Short_Details"].toString().replaceAll(
                      "Short Details of Notification", "");


              if (jobData.Short_Details.replaceAll(
                  "Short Details of Notification", "") == "" ||
                  jobData.Short_Details.replaceAll(
                      "Short Details of Notification", "") == "\n") {
                jobData.Short_Details =
                    job.data()["Total_Vacancies"].toString().replaceAll(
                        "Vacancy Details Total : ", "");
              }

              var vdetailsquery = <String>[];
              //print("Here0");


              bool isjdsaved = false;
              await ref.collection("Jobs" + "/" + department.id + "/" +
                  state.toString().toUpperCase() + "/" + job.id + "/VDetails")
                  .get()
                  .then((vdetails) async {
                //print("Here1");

                if(vdetails.docs.length == 0)
                  {
                    await PerformSaveJob(jobData);
                  }
                vdetails.docs.forEach((vdtl) async {
                  VacancyDetails vacancyDetails = new VacancyDetails();
                  vacancyDetails.Title = vdtl.data()["Title"];
                  vacancyDetails.TotalVacancies = vdtl.data()["TotalVacancies"];
                  vacancyDetails.headers = vdtl.data()["headers"];

                  var vdetailquery = {
                    "Title": vdtl.data()["Title"],
                    "TotalVacancies": vdtl.data()["TotalVacancies"],
                    "headers": vdtl.data()["headers"],
                    "data": null,
                  };

                  await ref.collection("Jobs" + "/" + department.id + "/" +
                      state.toString().toUpperCase() + "/" + job.id +
                      "/VDetails/" + vdtl.id + "/VacancyDetailsData")
                      .get()
                      .then((vdetaildata) async {
                    List<String> vacancydata = <String>[];
                    if(vdetaildata.docs.length == 0)
                      {
                       await PerformSaveJob(jobData);
                      }
                    for (var p = 0; p < vdetaildata.docs.length; p++) {
                      VacancyDetailsData vacancyDetailsData = new VacancyDetailsData();
                      vacancyDetailsData.data = vdetaildata.docs[p].data()["data"];
                      vacancyDetailsData.data =
                      vdetaildata.docs[p].data()["data"];

                      vacancyDetails.datas.add(vacancyDetailsData);
                      vacancydata.add(jsonEncode(
                          vdetaildata.docs[p].data()["data"].toString()));

                      vdetailquery["data"] = jsonEncode(vacancydata);

                      if (p == vdetaildata.docs.length - 1) {
                        var cc = await jsonEncode(vdetailquery);
                        vdetailsquery.add(cc);
                        jobData.vdetailsquery = await jsonEncode(vdetailsquery);
                        //print("Here + " + jobData.vdetailsquery);
                        await PerformSaveJob(jobData);

                      }
                    }
                  });


                  jobData.VDetails.add(vacancyDetails);
                });
              });*/