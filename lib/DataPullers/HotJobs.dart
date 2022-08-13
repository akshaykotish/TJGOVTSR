

import 'dart:core';
import 'dart:core';

import 'package:cloud_firestore/cloud_firestore.dart';

class HotJobs{

  static var Hots = <dynamic>[];

  static Future<void> UpdateHotJobs(String path) async {

    var hots = await FirebaseFirestore.instance.collection("Logs").doc("Hots").get();
    try {
      Hots = hots.exists ? hots.data()!["Hots"] : null;
      Hots = Hots == null ? <String>[] : Hots;
    }
    catch(e){
      print(e);
    }

    print(Hots.length);

    if(Hots.length >= 30) {
      Hots.removeRange(0, Hots.length - 29);
    }

    Hots.add(path);
    print(path + " " + Hots.length.toString());
    if(Hots.length == 1)
      {
        await FirebaseFirestore.instance.collection("Logs").doc("Hots").set({
          "Hots" : Hots,
        });
      }
    else {
      await FirebaseFirestore.instance.collection("Logs").doc("Hots").update({
        "Hots": Hots,
      });
    }
  }
}