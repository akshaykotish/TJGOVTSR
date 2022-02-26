import 'package:governmentapp/JobData.dart';
import 'package:governmentapp/VacancyDetails.dart';
import 'package:html/parser.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:html/parser.dart' show parse;
class Temp extends StatefulWidget {
  const Temp({Key? key}) : super(key: key);

  @override
  _TempState createState() => _TempState();
}

class _TempState extends State<Temp> {

  String Department = "";
  String Title = "";
  String Short_Details = "";
  String DataProviderUrl = "";
  Map<String, String> Important_Dates = new Map<String, String>();
  Map<String, String> ApplicationFees = new Map<String, String>();
  String Total_Vacancies = "";

  bool isAgeLimitDone = false;

  bool IsVacancyDetails = false;
  bool IsVacancyHeader = false;
  List<VacancyDetails> VDetails = <VacancyDetails>[];
  int VacancyId = -1;

  bool isSomeUsefullLinks = false;

  String HowToApply = "";

  String ApplyLink = "";
  String NotificationLink = "";
  String WebsiteLink = "";


  void Contains_Department_Title(String data){
    int c = 0;
    String word = "";

      for(int i=0; i<data.length; i++)
        {
          if((data[i] == '\n' && word.length > 0) || i == data.length - 1)
            {
              if(c == 1)
                {
                  Department = word;
                }
              else if(c == 2)
              {
                Title = word;
              }
              else if(c == 3)
              {
                Short_Details = word;
              }
              else if(c == 4)
              {
                DataProviderUrl = word;
              }

              word = "";
              c++;
            }
            else{
              word += data[i];
            }
        }

      //print(Department + " " + Title + " " + Short_Details + " " + DataProviderUrl);
  }

  void Contains_ImportandDates_ApplicationFee(String data){
    int c = 0;
    String word = "";

    bool ImpDates = false;
    bool AppFees = false;

    for(int i=0; i<data.length; i++)
    {
      if((data[i] == '\n' && word.length > 0) || i == data.length - 1)
      {
        word = word.replaceAll("\n", "");

        if(word == "" || word == "Important Dates" || word == "Application Fee")
          {
            if(ImpDates == false && word == "Important Dates")
              {
                ImpDates = true;
              }
            else if(AppFees == false && word == "Application Fee")
              {
                AppFees = true;
              }
            else if(ImpDates == true && AppFees == true){
              break;
            }


          }
        else{
          if(ImpDates && !AppFees)
          {
            var parts = word.split(":");
            if(parts.length > 1)
              {
                Important_Dates[parts[0]] = parts[1];
              }
            else{
              Important_Dates[parts[0]] = "";
            }

          }
          else if(ImpDates && AppFees)
          {
            var parts = word.split(":");
            if(parts.length > 1)
            {
              ApplicationFees[parts[0]] = parts[1];
            }
            else{
              ApplicationFees[parts[0]] = "";
            }
          }
        }



        word = "";
        c++;
      }
      else{
        word += data[i];
      }
    }
  }

  void Contains_AgeLimit(String data){
    isAgeLimitDone = true;
  }

  void Contains_VacancyDetails(String data){
    int c = 0;
    String word = "";


    for(int i=0; i<data.length; i++)
    {
      if((data[i] == '\n' && word.length > 0) || i == data.length - 1)
      {
        word = word.replaceAll("\n", "");


        if(c == 1)
          {
            Total_Vacancies = word;
          }

        word = "";
        c++;
      }
      else{
        word += data[i];
      }
    }


      IsVacancyDetails = true;
      IsVacancyHeader = true;
      isAgeLimitDone = true;

      VacancyId++;
      VacancyDetails vd = new VacancyDetails();
      vd.Title = word;
      VDetails.add(vd);

}


  void Contains_PostHeader(String data){
    int c = 0;
    String word = "";


    for(int i=0; i<data.length; i++)
    {
      if((data[i] == '\n' && word.length > 0) || i == data.length - 1)
      {
        word = word.replaceAll("\n", "");
        if(word != "" && word != " ") {
          VDetails[VacancyId].headers.add(word);
        }
        word = "";
        c++;
      }
      else{
        word += data[i];
      }
    }

    IsVacancyHeader = false;

  }


  void Contains_PostDatas(String data){
    int c = 0;
    String word = "";

    VacancyDetailsData vdd = new VacancyDetailsData();


    for(int i=0; i<data.length; i++)
    {
      if((data[i] == '\n' && word.length > 0) || i == data.length - 1)
      {
        word = word.replaceAll("\n", "");
        if(word != "" && word != " ") {
          vdd.data.add(word);
        }
        word = "";
        c++;
      }
      else{
        word += data[i];
      }
    }

    VDetails[VacancyId].datas.add(vdd);


  }
  
  void Contains_HowtoFill(String data) {
    data = data.replaceAll("(adsbygoogle = window.adsbygoogle || []).push({});", "");
    //data = data.replaceAll("\n", "");

    int indx = data.indexOf("How to");
    data = data.replaceRange(0, indx, "");

    HowToApply = data;
  }

  void Contains_ApplyOnline(String data){
    var indx = data.indexOf('href="') + 6;

    String link = "";

    int i = indx;
    while(data[i] != '"')
      {
        link += data[i];
        i++;
      }


      ApplyLink = link;
  }

  void Contains_DownloadNotifications(String data)
  {
    var indx = data.indexOf('href="') + 6;

    String link = "";

    int i = indx;
    while(data[i] != '"')
    {
      link += data[i];
      i++;
    }

    NotificationLink = link;
  }

  void Contains_OfficialWebsite(String data)
  {
    var indx = data.indexOf('href="') + 6;

    String link = "";

    int i = indx;
    while(data[i] != '"')
    {
      link += data[i];
      i++;
    }

    WebsiteLink = link;
  }

  void Read_Row5(String data){
    int c = 0;
    String word = "";


    for(int i=0; i<data.length; i++)
    {
      if((data[i] == '\n' && word.length > 0) || i == data.length - 1)
      {
        word = word.replaceAll("\n", "");
        print(c.toString() + " " + word);

        word = "";
        c++;
      }
      else{
        word += data[i];
      }
    }

  }


  void Save_Job(){
    JobData jobData = new JobData();
    jobData.Department = Department;
    jobData.Title = Title;
    jobData.Short_Details = Short_Details;
    jobData.DataProviderUrl = DataProviderUrl;
    jobData.Important_Dates = Important_Dates;
    jobData.ApplicationFees = ApplicationFees;
    jobData.Total_Vacancies = Total_Vacancies;
    jobData.VDetails = VDetails;
    jobData.HowToApply = HowToApply;
    jobData.ApplyLink = ApplyLink;
    jobData.NotificationLink = NotificationLink;
    jobData.WebsiteLink = WebsiteLink;

    print(Department);
    print(Title);
    print(Short_Details);
    print(DataProviderUrl);
    print("Important Dates");
    for(var id in Important_Dates.keys)
      {
        print(Important_Dates[id]);
      }
    print("Application Fees");
    for(var id in ApplicationFees.keys)
      {
        print(ApplicationFees[id]);
      }
    print(Total_Vacancies);


    for(var i=0; i<VDetails.length; i++)
      {
        print("Headers");
        for(int j=0; j<VDetails[i].headers.length; j++)
          {
            print(VDetails[i].headers[j]);
          }

        for(int j=0; j<VDetails[i].datas.length; j++)
          {
            print(VDetails[i].datas[j].data.toList());
          }
      }



    //print("VDL1: " + VDetails.length.toString());
    //if(VDetails.length != 0)
      //{
        //print("VDL2: " + VDetails[0].headers.length.toString());
        //print("VDL3: " + VDetails[0].datas.length.toString());
      //}

    print(HowToApply);
    print(ApplyLink);
    print(NotificationLink);
    print(WebsiteLink);
  }

  Future<void> Loading() async {
    var url = Uri.parse("https://www.sarkariresult.com/force/navy-ssc-entry-jan2023/");
    String pagedata = await http.read(url);



    var document = parse(pagedata);
    //print(document.getElementsByTagName("table")[2].children[0].children[0].text);

    try {
      for (int i = 0; i <
          document.getElementsByTagName("table")[2].children[0].children
              .length; i++) {
          //print(document.getElementsByTagName("table")[2].children[0].children[i].text);

        String Data = document.getElementsByTagName("table")[2].children[0].children[i].text;

          if(i == 0)
            {
              Contains_Department_Title(Data);
            }
          else if(i == 1)
            {
              Contains_ImportandDates_ApplicationFee(Data);
            }
          else if(Data.contains("Age Limit") && !isAgeLimitDone)
            {
              Contains_AgeLimit(Data);
            }
          else if(Data.contains("Vacancy Details"))
          {
            Contains_VacancyDetails(Data);
          }
          else if(Data.contains("How to Fill")){
            Contains_HowtoFill(Data);
          }
          else if(Data.contains("Interested Candidates Can Read"))
          {
            IsVacancyDetails = false;
            IsVacancyHeader = false;
            isSomeUsefullLinks = false;
            isAgeLimitDone = false;
          }
          else if(Data.contains("Important Links"))
          {
            isSomeUsefullLinks = true;
          }
          else if(isSomeUsefullLinks && Data.contains("Apply Online"))
          {
            Contains_ApplyOnline(document.getElementsByTagName("table")[2].children[0].children[i].children[1].innerHtml);
          }
          else if(isSomeUsefullLinks && Data.contains("Download Notification"))
          {
            Contains_DownloadNotifications(document.getElementsByTagName("table")[2].children[0].children[i].children[1].innerHtml);
          }
          else if(isSomeUsefullLinks && Data.contains("Official Website"))
          {
            Contains_OfficialWebsite(document.getElementsByTagName("table")[2].children[0].children[i].children[1].innerHtml);
          }
          else if(IsVacancyDetails && IsVacancyHeader)
          {
            Contains_PostHeader(Data);
          }
          else if(IsVacancyDetails)
            {
              Contains_PostDatas(Data);
            }


      }

      Save_Job();

    }
    catch(e)
    {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child:  Center(child: GestureDetector(
          onTap: (){
            Loading();
          },
          child: Container(
            width: 200,
            height: 50,
            color: Colors.grey,
            alignment: Alignment.center,
            child: const Text("Click"),
          ),
        )),
      ),
    );
  }
}
