

import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:governmentapp/HexColors.dart';

class PostGraphic extends CustomPainter{

  String PostName = "";
  String Department = "";
  String AboutJob = "";
  String Location = "";
  String UpdateName = "";
  String UpdateDate = "";
  PostGraphic({required this.PostName, required this.Department, required this.AboutJob, required this.Location, required this.UpdateName, required this.UpdateDate});



  @override
  void paint(Canvas canvas, Size size) {

    if(GetTheIMage.backgroundImage != null) {
      Paint paint = Paint();
      canvas.drawImage(GetTheIMage.backgroundImage, Offset(0, 0), paint);
    }

    TextSpan spanPostName = new TextSpan(style: GoogleFonts.quicksand(color: ColorFromHexCode("#E4A700"), fontWeight: FontWeight.w600, fontSize: 30 ), text:PostName);
    TextPainter tpPostName = new TextPainter(text: spanPostName, textAlign: TextAlign.left, textDirection: TextDirection.ltr);
    tpPostName.layout(minWidth: size.width - 80, maxWidth: size.width - 80);
    tpPostName.paint(canvas, new Offset(60, 60));


    TextSpan spanDepartment = new TextSpan(style: GoogleFonts.quicksand(color: ColorFromHexCode("#402F00"), fontWeight: FontWeight.w500, fontSize: 55 ), text: Department);
    TextPainter tpDepartment = new TextPainter(text: spanDepartment, textAlign: TextAlign.left, textDirection: TextDirection.ltr);
    tpDepartment.layout(minWidth: size.width - 80, maxWidth: size.width - 80);
    tpDepartment.paint(canvas, new Offset(60, 140));


    TextSpan spanLocation = new TextSpan(style: GoogleFonts.quicksand(color: ColorFromHexCode("#402F00"), fontSize: 30), text: Location);
    TextPainter tpLocation = new TextPainter(text: spanLocation, textAlign: TextAlign.left, textDirection: TextDirection.ltr);
    tpLocation.layout(minWidth: size.width - 80, maxWidth: size.width - 80);
    tpLocation.paint(canvas, new Offset(60, 350));


    TextSpan spanAboutJob = new TextSpan(style: GoogleFonts.quicksand(color: ColorFromHexCode("#402F00"), fontWeight: FontWeight.w300, fontSize: 25), text: AboutJob);
    TextPainter tpAboutJob = new TextPainter(text: spanAboutJob, textAlign: TextAlign.left, textDirection: TextDirection.ltr);
    tpAboutJob.layout(minWidth: size.width - 80, maxWidth: size.width - 80);
    tpAboutJob.paint(canvas, new Offset(60, 400));



    TextSpan spanUpdateName = new TextSpan(style: GoogleFonts.quicksand(color: ColorFromHexCode("#FF0000"), fontSize: 30), text: UpdateName + ": " + UpdateDate);
    TextPainter tpUpdateName = new TextPainter(text: spanUpdateName, textAlign: TextAlign.left, textDirection: TextDirection.ltr);
    tpUpdateName.layout(minWidth: size.width - 80, maxWidth: size.width - 80);
    tpUpdateName.paint(canvas, new Offset(60, 700));

    
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {

    return false;
  }

}

class GetTheIMage{
  static ui.Image backgroundImage = ui.Image as ui.Image;

  static Future<ui.Image> getUiImage(String imageAssetPath, int height, int width) async {
    final ByteData assetImageByteData = await rootBundle.load(imageAssetPath);
    final codec = await ui.instantiateImageCodec(
      assetImageByteData.buffer.asUint8List(),
      targetHeight: height,
      targetWidth: width,
    );
    final image = (await codec.getNextFrame()).image;
    backgroundImage = image;
    return image;
  }
}