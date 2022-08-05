

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:governmentapp/DataLoadingSystem/JobDisplayManagement.dart';
import 'package:governmentapp/DataLoadingSystem/Locations.dart';
import 'package:governmentapp/DataLoadingSystem/RequiredDataLoading.dart';
import 'package:governmentapp/JobData.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SearchAbleDataLoading{

  static List<String> SearchAbleCache = <String>[];
  static String JobIndexTimestamp = "";

  static Future<void> SaveForSearching() async {

    var Reference = FirebaseFirestore.instance;

    var Departments = await Reference.collection("Jobs").get();

    print("Departments ${Departments.docs.length}");

    int index = 0;
    await Future.forEach(Departments.docs, (dept) async {
      List<String> locationstocheck = ["INDIA"];

      await Future.forEach(Locations.locations, (String location) {
        if(location.toUpperCase() != "INDIA" && Departments.docs[index].id.toLowerCase().contains(location.toLowerCase()))
          {
            locationstocheck.add(location.toUpperCase());
          }
      });

      print("Locations ${locationstocheck.length}");

      await Future.forEach(locationstocheck, (String location) async {
        var Jobs = await Reference.collection("Jobs/" + Departments.docs[index].id + "/"  + location.toUpperCase()).get();

        int p = 0;
        if(Jobs != null && Jobs.docs.isNotEmpty)
          {
            print("Jobs ${Jobs.docs.length}");
            await Future.forEach(Jobs.docs, (job) async {
              String Path = "Jobs/" + Departments.docs[index].id + "/" + location + "/" + Jobs.docs[p].id;
              String Title = Jobs.docs[p].data()["Title"];
              String Key = Jobs.docs[p].id;
              String toStore = Key + ";" + Title + ";" + Path;
              if(!SearchAbleCache.contains(toStore)) {
                SearchAbleCache.add(toStore);
                print(toStore);
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
    await FirebaseFirestore.instance.collection("Indexs").doc("Jobs").set({
      "SearchAbleCache":SearchAbleCache,
      "TimeStamp": DateTime.now().toString(),
    });
    print("Data Stored to Firebase");
  }

  static Future<void> Fire() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setStringList("SearchAbleCache", SearchAbleCache);

    JobIndexTimestamp == null ? JobIndexTimestamp = "" : null;
    sharedPreferences.setString("JobIndexTimestamp", JobIndexTimestamp);
  }


  static Future<void> LoadJobIndexCache() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var a = (await sharedPreferences.getString("JobIndexTimestamp"));
    a != null ? JobIndexTimestamp = a : JobIndexTimestamp = "";
    var c = await sharedPreferences.getStringList("SearchAbleCache");
    c != null ? SearchAbleCache = c : null;
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
    var JobIndex = await FirebaseFirestore.instance.collection("Indexs").doc("Jobs").get();
    if(JobIndex.exists) {
      String ts = JobIndex.data()!["TimeStamp"];
      print("JobIndexTimestamp ${JobIndexTimestamp} and ${ts}");
      if(ts != JobIndexTimestamp)
        {
          JobIndexTimestamp = ts;
          var c = await JobIndex.data()!["SearchAbleCache"];
          await (c != null ? SearchAbleCache = List<String>.from(c) : null);
          await Fire();
        }
    }
  }

  static Future<void> FastestSearchSystem(List<String> searchkeywords) async {
    JobDisplayManagement.jobstoshow.clear();

    List<JobData> gains = <JobData>[];
    JobDisplayManagement.ismoreloadingjobs = true;

    await Future.forEach(SearchAbleCache, (searchable)
    async {
      bool isit = false;
      bool priority = false;

      await Future.forEach(searchkeywords, (keywords){

        var searchparts = keywords.toString().split(" ");

        String key1 = searchparts.length >= 1 ? searchparts[0] : "";
        String key2 = searchparts.length >= 2 ? searchparts[1] : "";
        String key3 = searchparts.length >= 3 ? searchparts[2] : "";

        if(searchable.toString().toLowerCase().contains(keywords.toString().toLowerCase()))
          {
            isit = true;
          }

        String Title = searchable.toString().split(";").length >= 2 ? searchable.toString().split(";")[1] : searchable.toString();
        if((Title.toString().toLowerCase().contains(key1.toLowerCase()) && Title.toString().toLowerCase().contains(key2.toLowerCase()) && Title.toString().toLowerCase().contains(key3.toLowerCase())) || (Title.toString().toLowerCase().contains(key1.toLowerCase()) && Title.toString().toLowerCase().contains(key2.toLowerCase())) || (Title.toString().toLowerCase().contains(key2.toLowerCase()) && Title.toString().toLowerCase().contains(key3.toLowerCase())) || (Title.toString().toLowerCase().contains(key1.toLowerCase()) && Title.toString().toLowerCase().contains(key3.toLowerCase())))
          {
            priority = true;
            print("Priority" + keywords.toString());
          }

      });
      if(isit == true)
        {
          var parts = searchable.toString().split(";");
          var job = await FirebaseFirestore.instance.doc(parts[2]).get();
          if(job.exists)
            {
              //print("Yay! job found!" + searchable.toString() + " " + isit.toString());
              JobData jobData = JobData();
              await jobData.LoadFromFireStoreValues(job);

              if(priority) {
                JobDisplayManagement.jobstoshow.add(jobData);
                JobDisplayManagement.jobstoshowstreamcontroller.add(
                    JobDisplayManagement.jobstoshow);
              }
              else{
                gains.add(jobData);
                print("Added to Gains" + jobData.Title);
              }

              if(JobDisplayManagement.jobstoshow.isEmpty)
                {
                  RequiredDataLoading.SaveCookiesForRequriedData(jobData);
                }

              JobDisplayManagement.isloadingjobs == true ? JobDisplayManagement.isloadingjobs = false : null;
              //await RequiredDataLoading.Fire(job);
            }
        }


      print("EFFE545");
    });

    print("EFFER");

    JobDisplayManagement.jobstoshow.addAll(gains);
    JobDisplayManagement.jobstoshowstreamcontroller.add(
        JobDisplayManagement.jobstoshow);


    JobDisplayManagement.ismoreloadingjobs = false;
    JobDisplayManagement.isloadingjobs = false;

  }

  static Future<void> Execute() async {
    //print("Started loading searchable data");
    //await SaveForSearching();
    //print("Data loaded, now displaying...");
    //await DisplayForSearching();
    //print("Saving to Firebase...");
    //await TempSaveToFirebase();
    //print("Saved");

    await LoadJobIndex();
    print("Length are ${SearchAbleCache.length}");

    //await FastestSearchSystem(["UPSC"]);

  }

}