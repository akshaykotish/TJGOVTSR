import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:html/parser.dart';
import 'package:http/http.dart' as http;


class EncylopediaSearch extends StatefulWidget {
  EncylopediaSearch({required this.url});

  String url = "";

  @override
  State<EncylopediaSearch> createState() => _EncylopediaSearchState();
}

class _EncylopediaSearchState extends State<EncylopediaSearch> {


  var AllContents = <Widget>[];

  void GetMyData()
  async {
    String url = widget.url;
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
      pagedata = String.fromCharCodes(data);
    }
    catch(e){
      print(e);
    }

    if(pagedata != "")
      {
        LoadContent(pagedata);
      }
  }

  void LoadContent(String data){
    var _AllContents = <Widget>[];

    var document = parse(data);
    var elements = document.getElementById("bodyContent");
    
    var Title = document.getElementById("firstHeading")?.text;
    
    _AllContents.add(Container(
        margin: EdgeInsets.only(top: 50),
        child: Container(
            child: Text(Title.toString(), style: TextStyle(fontFamily: "uber",fontWeight: FontWeight.bold, fontSize: 30,),))));

    var my = elements?.getElementsByClassName("mw-parser-output")[0].children;
    if(my != null) {
      for (int i = 0; i < my.length; i++) {
        
        String cntnt = my[i].text.replaceAll("â", " - ").replaceAll("(listen)", "");

        if(my[i].localName == "p") {
          _AllContents.add(Text(
            cntnt, style: TextStyle(fontFamily: "uber",fontSize: 20,),
          ));
        }
        else if(my[i].localName == "h2")
          {
            _AllContents.add(Text(
              cntnt, style: TextStyle(fontFamily: "uber",fontSize: 24, fontWeight: FontWeight.w700),
            ));
          }
        else if(my[i].localName == "h3")
          {
            _AllContents.add(Text(
              cntnt, style: TextStyle(fontFamily: "uber",fontSize: 25, fontWeight: FontWeight.w700),
            ));
          }
        else if(my[i].localName == "h4")
        {
          _AllContents.add(Text(
            cntnt, style: TextStyle(fontFamily: "uber",fontSize: 26, fontWeight: FontWeight.bold),
          ));
        }
        else if(my[i].localName == "div" && my[i].classes.contains("thumb"))
          {
            print("IMG DOIN");
            String? src = parse(my[i].outerHtml).getElementsByTagName("img")[0].attributes["src"].toString().replaceAll("//", "https://");

            print(src);

            if(src != null) {
              print("IMG DOINXXX");
              _AllContents.add(Container(
                  width: MediaQuery.of(context).size.width - 100,
                  color: Colors.black,
                  child: Image.network(src, fit: BoxFit.fitWidth,)));
            }
          }

        if(i == my.length - 1)
          {
            setState(() {
              AllContents = _AllContents;
            });
          }
      }
    }

  }

  @override
  void initState() {
    GetMyData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.only(
          top: 50,
          bottom: 0,
          left: 40,
          right: 40,
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: AllContents,
          ),
        )
      ),
    );
  }
}
