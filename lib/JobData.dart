

import 'dart:convert';

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

  void fromJson(String json)
  {
    var data = jsonDecode(json);

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

     print("LENGTH: " + data["VDetails"].toString());
     // vdetails.forEach((element) {
     //   print("EEE = " + element);
     // });


    HowToApply = data["HowToApply"];
     ApplyLink = data["ApplyLink"];
     NotificationLink = data["NotificationLink"];
     WebsiteLink = data["WebsiteLink"];
     url = data["url"];
     Location = data["Location"];
  }

  void LoadFromFireStore(var Data){

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
