import 'dart:convert';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:governmentapp/DataLoadingSystem/JobDisplayManagement.dart';
import 'package:governmentapp/VacancyDetails.dart';

class JobData {

  int count = 0;

  String Key = "UNKEY";
  String Department = "UNKNOWN";
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
  String Location = "INDIA";
  String vdetailsquery = "";
  List<dynamic> ButtonsName = <dynamic>[];
  List<dynamic> ButtonsURL = <dynamic>[];
  String Designation = "";
  String LastUpdate = "";
  String AdvertisementNumber = "";
  Map<String, dynamic> ExamCenters = new Map<String, dynamic>();
  List<dynamic> Corrections = <dynamic>[];
  Map<String, dynamic> AgeLimits = new Map<String, dynamic>();
  List<dynamic> HowTo = <dynamic>[];

  Future<void> GenerateKey() async
  {
    if(Title == "" && Designation != "")
      {
        Title = Designation;
      }
    Key =  Title.replaceAll("Online Form", "").replaceAll(
        " ", "").replaceAll("\n", "").replaceAll("/", "").replaceAll(":", "");
  }




  bool isSave = false;

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
      "HowToApply": HowToApply,
      "ApplyLink": ApplyLink,
      "NotificationLink": NotificationLink,
      "WebsiteLink": WebsiteLink,
      "url": url,
      "Location": Location,
      "vdetailsquery": vdetailsquery,
      "ButtonsName": jsonEncode(ButtonsName),
      "ButtonsURL": jsonEncode(ButtonsURL),
      "Designation": Designation,
      "LastUpdate": LastUpdate,
      "AdvertisementNumber": AdvertisementNumber,
    };
  }

  Future<void> fromJson(String json) async {
    try {
      var data = jsonDecode(json);


      try {
        vdetailsquery = data["vdetailsquery"];
        //print("VDQ ${vdetailsquery}");
        if (vdetailsquery != "") {
          await LoadVDetails(vdetailsquery);
        }
      }
      catch (e) {}

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

      ButtonsName = jsonDecode(data["ButtonsName"]);
      ButtonsURL = jsonDecode(data["ButtonsURL"]);

      Designation = data["Designation"]!;
      LastUpdate = data["LastUpdate"]!;

      AdvertisementNumber = data["AdvertisementNumber"];
      ExamCenters = data["ExamCenters"] != null ? data["ExamCenters"] : Map<String, dynamic>();
      Corrections = data["Corrections"] != null ? data["Corrections"] : <dynamic>[];
      AgeLimits = data["AgeLimits"] != null ? data["AgeLimits"] : Map<String, dynamic>();
      HowTo = data["HowTo"] != null ? data["HowTo"] : <dynamic>[];
    }
    catch(e)
    {
      print(e);
    }
  }

  Future<void> LoadVDetails(String vdetailsqry) async {
    List<dynamic> AllDatas = <dynamic>[];

    AllDatas = jsonDecode(vdetailsqry);

    if(AllDatas.isNotEmpty) {
      AllDatas.forEach((ele) async {
          var element = ele;
          var myele = jsonDecode(element);

          VacancyDetails vacancyDetails = new VacancyDetails();
          vacancyDetails.Title = myele["Title"].toString();
          vacancyDetails.TotalVacancies = myele["TotalVacancies"] ?? 0;

          var myheader = myele["headers"];
          if (myheader.runtimeType == String) {
            vacancyDetails.headers = jsonDecode(await myele["headers"]);
          }
          else {
            vacancyDetails.headers = myheader;
          }

          List<dynamic> datas = <dynamic>[];
          var mydata = myele["data"];
          if (mydata.runtimeType == String) {
            datas = jsonDecode(mydata);
          }
          else {
            datas = mydata;
          }
          //List<dynamic> datas = jsonDecode(await myele["data"]);

          await Future.forEach(datas, (dynamic isdata) {
            VacancyDetailsData vacancyDetailsData = new VacancyDetailsData();

            var vddata = isdata.toString().replaceAll('"', "")
                .replaceAll("[", "")
                .replaceAll("]", "");
            var vddatas = vddata.split(",");

            vacancyDetailsData.data = vddatas;

            vacancyDetails.datas.add(vacancyDetailsData);
          });
          VDetails.add(vacancyDetails);

      });
    }
  }

  Future<void> LoadingVDetails(var job, var ref) async {
    try {
      var vdetailsquerylist = <String>[];
      var LVDVDetails = await ref.collection(
          "Jobs" + "/" + job.data()["Department"] + "/" +
              job.data()["Location"].toString().toUpperCase() + "/" + job.id +
              "/VDetails").get();
      int indx = 0;
      await Future.forEach(LVDVDetails.docs, (vdtl) async {
        var data = LVDVDetails.docs[indx].data();
        VacancyDetails vacancyDetails = new VacancyDetails();
        vacancyDetails.Title = data["Title"];
        vacancyDetails.TotalVacancies = data["TotalVacancies"];
        vacancyDetails.headers = data["headers"];
        var vdetailquery = {
          "Title": data["Title"],
          "TotalVacancies": data["TotalVacancies"],
          "headers": data["headers" ],
          "data": null,
        };
        var LVDVDetailData = await ref.collection(
            "Jobs" + "/" + job.data()["Department"] + "/" +
                job.data()["Location"].toString().toUpperCase() + "/" + job.id +
                "/VDetails/" + LVDVDetails.docs[indx].id +
                "/VacancyDetailsData")
            .get();
        List<String> vacancydata = <String>[];
        int p = 0;
        await Future.forEach(LVDVDetailData.docs, (ele) async {
          var VDetailDataA = LVDVDetailData.docs[p].data();
          VacancyDetailsData vacancyDetailsData = new VacancyDetailsData();
          vacancyDetailsData.data = VDetailDataA["data"];

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
    catch (e) {}
  }

  Future<void> LoadFromFireStoreValues(var job) async {
      var ref = FirebaseFirestore.instance;

      if(job != null && job.data() != null) {
        try {
          Title = job.data()!["Title"].toString();
          Department = job.data()["Department"].toString();
          url = job.data()["URL"].toString();
          Total_Vacancies = job.data()["Total_Vacancies"].toString();
          WebsiteLink = job.data()["WebsiteLink"].toString();
          Location = job.data()["Location"].toString();
          ApplicationFees = job.data()["ApplicationFees"];
          Important_Dates = job.data()["Important_Dates"];
          HowToApply = job.data()["HowToApply"].toString();
          Key = job.id;
          ApplyLink = job.data()["ApplyLink"].toString();
          WebsiteLink = job.data()["WebsiteLink"].toString();
          NotificationLink = job.data()["NotificationLink"].toString();

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

          ButtonsName = job.data()["ButtonsName"] ?? List<dynamic>;
          ButtonsURL = job.data()["ButtonsURL"] ?? List<dynamic>;

          Designation = job.data()["Designation"].toString();
          LastUpdate = job.data()["LastUpdate"].toString();


          AdvertisementNumber = job.data()["AdvertisementNumber"].toString();
          ExamCenters = job.data()["ExamCenters"];
          Corrections = job.data()["Corrections"];
          AgeLimits = job.data()["AgeLimits"];
          HowTo = job.data()["HowTo"];

          await LoadingVDetails(job, ref);
        }
        catch(e)
        {
          print("Error: $e");
        }
      }

  }

}