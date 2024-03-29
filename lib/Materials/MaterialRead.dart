import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:governmentapp/AdFile.dart';
import 'package:governmentapp/Ads/HomeAd.dart';
import 'package:governmentapp/DataPullers/MaterialsPusher.dart';
import 'package:governmentapp/HexColors.dart';
import 'package:governmentapp/Materials/MaterialResults.dart';
import 'package:governmentapp/Materials/MaterialData.dart';
import 'package:html/parser.dart';
import 'package:http/http.dart' as http;

class MaterialRead extends StatefulWidget {
  const MaterialRead({Key? key}) : super(key: key);

  @override
  State<MaterialRead> createState() => _MaterialReadState();
}

class _MaterialReadState extends State<MaterialRead> {
  bool isloading = false;
  TextEditingController textEditingController = TextEditingController();



  Future<void> Search() async
  {
    setState(() {
      isloading = true;
    });
    String search = textEditingController.text;
    MaterialDatas.SearchTitle = search;
    MaterialDatas.materialDatas.forEach((MaterialData materialData) {
      if(materialData.Name.toLowerCase().contains(search.toLowerCase()))
        {
          MaterialDatas.searchmaterialDatas.add(materialData);
        }
    });
  }


  Container adcntnr = Container();
  Future<void> LoadADWidget()
  async {
    await TJSNInterstitialAd.LoadMaterial();
    adcntnr = Container(
      child: TJSNInterstitialAd.adWidget5,
      width: 320,
      height: 100,
    );
    setState(() {

    });
  }


  @override
  void initState() {
    LoadADWidget();
    TJSNInterstitialAd.LoadMaterial();
    MaterialPusher.Execute();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          color: ColorFromHexCode("#FFFFFF"),
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                width: 200,
                height: 200,
                decoration: const BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage("./assets/branding/book.png")
                    )
                ),
              ),
              const SizedBox(height: 20,),
              Text("Find the Material", style: TextStyle(fontFamily: "uber",fontSize: 25, fontWeight: FontWeight.w700),),
              const SizedBox(height: 20,),
              Container(
                width: MediaQuery.of(context).size.width,
                margin: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: const BorderRadius.all(Radius.circular(15)),
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
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: "Write a job name or book name",
                  ),
                ),
              ),
              GestureDetector(
                onTap: () async {
                  await Search();

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
                        return const MaterialResult();
                      }));
                },
                child: Container(
                  height: 60,
                  width: MediaQuery.of(context).size.width,
                  margin: const EdgeInsets.only(left: 90, right: 90, top: 20, bottom: 20),
                  decoration: BoxDecoration(
                    color: Colors.grey[900],
                    borderRadius: const BorderRadius.all(Radius.circular(15)),
                  ),
                  alignment: Alignment.center,
                  padding: const EdgeInsets.all(20),
                  child: Text("Search", style: TextStyle(fontFamily: "uber",fontSize: 20, fontWeight: FontWeight.w500, color: Colors.grey[400]),),
                ),
              ),
              Container(
                height: 50,
                width: 50,
                alignment: Alignment.center,
                padding: const EdgeInsets.all(20),
                child: isloading ? CircularProgressIndicator() : null,
              ),
              TJSNInterstitialAd.AdsEnabled ? HomeAd(adkey: "ca-app-pub-3701741585114162/1630773412",) : Container(child: Text(""),),
            ],
          ),
        ),
      ),
    );
  }
}
