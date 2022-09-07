

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:governmentapp/DataLoadingSystem/SearchAbleDataLoading.dart';
import 'package:governmentapp/DataPullers/WriteToFirebase.dart';

class FilterIndexes{
  static Future<void> RemoveOlds() async {
    var SrchC = <String>[];
    var Indexs = await FirebaseFirestore.instance.collection("Indexs").doc("Jobs").get();


    if(Indexs.exists)
      {
        var Indexes = Indexs.data()!["SearchAbleCache"] as List<dynamic>;
        var NEWIndexes = <String>[];
        print(Indexes.length.toString() + " " + DateTime.now().toString());
        Indexes.forEach((element) {
          String c = element.toString();
          
          if(
              (c.contains("2015") ||
              c.contains("2016") ||
              c.contains("2017") ||
              c.contains("2018") ||
              c.contains("2019") ||
              c.contains("2020")) && (!c.contains(DateTime.now().year.toString()))
          )
            {

            }
          else{
            SearchAbleDataLoading.SearchAbleCache.add(c);
          }
        });
        print(SearchAbleDataLoading.SearchAbleCache.length.toString() + " " + DateTime.now().toString());
        await SearchAbleDataLoading.JobIndexSaveToFirebase();
      }
  }
}