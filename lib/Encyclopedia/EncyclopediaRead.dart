import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:governmentapp/AdFile.dart';
import 'package:governmentapp/Ads/HomeAd.dart';
import 'package:governmentapp/Encyclopedia/EncyclopediaResults.dart';
import 'package:governmentapp/Encyclopedia/EncylopediaData.dart';
import 'package:governmentapp/HexColors.dart';
import 'package:html/parser.dart';
import 'package:http/http.dart' as http;

class EncyclopediaRead extends StatefulWidget {
  const EncyclopediaRead({Key? key}) : super(key: key);

  @override
  State<EncyclopediaRead> createState() => _EncyclopediaReadState();
}

class _EncyclopediaReadState extends State<EncyclopediaRead> {
  bool isloading = false;
  TextEditingController textEditingController = TextEditingController();


  Future<void> Search()
  async {
    EncylopediaDatas.encylopediaDatas.clear();

    if(textEditingController.text != "" && textEditingController.text != " " && textEditingController.text.isNotEmpty) {
      EncylopediaDatas.SearchTitle = textEditingController.text;
      String url = "https://en.wikipedia.org/w/index.php?search=${textEditingController
          .text}&title=Special:Search&profile=advanced&fulltext=1&ns0=1";
      setState(() {
        isloading = true;
      });

      Uri uri = Uri.parse(url);
      var res = await http.get(uri);

      int lastbyte = 0;
      try{
        lastbyte = res.bodyBytes.length;
      }
      catch(e)
      {
        int lastindex = e.toString().lastIndexOf("Unexpected extension byte (at offset ") + "Unexpected extension byte (at offset ".length;
        String str = e.toString().substring(lastindex, e.toString().length-1);

        lastbyte = int.parse(str);
      }
      
      String pagedata = "";
      try {
        var data = res.bodyBytes.sublist(0, lastbyte-1);
        pagedata = String.fromCharCodes(data).replaceAll("Wikipedia", "TJSNPedia");
        await ScrapResults(pagedata);

      }
      catch(e){
        print(e);
      }

    }
  }

  Future<void> ScrapResults(String pagedata)
  async {
    var document = parse(pagedata);
    var searchResults = document.getElementsByClassName("mw-search-results");
    print(searchResults);
    var allLish = parse(searchResults[0].outerHtml);
    var allLis = allLish.getElementsByTagName("li");
    print("Required Length is ${allLis[0].text}");
    for(int i=0; i<allLis.length; i++)
      {
        await MakeAResultBox(allLis[i].outerHtml);
        if(allLis.length - 1 == i)
          {
            setState(() {
              isloading = false;
            });
            Navigator.push(context, PageRouteBuilder(
                transitionDuration: const Duration(seconds: 1),
                transitionsBuilder: (BuildContext context, Animation<double> animation, Animation<double> secAnimation, Widget child){
                  const begin = Offset(1.5, 0.0);
                  const end = Offset.zero;
                  const curve = Curves.ease;

                  var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

                  return SlideTransition(
                    position: animation.drive(tween),
                    child: child,
                  );
                },
                pageBuilder: (BuildContext context, Animation<double> animation, Animation<double> secAnimation){
                  return EncyclopediaResult();
                }));
          }
      }
  }

  Future<void> MakeAResultBox(String res) async {
    var doc = parse(res);
    String aName = doc.getElementsByTagName("a")[0].text;
    String aURL = "https://en.wikipedia.org" + doc.getElementsByTagName("a")[0].attributes["href"].toString();
    String Details = doc.getElementsByClassName("searchresult")[0].text;

    EncylopediaDatas.encylopediaDatas.add(EncylopediaData(aName, aURL, Details));
    print("Name = ${aName} and URL = ${aURL} and Details = ${Details}");
  }

  Container adCntnr = Container();
  Future<void> LoadADWidget()
  async {
    await TJSNInterstitialAd.LoadEncyclopedia();
    adCntnr = Container(
      child: TJSNInterstitialAd.adWidget4,
      width: 320,
      height: 100,
    );
    setState(() {

    });
  }


  @override
  void initState() {
    LoadADWidget();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          color: ColorFromHexCode("#404752"),
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text("TJSNPedia", style: GoogleFonts.poppins(fontSize: 30, fontWeight: FontWeight.w700, color: ColorFromHexCode("#F2E7D5")),),
              const SizedBox(height: 20,),
              Container(
                width: MediaQuery.of(context).size.width,
                margin: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: ColorFromHexCode("#D9D9D9"),
                  borderRadius: const BorderRadius.all(Radius.circular(5)),
                ),
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.all(10),
                child: TextField (
                  onSubmitted: (e){
                    Search();
                  },
                  controller: textEditingController,
                  onChanged: (e){

                  },
                  decoration: InputDecoration(
                      border: InputBorder.none,
                    hintText: "Search anything",
                    hintStyle: GoogleFonts.poppins(fontWeight: FontWeight.w500),
                    suffixIcon: GestureDetector(
                        onTap: (){
                          Search();
                        },
                        child: Icon(Icons.search)),
                  ),

                ),
              ),
              Container(
                height: 50,
                width: 50,
                alignment: Alignment.center,
                padding: const EdgeInsets.all(20),
                child: isloading ? CircularProgressIndicator() : null,
              ),
              TJSNInterstitialAd.AdsEnabled ? HomeAd(adkey: "ca-app-pub-3701741585114162/7553732677",) : Container(child: Text(""),),

            ],
          ),
        ),
      ),
    );
  }
}
