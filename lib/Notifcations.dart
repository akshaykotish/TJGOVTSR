

import 'dart:async';

class Notifications{
  static List<String> notifications = <String>[];
  static int notifcs = 0;

  static StreamController<List<String>> NOTIFJOBSC = StreamController<List<String>>();
  static Stream NOTIFJOBSS = NOTIFJOBSC.stream;
  static late Function NOTIFJOBSF;


  static void init(){
    NOTIFJOBSS.listen((event) async {
      NOTIFJOBSF(event);
    });
  }
}