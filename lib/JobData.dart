

import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:governmentapp/VacancyDetails.dart';

class JobData{
  String Key = "";
  String Department = "";
  String Title = "";
  String Short_Details = "";
  String DocumentRequired = "";
  String DataProviderUrl = "";
  Map<String, dynamic> Important_Dates = new Map<String, dynamic>();
  Map<String, dynamic> ApplicationFees = new Map<String, dynamic>();
  String Total_Vacancies = "";
  List<VacancyDetails> VDetails = <VacancyDetails>[];
  String HowToApply = "";
  String ApplyLink = "";
  String NotificationLink = "";
  String WebsiteLink = "";
  String url = "";
  String Location = "";
  String vdetailsquery = "";


  bool isSave = false;


  String CToString()
  {
    return Key + ";;;" + Department + ";;;" + Title + ";;;" + Short_Details + ";;;" +
    DocumentRequired + ";;;" + DataProviderUrl + ";;;" +Important_Dates.toString() + ";;;" +ApplicationFees.toString() +
    Total_Vacancies + ";;;" + HowToApply + ";;;" + NotificationLink + ";;;" +WebsiteLink + ";;;" +
    url + ";;;" + Location + ";;;" + vdetailsquery + ";;;";
  }

  Future<Map> toJson() async {

    List VDetailslst = [];

    await Future.forEach(VDetails, (VacancyDetails element) async {
      VDetailslst.add(await element.toJson());
    });

    return {
      "Key": Key,
      "Department": Department,
      "Title": Title,
      "Short_Details": Short_Details,
      "DocumentRequired": DocumentRequired,
      "DataProviderUrl": DataProviderUrl,
      "Important_Dates": jsonEncode(Important_Dates),
      "ApplicationFees": jsonEncode(ApplicationFees),
      "Total_Vacancies": Total_Vacancies,
      "VDetails": vdetailsquery,
      "HowToApply" : HowToApply,
      "ApplyLink" : ApplyLink,
      "NotificationLink" : NotificationLink,
      "WebsiteLink": WebsiteLink,
      "url" : url,
      "Location": Location,
      "vdetailsquery": vdetailsquery,
    };
  }

  Future<void> fromJson(String json)
  async {
    var data = jsonDecode(json);

    vdetailsquery = data["vdetailsquery"];
    print("VDQ ${vdetailsquery}");
    if(vdetailsquery != "") {
      await LoadVDetails(vdetailsquery);
    }
     Key = data["Key"];
     Department = data["Department"];
     Title = data["Title"];
     Short_Details = data["Short_Details"];
     DocumentRequired = data["DocumentRequired"];
     DataProviderUrl = data["DataProviderUrl"];
     Important_Dates = jsonDecode(data["Important_Dates"]);
     ApplicationFees = jsonDecode(data["ApplicationFees"]);
     Total_Vacancies = data["Total_Vacancies"];

     //List<dynamic> vdetails = jsonDecode(data["VDetails"]);

     ////print("LENGTH: " + data["VDetails"].toString());
     // vdetails.forEach((element) {
     //   //print("EEE = " + element);
     // });


    HowToApply = data["HowToApply"];
     ApplyLink = data["ApplyLink"];
     NotificationLink = data["NotificationLink"];
     WebsiteLink = data["WebsiteLink"];
     url = data["url"];
     Location = data["Location"];
  }

  Future<void> LoadVDetails(String vdetailsqry) async {
      //print("Start1");

      List<dynamic> AllDatas = <dynamic>[];

      try {
        AllDatas = jsonDecode(vdetailsqry);
      }
      catch(e)
    {
      print("Here is error " + vdetailsqry);
      return;
    }

      AllDatas.forEach((ele) async {
        try {
          var element = ele; //.toString().replaceAll("\"\\\"", "").replaceAll('"\"', "").replaceAll('\""', "");
          //print(element);
          var myele = jsonDecode(element);

          VacancyDetails vacancyDetails = new VacancyDetails();
          vacancyDetails.Title = myele["Title"].toString();
          vacancyDetails.TotalVacancies = myele["TotalVacancies"] ?? 0;

          //print("DATAS = " + myele["data"].toString().replaceAll(r'"\"', "").replaceAll(r'\""', ''));
          //vacancyDetails.datas = jsonDecode(myele["data"]);
          var myheader = myele["headers"];
          if (myheader.runtimeType == String) {
            vacancyDetails.headers = jsonDecode(await myele["headers"]);
          }
          else {
            vacancyDetails.headers = myheader;
          }

          List<dynamic> datas = <dynamic>[];
          var mydata = myele["data"];
          if(mydata.runtimeType == String)
            {
              datas = jsonDecode(mydata);
            }
          else{
            datas = mydata;
          }
          //List<dynamic> datas = jsonDecode(await myele["data"]);

          await Future.forEach(datas, (dynamic isdata) {
            VacancyDetailsData vacancyDetailsData = new VacancyDetailsData();

            var vddata = isdata.toString().replaceAll('"', "").replaceAll("[", "").replaceAll("]", "");
            var vddatas = vddata.split(",");

            vacancyDetailsData.data = vddatas;

            vacancyDetails.datas.add(vacancyDetailsData);
          });
          VDetails.add(vacancyDetails);

        }
        catch (e) {
          print("After eroor = " + e.toString());
        }
      });


      //print("End1");
  }

  Future<void> LoadingVDetails(var job, var ref) async {

    var vdetailsquerylist = <String>[];
    print("Flag A");
    var LVD_VDetails = await ref.collection("Jobs" + "/" + job.data()["Department"] + "/" + job.data()["Location"].toString().toUpperCase() + "/" + job.id + "/VDetails").get();
    print("Flag B");
    int indx = 0;
    await Future.forEach(LVD_VDetails.docs, (vdtl) async {
      print("RunType = " + vdtl.runtimeType.toString());
      print("Flag C");
      var data = LVD_VDetails.docs[indx].data();
      VacancyDetails vacancyDetails = new VacancyDetails();
      vacancyDetails.Title = data["Title"];
      vacancyDetails.TotalVacancies = data["TotalVacancies"];
      vacancyDetails.headers = data["headers"];
      print("Flag D");
      var vdetailquery = {
        "Title": data["Title"],
        "TotalVacancies": data["TotalVacancies"],
        "headers": data["headers" ],
        "data": null,
      };
      print("Flag E");
      var LVD_VDetailData = await ref.collection("Jobs" + "/" + job.data()["Department"] + "/" + job.data()["Location"].toString().toUpperCase() + "/" + job.id + "/VDetails/" + LVD_VDetails.docs[indx].id + "/VacancyDetailsData").get();
      print("Flag F");
      List<String> vacancydata = <String>[];
      int p = 0;
      await Future.forEach(LVD_VDetailData.docs, (ele) async {
        print("Flag G");
        var VDetailDataA = LVD_VDetailData.docs[p].data();
        VacancyDetailsData vacancyDetailsData = new VacancyDetailsData();
        vacancyDetailsData.data = VDetailDataA["data"];
        //vacancyDetailsData.data = VDetailDataA["data"];

        vacancyDetails.datas.add(vacancyDetailsData);
        vacancydata.add(jsonEncode(VDetailDataA["data"].toString()));

        vdetailquery["data"] = jsonEncode(vacancydata);

        if (p == VDetailDataA.length - 1) {
          var cc = await jsonEncode(vdetailquery);
          vdetailsquerylist.add(cc);
          vdetailsquery = await jsonEncode(vdetailsquerylist);
        }
        p++;
      });
      VDetails.add(vacancyDetails);
      indx++;
    });
  }

  Future<void> LoadFromFireStoreValues(var job) async {
    var ref = FirebaseFirestore.instance;

    Title = job.data()["Title"];
    Department = job.data()["Department"];
    url = job.data()["URL"];
    Total_Vacancies = job.data()["Total_Vacancies"];
    WebsiteLink = job.data()["WebsiteLink"];
    Location = job.data()["Location"];
    ApplicationFees = job.data()["ApplicationFees"];
    Important_Dates = job.data()["Important_Dates"];
    HowToApply = job.data()["HowToApply"];
    Key = job.id;
    ApplyLink = job.data()["ApplyLink"];
    WebsiteLink = job.data()["WebsiteLink"];
    NotificationLink = job.data()["NotificationLink"];

    Short_Details =
        job.data()["Short_Details"].toString().replaceAll(
            "Short Details of Notification", "");


    if (Short_Details.replaceAll(
        "Short Details of Notification", "") == "" ||
        Short_Details.replaceAll(
            "Short Details of Notification", "") == "\n") {
      Short_Details =
          job.data()["Total_Vacancies"].toString().replaceAll(
              "Vacancy Details Total : ", "");
    }


    await LoadingVDetails(job, ref);
    print("REQ " + vdetailsquery);


  }



  void GetFromString(String data){
    var allvars = data.split(";;;");

    for(int i=0; i<allvars.length; i++)
      {
        switch(i)
        {
          case 0:
            Key = allvars[i];
            break;
          case 1:
            Department = allvars[i];
            break;
          case 2:
            Title = allvars[i];
            break;
          case 3:
            Short_Details = allvars[i];
            break;
          case 4:
            DocumentRequired = allvars[i];
            break;
          case 5:
            DataProviderUrl = allvars[i];
            break;
          case 6:
            var data = allvars[i].split(",");
            Map<String, dynamic> Important_Dates = Map<String, dynamic>();
            data.forEach((element) => Important_Dates[element.split(":")[0]] = element.split(":").length > 1 ? element.split(":")[1] : "");
            break;
          case 7:
            var data = allvars[i].split(",");
            Map<String, dynamic> ApplicationFees = Map<String, dynamic>();
            data.forEach((element) => ApplicationFees[element.split(":")[0]] = element.split(":").length > 1 ? element.split(":")[1] : "");
            break;
          case 8:
            Total_Vacancies = allvars[i];
            break;
          case 9:
            HowToApply = allvars[i];
            break;
          case 10:
            ApplyLink = allvars[i];
            break;
          case 11:
            NotificationLink =  allvars[i];
            break;
          case 12:
            WebsiteLink =  allvars[i];
            break;
          case 13:
            url = allvars[i];
            break;
          case 14:
            Location = allvars[i];
            break;
        }
      }
  }
}
