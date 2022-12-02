import 'dart:core';
import 'dart:io';
import 'dart:math';

import 'package:flutter/widgets.dart';
import 'package:governmentapp/Graphics/PostGraphic.dart';
import 'dart:ui' as ui;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;



class PostOnSocialMedia{
  static String Designation = "";
  static String Department = "";
  static String Path = "";
  static String JobString = "";
  static String AboutJob = "";
  static String Location = "";
  static String URL = "";

  static String InstagramAT = "EAAxKt4iMcvYBAI3pVoiVKjGZCizkv3DPOZCWcUTTKvvP8PDRW4RLK6gIwsXTo7CuEcdiToVtR1InnW7maqQJsad04WngHpo3OrFSXnmAqrymOYnwjanBAvNvl4f2FOSs3KHZCvpz1q8ChYlZCKFKKKrVkxEG5QZCdyDHSLAS8sh4zP3ROwfZCI";
  static String FacebookAT = "EAAxKt4iMcvYBAI3pVoiVKjGZCizkv3DPOZCWcUTTKvvP8PDRW4RLK6gIwsXTo7CuEcdiToVtR1InnW7maqQJsad04WngHpo3OrFSXnmAqrymOYnwjanBAvNvl4f2FOSs3KHZCvpz1q8ChYlZCKFKKKrVkxEG5QZCdyDHSLAS8sh4zP3ROwfZCI";


  static Future<ui.Image> getImage(String UpdateName, String UpdateDate) async {
    PostGraphic postGraphic = PostGraphic(PostName: Designation, Department: Department, AboutJob: AboutJob, Location: Location, UpdateName: UpdateName, UpdateDate: UpdateDate);
    ui.PictureRecorder recorder = ui.PictureRecorder();
    postGraphic.paint(Canvas(recorder), Size(1080, 1080));
    ui.Picture picture = recorder.endRecording();
    return await picture.toImage(1080, 1080);
  }


  static Future<void> UploadPhoto(String ID, String UpdateName, String UpdateDate) async {
    var rng = Random();
    int random = rng.nextInt(5);

    final storageRef = FirebaseStorage.instance.ref();
    final logfile = storageRef.child("logfile${random}.png");
    ui.Image image = await getImage(UpdateName, UpdateDate);

    var bytes = await image.toByteData(format: ui.ImageByteFormat.png);

    if(bytes != null) {
      Directory appDocDir = await getApplicationDocumentsDirectory();
      File file = File("${appDocDir.path}/logfile${random}.png");
      await file.writeAsBytes(bytes.buffer.asUint8List(bytes.offsetInBytes, bytes.lengthInBytes));
      try {
        await logfile.putFile(file);
        URL = await logfile.getDownloadURL();

        print("URL: $URL");

        await PostOnFacebook(URL);
        await PostOnInstagram(URL);
      }
      catch (e) {
        print("URL ERROR ${e}");
      }
    }
  }

  static Future<void> PostOnFacebook(String url) async {
    Uri uri = Uri.parse("https://graph.facebook.com/101660532329466/photos?url=${url}&access_token=$FacebookAT");
    var res = await http.post(uri);
    print("Facebook = " + res.body);
  }

  static Future<void> PostOnInstagram(String url) async {
    //Uri uri = Uri.parse("https://graph.facebook.com/v15.0/17841455470887325/media?image_url=$url&caption=#sarkarinaukri&access_token=$InstagramAT");

    Uri uri = Uri.parse("https://graph.facebook.com/v15.0/17841455470887325/media?image_url=${url}&caption=${"Download our app from playstore. Link in the bio."}&access_token=$InstagramAT");
    var res = await http.post(uri);
    print(res.body);
    String pid = res.body.replaceAll("{", "").replaceAll("}", "").split(":")[1].replaceAll('"', "");
    print("PID is " + pid);
    Uri publish = Uri.parse("https://graph.facebook.com/v15.0/17841455470887325/media_publish?creation_id=${pid}&access_token=$InstagramAT");
    var publishres = await http.post(publish);
    print("Instagram = " + publishres.body);
  }
}