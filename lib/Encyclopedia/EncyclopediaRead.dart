import 'package:flutter/material.dart';
import 'package:governmentapp/Encyclopedia/EncyclopediaResults.dart';
import 'package:governmentapp/Encyclopedia/EncylopediaData.dart';
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
            Navigator.push(context, MaterialPageRoute(builder: (context) => EncyclopediaResult()));
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
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
                    image: AssetImage("./assets/branding/encyclopedia.png")
                  )
                ),
              ),
              const SizedBox(height: 20,),
              const Text("Encyclopedia", style: TextStyle(fontSize: 25, fontWeight: FontWeight.w700),),
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
                  height: 60,
                  width: MediaQuery.of(context).size.width,
                  margin: const EdgeInsets.only(left: 90, right: 90, top: 20, bottom: 20),
                  decoration: BoxDecoration(
                    color: Colors.grey[900],
                    borderRadius: const BorderRadius.all(Radius.circular(15)),
                  ),
                  alignment: Alignment.center,
                  padding: const EdgeInsets.all(20),
                  child: Text("Search", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500, color: Colors.grey[400]),),
                ),
              ),
              Container(
                height: 50,
                width: 50,
                alignment: Alignment.center,
                padding: const EdgeInsets.all(20),
                child: isloading ? CircularProgressIndicator() : null,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
