import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:html/parser.dart';
import 'package:http/http.dart' as http;

class GKPullers{
  static void Execute(){
    print("GK Executing...");
    GKToday.Start();
    GKTodayQuiz.Start();
  }
}

class GKTodayData{
  String Heading = "";
  String Date = "";
  String Image = "";
  String Content = "";
  String URL = "";

  GKTodayData(String heading, String date, String image, String content, String url)
  {
    Heading = heading; Date = date; Image = image; Content = content; URL = url;
  }
}

class GKToday{
  static int index = 0;
  static List<GKTodayData> GKtodayDatas = <GKTodayData>[];

  static Future<void> PushOnFirebase() async {
    var GKToday = await FirebaseFirestore.instance.collection("GKToday").get();
    GKToday.docs.forEach((element) async {
        await FirebaseFirestore.instance.collection("GKToday").doc(element.id).delete();
    });

    GKtodayDatas.forEach((GKTodayData gKtodayData) async {
      index++;
      String NMBR = index < 10 ? "000$index" :
        index < 100 ? "00$index" :
            index < 1000 ? "0$index" : index.toString();

      print("GK INdex GK$NMBR");
      await FirebaseFirestore.instance.collection("GKToday").doc("GK$NMBR").set({
      "Heading": gKtodayData.Heading,
      "Date": gKtodayData.Date,
      "Image": gKtodayData.Image,
      "Content": gKtodayData.Content,
      "URL": gKtodayData.URL,
      });
    });

    FirebaseFirestore.instance.collection("Logs").doc("GKDates").update({"GKNEWS": "${DateTime
        .now()
        .year}-${DateTime
        .now()
        .month}-${DateTime
        .now()
        .day}"});
  }

  static Future<void> GetAllNewsOnPage(String url)
  async {
    var document = await http.read(Uri.parse(url));
    var inside_post = parse(document).getElementsByClassName("inside_post");

    var subnodes = inside_post[0].children;


    String Heading = "";
    String Date = "";
    String Image = "";
    String Content = "";
    String URL = "";

    for(int i=0; i<subnodes.length; i++)
      {
        String? idis = subnodes[i].attributes["id"];
        String? classis = subnodes[i].attributes["class"];
        String? type = subnodes[i].localName;
        if(idis == "list")
          {
            Heading = subnodes[i].text;
            URL = subnodes[i].getElementsByTagName("a").isNotEmpty ?  subnodes[i].getElementsByTagName("a")[0].attributes["href"].toString() : "https://www.gktoday.in/current-affairs?TrafficFrom=TrackJobsSArkariNaukriApp";
          }
        if(classis == "postmeta-primary")
          {
            Date = subnodes[i].text;
          }
        if(classis == "featured_image")
          {
            Image = subnodes[i].getElementsByTagName("img").isNotEmpty ? subnodes[i].getElementsByTagName("img")[0].attributes["src"].toString() : "https://www.gktoday.in/wp-content/themes/groovy/images/logo.png";
          }

        if(type == "p" && classis != "small-font")
        {
          Content = subnodes[i].text;
          GKtodayDatas.add(GKTodayData(Heading, Date, Image, Content, URL));
          Content = "";
          Date = "";
          Image = "";
          Content = "";
          URL = "";
        }
      }

  }


  static Future<void> SepratingPage(String pagedata) async {
    var data = parse(pagedata);
    var pages = data.getElementsByClassName("wp-pagenavi");

    if(pages.isNotEmpty)
      {
        var anchors = pages[0].getElementsByTagName("a");

        int first = int.parse(anchors[0].text);
        int last = int.parse(anchors[anchors.length-1].text);

        for(int i=first-1; i<=last; i++)
          {
            String URL = "https://www.gktoday.in/current-affairs/page/$i/";
            await GetAllNewsOnPage(URL);
          }

        await PushOnFirebase();
      }
  }

  static Future<void> LoadCurrentAffairs() async {
    var pagedata = await http.read(Uri.parse("https://www.gktoday.in/current-affairs/"));
    await SepratingPage(pagedata);
  }

  static Future<void> Start() async {
    var Timings = await FirebaseFirestore.instance.collection("Logs").doc("GKDates").get();
    var Time = Timings.exists ? Timings.data()!["GKNEWS"] : "";


    if(Time != "${DateTime
        .now()
        .year}-${DateTime
        .now()
        .month}-${DateTime
        .now()
        .day}") {
      print("Loading Current Affairs");
      await LoadCurrentAffairs();
    }
  }
}

class GKTodayQuizData{
  String Question = "";
  List<String> Options = <String>[];
  String Answer = "";
  String Hint = "";

  GKTodayQuizData(q, o, a, h)
  {
    Question = q; Options = o; Answer = a; Hint = h;
  }
}

class GKTodayQuiz{


  static List<GKTodayQuizData> GKTodayQuizDatas = <GKTodayQuizData>[];

  static Future<void> PushOnFirebase() async {
    String ThisMonth = DateTime.now().month.toString() + DateTime.now().year.toString();
    await FirebaseFirestore.instance.collection("GKTodayQuiz").doc(ThisMonth).delete();

    GKTodayQuizDatas.forEach((GKTodayQuizData gKtodayQuizData) async {
      await FirebaseFirestore.instance.collection("GKTodayQuiz").doc(ThisMonth).collection("Questions").add({
        "Question": gKtodayQuizData.Question,
        "Answer": gKtodayQuizData.Answer,
        "Options": gKtodayQuizData.Options,
        "Hint": gKtodayQuizData.Hint,
      });
    });
    
    await FirebaseFirestore.instance.collection("Logs").doc("GKDates").update({"GKQUIZ": "${DateTime
        .now()
        .year}-${DateTime
        .now()
        .month}-${DateTime
        .now()
        .day}"});
  }

  static Future<void> GetAllQuizOnPage(String url) async
  {
    var document = await http.read(Uri.parse(url));
    var quiz_print = parse(document).getElementsByClassName("quiz_print");
    var sques_quizs = quiz_print[0].getElementsByClassName("sques_quiz");
    for(int i=0; i<sques_quizs.length; i++)
      {
        var wp_quiz_question = sques_quizs[i].getElementsByClassName("wp_quiz_question")[0].text;
        int z = wp_quiz_question.indexOf(".");
        String question = wp_quiz_question.substring(z+2, wp_quiz_question.length);

        var wp_quiz_question_options = sques_quizs[i].getElementsByClassName("wp_quiz_question_options")[0].text;

        int a = wp_quiz_question_options.indexOf("[A]");
        int b = wp_quiz_question_options.indexOf("[B]");
        int c = wp_quiz_question_options.indexOf("[C]");
        int d = wp_quiz_question_options.indexOf("[D]");

        String A = wp_quiz_question_options.substring(a + 4, b);
        String B = wp_quiz_question_options.substring(b + 4, c);
        String C = wp_quiz_question_options.substring(c + 4, d);
        String D = wp_quiz_question_options.substring(d + 4, wp_quiz_question_options.length);

        var ques_answer = sques_quizs[i].getElementsByClassName("ques_answer")[0].text;
        int e = ques_answer.indexOf("[");
        int f = ques_answer.indexOf("]");
        String answer = ques_answer.substring(e+1, f);

        var answer_hint = sques_quizs[i].getElementsByClassName("answer_hint")[0].text;
        String hint = answer_hint.replaceAll("Notes:", "");

        List<String> options = [A, B, C, D];
        GKTodayQuizDatas.add(GKTodayQuizData(question, options, answer, hint));
      }
 }


  static Future<void> SepratingPage(String pagedata) async {
    var data = parse(pagedata);
    var pages = data.getElementsByClassName("basic_quiz_pagination");

    if(pages.isNotEmpty)
    {
      var anchors = pages[0].getElementsByTagName("a");

      int first = int.parse(anchors[0].text);
      int last = int.parse(anchors[anchors.length-2].text);

      for(int i=first; i<=last; i++)
      {
        String URL = "https://www.gktoday.in/quizbase/current-affairs-quiz-september-2022?pageno=$i/";
        await GetAllQuizOnPage(URL);
      }
      await PushOnFirebase();
    }
  }

  static Future<void> LoadQuizData() async {
    List<String> months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',

      'July',
      'August',
      'September',
      'October',
      'November',
      'December'
    ];
    String month = months[DateTime.now().month-1].toLowerCase();
    String year = DateTime.now().year.toString();
    var pagedata = await http.read(Uri.parse("https://www.gktoday.in/quizbase/current-affairs-quiz-${month}-${year}"));
    await SepratingPage(pagedata);
  }


  static Future<void> Start() async {
    var Timings = await FirebaseFirestore.instance.collection("Logs").doc("GKDates").get();
    var Time = Timings.exists ? Timings.data()!["GKQUIZ"] : "";

    if(Time != "${DateTime
        .now()
        .year}-${DateTime
        .now()
        .month}-${DateTime
        .now()
        .day}") {
      await LoadQuizData();
    }
  }
}