import 'package:flutter/material.dart';
import 'package:governmentapp/Encyclopedia/EncyclopediaSearch.dart';
import 'package:governmentapp/Encyclopedia/EncylopediaData.dart';
import 'package:html/parser.dart';
import 'package:http/http.dart' as http;

class EncyclopediaResult extends StatefulWidget {
  const EncyclopediaResult({Key? key}) : super(key: key);

  @override
  State<EncyclopediaResult> createState() => _EncyclopediaResultState();
}

class _EncyclopediaResultState extends State<EncyclopediaResult> {

  bool isloading = false;

  TextEditingController textEditingController = TextEditingController();
  var SearchResults = <Widget>[];


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
        pagedata = String.fromCharCodes(data).replaceAll("Wikipedia", "Encyclopedia");
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
        LoadSearchResult();
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


  void LoadSearchResult(){
    var _SearchResults = <Widget>[];
    EncylopediaDatas.encylopediaDatas.forEach((EncylopediaData encylopediaData) {
      _SearchResults.add(
        GestureDetector(
          onTap: (){
            print(encylopediaData.URL);
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
                  return EncylopediaSearch(url: encylopediaData.URL);
                }));
          },
          child: Container(
            margin: EdgeInsets.only(top: 10, bottom: 10),
            child: Column
              (
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(encylopediaData.Name, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: Colors.blueAccent),),
                Text(encylopediaData.Details, style: TextStyle(fontSize: 15,color: Colors.grey[500] ),),
              ],
            ),
          ),
        )
      );

      setState(() {
        textEditingController.text = EncylopediaDatas.SearchTitle;
        SearchResults = _SearchResults;
      });
    });
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
                                image: AssetImage("./assets/branding/encyclopedia.png")
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
                            hintText: "Search anything",
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: (){
                          Search();
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
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.all(20),
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
