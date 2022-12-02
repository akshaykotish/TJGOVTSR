

import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:governmentapp/DataLoadingSystem/JobDisplayManagement.dart';
import 'package:governmentapp/DataLoadingSystem/Locations.dart';
import 'package:governmentapp/DataLoadingSystem/RequiredDataLoading.dart';
import 'package:governmentapp/JobDisplayData.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:governmentapp/JobDisplayData.dart';
import 'JobDisplayManagement.dart';

class SearchAbleDataLoading{

  static List<String> JobisAlreadyAdded = <String>[];

  static List<String> SearchAbleCache = <String>[];
  static List<String> SearchAbleDepartmentsOnlyCache = <String>[];
  static String JobIndexTimestamp = "";

  static List<JobDisplayData> beforeyears = <JobDisplayData>[];

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
        if(Jobs.docs.isNotEmpty)
          {
            await Future.forEach(Jobs.docs, (job) async {
              String JobString = "Jobs/" + Departments.docs[index].id + "/" + location + "/" + Jobs.docs[p].id;
              String toStore = JobString  + ";" + Jobs.docs[p].data()["Department"] + ";" + Jobs.docs[p].data()["Designation"] + ";" + Jobs.docs[p].data()["Short_Details"];
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
      print("Writing to Firebase");
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

  static Future<JobDisplayData> GetJobFromURL(String JobString)
  async {
    var job;
    try {
      job = await FirebaseFirestore.instance.doc(JobString).get();
    }
    catch(e){
      print("${e} + ${JobString}");
    }
    //JobDisplayData JobDisplayData = JobDisplayData();
//    await JobDisplayData.LoadFromFireStoreValues(job);
  //  return JobDisplayData;
    return JobDisplayData("");
  }

  static Future<void> AddToShow(List<JobDisplayData> list) async
  {
    //JobDisplayManagement.SEARCHJOBS.addAll(list);
      ////JobDisplayManagement.SEARCHJOBSC.add(//JobDisplayManagement.SEARCHJOBS);
  }


  static Future<void> FindAndAdd(String JobString, int count) async {
    String currentyear = DateTime.now().year.toString();
    String nextyear = (DateTime.now().year+1).toString();

    if(JobString.contains(currentyear) || JobString.contains(nextyear)) {
      JobDisplayManagement.SEARCHJOBS.add(JobDisplayData(JobString, count));
      JobDisplayManagement.ISLoading = false;
      JobDisplayManagement.IsMoreLoading = false;
    }
    else{
      beforeyears.add(JobDisplayData(JobString, count));
    }
  }

  static Future<void> LetsDisplayJobs(List<String> tp) async
  {
    tp.forEach((element) async {
      await FindAndAdd(element, 1);
    });
  }

  static Future<int> FindtheValue(String searchkeyword, String JobString) async {
    String key1 = searchkeyword.split(" ").length >= 1 ? searchkeyword.split(" ")[0].toLowerCase() : "zzzxxxyyy";
    String key2 = searchkeyword.split(" ").length >= 2 ? searchkeyword.split(" ")[1].toLowerCase() : "zzzxxxyyy";
    String key3 = searchkeyword.split(" ").length >= 3 ? searchkeyword.split(" ")[2].toLowerCase() : "zzzxxxyyy";


    if(JobString.toLowerCase().contains(key1.toLowerCase()) && JobString.toLowerCase().contains(key2.toLowerCase()) && JobString.toLowerCase().contains(key3.toLowerCase()))
    {
      return 3;
    }
    else if((JobString.toLowerCase().contains(key1.toLowerCase()) && JobString.toLowerCase().contains(key2.toLowerCase())) ||
      (JobString.toLowerCase().contains(key2.toLowerCase()) && JobString.toLowerCase().contains(key3.toLowerCase())) ||
      (JobString.toLowerCase().contains(key1.toLowerCase()) && JobString.toLowerCase().contains(key3.toLowerCase()))
        )
    {
      return 2;
    }
    else if(JobString.toLowerCase().contains(key1.toLowerCase()) || JobString.toLowerCase().contains(key2.toLowerCase()) || JobString.toLowerCase().contains(key3.toLowerCase()))
    {
      return 1;
    }
    return 0;
  }

  static Future<void> FastestSearchSystem(List<String> searchkeywords) async {
    JobDisplayManagement.WhichShowing = 3;
    JobDisplayManagement.ISLoading =   true;
    JobDisplayManagement.IsMoreLoading = true;

    JobDisplayManagement.SEARCHJOBS.clear();
    beforeyears.clear();
    ////JobDisplayManagement.SEARCHJOBSC.add(//JobDisplayManagement.SEARCHJOBS);


    List<String> ReversedSearchAbleCache = List.from(SearchAbleCache.reversed);
    print(ReversedSearchAbleCache.length);
    if(searchkeywords == null)
      {
        return;
      }

    List<String> suggestions = <String>[];

    List<String> SuggestionsJobs = <String>[];
    JobisAlreadyAdded = <String>[];

    for(int i=0; i<JobDisplayManagement.SEARCHEDPATHS.length; i++)
    {
      if(!SuggestionsJobs.contains(JobDisplayManagement.SEARCHEDPATHS[i])) {
        JobDisplayManagement.ISLoading =   false;
        FindAndAdd(JobDisplayManagement.SEARCHEDPATHS[i], 4);
        SuggestionsJobs.add(JobDisplayManagement.SEARCHEDPATHS[i]);
      }
    }

    for(int i=0; i<searchkeywords.length; i++)
      {
        var parts = searchkeywords[i].split(" ");
        for(int j=0; j<parts.length; j++)
          {
            suggestions.add(parts[j]);
          }
      }

    int maxvalue = ReversedSearchAbleCache.length~/4;
    for(int i = 0; i <maxvalue; i++)
      {

        int a = (ReversedSearchAbleCache.length - i - 1); // 1000 - 1 = 999 i.e. 748 <= a <= 999
        int b = ReversedSearchAbleCache.length~/2 - i - 1; //500 - 1 = 499 i.e. 249 <= b <= 499
        int c = ReversedSearchAbleCache.length~/2 + i; //500 = 500 i.e. 500 <= c <= 749

        String JobString_i = ReversedSearchAbleCache[i].toLowerCase();
        String JobString_a = ReversedSearchAbleCache[a].toLowerCase();
        String JobString_b = ReversedSearchAbleCache[b].toLowerCase();
        String JobString_c = ReversedSearchAbleCache[c].toLowerCase();


        if(i == 0 || i == maxvalue - 1) {
          print("${i} => ${a}, ${b}, ${c} and ${ReversedSearchAbleCache.length / 4}");
        }


        for(int j=0; j<searchkeywords.length; j++)
        {

          List<String> Keys = searchkeywords[j].split(" ");

          if(JobString_i.contains(searchkeywords[j]) || (Keys.length >= 2 && JobString_i.contains(Keys[0]) && JobString_a.contains(Keys[1])))
          {
            String JobString = ReversedSearchAbleCache[i];//ReversedSearchAbleCache[i].split(";").length == 3 ? ReversedSearchAbleCache[i].split(";")[2] : ReversedSearchAbleCache[i].split(";")[0];
            if(!JobisAlreadyAdded.contains(JobString)) {
              FindAndAdd(JobString, 4);
              JobisAlreadyAdded.add(JobString);
            }
          }
          else if(JobString_a.contains(searchkeywords[j]) || (Keys.length >= 2 && JobString_a.contains(Keys[0]) && JobString_a.contains(Keys[1])))
          {
            String JobString = ReversedSearchAbleCache[a];//ReversedSearchAbleCache[a].split(";").length == 3 ? ReversedSearchAbleCache[a].split(";")[2] : ReversedSearchAbleCache[a].split(";")[0];
            if(!JobisAlreadyAdded.contains(JobString)) {
              FindAndAdd(JobString, 4);
              JobisAlreadyAdded.add(JobString);
            }
          }
          else if(JobString_b.contains(searchkeywords[j]) || (Keys.length >= 2 && JobString_b.contains(Keys[0]) && JobString_b.contains(Keys[1])))
          {
            String JobString = ReversedSearchAbleCache[b];//ReversedSearchAbleCache[b].split(";").length == 3 ? ReversedSearchAbleCache[b].split(";")[2] : ReversedSearchAbleCache[b].split(";")[0];
            if(!JobisAlreadyAdded.contains(JobString)) {
              FindAndAdd(JobString, 4);
              JobisAlreadyAdded.add(JobString);
            }
          }
          else if(JobString_c.contains(searchkeywords[j]) || (Keys.length >= 2 && JobString_c.contains(Keys[0]) && JobString_c.contains(Keys[1])))
          {
            String JobString = ReversedSearchAbleCache[c];//ReversedSearchAbleCache[c].split(";").length == 3 ? ReversedSearchAbleCache[c].split(";")[2] : ReversedSearchAbleCache[c].split(";")[0];
            if(!JobisAlreadyAdded.contains(JobString)) {
              FindAndAdd(JobString, 4);
              JobisAlreadyAdded.add(JobString);
            }
          }
        }


        ////JobDisplayManagement.SEARCHJOBSC.add(//JobDisplayManagement.SEARCHJOBS);


        for(int j=0; j<suggestions.length; j++)
        {
          if(JobString_i.contains(suggestions[j]))
          {
            String JobString = ReversedSearchAbleCache[i];//JobString_i.split(";").length == 3 ? JobString_i.split(";")[2] : JobString_i.split(";")[0];
            if(!JobisAlreadyAdded.contains(JobString)) {
              SuggestionsJobs.add(JobString);
              JobisAlreadyAdded.add(JobString);
            }
          }
          else if(JobString_a.contains(suggestions[j]))
          {
            String JobString = ReversedSearchAbleCache[a];//JobString_a.split(";").length == 3 ? JobString_a.split(";")[2] : JobString_a.split(";")[0];
            if(!JobisAlreadyAdded.contains(JobString)) {
              SuggestionsJobs.add(JobString);
              JobisAlreadyAdded.add(JobString);
            }
          }
          else if(JobString_b.contains(suggestions[j]))
          {
            String JobString = ReversedSearchAbleCache[b];//JobString_b.split(";").length == 3 ? JobString_b.split(";")[2] : JobString_b.split(";")[0];
            if(!JobisAlreadyAdded.contains(JobString)) {
              SuggestionsJobs.add(JobString);
              JobisAlreadyAdded.add(JobString);
            }
          }
          else if(JobString_c.contains(suggestions[j]))
          {
            String JobString = ReversedSearchAbleCache[c];//JobString_c.split(";").length == 3 ? JobString_c.split(";")[2] : JobString_c.split(";")[0];
            if(!JobisAlreadyAdded.contains(JobString)) {
              SuggestionsJobs.add(JobString);
              JobisAlreadyAdded.add(JobString);
            }
          }
        }

        JobDisplayManagement.SEARCHJOBS.addAll(beforeyears);
        ////JobDisplayManagement.SEARCHJOBSC.add(//JobDisplayManagement.SEARCHJOBS);
        //s
        // if(i == (maxvalue -1) && SuggestionsJobs.isNotEmpty) {
        //   if(JobDisplayManagement.SEARCHJOBS.length < 10) {
        //     if(SuggestionsJobs.length > 10) {
        //       LetsDisplayJobs(SuggestionsJobs.sublist(0, 10));
        //     }
        //     else{
        //       LetsDisplayJobs(SuggestionsJobs);
        //     }
        //   }
        // }

      }

  }


  static Future<void> Execute() async {
    await LoadJobIndex();
  }

}