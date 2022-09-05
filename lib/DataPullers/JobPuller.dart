//
//
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:governmentapp/DataPullers/Scrapper.dart';
// import 'package:governmentapp/DataPullers/WriteToFirebase.dart';
// import 'package:governmentapp/JobData.dart';
// import 'package:html/parser.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
// class JobPuller{
//
//   String LatestJobsLastLink = "";
//   String NewLatestJobsLastLink = "";
//   int LastSavedSizes = 0;
//   int NewLastSavedSizes = 0;
//
//
//   WriteToFirebase writeToFirebase = WriteToFirebase();
//
//
//   Future<void> SaveLatestJobsLastJobIDCache()
//   async {
//     (await SharedPreferences.getInstance()).setString("LatestJobsLastLink", NewLatestJobsLastLink);
//   }
//
//   Future<String?> ReadLatestJobsLastJobIDCache()
//   async {
//     return (await SharedPreferences.getInstance()).getString("LatestJobsLastLink");
//   }
//
//   Future<String> GetLatestJobsLastJobLink() async {
//     String value = "";
//     try {
//       value = (await FirebaseFirestore.instance.collection("Logs").doc(
//           "LastSavedID").get()).data()!["LatestJobsLastLink"];
//     }
//     catch(e){
//       value = "";
//     }
//     return value;
//   }
//
//   Future<void> UpdateLatestJobsLastJobLink() async {
//     (await FirebaseFirestore.instance.collection("Logs").doc("LastSavedID").set({"LatestJobsLastLink" : NewLatestJobsLastLink}));
//   }
//
//
//   Future<int> GetLatestJobsLastJobsSize() async {
//     String value = "0";
//     try {
//       value = (await FirebaseFirestore.instance.collection("Logs").doc(
//           "LastSavedSizes").get()).data()!["LatestJobsLastSize"].toString();
//     }
//     catch(E){value = "0";}
//
//     if(value != "")
//     {
//       return int.parse(value);
//     }
//     return 0;
//   }
//
//
//   Future<void> UpdateLatestJobsLastJobsSize() async {
//     FirebaseFirestore.instance.collection("Logs").doc("LastSavedSizes").set({"LatestJobsLastSize" : NewLastSavedSizes});
//   }
//
//
//
//   Future<void> ReadLatestJobsURLs(String pagedata) async {
//     var Table = parse(pagedata).getElementsByTagName("table");
//     var Links = Table[0].getElementsByTagName("a");
//
//     int NetDataSize = Links.length;
//     NewLastSavedSizes = LastSavedSizes;
//
//     int l = 0;
//     for(int i=(NetDataSize - LastSavedSizes) - 1; i>=0 /*&& l < 10*/; i--)
//     {
//       String link = Links[i].attributes["href"].toString();
//
//       Scrapper scrapper = Scrapper();
//       await scrapper.Start(link).then((JobData jobData) async {
//         await WriteToFirebase.WriteToJob(jobData);
//         await WriteToFirebase.WriteIndexToFirebase(jobData);
//         NewLastSavedSizes++;
//         await UpdateLatestJobsLastJobsSize();
//       });
//       l++;
//     }
//
//   }
//
//
// }