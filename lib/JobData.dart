

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
}
