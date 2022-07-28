import 'dart:math';

import 'package:governmentapp/DataLoadingSystem/SearchAbleDataLoading.dart';
import 'package:governmentapp/JobData.dart';
import 'package:governmentapp/VacancyDetails.dart';
import 'package:html/parser.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' show parse;
import 'package:cloud_firestore/cloud_firestore.dart';


class Pull{

  JobData jobData = new JobData();

  String Department = "";
  String Title = "";
  String Short_Details = "";
  String DataProviderUrl = "";
  Map<String, String> Important_Dates = new Map<String, String>();
  Map<String, String> ApplicationFees = new Map<String, String>();
  String Total_Vacancies = "";

  String DocumentRequired = "";

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

  Pull(){

  }


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


  VacancyDetailsData OldVacancyDetails = new VacancyDetailsData();
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

    if(OldVacancyDetails.data.length < vdd.data.length)
      {
        print("A");
        for(int l=OldVacancyDetails.data.length; l<vdd.data.length; l++)
          {
            print("PD" + vdd.data[l]);
            OldVacancyDetails.data.add(vdd.data[l]);
          }
      }
    else if(OldVacancyDetails.data.length > vdd.data.length)
      {
        print("B");
        for(int l=vdd.data.length; l<OldVacancyDetails.data.length; l++)
        {
          print("PD" + OldVacancyDetails.data[l]);
          vdd.data.add(OldVacancyDetails.data[l]);
        }
      }

    OldVacancyDetails = vdd;

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


  void Contains_DocumentRequired(String data){
    DocumentRequired = data;
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
    jobData.Department = Department;
    jobData.Title = Title;
    jobData.Short_Details = Short_Details;
    jobData.DocumentRequired = DocumentRequired;
    jobData.DataProviderUrl = DataProviderUrl;
    jobData.Important_Dates = Important_Dates;
    jobData.ApplicationFees = ApplicationFees;
    jobData.Total_Vacancies = Total_Vacancies;
    jobData.VDetails = VDetails;
    jobData.HowToApply = HowToApply;
    jobData.ApplyLink = ApplyLink;
    jobData.NotificationLink = NotificationLink;
    jobData.WebsiteLink = WebsiteLink;

  }

  String pagedata = "";
  String Data = "";
  var url;
  var document;

  Future<JobData> Load(String joburl) async {
    jobData.url = joburl;
    //var url = Uri.parse("https://www.sarkariresult.com/force/navy-ssc-entry-jan2023/");
    joburl = joburl.replaceAll(" ", "");
    url = Uri.parse(joburl);

    pagedata = await http.read(url);



    document = parse(pagedata);
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
        else if(Data.contains("Vacancy Details") || Data.contains("Exam Details"))
        {
          Contains_VacancyDetails(Data);
        }
        else if(Data.contains("How to Fill") && HowToApply == ""){
          Contains_HowtoFill(Data);
        }
        else if(Data.contains("Document Required"))
        {
          Contains_DocumentRequired(Data);
        }
        else if(Data.contains("Interested Candidate"))
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
          try {
            Contains_ApplyOnline(
                document.getElementsByTagName("table")[2].children[0]
                    .children[i].children[1].innerHtml);
          }
          catch(e){}
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
      return jobData;

  }


  void init() {
    Department = "";
    Title = "";
    Short_Details = "";
    DataProviderUrl = "";
    Important_Dates = new Map<String, String>();
    ApplicationFees = new Map<String, String>();
    Total_Vacancies = "";

    isAgeLimitDone = false;

    IsVacancyDetails = false;
    IsVacancyHeader = false;
    VDetails = <VacancyDetails>[];
    VacancyId = -1;

    isSomeUsefullLinks = false;

    HowToApply = "";

    ApplyLink = "";
    NotificationLink = "";
    WebsiteLink = "";
  }

}


class JobsFetcher{

  var islogged = false;

  String ExtractURL(String data){
    var res = data.indexOf('href="');

    String link = "";
    int i = res + 6;
    while(data[i] != '"')
      {
        link += data[i];
        i++;
      }

      return link;
  }

  String GenerateRandomID(){
    Random random = Random();
    String RID = DateTime.now().toString().replaceAll("/", "").replaceAll(":", "").replaceAll("-", "").replaceAll(" ", "").replaceAll(".", "") + random.nextInt(5000).toString();
    return RID;
  }

  String LSID = "";
  bool StopTheSave = false;

  Future<bool> WriteToFirebase(JobData jobData) async {
    String DocumentID = jobData.Title.replaceAll("Online Form", "").replaceAll(" ", "").replaceAll("\n", "").replaceAll("/", "").replaceAll(":", "");
    print(DocumentID);

    if(LSID != DocumentID) {
      FirebaseFirestore firestore = FirebaseFirestore.instance;

      if (DocumentID.isEmpty) {
        return false;
      }


      try {
        String LocationURL = "AllJobs/" +
            jobData.Department.replaceAll("/", "") + "/" +
            jobData.Location.replaceAll("/", "");

        String Part1 = jobData.Department.replaceAll("/", "").replaceAll(
            ",", "");
        String Part2 = jobData.Location.replaceAll("/", "")
            .replaceAll(",", "")
            .toUpperCase();

        String DocumentName = Part1 + "/" + Part2 + "/" + DocumentID;

        FirebaseFirestore.instance.collection("Jobs").doc(Part1).set({}).then((
            value) {
          FirebaseFirestore.instance.collection("Jobs").doc(DocumentName)
              .get()
              .then((value) async {
            if (value.data() == null) {
              FirebaseFirestore.instance.collection("Jobs")
                  .doc(DocumentName)
                  .set({
                "Department": jobData.Department,
                "Title": jobData.Title,
                "Short_Details": jobData.Short_Details,
                "DocumentRequired": jobData.DocumentRequired,
                "DataProviderUrl": jobData.DataProviderUrl,
                "Important_Dates": jobData.Important_Dates,
                "ApplicationFees": jobData.ApplicationFees,
                "Total_Vacancies": jobData.Total_Vacancies,
                "HowToApply": jobData.HowToApply,
                "ApplyLink": jobData.ApplyLink,
                "NotificationLink": jobData.NotificationLink,
                "WebsiteLink": jobData.WebsiteLink,
                "URL": jobData.url,
                "Location": jobData.Location,
              });


              for (int i = 0; i < jobData.VDetails.length; i++) {
                String ID = GenerateRandomID();

                FirebaseFirestore.instance.collection("Jobs/").doc(
                    DocumentName + "/VDetails/" + ID).set({
                  "TotalVacancies": jobData.VDetails[i].TotalVacancies,
                  "Title": jobData.VDetails[i].Title,
                  "headers": jobData.VDetails[i].headers,
                });

                for (int j = 0; j < jobData.VDetails[i].datas.length; j++) {
                  String IDJ = GenerateRandomID();

                  FirebaseFirestore.instance.collection("Jobs/")
                      .doc(
                      DocumentName + "/VDetails/" + ID +
                          "/VacancyDetailsData/" + IDJ)
                      .set({
                    "data": jobData.VDetails[i].datas[j].data,});
                }
              }

              if(islogged == false) {
                FirebaseFirestore.instance.collection('Logs')
                    .doc("LastSavedID")
                    .set({
                  "JobId": DocumentID,
                }).then((value) {
                  islogged = true;
                });
              }

              await UpdatetoIndex(jobData, DocumentID);
              return true;

            }
            else {
              return false;
            }
          });
        });


        //FirebaseFirestore.instance.collection("Jobs").doc(jobData.Department.replaceAll("/", "").replaceAll(" ", "")).collection(jobData.Location.replaceAll("/", "").replaceAll(" ", "")).doc(DocumentID).set({"Hello": "World"});


      }
      catch (e) {
        print("Jobs/" + jobData.Department + "/" + jobData.Location + "/" +
            DocumentID);
        print("FirebaseError: ${e}");
      }
    }
    else{
      StopTheSave = true;
    }
    return true;
  }

  static var States = <String>["Andaman and Nicobar", "Andhra Pradesh", "Arunachal Pradesh", "Assam", "Bihar", "Chandigarh", "Chhattisgarh", "Dadra and Nagar Haveli", "Daman and Diu", "Delhi", "Goa", "Gujarat", "Haryana", "Himachal Pradesh", "Jammu and Kashmir", "Jharkhand", "Karnataka", "Kerala", "Lakshadweep", "Madhya Pradesh", "Maharashtra", "Manipur", "Meghalaya", "Mizoram", "Nagaland", "Orissa", "Puducherry", "Punjab", "Rajasthan", "Sikkim", "Tamil Nadu", "Telangana", "Tripura", "Uttar Pradesh", "Uttarakhand", "West Bengal"];
  static String FindLocation(JobData jobData){
    String Location = "India";

    for(int i=0; i<States.length; i++)
      {
        if(jobData.Short_Details.contains(States[i]) ||
          jobData.Title.contains(States[i]) ||
            jobData.Department.contains(States[i]) ||
            jobData.VDetails.contains(States[i]) ||
            jobData.DocumentRequired.contains(States[i]) ||
            jobData.Total_Vacancies.contains(States[i]) ||
            jobData.Important_Dates.keys.toString().contains(States[i])
          )
          {
            Location = States[i];
            break;
          }
      }

    return Location;
  }


  Future<String> LastSaveID() async {
    String Output = "";

    await FirebaseFirestore.instance.collection("Logs").doc("LastSavedID").get().then(await (value){
      if(value.exists)
        {
          Output = value.data()!["JobId"];
          return Output;
        }
    });
    return Output;
  }

  Future<void> Load() async {

    try {
      LSID = await LastSaveID();

      var url = Uri.parse("https://www.sarkariresult.com/latestjob/");
      String pagedata = await http.read(url);
      var document = parse(pagedata);

      //print(document.getElementsByTagName("li")[20].text);
      //print(document.getElementsByTagName("li")[20].innerHtml);
      //print(ExtractURL(document.getElementsBhttps://www.sarkariresult.com/latestjob/yTagName("li")[20].innerHtml));

      //var URLLink = ExtractURL(document.getElementsByTagName("li")[20 ].innerHtml);


      for (int i = 20; i < document
          .getElementsByTagName("li")
          .length; i++) {
        if (!StopTheSave) {
          JobData jobData = JobData();
          Pull pull = Pull();

          String title = document.getElementsByTagName("li")[i].text;
          var EURL = await ExtractURL(
              document.getElementsByTagName("li")[i].innerHtml.toString());
          jobData.url = EURL;
          jobData = await pull.Load(EURL);

          jobData.Location = await FindLocation(jobData);

          print("Length is " + jobData.VDetails.length.toString());
          await WriteToFirebase(jobData);
        }
        else {
          print("Saved Done");
          break;
        }
      }
    }
    catch(E)
    {
      //print(E);
    }
  }

  Future<void> UpdatetoIndex(JobData jobData, String DocumentID) async {
    String Path = "Jobs/" + jobData.Department + "/" + jobData.Location.toUpperCase() + "/" + DocumentID;
    String Title = jobData.Title;
    String Key = DocumentID;
    String toStore = Key + ";" + Title + ";" + Path;
    (SearchAbleDataLoading.SearchAbleCache.contains(toStore) == false ? SearchAbleDataLoading.SearchAbleCache.add(toStore) : null);
    await SearchAbleDataLoading.Fire();
    await SearchAbleDataLoading.JobIndexSaveToFirebase();
    print("FRoMDTPULLER");
  }
}