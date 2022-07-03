import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:governmentapp/Files/DepartmentBox.dart';
import 'package:governmentapp/Files/JobBox.dart';
import 'package:governmentapp/JobData.dart';
import 'package:governmentapp/VacancyDetails.dart';
import 'package:shared_preferences/shared_preferences.dart';


class JobBoxs extends StatefulWidget {
  const JobBoxs({Key? key}) : super(key: key);

  @override
  State<JobBoxs> createState() => _JobBoxsState();
}

class _JobBoxsState extends State<JobBoxs> {

  var States = <String>["India", "Delhi","Andaman and Nicobar", "Andaman and Nicobar", "Andhra Pradesh", "Arunachal Pradesh", "Assam", "Bihar", "Chandigarh", "Chhattisgarh", "Dadra and Nagar Haveli", "Daman and Diu", "Delhi", "Goa", "Gujarat", "Haryana", "Himachal Pradesh", "Jammu and Kashmir", "Jharkhand", "Karnataka", "Kerala", "Lakshadweep", "Madhya Pradesh", "Maharashtra", "Manipur", "Meghalaya", "Mizoram", "Nagaland", "Orissa", "Puducherry", "Punjab", "Rajasthan", "Sikkim", "Tamil Nadu", "Telangana", "Tripura", "Uttar Pradesh", "Uttarakhand", "West Bengal"];
  var UserDepartments = <String>[];
  var UserStates = <String>[];
  var UserIntrests = <String>[];
  var AllDepartmentsList = <Widget>[];
  var LovedJobs = <String>[];


  Future<void> LoadPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    print("Loading Pref Run1");
    UserDepartments = (await prefs.getStringList('UserDepartments'))!;
    UserStates = (await prefs.getStringList('UserStates'))!;
    UserIntrests = (await prefs.getStringList('UserInterest'))!;
    LovedJobs = (await prefs.getStringList('lovedjobs'))!;
    print("Loading Pref Run2");
  }


  Future<void> Load_My_Jobs(String keyword, bool isloved)
  async {

    print("Loading Pref Started");
      await LoadPrefs();
    print("Loading Pref Ended");

    //SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    var _AllDepartmentsList = <Widget>[];
    Map<String, List<JobBox>> _ToShowJobs = new Map<String, List<JobBox>>();

    var ref = FirebaseFirestore.instance;
    var Departments = await ref.collection("Jobs").get();

    int index = 0;
    var AllDocs = await Departments.docs;
     for (var department in Departments.docs) {

       index++;
      //print(department.id);
      //States.forEach((state) async {
        var statesToSearch = <String>[];

       await Future.forEach(States, (state) {
          if(department.id.toLowerCase().contains(state.toString().toLowerCase()))
            {
              statesToSearch.add(state.toString().toUpperCase());
            }
        });

        statesToSearch.isEmpty ? statesToSearch.add("INDIA") : statesToSearch;

        await Future.forEach(statesToSearch, (state) async {
          var Jobs = await ref.collection("Jobs" + "/" + department.id + "/" + state.toString().toUpperCase()).get();
          for (var job in Jobs.docs) {

            if(job.data()["Title"].toString().toLowerCase().contains(keyword.toLowerCase()) || job.data()["Department"].toString().toLowerCase().contains(keyword.toLowerCase()))
              {
                if (kDebugMode) {
                  print(job.id + " " + job.data()["Location"].toString());
                }


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

                print("<" + jobData.Short_Details + ">");

                if(jobData.Short_Details.replaceAll("Short Details of Notification", "") == "" || jobData.Short_Details.replaceAll("Short Details of Notification", "") == "\n")
                {
                  jobData.Short_Details = job.data()["Total_Vacancies"].toString().replaceAll("Vacancy Details Total : ", "");
                }

                ref.collection("Jobs" + "/" + department.id + "/" + state.toString().toUpperCase() + "/" + job.id + "/VDetails").get().then((vdetails){
                  vdetails.docs.forEach((vdtl) {
                    VacancyDetails vacancyDetails = new VacancyDetails();
                    vacancyDetails.Title = vdtl.data()["Title"];
                    vacancyDetails.TotalVacancies = vdtl.data()["TotalVacancies"];
                    vacancyDetails.headers = vdtl.data()["headers"];

                    ref.collection("Jobs" + "/" + department.id + "/" + state.toString().toUpperCase() + "/" + job.id + "/VDetails/" + vdtl.id + "/VacancyDetailsData").get().then((vdetaildata){
                      vdetaildata.docs.forEach((vdtldata) {
                        VacancyDetailsData vacancyDetailsData = new VacancyDetailsData();
                        vacancyDetailsData.data = vdtldata.data()["data"];

                        vacancyDetails.datas.add(vacancyDetailsData);
                      });
                    });

                    jobData.VDetails.add(vacancyDetails);

                  });
                });

                if(!_ToShowJobs.containsKey(jobData.Department))
                  {
                    _ToShowJobs[jobData.Department] = <JobBox>[];
                  }

                _ToShowJobs[jobData.Department]!.add(JobBox(isClicked: false, jobData: jobData));
                print(_ToShowJobs.length.toString() + " is lenght");
              }

          }
        });

       if(index == AllDocs.length)
       {
         print("INDEX REACHED" + _ToShowJobs.length.toString());
         _ToShowJobs.forEach((key, value) {
           _AllDepartmentsList.add(DepartmentBox(DepartmentName: key, jobboxes: value));

           setState(() {
             AllDepartmentsList = _AllDepartmentsList;
           });
         });
       }



      //});
    }



    
  }



  @override
  void initState() {
    Load_My_Jobs("Haryana", false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: AllDepartmentsList,
      ),
    );
  }
}
