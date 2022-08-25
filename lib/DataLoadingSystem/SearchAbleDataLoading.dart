

import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:governmentapp/DataLoadingSystem/JobDisplayManagement.dart';
import 'package:governmentapp/DataLoadingSystem/Locations.dart';
import 'package:governmentapp/DataLoadingSystem/RequiredDataLoading.dart';
import 'package:governmentapp/JobData.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SearchAbleDataLoading{

  static List<String> SearchAbleCache = <String>[];
  static List<String> SearchAbleDepartmentsOnlyCache = <String>[];
  static String JobIndexTimestamp = "";

  static Future<void> SaveForSearching() async {

    var Reference = FirebaseFirestore.instance;

    var Departments = await Reference.collection("Jobs").get();

    int index = 0;
    await Future.forEach(Departments.docs, (dept) async {
      List<String> locationstocheck = ["INDIA"];

      await Future.forEach(Locations.locations, (String location) {
        if(location.toUpperCase() != "INDIA" && Departments.docs[index].id.toLowerCase().contains(location.toLowerCase()))
          {
            locationstocheck.add(location.toUpperCase());
          }
      });


      await Future.forEach(locationstocheck, (String location) async {
        var Jobs = await Reference.collection("Jobs/" + Departments.docs[index].id + "/"  + location.toUpperCase()).get();

        int p = 0;
        if(Jobs != null && Jobs.docs.isNotEmpty)
          {
            await Future.forEach(Jobs.docs, (job) async {
              String Path = "Jobs/" + Departments.docs[index].id + "/" + location + "/" + Jobs.docs[p].id;
              String toStore = Path  + ";" + Jobs.docs[p].data()["Department"] + ";" + Jobs.docs[p].data()["Designation"] + ";" + Jobs.docs[p].data()["Short_Details"];
              if(!SearchAbleCache.contains(toStore)) {
                SearchAbleCache.add(toStore);
                SearchAbleDepartmentsOnlyCache.add(Departments.docs[index].id);
                await Fire();
              }
              p++;
            });
          }
      });
      index++;
    });

  }

  static Future<void> JobIndexSaveToFirebase() async {
    if(SearchAbleCache.length != 0) {
      await FirebaseFirestore.instance.collection("Indexs").doc("Jobs").set({
        "SearchAbleCache": SearchAbleCache,
        "TimeStamp": DateTime.now().toString(),
      });
    }
  }

  static Future<void> Fire() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setStringList("SearchAbleCache", SearchAbleCache);
    sharedPreferences.setStringList("SearchAbleDepartmentsOnlyCache", SearchAbleDepartmentsOnlyCache);
    JobIndexTimestamp == null ? JobIndexTimestamp = "" : null;
    sharedPreferences.setString("JobIndexTimestamp", JobIndexTimestamp);
  }


  static Future<void> LoadJobIndexCache() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var a = (await sharedPreferences.getString("JobIndexTimestamp"));
    a != null ? JobIndexTimestamp = a : JobIndexTimestamp = "";
    var c = await sharedPreferences.getStringList("SearchAbleCache");
    c != null ? SearchAbleCache = c : null;
    var d = await sharedPreferences.getStringList("SearchAbleDepartmentsOnlyCache");
    d != null ? SearchAbleDepartmentsOnlyCache = d : null;

  }

  static Future<void> DisplayForSearching() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var c = await sharedPreferences.getStringList("SearchAbleCache");
    if(c != null && c.isNotEmpty)
      {
        c.forEach((element) {
          print(element);
        });
      }
  }


  static Future<void> LoadJobIndex() async {
    await LoadJobIndexCache();
    try {
      var JobIndex = await FirebaseFirestore.instance.collection("Indexs").doc(
          "Jobs").get();
      if (JobIndex.exists) {
        String ts = JobIndex.data()!["TimeStamp"];
        if (ts != JobIndexTimestamp) {
          JobIndexTimestamp = ts;
          var c = await JobIndex.data()!["SearchAbleCache"];
          await (c != null ? SearchAbleCache = List<String>.from(c) : null);
          await Fire();
        }
      }
    }
    catch(e)
    {
      print(e);
    }
  }

  static Future<JobData> GetJobFromURL(String path)
  async {
    var job;
    try {
      job = await FirebaseFirestore.instance.doc(path).get();
    }
    catch(e){
      print("${e} + ${path}");
    }
    JobData jobData = JobData();
    await jobData.LoadFromFireStoreValues(job);
    return jobData;
  }

  static Future<void> AddToShow(List<JobData> list) async
  {
    JobDisplayManagement.jobstoshow.addAll(list);
    JobDisplayManagement.jobstoshowstreamcontroller.add(JobDisplayManagement.jobstoshow);
  }

  static Future<void> FindAndAdd(String path, int count) async {
    if(path.split("/").length == 4 && path.split("/")[3] != "") {
      JobData jobData = await GetJobFromURL(path);
      if (jobData.Department != "UNKNOWN" && jobData.Key != "UNKEY") {
        jobData.count = count;
        JobDisplayManagement.jobstoshow.add(jobData);
        JobDisplayManagement.jobstoshowstreamcontroller.add(
            JobDisplayManagement.jobstoshow);
      }
    }
  }

  static Future<void> LetsDisplayJobs(List<String> em,List<String> fp,List<String> sp,List<String> tp) async
  {
    em.forEach((element) {
      FindAndAdd(element, 4);
    });
    fp.forEach((element) {
      FindAndAdd(element, 3);
    });
    sp.forEach((element) {
      FindAndAdd(element, 2);
    });
    tp.forEach((element) {
      FindAndAdd(element, 1);
    });
  }

  static Future<void> FastestSearchSystem(List<String> searchkeywords) async {
      print("Start: " + DateTime.now().toString());
      JobDisplayManagement.isloadingjobs = true;
      JobDisplayManagement.ismoreloadingjobs = true;
      JobDisplayManagement.jobstoshow.clear();

      if (searchkeywords == null || searchkeywords.isEmpty) {      JobDisplayManagement.isloadingjobs = true;
      JobDisplayManagement.isloadingjobs = false;
      JobDisplayManagement.ismoreloadingjobs = false;
        return;
      }

      List<String> exactmatch = <String>[];
      List<String> firstpriority = <String>[];
      List<String> secondpriority = <String>[];
      List<String> thirdpriority = <String>[];



      var RevSearchable = await SearchAbleCache.reversed;
      await Future.forEach(RevSearchable, (String JobString) async {
        if(JobDisplayManagement.jobstoshow.length >= 100)
          {
            JobDisplayManagement.isloadingjobs = false;
            JobDisplayManagement.ismoreloadingjobs = false;
            return;
          }
          await Future.forEach(searchkeywords, (String keyword) async {
            if(JobDisplayManagement.jobstoshow.length >= 100)
            {
              return;
            }
            int count = 0;

            var diffs = JobString.split(";");
            String path = "";

            if(diffs.length == 3)
            {
              path = diffs[2];
            }
            else{
              path = diffs[0];
            }

            if(JobString.toLowerCase().contains(keyword.toLowerCase()))
              {
                exactmatch.add(path);
              }
            else {
              List<String> parts = keyword.split(" ");
              await Future.forEach(parts, (String key) {
                if (JobString.toLowerCase().contains(key.toLowerCase())) {
                  count++;
                }
              });
              
              if(count >= 3)
                {
                  firstpriority.add(path);
                }
              else if(count >= 2)
              {
                secondpriority.add(path);
              }
              else if(count >= 1)
              {
                thirdpriority.add(path);
              }
            }
                });
          });


      await LetsDisplayJobs(exactmatch, firstpriority, secondpriority, thirdpriority);

      JobDisplayManagement.isloadingjobs = false;
      JobDisplayManagement.ismoreloadingjobs = false;
      print("End: " + DateTime.now().toString());

  }


  static Future<void> Execute() async {
    await LoadJobIndex();
  }

}