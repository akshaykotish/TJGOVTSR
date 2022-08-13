

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:governmentapp/JobData.dart';

import '../VacancyDetails.dart';

class TempAllJobs{

  static List<JobData> jobDatas = <JobData>[];
  static var States = <String>["India","Andaman and Nicobar", "Andaman and Nicobar", "Andhra Pradesh", "Arunachal Pradesh", "Assam", "Bihar", "Chandigarh", "Chhattisgarh", "Dadra and Nagar Haveli", "Daman and Diu", "Delhi", "Goa", "Gujarat", "Haryana", "Himachal Pradesh", "Jammu and Kashmir", "Jharkhand", "Karnataka", "Kerala", "Lakshadweep", "Madhya Pradesh", "Maharashtra", "Manipur", "Meghalaya", "Mizoram", "Nagaland", "Orissa", "Puducherry", "Punjab", "Rajasthan", "Sikkim", "Tamil Nadu", "Telangana", "Tripura", "Uttar Pradesh", "Uttarakhand", "West Bengal"];

  static void LoadForSearch(String toSearch)
  {
    FirebaseFirestore.instance.collection("Jobs").get().then((jobs) {
      jobs.docs.forEach((job) {
        for(var state in States) {
          FirebaseFirestore.instance.doc("Jobs/" + job.id).collection(state.toUpperCase()).get().then((
              GetJobDatas) {
              GetJobDatas.docs.forEach((GetJobData) {
                JobData jobData = new JobData();
                jobData.Title = GetJobData.data()["Title"];
                jobData.Department = GetJobData.data()["Department"];
                jobData.url = GetJobData.data()["URL"];
                jobData.Total_Vacancies = GetJobData.data()["Total_Vacancies"];
                jobData.WebsiteLink = GetJobData.data()["WebsiteLink"];
                jobData.Location = GetJobData.data()["Location"];
                jobData.ApplicationFees = GetJobData.data()["ApplicationFees"];
                jobData.Important_Dates = GetJobData.data()["Important_Dates"];
                jobData.HowToApply = GetJobData.data()["HowToApply"];
                jobData.Key = GetJobData.id;
                jobData.ApplyLink = GetJobData.data()["ApplyLink"];
                jobData.WebsiteLink = GetJobData.data()["WebsiteLink"];
                jobData.NotificationLink = GetJobData.data()["NotificationLink"];

                jobData.Short_Details = GetJobData.data()["Short_Details"].toString().replaceAll("Short Details of Notification", "");

                print("<" + jobData.Short_Details + ">");

                if(jobData.Short_Details.replaceAll("Short Details of Notification", "") == "" || jobData.Short_Details.replaceAll("Short Details of Notification", "") == "\n")
                {
                  jobData.Short_Details = GetJobData.data()["Total_Vacancies"].toString().replaceAll("Vacancy Details Total : ", "");
                }

                FirebaseFirestore.instance.collection("Jobs/" + job.id + "/" + state + "/" + GetJobData.id + "/VDetails").get().then((vdetails){
                  vdetails.docs.forEach((vdtl) {
                    VacancyDetails vacancyDetails = new VacancyDetails();
                    vacancyDetails.Title = vdtl.data()["Title"];
                    vacancyDetails.TotalVacancies = vdtl.data()["TotalVacancies"];
                    vacancyDetails.headers = vdtl.data()["headers"];

                    FirebaseFirestore.instance.collection("Jobs/" + job.id + "/" + state + "/" + GetJobData.id + "/VDetails/" + vdtl.id + "/VacancyDetailsData").get().then((vdetaildata){
                      vdetaildata.docs.forEach((vdtldata) {
                        VacancyDetailsData vacancyDetailsData = new VacancyDetailsData();
                        vacancyDetailsData.data = vdtldata.data()["data"];

                        vacancyDetails.datas.add(vacancyDetailsData);
                      });
                    });

                    jobData.VDetails.add(vacancyDetails);

                  });
                });

                jobDatas.add(jobData);
              });
          });
        }
      });
    });
  }

}
