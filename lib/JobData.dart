

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


  bool isSave = false;


  String CToString()
  {
    return Key + ";;;" + Department + ";;;" + Title + ";;;" + Short_Details + ";;;" +
    DocumentRequired + ";;;" + DataProviderUrl + ";;;" +Important_Dates.toString() + ";;;" +ApplicationFees.toString() +
    Total_Vacancies + ";;;" + HowToApply + ";;;" + NotificationLink + ";;;" +WebsiteLink + ";;;" +
    url + ";;;" + Location + ";;;";
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
