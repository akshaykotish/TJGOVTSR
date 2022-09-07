import 'dart:core';

import 'package:governmentapp/JobData.dart';

class JobDisplayDatas{
  static List<JobDisplayData> jobDisplayDatas = <JobDisplayData>[];
}


class JobDisplayData{
  String Designation = "";
  int Count = 0;
  String Department = "";
  String Path = "";
  String JobString = "";
  late JobData jobData;

  void LoadFromSearchString(String jobString)
  {
    JobString = jobString;
  }

  JobDisplayData(String jobString, [this.Count = 0])
  {
    //ASRBAgricultureAO&F&AORecruitment2021;ASRB Agriculture AO & F&AO Recruitment 2021;Jobs/Agricultural Scientists Recruitment Board (ASRB) /INDIA/ASRBAgricultureAO&F&AORecruitment2021
    //Jobs/Steel Authority of India Limited (Sail)/INDIA/SailBokaroSteelPlantAttendantCumTechnicianRecruitment2022;Steel Authority of India Limited (Sail);Sail Bokaro Steel Plant Attendant-Cum Technician Recruitment 2022 Apply Online for 146 Post;Steel Authority of India Limited (Sail) Bokaro Steel Plant Attendant-Cum Technician Vacancy 2022 has released the Detailed Notification for the recruitment of 146 posts. Any candidate who is interested in this recruitment and fulfills the eligibility can apply online from 25 August 2022 to 15 September 2022. For eligibility, age limit, training center, pay scale, selection procedure and all other information in recruitment, read the Attendant Cum Technician notification issued by Sail Bokaro Steel Plant and then apply.
    JobString = jobString;

    var Parts = JobString.split(";");
    if(Parts.length == 3)
      {
        Department = Parts[2].split("/")[1];
        Designation = Parts[1];
        Path = Parts[2];

      }
    else{
      Department = Parts[1];
      Designation = Parts[2];
      Path = Parts[0];
    }
  }
}
