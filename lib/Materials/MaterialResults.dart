import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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
    MaterialDatas.searchmaterialDatas.forEach((MaterialData materialData) async {

      if(materialData.URL != null && materialData.Name != "" && await canLaunch(materialData.URL) && !materialData.Name.contains("Forgot") && !materialData.Name.contains("ExamForo") && !materialData.Name.contains("Comments") && materialData.Name != "" && materialData.Name != " ") {
        String Title = materialData.Name;
        
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
              child: Row(
                children: <Widget>[
                  const Icon(Icons.picture_as_pdf_sharp, size: 25,),
                  SizedBox(width: 5,),
                  Container(
                    width: MediaQuery.of(context).size.width - 100,
                    margin: const EdgeInsets.only(top: 5, bottom: 5),
                    decoration: BoxDecoration(
                      color: Colors.white70.withOpacity(.1),
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                    ),
                    padding: EdgeInsets.all(5),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        SizedBox(width: 10,),
                        Text(Title == "" ? "My " +
                            MaterialDatas.SearchTitle.toString() : Title, style: GoogleFonts.quicksand(
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                          color: Colors.grey[900],
                        ),),
                        Text("Source: ${materialData.Source}", style: GoogleFonts.quicksand(
                          fontWeight: FontWeight.w200,
                          fontSize: 7,
                          color: Colors.grey[200],
                        ),),
                      ],
                    ),
                  ),
                ],
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
    textEditingController.text = MaterialDatas.SearchTitle;
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
                          onSubmitted: (e){
                            Search();
                          },
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
                child: Text("All the documents are scrapped from Internet. Some documents may need sign in.", style: GoogleFonts.quicksand(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.grey.shade300), textAlign: TextAlign.start,),
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
