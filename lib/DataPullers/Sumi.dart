
import 'package:flutter/cupertino.dart';
import 'package:html/parser.dart';
import 'package:http/http.dart' as http;

class Sumi{


  Future<void> Load_NeededPage(String uurl)
  async {
    var url = Uri.parse(uurl);
    String pagedata = await http.read(url);
    var document = parse(pagedata);
  }


  Future<void> Execute() async {
    var url = Uri.parse("https://ieltspracticeonline.com/ielts-writing/ielts-academic-task-1/");
    String pagedata = await http.read(url);
    var document = parse(pagedata);

    var all_a = document.getElementsByTagName("a");

    for(int i=66; i<all_a.length; i++)
      {
        String data = all_a[i].outerHtml;
        var indx = data.indexOf('href="') + 6;

        String link = "";

        int j = indx;
        while(data[j] != '"')
        {
          link += data[j];
          j++;
        }


        Load_NeededPage(link);
        //print("Sumi" + i.toString() + all_a[i].outerHtml);
      }

  }
}