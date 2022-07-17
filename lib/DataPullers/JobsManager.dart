



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
    ////print("Loading Pref Run1");
    UserDepartments = (await prefs.getStringList('UserDepartments'))!;
    UserStates = (await prefs.getStringList('UserStates'))!;
    UserIntrests = (await prefs.getStringList('UserInterest'))!;
    LovedJobs = (await prefs.getStringList('lovedjobs'))!;
    ////print("Loading Pref Run2");
  }

  static bool isOkayToLoadCache = false;
  static List<String> CacheJobs = <String>[];
  static var CacheDate = "";

  static Future<bool> Check_JobsCache() async {

    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    try {
      CacheJobs = (await sharedPreferences.getStringList("JobsCache"))!;
      CacheDate = (await sharedPreferences.getString("JobsCacheDate"))!;
    }catch(e){

    }

    if(CacheJobs != null && CacheJobs.isNotEmpty && CacheDate != null && CacheDate != "") {
      DateTime dateTime = DateTime.parse(CacheDate);
      ////print("Cache Jobs Length " + CacheJobs.length.toString() + " DateTime " (dateTime
  //            .difference(DateTime.now())
//              .inDays > 2).toString());

      if (CacheJobs != null && CacheJobs.isNotEmpty && dateTime
          .difference(DateTime.now())
          .inDays > 2) {
        isOkayToLoadCache = false;
      }
      else {
        isOkayToLoadCache = true;
      }
    }
    else{
      isOkayToLoadCache = false;
    }
    return isOkayToLoadCache;
  }

  static Future<void> Update_JobsCache() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.setStringList("JobsCache", CacheJobs);
    CacheDate = await DateTime.now().toString();
    await sharedPreferences.setString("JobsCacheDate", CacheDate);
    await sharedPreferences.setStringList("KeysCache", KeysCache);

    //////print("DataStored ${CacheDate}");
  }

  static Future<void> LoadDataFromCache() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    CacheJobs = (await sharedPreferences.getStringList("JobsCache"))!;


    if(CacheJobs !=null && CacheJobs.isNotEmpty)
      {
        ////print("Loaded from Cache");
        CacheJobs.forEach((job) {
          JobData jobData = new JobData();
          jobData.fromJson(job);
          jobs.add(jobData);
          if (jobData.Title.contains("Clerk")) {
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

  static Future<void> SaveLastJobID() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var data = await FirebaseFirestore.instance.collection("Logs").doc("LastSavedID").get();

    String lastSavedId = data.data()!["JobId"];
    sharedPreferences.setString("LastSavedID", lastSavedId);
  }

  static Future<void> LoadNewJobs() async {

    var _AllDepartmentsList = <Widget>[];
    Map<String, List<JobBox>> _ToShowJobs = new Map<String, List<JobBox>>();

    var ref = FirebaseFirestore.instance;
    var Departments = await ref.collection("Jobs").get();

    int index = 0;
    var AllDocs = await Departments.docs;
    for (var department in Departments.docs) {
      index++;
      //////print(department.id);
      //States.forEach((state) async {
      var statesToSearch = <String>[];

      await Future.forEach(States, (state) {
        if (department.id.toLowerCase().contains(
            state.toString().toLowerCase())) {
          statesToSearch.add(state.toString().toUpperCase());
        }
      });

      statesToSearch.isEmpty ? statesToSearch.add("INDIA") : statesToSearch;

      await Future.forEach(statesToSearch, (state) async {
        var Jobs;
        try {
          Jobs = await ref.collection("Jobs" + "/" + department.id + "/" +
              state.toString().toUpperCase()).get();
        }
        catch (e) {}
        for (var job in Jobs.docs) {

          String key  = job.id;
          //await LookForJob(key);

          if(!KeysCache.contains(key)) {
            JobData jobData = new JobData();
            jobData.Title = job.data()["Title"];
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

            ////print("<" + jobData.Short_Details + ">");

            if (jobData.Short_Details.replaceAll(
                "Short Details of Notification", "") == "" ||
                jobData.Short_Details.replaceAll(
                    "Short Details of Notification", "") == "\n") {
              jobData.Short_Details =
                  job.data()["Total_Vacancies"].toString().replaceAll(
                      "Vacancy Details Total : ", "");
            }

            var vdetailsquery = <String>[];

            ref.collection("Jobs" + "/" + department.id + "/" +
                state.toString().toUpperCase() + "/" + job.id + "/VDetails")
                .get()
                .then((vdetails) {
              vdetails.docs.forEach((vdtl) {
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

                ref.collection("Jobs" + "/" + department.id + "/" +
                    state.toString().toUpperCase() + "/" + job.id +
                    "/VDetails/" + vdtl.id + "/VacancyDetailsData")
                    .get()
                    .then((vdetaildata) async {
                  List<String> vacancydata = <String>[];

                  //     vdetaildata.docs.forEach((vdtldata) {
                  //           VacancyDetailsData vacancyDetailsData = new VacancyDetailsData();
                  //           vacancyDetailsData.data = vdtldata.data()["data"];
                  //
                  //           vacancyDetails.datas.add(vacancyDetailsData);
                  //           vacancydata.add(jsonEncode(vdtldata.data()["data"].toString()));
                  //
                  //           ////print("Looking for" + vdtldata.data()["data"].toString());
                  //
                  //           vdetailquery["data"] = jsonEncode(vacancydata);
                  // });

                  for (var p = 0; p < vdetaildata.size; p++) {
                    VacancyDetailsData vacancyDetailsData = new VacancyDetailsData();
                    vacancyDetailsData.data =
                    vdetaildata.docs[p].data()["data"];

                    vacancyDetails.datas.add(vacancyDetailsData);
                    vacancydata.add(jsonEncode(
                        vdetaildata.docs[p].data()["data"].toString()));

                    vdetailquery["data"] = jsonEncode(vacancydata);
                    ////print("vdetailquery['data'] = " + vdetailquery["data"]);

                    if (p == vdetaildata.size - 1) {
                      var cc = await jsonEncode(vdetailquery);
                      vdetailsquery.add(cc);
                      ////print("CC = " + vdetailquery.toString());
                      jobData.vdetailsquery = await jsonEncode(vdetailsquery);
                      ////print("VDTLQRY: " + jsonEncode(vdetailsquery));
                    }
                  }
                });


                jobData.VDetails.add(vacancyDetails);
              });
            });

            if (jobData.Title.contains("Clerk")) {
              filtered_jobs.add(jobData);
              loadingjobs.add(filtered_jobs);
            }
            jobs.add(jobData);

            String jobString = jsonEncode(await jobData.toJson());
            ////print(jobString);
            if (!CacheJobs.contains(jobString)) {
              CacheJobs.add(jobString);
              Update_JobsCache();
            }
          }

        }

      }).then((value) async {
        await Update_JobsCache();
      });
    }
  }

  static int TotalJobs = 0;
  static int TotalJobsCached = 0;

  static Future<void> LoadJobsCounts() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    TotalJobs = ((await sharedPreferences.getInt("TotalJobs")) == null ? 0 : (await sharedPreferences.getInt("TotalJobs")))!;
    TotalJobsCached = ((await sharedPreferences.getInt("TotalJobsCached")) == null ? 0 : (await sharedPreferences.getInt("TotalJobsCached")))!;
  }

  static Future<void> SaveJobsCounts() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    (sharedPreferences.setInt("TotalJobs", TotalJobs));
    (sharedPreferences.setInt("TotalJobsCached",TotalJobsCached));
  }

/*
  static Future<void> LoadAllJobs()
  async {

    await LoadSavedKeysJobs();
    await Check_JobsCache();
    await LoadJobsCounts();

    ////print("JOB COunts are ${TotalJobs} and ${TotalJobsCached}");

    if(!isOkayToLoadCache || ((TotalJobs != TotalJobsCached) || TotalJobsCached == 0)) {
      ////print("Loaded from Web");

      var _AllDepartmentsList = <Widget>[];
      Map<String, List<JobBox>> _ToShowJobs = new Map<String, List<JobBox>>();

      var ref = FirebaseFirestore.instance;
      var Departments = await ref.collection("Jobs").get();

      int index = 0;
      var AllDocs = await Departments.docs;

      for (var department in Departments.docs) {
        index++;
        //////print(department.id);
        //States.forEach((state) async {
        var statesToSearch = <String>[];


        await Future.forEach(States, (state) {
          if (department.id.toLowerCase().contains(
              state.toString().toLowerCase())) {
            statesToSearch.add(state.toString().toUpperCase());
          }
        });

        statesToSearch.isEmpty ? statesToSearch.add("INDIA") : statesToSearch;

        await Future.forEach(statesToSearch, (state) async {
         late QuerySnapshot Jobs;
          try {
            Jobs = await ref.collection("Jobs" + "/" + department.id + "/" +
                state.toString().toUpperCase()).get();

          }
          catch (e) {}

          TotalJobs += Jobs.docs.length;
          for (var job in Jobs.docs) {

            String key  = job.id;
            if(!KeysCache.contains(key)) {
              JobData jobData = new JobData();
              jobData.Title = job.data()["Title"];
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

              ////print("<" + jobData.Short_Details + ">");

              if (jobData.Short_Details.replaceAll(
                  "Short Details of Notification", "") == "" ||
                  jobData.Short_Details.replaceAll(
                      "Short Details of Notification", "") == "\n") {
                jobData.Short_Details =
                    job.data()["Total_Vacancies"].toString().replaceAll(
                        "Vacancy Details Total : ", "");
              }

              var vdetailsquery = <String>[];

              ref.collection("Jobs" + "/" + department.id + "/" +
                  state.toString().toUpperCase() + "/" + job.id + "/VDetails")
                  .get()
                  .then((vdetails) {
                vdetails.docs.forEach((vdtl) {
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

                  ref.collection("Jobs" + "/" + department.id + "/" +
                      state.toString().toUpperCase() + "/" + job.id +
                      "/VDetails/" + vdtl.id + "/VacancyDetailsData")
                      .get()
                      .then((vdetaildata) async {
                    List<String> vacancydata = <String>[];

                    //     vdetaildata.docs.forEach((vdtldata) {
                    //           VacancyDetailsData vacancyDetailsData = new VacancyDetailsData();
                    //           vacancyDetailsData.data = vdtldata.data()["data"];
                    //
                    //           vacancyDetails.datas.add(vacancyDetailsData);
                    //           vacancydata.add(jsonEncode(vdtldata.data()["data"].toString()));
                    //
                    //           ////print("Looking for" + vdtldata.data()["data"].toString());
                    //
                    //           vdetailquery["data"] = jsonEncode(vacancydata);
                    // });

                    for (var p = 0; p < vdetaildata.size; p++) {
                      VacancyDetailsData vacancyDetailsData = new VacancyDetailsData();
                      vacancyDetailsData.data =
                      vdetaildata.docs[p].data()["data"];

                      vacancyDetails.datas.add(vacancyDetailsData);
                      vacancydata.add(jsonEncode(
                          vdetaildata.docs[p].data()["data"].toString()));

                      vdetailquery["data"] = jsonEncode(vacancydata);
                      ////print("vdetailquery['data'] = " + vdetailquery["data"]);

                      if (p == vdetaildata.size - 1) {
                        var cc = await jsonEncode(vdetailquery);
                        vdetailsquery.add(cc);
                        ////print("CC = " + vdetailquery.toString());
                        jobData.vdetailsquery = await jsonEncode(vdetailsquery);
                        ////print("VDTLQRY: " + jsonEncode(vdetailsquery));
                      }
                    }
                  });


                  jobData.VDetails.add(vacancyDetails);
                });
              });

              if (jobData.Title.contains("Clerk")) {
                filtered_jobs.add(jobData);
                loadingjobs.add(filtered_jobs);
              }
              jobs.add(jobData);

              String jobString = jsonEncode(await jobData.toJson());
              ////print(jobString);
              if (!KeysCache.contains(key)) {
                CacheJobs.add(jobString);

                Update_JobsCache();
                TotalJobsCached++;
                SaveJobsCounts();
                SaveSavedKeysJobs();
              }
              TotalJobs++;
            }

          }

        }).then((value) async {
          await Update_JobsCache();
        });
      }
    }
    else{
      LoadDataFromCache();
    }
  }
*/

  static Future<List<JobData>> FilteredJobs(List<String> keywords, bool isloved) async {
    filtered_jobs.clear();
    loadingjobs.add(filtered_jobs);
    var LovedJobs = <String>[];
    final prefs = await SharedPreferences.getInstance();
    LovedJobs = (await prefs.getStringList('lovedjobs'))!;

    jobs.forEach((job) {
      if(keywords.isNotEmpty) {
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
    await LoadSavedKeysJobs();

    print("KeysCache:- " + KeysCache.length.toString());
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

        await Future.forEach(statesToSearch, (state) async {
          var Jobs;
          try {
            Jobs = await ref.collection("Jobs" + "/" + department.id + "/" +
                state.toString().toUpperCase()).get();

          }
          catch (e) {}

          for (var job in Jobs.docs) {

            ////print("R");
            String key  = job.id;
            if(!KeysCache.contains(key)) {
              //print("Loaded from Database ${key}");
              JobData jobData = new JobData();
              jobData.Title = job.data()["Title"];
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

              jobData.Short_Details = job.data()["Short_Details"].toString().replaceAll("Short Details of Notification", "");


              if (jobData.Short_Details.replaceAll(
                  "Short Details of Notification", "") == "" ||
                  jobData.Short_Details.replaceAll(
                      "Short Details of Notification", "") == "\n") {
                jobData.Short_Details =
                    job.data()["Total_Vacancies"].toString().replaceAll(
                        "Vacancy Details Total : ", "");
              }

              var vdetailsquery = <String>[];

              ref.collection("Jobs" + "/" + department.id + "/" +
                  state.toString().toUpperCase() + "/" + job.id + "/VDetails")
                  .get()
                  .then((vdetails) {
                vdetails.docs.forEach((vdtl) {
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

                  ref.collection("Jobs" + "/" + department.id + "/" +
                      state.toString().toUpperCase() + "/" + job.id +
                      "/VDetails/" + vdtl.id + "/VacancyDetailsData")
                      .get()
                      .then((vdetaildata) async {
                    List<String> vacancydata = <String>[];
                    for (var p = 0; p < vdetaildata.size; p++) {
                      VacancyDetailsData vacancyDetailsData = new VacancyDetailsData();
                      vacancyDetailsData.data =
                      vdetaildata.docs[p].data()["data"];

                      vacancyDetails.datas.add(vacancyDetailsData);
                      vacancydata.add(jsonEncode(
                          vdetaildata.docs[p].data()["data"].toString()));

                      vdetailquery["data"] = jsonEncode(vacancydata);

                      if (p == vdetaildata.size - 1) {
                        var cc = await jsonEncode(vdetailquery);
                        vdetailsquery.add(cc);
                        jobData.vdetailsquery = await jsonEncode(vdetailsquery);
                      }
                    }
                  });


                  jobData.VDetails.add(vacancyDetails);
                });
              });

              if (jobData.Title.contains("Clerk")) {
                filtered_jobs.add(jobData);
                loadingjobs.add(filtered_jobs);
              }


              jobs.add(jobData);

              await SaveToCache(jobData);
            }
            else{
              //print("Loaded from Cache ${key}");
              await FindJobFromCache(key);
            }
          }

        }).then((value) async {
          await Update_JobsCache();
        });
      }
  }

  static Future<void> SaveToCache(JobData jobData)
  async {
      String jobString = await jsonEncode(await jobData.toJson());
      CacheJobs.add(jobString);
      KeysCache.add(jobData.Key);


      await Update_JobsCache();
      await SaveSavedKeysJobs();

      print("Job Cached = ${jobData.Key}");
  }

  static Future<void> FindJobFromCache(String key) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    CacheJobs = (await sharedPreferences.getStringList("JobsCache"))!;


    if(CacheJobs !=null && CacheJobs.isNotEmpty)
    {
      CacheJobs.forEach((job) {
        JobData jobData = new JobData();
        jobData.fromJson(job);
        if(jobData.Key == key) {
          jobs.add(jobData);
          if (jobData.Title.contains("Clerk")) {
            filtered_jobs.add(jobData);
            loadingjobs.add(filtered_jobs);
          }
        }
      });
    }
  }
}