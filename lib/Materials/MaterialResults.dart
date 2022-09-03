import 'package:flutter/material.dart';
import 'package:governmentapp/AdFile.dart';
import 'package:governmentapp/Encyclopedia/EncyclopediaSearch.dart';
import 'package:governmentapp/Encyclopedia/EncylopediaData.dart';
import 'package:governmentapp/Materials/MaterialData.dart';
import 'package:governmentapp/Materials/MaterialSearch.dart';
import 'package:html/parser.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

class MaterialResult extends StatefulWidget {
  const MaterialResult({Key? key}) : super(key: key);

  @override
  State<MaterialResult> createState() => _MaterialResultState();
}

class _MaterialResultState extends State<MaterialResult> {

  bool isloading = false;

  TextEditingController textEditingController = TextEditingController();
  var SearchResults = <Widget>[];

  Future<void> LoadSearchResult() async {
    var _SearchResults = <Widget>[];
    MaterialDatas.searchmaterialDatas.forEach((MaterialData materialData) {

      if(materialData.URL != null && materialData.URL != "" && materialData.URL != "null") {
        String Title = materialData.Name.replaceAll("à", "").replaceAll("¤", "").replaceAll("¸", "").replaceAll("", "").replaceAll("¥", "").replaceAll("", "").replaceAll("", "").replaceAll("", "").replaceAll("¤²", "");
        
        _SearchResults.add(
            GestureDetector(
              onTap: () async {
                await TJSNInterstitialAd.LoadAnAd();
                if (await canLaunch(materialData.URL)) {
                  await launch(materialData.URL);
                }
                else {
                  print("Can't launch ${materialData.URL}");
                }
              },
              child: Container(
                margin: const EdgeInsets.only(top: 10, bottom: 10),
                decoration: BoxDecoration(
                  border: Border.all(
                      color: Colors.grey.shade500.withOpacity(0.1), width: 1),
                  boxShadow: [
                    BoxShadow(
                      offset: Offset(2, 2),
                      blurRadius: 5,
                      spreadRadius: 5,
                      color: Colors.blue.shade200.withOpacity(0.1),

                    ),

                  ],
                  color: Colors.white70.withOpacity(.1),
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                ),
                padding: EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      MaterialDatas.SearchTitle.toUpperCase(), style: TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: 10,
                      color: Colors.grey[600],
                    ),),
                    SizedBox(width: 10,),
                    Text(Title == "" ? "My " +
                        MaterialDatas.SearchTitle.toString() : Title, style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                      color: Colors.grey[900],
                    ),),
                  ],
                ),
              ),
            )
        );

        setState(() {
          isloading = false;
          SearchResults = _SearchResults;
        });
      }
    });
  }


  Future<void> Search() async
  {
    MaterialDatas.SearchTitle = textEditingController.text;
    MaterialDatas.searchmaterialDatas.clear();
    setState(() {
      isloading = true;
    });
    String search = textEditingController.text;
    MaterialDatas.materialDatas.forEach((MaterialData materialData) {
      if(materialData.Name.toLowerCase().contains(search.toLowerCase()))
      {
        MaterialDatas.searchmaterialDatas.add(materialData);
      }
    });

    LoadSearchResult();
  }

  @override
  void initState() {
    LoadSearchResult();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              GestureDetector(
                onTap: ()=>LoadSearchResult(),
                child: Container(
                  color: Colors.blueAccent,
                  height: 150,
                  padding: const EdgeInsets.only(
                      top: 50,
                      left: 10,
                      right: 10,
                      bottom: 10
                  ),
                  alignment: Alignment.center,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Container(
                        width: 50,
                        height: 50,
                        decoration: const BoxDecoration(
                            image: DecorationImage(
                                image: AssetImage("./assets/branding/book.png")
                            )
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width - 150,
                        height: 60,
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: const BorderRadius.all(Radius.circular(15)),
                        ),
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.all(10),
                        margin: const EdgeInsets.all(10),
                        child: TextField (

                          controller: textEditingController,
                          onChanged: (e){

                          },
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: "Write job or a document name",
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () async {
                          await Search().then((value) async {
                            await LoadSearchResult();
                          });
                        },
                        child: Container(
                          width: 50,
                          height: 50,
                          child: Icon(Icons.search, color: Colors.white,),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Container(
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.all(20),
                child: Text("Some documents may need sign in.", style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.grey.shade300), textAlign: TextAlign.start,),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                padding: const EdgeInsets.all(20),
                child: SingleChildScrollView(
                  child: isloading ? Center(child: const CircularProgressIndicator()) : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: SearchResults,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
