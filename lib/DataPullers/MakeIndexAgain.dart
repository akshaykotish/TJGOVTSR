import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:governmentapp/DataLoadingSystem/Locations.dart';
import 'package:governmentapp/DataLoadingSystem/SearchAbleDataLoading.dart';
import 'package:governmentapp/DataPullers/WriteToFirebase.dart';
import 'package:governmentapp/JobData.dart';

class MakeIndexAgain{
  
  static Future<void> CleanIndex() async {
    SearchAbleDataLoading.SearchAbleCache.clear();
    await FirebaseFirestore.instance.collection("Indexs").doc("Jobs").delete();
  }

 static Future<void> MakeIndexOfJobs() async {
    var Departments = await FirebaseFirestore.instance.collection("Jobs").get();
    for(var Department in Departments.docs)
      {
        List<String> MyStates = <String>[];
        MyStates.add("INDIA");
        for(var State in Locations.locations)
          {
            if(Department.toString().toLowerCase().contains(State.toLowerCase()))
              {
                MyStates.add(State.toUpperCase());
              }
          }
        print(MyStates.length);

        for(var State in MyStates)
          {
            var Jobs = await FirebaseFirestore.instance.collection("Jobs").doc(Department.id).collection(State).get();
            for(var Job in Jobs.docs)
              {
                JobData jobData = JobData();
                String Path = "Jobs/${Department.id}/${State}/${Job.id}";
                await jobData.LoadFromFireStoreValues(Job);
                String toStore = Path + ";" + jobData.Department + ";" + jobData.Designation + ";" + jobData.Short_Details;
                
                int currentYear = DateTime.now().year;
                if(toStore.contains((currentYear-2).toString()) || toStore.contains((currentYear-1).toString()) || toStore.contains(currentYear.toString()) || toStore.contains((currentYear+1).toString())) {
                  SearchAbleDataLoading.SearchAbleCache.add(toStore);
                  print("Accepted ${jobData.Designation}");
                }
                else{
                  print("Rejected ${jobData.Designation}");
                }
              }
          }
      }
  }
  
  static Future<void> Execute() async {
    print("Before Index is ${SearchAbleDataLoading.SearchAbleCache.length}");
    await CleanIndex();
    print("After Clean Index is ${SearchAbleDataLoading.SearchAbleCache.length}");
    await MakeIndexOfJobs();
    await SearchAbleDataLoading.JobIndexSaveToFirebase();
    print("New Length of Index is ${SearchAbleDataLoading.SearchAbleCache.length}");
  }
}