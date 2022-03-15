

import 'package:governmentapp/VacancyDetails.dart';

class JobData{
  String Department = "";
  String Title = "";
  String Short_Details = "";
  String DocumentRequired = "";
  String DataProviderUrl = "";
  Map<String, String> Important_Dates = new Map<String, String>();
  Map<String, String> ApplicationFees = new Map<String, String>();
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
