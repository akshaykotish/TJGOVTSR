import 'dart:core';
import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:governmentapp/Graphics/PostGraphic.dart';
import 'dart:ui' as ui;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;



class PostOnSocialMedia{
   String Designation = "";
   String Department = "";
   String Path = "";
   String JobString = "";
   String AboutJob = "";
   String Location = "";
   String URL = "";

  PostOnSocialMedia() {

  }

   Future<ui.Image> getImage(String UpdateName, String UpdateDate) async {
    PostGraphic postGraphic = PostGraphic(PostName: Designation, Department: Department, AboutJob: AboutJob, Location: Location, UpdateName: UpdateName, UpdateDate: UpdateDate);
    ui.PictureRecorder recorder = ui.PictureRecorder();
    postGraphic.paint(Canvas(recorder), Size(1080, 1080));
    ui.Picture picture = recorder.endRecording();
    return await picture.toImage(1080, 1080);
  }


   Future<void> UploadPhoto(String UpdateName, String UpdateDate) async {
    var rng = Random();
    int random = rng.nextInt(5);
    String FileName = "ToUploadFile${random}";

    final storageRef = FirebaseStorage.instance.ref();
    final logfile = storageRef.child("${FileName}.png");
    ui.Image image = await getImage(UpdateName, UpdateDate);

    var bytes = await image.toByteData(format: ui.ImageByteFormat.png);

    if(bytes != null) {
      Directory appDocDir = await getApplicationDocumentsDirectory();
      File file = File("${appDocDir.path}/${FileName}.png");
      await file.writeAsBytes(bytes.buffer.asUint8List(bytes.offsetInBytes, bytes.lengthInBytes));
      try {
        await logfile.putFile(file);
        URL = await logfile.getDownloadURL();

        print("URL: $URL");
        SocialMedia socialMedia = SocialMedia();
        await socialMedia.PostOnFacebook(URL);
        await socialMedia.PostOnInstagram(URL, Designation);
      }
      catch (e) {
        print("URL ERROR ${e}");
      }
    }
  }

}

class SocialMedia{


  SocialMedia(){
    FirebaseFirestore.instance.collection("APIs").doc("SocialMedia").get().then((SM){
      if(SM.exists) {
        String fb = SM.data()!["Facebook"];
        String ig = SM.data()!["Instagram"];

        InstagramAT = ig;
        FacebookAT = fb;

        print("RECIEVED OK ${InstagramAT} and ${FacebookAT}");
      }
    });
  }

  Future<void> PostOnFacebook(String ToUploadLink) async {
    print("Facebook:- " + ToUploadLink);
    Uri uri = Uri.parse("https://graph.facebook.com/101660532329466/photos?url=${ToUploadLink}&access_token=$FacebookAT");
    var res = await http.post(uri);
    print("Facebook = " + res.body);
  }

   Future<void> PostOnInstagram(String ToUploadLink, String caption) async {
    //Uri uri = Uri.parse("https://graph.facebook.com/v15.0/17841455470887325/media?image_url=$url&caption=#sarkarinaukri&access_token=$InstagramAT");

     print("Instagram:- " + ToUploadLink);
    Uri uri = Uri.parse("https://graph.facebook.com/v15.0/17841455470887325/media?image_url=${ToUploadLink}&caption=${caption}&access_token=$InstagramAT");
    var res = await http.post(uri);
    print(res.body);
    String pid = res.body.replaceAll("{", "").replaceAll("}", "").split(":")[1].replaceAll('"', "");
    print("PID is " + pid);
    Uri publish = Uri.parse("https://graph.facebook.com/v15.0/17841455470887325/media_publish?creation_id=${pid}&access_token=$InstagramAT");
    var publishres = await http.post(publish);
    print("Instagram = " + publishres.body);
  }
}