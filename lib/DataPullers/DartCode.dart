// JobData jobData = new JobData();
// jobData.Title = job.data()["Title"];
// jobData.Department = job.data()["Department"];
// jobData.url = job.data()["URL"];
// jobData.Total_Vacancies = job.data()["Total_Vacancies"];
// jobData.WebsiteLink = job.data()["WebsiteLink"];
// jobData.Location = job.data()["Location"];
// jobData.ApplicationFees = job.data()["ApplicationFees"];
// jobData.Important_Dates = job.data()["Important_Dates"];
// jobData.HowToApply = job.data()["HowToApply"];
// jobData.Key = job.id;
// jobData.ApplyLink = job.data()["ApplyLink"];
// jobData.WebsiteLink = job.data()["WebsiteLink"];
// jobData.NotificationLink = job.data()["NotificationLink"];
//
// jobData.Short_Details = job.data()["Short_Details"].toString().replaceAll("Short Details of Notification", "");
//
// print("<" + jobData.Short_Details + ">");
//
// if(jobData.Short_Details.replaceAll("Short Details of Notification", "") == "" || jobData.Short_Details.replaceAll("Short Details of Notification", "") == "\n")
// {
// jobData.Short_Details = job.data()["Total_Vacancies"].toString().replaceAll("Vacancy Details Total : ", "");
// }
//
// FirebaseFirestore.instance.collection(link + "/" + job.id + "/VDetails").get().then((vdetails){
// vdetails.docs.forEach((vdtl) {
// VacancyDetails vacancyDetails = new VacancyDetails();
// vacancyDetails.Title = vdtl.data()["Title"];
// vacancyDetails.TotalVacancies = vdtl.data()["TotalVacancies"];
// vacancyDetails.headers = vdtl.data()["headers"];
//
// FirebaseFirestore.instance.collection(link + "/" + job.id + "/VDetails/" + vdtl.id + "/VacancyDetailsData").get().then((vdetaildata){
// vdetaildata.docs.forEach((vdtldata) {
// VacancyDetailsData vacancyDetailsData = new VacancyDetailsData();
// vacancyDetailsData.data = vdtldata.data()["data"];
//
// vacancyDetails.datas.add(vacancyDetailsData);
// });
// });
//
// jobData.VDetails.add(vacancyDetails);
//
// });
// });



//------------------------------------------


//
// Future<void> Load_My_Jobs(String keyword)
// async {
//
//   await LoadPrefs();
//
//   var _AllDepartmentsList = <Widget>[];
//   Map<String, List<JobBox>> _ToShowJobs = new Map<String, List<JobBox>>();
//
//   var ref = FirebaseFirestore.instance;
//   var Departments = await ref.collection("Jobs").get();
//
//   int index = 0;
//   var AllDocs = await Departments.docs;
//   for (var department in Departments.docs) {
//
//     index++;
//     //print(department.id);
//     //States.forEach((state) async {
//     var statesToSearch = <String>[];
//
//     await Future.forEach(States, (state) {
//       if(department.id.toLowerCase().contains(state.toString().toLowerCase()))
//       {
//         statesToSearch.add(state.toString().toUpperCase());
//       }
//     });
//
//     statesToSearch.isEmpty ? statesToSearch.add("INDIA") : statesToSearch;
//
//     await Future.forEach(statesToSearch, (state) async {
//       var Jobs;
//       try {
//         Jobs = await ref.collection("Jobs" + "/" + department.id + "/" +
//             state.toString().toUpperCase()).get();
//       }
//       catch(e){
//
//       }
//       for (var job in Jobs.docs) {
//
//         if(job.data()["Title"].toString().toLowerCase().contains(keyword.toLowerCase()) || job.data()["Department"].toString().toLowerCase().contains(keyword.toLowerCase()))
//         {
//           if (kDebugMode) {
//             print(job.id + " " + job.data()["Location"].toString());
//           }
//
//
//           JobData jobData = new JobData();
//           jobData.Title = job.data()["Title"];
//           jobData.Department = job.data()["Department"];
//           jobData.url = job.data()["URL"];
//           jobData.Total_Vacancies = job.data()["Total_Vacancies"];
//           jobData.WebsiteLink = job.data()["WebsiteLink"];
//           jobData.Location = job.data()["Location"];
//           jobData.ApplicationFees = job.data()["ApplicationFees"];
//           jobData.Important_Dates = job.data()["Important_Dates"];
//           jobData.HowToApply = job.data()["HowToApply"];
//           jobData.Key = job.id;
//           jobData.ApplyLink = job.data()["ApplyLink"];
//           jobData.WebsiteLink = job.data()["WebsiteLink"];
//           jobData.NotificationLink = job.data()["NotificationLink"];
//
//           jobData.Short_Details = job.data()["Short_Details"].toString().replaceAll("Short Details of Notification", "");
//
//           print("<" + jobData.Short_Details + ">");
//
//           if(jobData.Short_Details.replaceAll("Short Details of Notification", "") == "" || jobData.Short_Details.replaceAll("Short Details of Notification", "") == "\n")
//           {
//             jobData.Short_Details = job.data()["Total_Vacancies"].toString().replaceAll("Vacancy Details Total : ", "");
//           }
//
//           ref.collection("Jobs" + "/" + department.id + "/" + state.toString().toUpperCase() + "/" + job.id + "/VDetails").get().then((vdetails){
//             vdetails.docs.forEach((vdtl) {
//               VacancyDetails vacancyDetails = new VacancyDetails();
//               vacancyDetails.Title = vdtl.data()["Title"];
//               vacancyDetails.TotalVacancies = vdtl.data()["TotalVacancies"];
//               vacancyDetails.headers = vdtl.data()["headers"];
//
//               ref.collection("Jobs" + "/" + department.id + "/" + state.toString().toUpperCase() + "/" + job.id + "/VDetails/" + vdtl.id + "/VacancyDetailsData").get().then((vdetaildata){
//                 vdetaildata.docs.forEach((vdtldata) {
//                   VacancyDetailsData vacancyDetailsData = new VacancyDetailsData();
//                   vacancyDetailsData.data = vdtldata.data()["data"];
//
//                   vacancyDetails.datas.add(vacancyDetailsData);
//                 });
//               });
//
//               jobData.VDetails.add(vacancyDetails);
//
//             });
//           });
//
//           if((isloved && LovedJobs.contains(jobData.Key) && (keyword == "" || jobData.Title.toLowerCase().contains(keyword.toLowerCase()) || jobData.Department.toLowerCase().contains(keyword.toLowerCase()) || jobData.Location.toLowerCase().contains(keyword.toLowerCase()))) || (!isloved && (keyword == "" || jobData.Title.toLowerCase().contains(keyword.toLowerCase()) || jobData.Department.toLowerCase().contains(keyword.toLowerCase()) || jobData.Location.toLowerCase().contains(keyword.toLowerCase())))) {
//
//             if (!_ToShowJobs.containsKey(jobData.Department)) {
//               _ToShowJobs[jobData.Department] = <JobBox>[];
//             }
//
//             _ToShowJobs[jobData.Department]!.add(
//                 JobBox(isClicked: false, jobData: jobData));
//             print(_ToShowJobs.length.toString() + " is lenght");
//           }
//         }
//
//       }
//     });
//
//     if(index == AllDocs.length)
//     {
//       print("INDEX REACHED" + _ToShowJobs.length.toString());
//       _ToShowJobs.forEach((key, value) {
//         _AllDepartmentsList.add(DepartmentBox(DepartmentName: key, jobboxes: value));
//
//         setState(() {
//           AllDepartmentsList = _AllDepartmentsList;
//         });
//       });
//     }
//
//   }
//
//
//
//
// }
//
