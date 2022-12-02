import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:governmentapp/DataLoadingSystem/JobDisplayManagement.dart';
import 'package:governmentapp/DataPullers/GKPullers.dart';
import 'package:governmentapp/HexColors.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:translator/translator.dart';
import 'package:url_launcher/url_launcher.dart';

class GKPage extends StatefulWidget {
  GKPage({required this.gkTodayData});

  GKTodayData gkTodayData;

  @override
  State<GKPage> createState() => _GKPageState();
}

class _GKPageState extends State<GKPage> {
  final translator = GoogleTranslator();

  String HeaderHindi = "";
  String ContentHindi = "";

  Future<void> ConvertToHindi() async {
    HeaderHindi = (await translator.translate(widget.gkTodayData.Heading, from: 'en', to: 'hi')).text;
    ContentHindi = (await translator.translate(widget.gkTodayData.Content, from: 'en', to: 'hi')).text;
    setState(() {

    });
  }

  @override
  void initState() {
    JobDisplayManagement.LanguageChangeF = (String lang)
    {
      setState(() {

      });
    };
    ConvertToHindi();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        if (await canLaunch(widget.gkTodayData.URL)) {
        await launch(widget.gkTodayData.URL);
        }
        else {
        print("Can't launch ${widget.gkTodayData.URL}");
        }
      },
      child: Container(
        color: ColorFromHexCode("#404752"),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height/3,
              margin: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
              color: ColorFromHexCode("#404752"),
              child: Image.network(widget.gkTodayData.Image, fit: BoxFit.contain,),
            ),
            Container(
                padding: const EdgeInsets.only(left: 25, right: 25, top: 20),
                child: Text(GKTodayData.CurrentLanguage == "English" ? widget.gkTodayData.Heading : HeaderHindi, style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 25, color: Colors.white ),)),
      Container(
      padding: const EdgeInsets.only(left: 25, right: 25, top: 5),
      child: Text(GKTodayData.CurrentLanguage == "English" ? widget.gkTodayData.Content : ContentHindi, style: GoogleFonts.poppins(fontWeight: FontWeight.w400, color: Colors.white ),)
    ),
    Container(
      padding: const EdgeInsets.only(left: 25, right: 25, top: 5),
    child: Text("Source: ${widget.gkTodayData.URL}", style: GoogleFonts.poppins(fontSize: 8, color: Colors.white),),
    )
          ],
        ),
      ),
    );
  }
}
