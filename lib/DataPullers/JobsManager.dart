

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:governmentapp/Files/JobBox.dart';
import 'package:governmentapp/JobData.dart';
import 'package:governmentapp/VacancyDetails.dart';
import 'package:shared_preferences/shared_preferences.dart';

class JobsManager{
  static List<JobData> jobs = <JobData>[];
  static List<JobData> filtered_jobs = <JobData>[];


  static Future<void> LoadAllJobs(String keyword)
  async {
    var States = <String>["India", "Delhi","Andaman and Nicobar", "Andaman and Nicobar", "Andhra Pradesh", "Arunachal Pradesh", "Assam", "Bihar", "Chandigarh", "Chhattisgarh", "Dadra and Nagar Haveli", "Daman and Diu", "Delhi", "Goa", "Gujarat", "Haryana", "Himachal Pradesh", "Jammu and Kashmir", "Jharkhand", "Karnataka", "Kerala", "Lakshadweep", "Madhya Pradesh", "Maharashtra", "Manipur", "Meghalaya", "Mizoram", "Nagaland", "Orissa", "Puducherry", "Punjab", "Rajasthan", "Sikkim", "Tamil Nadu", "Telangana", "Tripura", "Uttar Pradesh", "Uttarakhand", "West Bengal"];

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
        var Jobs;
        try {
          Jobs = await ref.collection("Jobs" + "/" + department.id + "/" +
              state.toString().toUpperCase()).get();
        }
        catch(e){

        }
        for (var job in Jobs.docs) {

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
            jobs.add(jobData);
        }
      });
    }
  }

  static Future<List<JobData>> FilteredJobs(String keyword, bool isloved) async {
    filtered_jobs.clear();
    var LovedJobs = <String>[];
    final prefs = await SharedPreferences.getInstance();
    LovedJobs = (await prefs.getStringList('lovedjobs'))!;

    jobs.forEach((job) {
        if(((isloved && LovedJobs.contains(job.Key)) || (!isloved)) && (keyword == "" || job.Title.toLowerCase().contains(keyword.toLowerCase()) || job.Department.toLowerCase().contains(keyword.toLowerCase())))
        {
          filtered_jobs.add(job);
        }
    });

    return filtered_jobs;
  }
}