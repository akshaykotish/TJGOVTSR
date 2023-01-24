import 'dart:io';

import 'package:flutter/material.dart';
import 'dart:ui' as ui;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:governmentapp/Graphics/PostGraphic.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;

class AutoPost extends StatefulWidget {
  const AutoPost({Key? key}) : super(key: key);

  @override
  State<AutoPost> createState() => _AutoPostState();
}

class _AutoPostState extends State<AutoPost> {
  String InstagramAT = "EAAxKt4iMcvYBAC1rK8Lr58xoV4IgkJ8js7ZBuA7OENHfl6XKL0fA9ImEcBiG1lJVesHsQKW0lcIz7wfQYXyu4FQ5vJfPyZCLkoJKuaN3mH9rOEl5pxpFxL5vFgxTD4IdzJs2E2wouAQjTBKMg1kOoWHpCKY7CZAZBh9ZAGaJMHNfZCDkTtNZCtP";
  String FacebookAT = "EAAxKt4iMcvYBAC1rK8Lr58xoV4IgkJ8js7ZBuA7OENHfl6XKL0fA9ImEcBiG1lJVesHsQKW0lcIz7wfQYXyu4FQ5vJfPyZCLkoJKuaN3mH9rOEl5pxpFxL5vFgxTD4IdzJs2E2wouAQjTBKMg1kOoWHpCKY7CZAZBh9ZAGaJMHNfZCDkTtNZCtP";


  Future<ui.Image> getImage(String UpdateName, String UpdateDate) async {
    PostGraphic postGraphic = PostGraphic(PostName: "Designation", Department: "Department", AboutJob: "AboutJob", Location: "Location", UpdateName: "UpdateName", UpdateDate: "UpdateDate");
    ui.PictureRecorder recorder = ui.PictureRecorder();
    postGraphic.paint(Canvas(recorder), Size(1080, 1080));
    ui.Picture picture = recorder.endRecording();
    return await picture.toImage(1080, 1080);
  }


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
        String URL = await logfile.getDownloadURL();

        print("URL: $URL");

        await PostOnFacebook(URL);
        await PostOnInstagram(URL);
      }
      catch (e) {
        print("URL ERROR ${e}");
      }
    }
  }

  Future<void> PostOnFacebook(String url) async {
    Uri uri = Uri.parse("https://graph.facebook.com/101660532329466/photos?url=${url}&access_token=$FacebookAT");
    var res = await http.post(uri);
    print("Facebook = " + res.body);
  }

  Future<void> PostOnInstagram(String url) async {
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

  void PostONFBANDINSTA(){
    UploadPhoto("ID", "UpdateName", "UpdateDate");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Center(
          child: GestureDetector(
            onTap: PostONFBANDINSTA,
            child: Text("Click Me"),
          )
        ),
      ),
    );
  }
}
