

import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:governmentapp/DataPullers/GKPullers.dart';
import 'package:governmentapp/HexColors.dart';
import 'package:governmentapp/PostOnSocialMedia.dart';
import 'package:path_provider/path_provider.dart';
import '../Graphics/PostGraphic.dart';


class PostGKOnSocialMedia{
     Future<ui.Image> GetGKImage(GKTodayData gkTodayData)  async {
      ui.Image gkimage =  await LoadImageFromURL.NetworkImage(gkTodayData.Image, 600, 1080);
      GKPostGraphic postGraphic = GKPostGraphic(gkimage: gkimage, Title: gkTodayData.Heading, Content: gkTodayData.Content);
      ui.PictureRecorder recorder = ui.PictureRecorder();
      postGraphic.paint(Canvas(recorder), Size(1080, 1350));
      ui.Picture picture = recorder.endRecording();
      return await picture.toImage(1080, 1350);
    }

     Future<void> Execute(GKTodayData gkTodayData) async {
      var rng = Random();
      int random = rng.nextInt(5);
      String FileName = "ToGKploadFile${random}";

      final storageRef = FirebaseStorage.instance.ref();
      final logfile = storageRef.child("${FileName}.png");
      ui.Image image = await GetGKImage(gkTodayData);

      var bytes = await image.toByteData(format: ui.ImageByteFormat.png);

      if(bytes != null) {
        Directory appDocDir = await getApplicationDocumentsDirectory();
        File file = File("${appDocDir.path}/${FileName}.png");
        await file.writeAsBytes(bytes.buffer.asUint8List(bytes.offsetInBytes, bytes.lengthInBytes));
        try {
          await logfile.putFile(file);
          String URL = await logfile.getDownloadURL();

          print("URL: $URL");


          SocialMedia socialMedia = new SocialMedia();

          await socialMedia.PostOnFacebook(URL);
          await socialMedia.PostOnInstagram(URL, "Visit the website on www.TrackJobs.in and download TJSN Jobs app from Playstore.");
        }
        catch (e) {
          print("URL ERROR ${e}");
        }
      }
    }
}



class GKPostGraphic extends CustomPainter{

  ui.Image gkimage;
  String Title = "";
  String Content = "";
  GKPostGraphic({required this.gkimage, required this.Title, required this.Content});



  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawColor(Colors.white, BlendMode.color);

    Paint paint = Paint();
    canvas.drawImage(gkimage, Offset(0, 0), paint);


    TextSpan spanHeading = new TextSpan(style: GoogleFonts.poppins(color: ColorFromHexCode("#000000"), fontSize: 60, fontWeight: FontWeight.bold), text: Title);
    TextPainter tpHeading = new TextPainter(text: spanHeading, textAlign: TextAlign.left, textDirection: TextDirection.ltr);
    tpHeading.layout(minWidth: size.width - 80, maxWidth: size.width - 80);
    tpHeading.paint(canvas, new Offset(60, 650));

    TextSpan spanContent = new TextSpan(style: GoogleFonts.poppins(color: ColorFromHexCode("#808080"), fontSize: 30), text: Content);
    TextPainter tpContent= new TextPainter(text: spanContent, textAlign: TextAlign.left, textDirection: TextDirection.ltr);
    tpContent.layout(minWidth: size.width - 80, maxWidth: size.width - 80);
    tpContent.paint(canvas, new Offset(60, 890));

    TextSpan spandownloadmessage = new TextSpan(style: GoogleFonts.poppins(color: ColorFromHexCode("#808080"), fontSize: 30), text: "Download TJSN Jobs app from PlayStore and visit www.TrackJobs.in");
    TextPainter tpdownloadmessage = new TextPainter(text: spandownloadmessage, textAlign: TextAlign.left, textDirection: TextDirection.ltr);
    tpdownloadmessage.layout(minWidth: size.width - 80, maxWidth: size.width - 80);
    tpdownloadmessage.paint(canvas, new Offset(60, 1200));

  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}


class LoadImageFromURL{
   static Future<ui.Image> NetworkImage(String url, height, width) async {
     Uint8List bytes = (await NetworkAssetBundle(Uri.parse(url))
         .load(url))
         .buffer
         .asUint8List();

     final codec = await ui.instantiateImageCodec(
       bytes,
       targetHeight: height,
       targetWidth: width,
     );
     final image = (await codec.getNextFrame()).image;
     return image;
   }
}