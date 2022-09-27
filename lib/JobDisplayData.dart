import 'dart:core';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:governmentapp/Graphics/PostGraphic.dart';
import 'package:governmentapp/JobData.dart';
import 'package:governmentapp/Notifcations.dart';
import 'dart:ui' as ui;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;


class JobDisplayDatas{
  static List<JobDisplayData> jobDisplayDatas = <JobDisplayData>[];
}


class JobDisplayData {
  String Designation = "";
  int Count = 0;
  String Department = "";
  String Path = "";
  String JobString = "";
  String AboutJob = "";
  String Location = "";
  String InstagramAT = "EAAxKt4iMcvYBAKkWZA7JonTNohYJ8cu6diHpEZAmqcIACCDzZA3tQRPDzZCJP3aEPJzZACfm2OZAuZClp9AwQzfEZBRZBGKbEoF6ccD7n6yskhlCwVupPlgKajrzUdYgWeE2g8LZCSVM5orXs9pyoakR1E17XRezHH7727n9id5WXInx7EuYe9X1IN";
  String FacebookAT = "EAAxKt4iMcvYBAFZBA0qX9mlyUUlZARTBt1xQE4Kf6h1GCUuZAOgAL0fNnxHQBc9zz5oSNZCZAMrNXgyL5ZA1wSOcZB8N4yPFBGmEBEuvVL2LwZCNwWFDQjqYN3F8VAHrOTAjOeoBpxqixjgD7xtU7ZA77mtJun8W2Tdcr2WAqv5ZBuqC4TYcqdfIDt";

  late JobData jobData;

  void LoadFromSearchString(String jobString) {
    JobString = jobString;
  }

  Future<ui.Image> getImage(String UpdateName, String UpdateDate) async {
    PostGraphic postGraphic = PostGraphic(PostName: Designation, Department: Department, AboutJob: AboutJob, Location: Location, UpdateName: UpdateName, UpdateDate: UpdateDate);
    ui.PictureRecorder recorder = ui.PictureRecorder();
    postGraphic.paint(Canvas(recorder), Size(1080, 1080));
    ui.Picture picture = recorder.endRecording();
    return await picture.toImage(1080, 1080);
  }

  String URL = "";
  Future<void> UploadPhoto(String ID, String UpdateName, String UpdateDate) async {
    final storageRef = FirebaseStorage.instance.ref();
    final logfile = storageRef.child("logfile.png");
    ui.Image image = await getImage(UpdateName, UpdateDate);


    var bytes = await image.toByteData(format: ui.ImageByteFormat.png);

    if(bytes != null) {
      Directory appDocDir = await getApplicationDocumentsDirectory();
      File file = File("${appDocDir.path}/logfile.png");
      await file.writeAsBytes(bytes.buffer.asUint8List(bytes.offsetInBytes, bytes.lengthInBytes));
      try {
        await logfile.putFile(file);
        URL = await logfile.getDownloadURL();
        await PostOnFacebook(URL);
        await PostOnInstagram(URL);
      }
      catch (e) {
        print("URL ERROR ${e}");
      }
    }
  }


  Future<void> CheckPostLog(String ID, String UpdateName, String UpdateDate) async {

    var Log = await FirebaseFirestore.instance.doc(Path).collection("Logs").doc(ID).get();
    if(Log.exists == false)
      {
        print("$ID is here");
        await UploadPhoto(ID, UpdateName, UpdateDate);
        await FirebaseFirestore.instance.doc(Path).collection("Logs").doc(ID).set({
          "ID": ID,
          "URL": URL,
          "TimeStamp": DateTime.now().toIso8601String(),
        });
      }
  }

  Future<void> PostOnFacebook(String url) async {
    Uri uri = Uri.parse("https://graph.facebook.com/101660532329466/photos?url=${url}&access_token=$FacebookAT");
    var res = await http.post(uri);
    print("Facebook = " + res.body);
  }

  Future<void> PostOnInstagram(String url) async {
      Uri uri = Uri.parse("https://graph.facebook.com/v15.0/17841455470887325/media?image_url=$url&caption=#sarkarinaukri&access_token=$InstagramAT");
    var res = await http.post(uri);
    print(res.body);
    String pid = res.body.replaceAll("{", "").replaceAll("}", "").split(":")[1].replaceAll('"', "");
    print("PID is " + pid);
    Uri publish = Uri.parse("https://graph.facebook.com/v15.0/17841455470887325/media_publish?creation_id=${pid}&access_token=$InstagramAT");
    var publishres = await http.post(publish);
    print("Instagram = " + publishres.body);
  }

  Future<void> CheckForNotifications() async {
    var Job = await FirebaseFirestore.instance.doc(Path).get();
    var Dates = Job.exists ? Job.data()!["Important_Dates"] as Map<String, dynamic> : null;

    if(Dates != null){
      for (var key in Dates.keys) {
        var parts = Dates[key].toString().split("/");

        if(parts.length == 3)
        {
          int day = int.parse(parts[0]);
          int month = int.parse(parts[1]);
          int year = int.parse(parts[2].substring(0, 4));

          DateTime dateTime = DateTime.now();

          if(day == dateTime.day && month == dateTime.month && year == dateTime.year)
          {
            String DateKey = Dates[key].toString().replaceAll("/", "").replaceAll("-", "").replaceAll(":", "");
            await CheckPostLog(DateKey, key, Dates[key]);
            Notifications.notifications.add("${Designation}'s ${key}");
            Notifications.NOTIFJOBSC.add(Notifications.notifications);
          }
        }
      }
    }
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
        int l = Designation.indexOf("Online Form");
        if(l>=0) {
          Designation = Designation.substring(0, l);
        }
        Path = Parts[2];

      }
    else{
      Department = Parts[1];
      Designation = Parts[2];
      Location = Parts[0].split("/")[2];
      AboutJob = Parts[3];
      int l = Designation.indexOf("Online Form");
      if(l >= 0) {
        Designation = Designation.substring(0, l);
      }
      Path = Parts[0];
    }
    CheckForNotifications();
  }
}
