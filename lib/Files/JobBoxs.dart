import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:governmentapp/Files/CurrentJob.dart';
import 'package:governmentapp/Files/DepartmentBox.dart';
import 'package:governmentapp/Files/JobBox.dart';
import 'package:governmentapp/Files/LoadedData.dart';
import 'package:governmentapp/VacancyDetails.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../JobData.dart';

class JobBoxs extends StatefulWidget {
  const JobBoxs({Key? key}) : super(key: key);

  @override
  State<JobBoxs> createState() => _JobBoxsState();
}

class _JobBoxsState extends State<JobBoxs> {

  var States = <String>["India","Andaman and Nicobar", "Andaman and Nicobar", "Andhra Pradesh", "Arunachal Pradesh", "Assam", "Bihar", "Chandigarh", "Chhattisgarh", "Dadra and Nagar Haveli", "Daman and Diu", "Delhi", "Goa", "Gujarat", "Haryana", "Himachal Pradesh", "Jammu and Kashmir", "Jharkhand", "Karnataka", "Kerala", "Lakshadweep", "Madhya Pradesh", "Maharashtra", "Manipur", "Meghalaya", "Mizoram", "Nagaland", "Orissa", "Puducherry", "Punjab", "Rajasthan", "Sikkim", "Tamil Nadu", "Telangana", "Tripura", "Uttar Pradesh", "Uttarakhand", "West Bengal"];
  var UserDepartments = <String>[];
  var UserStates = <String>[];
  var UserIntrests = <String>[];
  var AllDepartmentsList = <Widget>[];
  var LovedJobs = <String>[];

  bool isDataloaded = false;



  Future<void> LoadJobs() async {
    var _AllDepartmentsList = <Widget>[];


    final prefs = await SharedPreferences.getInstance();
    UserDepartments = (await prefs.getStringList('UserDepartments'))!;
    UserStates = (await prefs.getStringList('UserStates'))!;
    UserIntrests = (await prefs.getStringList('UserInterest'))!;
    LovedJobs = (await prefs.getStringList('lovedjobs'))!;

    var ToLoadJobs = <String>[];
    int l = 0;

    for(int i=0; i<UserDepartments.length; i++)
      {
        for(int j=0; j<UserStates.length; j++)
          {
            ToLoadJobs.add(
              "Jobs/" + UserDepartments[i] + "/" + UserStates[j].toUpperCase()
            );

            print(ToLoadJobs[l]);
            l++;
          }
      }


    int islast = 0;
    Map<String, List<JobBox>> ToShowJobs = Map<String, List<JobBox>>();
    for(var link in ToLoadJobs)
      {
        FirebaseFirestore.instance.collection(link).get().then((value){
          value.docs.forEach((job) {

            bool KeywordisAvailable = false;
            Future.forEach(UserIntrests, (element){
              if(job.data()["Title"].toString().contains(element.toString()))
              {
                KeywordisAvailable = true;
              }
            });

            KeywordisAvailable = UserIntrests.length == 0 ? true : KeywordisAvailable;



            if(!ToShowJobs.containsKey(job.data()["Department"]) && KeywordisAvailable)
              {
                ToShowJobs[job.data()["Department"]] = <JobBox>[];
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

            FirebaseFirestore.instance.collection(link + "/" + job.id + "/VDetails").get().then((vdetails){
              vdetails.docs.forEach((vdtl) {
                    VacancyDetails vacancyDetails = new VacancyDetails();
                    vacancyDetails.Title = vdtl.data()["Title"];
                    vacancyDetails.TotalVacancies = vdtl.data()["TotalVacancies"];
                    vacancyDetails.headers = vdtl.data()["headers"];

                    FirebaseFirestore.instance.collection(link + "/" + job.id + "/VDetails/" + vdtl.id + "/VacancyDetailsData").get().then((vdetaildata){
                      vdetaildata.docs.forEach((vdtldata) {
                        VacancyDetailsData vacancyDetailsData = new VacancyDetailsData();
                        vacancyDetailsData.data = vdtldata.data()["data"];

                        vacancyDetails.datas.add(vacancyDetailsData);
                      });
                    });

                    jobData.VDetails.add(vacancyDetails);

              });
            });


            LoadedJobData.LoadedjobDatas.add(jobData);
            if(KeywordisAvailable) {
              ToShowJobs[job.data()["Department"]]?.add(
                  JobBox(isClicked: false, jobData: jobData));
              print(jobData.Title);
            }
          });
        }).then((value){
          print("Is last: " + islast.toString());
          if(islast == ToLoadJobs.length - 1 && !isDataloaded) {
            isDataloaded = true;
            print("OAI: " + islast.toString());
            for (var depts in ToShowJobs.keys) {
              _AllDepartmentsList.add(
                  DepartmentBox(
                      DepartmentName: depts, jobboxes: ToShowJobs[depts]!)
              );
              _AllDepartmentsList.add(
                SizedBox(height: 50,),
              );

              setState(() {
                AllDepartmentsList = _AllDepartmentsList;
              });
            }


          }
          islast++;
        });
      }

  }


  Future<void> LoadLovedJobs() async {

    print("LovedJobs");

    AllDepartmentsList.clear();

    var _AllDepartmentsList = <Widget>[];


    final prefs = await SharedPreferences.getInstance();
    UserDepartments = (await prefs.getStringList('UserDepartments'))!;
    UserStates = (await prefs.getStringList('UserStates'))!;
    UserIntrests = (await prefs.getStringList('UserInterest'))!;


    var ToLoadJobs = <String>[];
    int l = 0;

    for(int i=0; i<UserDepartments.length; i++)
    {
      for(int j=0; j<UserStates.length; j++)
      {
        ToLoadJobs.add(
            "Jobs/" + UserDepartments[i] + "/" + UserStates[j].toUpperCase()
        );

        print(ToLoadJobs[l]);
        l++;
      }
    }


    int islast = 0;
    Map<String, List<JobBox>> ToShowJobs = Map<String, List<JobBox>>();
    for(var link in ToLoadJobs)
    {
      FirebaseFirestore.instance.collection(link).get().then((value){
        value.docs.forEach((job) {
          bool KeywordisAvailable = false;

          if (LovedJobs.contains(job.id))
          {
            KeywordisAvailable = true;
          }

          print("Keyword is ${KeywordisAvailable}");

          if(!ToShowJobs.containsKey(job.data()["Department"]) && KeywordisAvailable)
          {
            ToShowJobs[job.data()["Department"]] = <JobBox>[];
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

          FirebaseFirestore.instance.collection(link + "/" + job.id + "/VDetails").get().then((vdetails){
            vdetails.docs.forEach((vdtl) {
              VacancyDetails vacancyDetails = new VacancyDetails();
              vacancyDetails.Title = vdtl.data()["Title"];
              vacancyDetails.TotalVacancies = vdtl.data()["TotalVacancies"];
              vacancyDetails.headers = vdtl.data()["headers"];

              FirebaseFirestore.instance.collection(link + "/" + job.id + "/VDetails/" + vdtl.id + "/VacancyDetailsData").get().then((vdetaildata){
                vdetaildata.docs.forEach((vdtldata) {
                  VacancyDetailsData vacancyDetailsData = new VacancyDetailsData();
                  vacancyDetailsData.data = vdtldata.data()["data"];

                  vacancyDetails.datas.add(vacancyDetailsData);
                });
              });

              jobData.VDetails.add(vacancyDetails);

            });
          });


          LoadedJobData.LoadedjobDatas.add(jobData);
          if(KeywordisAvailable){
            ToShowJobs[job.data()["Department"]]?.add(JobBox(isClicked: false, jobData: jobData));
            print(jobData.Title + " LovedOKJobs");
          }
        });
      }).then((value){
        print("Is last: " + islast.toString());
        if(islast == ToLoadJobs.length - 1 && !isDataloaded) {
          isDataloaded = true;
          print("OAI: " + islast.toString());
          for (var depts in ToShowJobs.keys) {
            _AllDepartmentsList.add(
                DepartmentBox(
                    DepartmentName: depts, jobboxes: ToShowJobs[depts]!)
            );

            _AllDepartmentsList.add(
              SizedBox(height: 50,),
            );

            setState(() {
              AllDepartmentsList = _AllDepartmentsList;
            });
          }


        }
        islast++;
      });
    }

  }

  String GetShortForm(String text){
    var output = "";

    for(int i=0; i<text.length; i++)
      {
        if(i == 0)
          {
            output += text[i];
          }
        else if(text[i-1] == ' ')
          {
            output += text[i];
          }
        else if(text[i] == ',' || text[i] == '(' || text[i] == ')')
          {
            break;
          }
      }

    return output;
  }


  void LoadSearchJobs(List<String> searchText){

  if(searchText != null && searchText.isNotEmpty) {
    setState(() {
      AllDepartmentsList.clear();
    });

    var _AllDepartmentsList = <Widget>[];


    Map<String, List<JobBox>> ToShowJobs = Map<String, List<JobBox>>();

    print("TLJ:- " + LoadedJobData.LoadedjobDatas.length.toString());
    for (int i = 0; i < LoadedJobData.LoadedjobDatas.length; i++) {
      JobData jobData = LoadedJobData.LoadedjobDatas[i];

      bool iscontainsinany = false;
      for (int j = 0; j < searchText.length; j++) {
        if (jobData.Title.toLowerCase().contains(searchText[j].toLowerCase())) {
          iscontainsinany = true;
        }
      }
      if (iscontainsinany == true) {
        print("TLJ ADDED: " + jobData.Department);

        if (!ToShowJobs.containsKey(jobData.Department)) {
          ToShowJobs[jobData.Department] = <JobBox>[];
        }

        ToShowJobs[jobData.Department]!.add(
            JobBox(isClicked: false, jobData: jobData));
      }

      if (i == LoadedJobData.LoadedjobDatas.length - 1) {
        for (var depts in ToShowJobs.keys) {
          var db = DepartmentBox(
              DepartmentName: depts, jobboxes: ToShowJobs[depts]!);
          _AllDepartmentsList.add(db);

          _AllDepartmentsList.add(
            SizedBox(height: 50,),
          );

          setState(() {
            AllDepartmentsList = _AllDepartmentsList;
          });
        }
      }
    }
  }
  }

  List<String> ToSearchKeywords = <String>[];

  @override
  void initState() {
    LoadJobs();

    CurrentJob.currentSearchDataStreamToCall = (value){
      setState(() {
        ToSearchKeywords = value;

        LoadSearchJobs(ToSearchKeywords);
      });
    };

    CurrentJob.lovedjobDataStreamToCall = (){
      setState(() {
        LoadLovedJobs();
      });
    };

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: SingleChildScrollView(
        child: Column(
          children: AllDepartmentsList,
        ),
      ),
    );
  }
}
