

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WriteALog{

  static Future<void> Write(String type, String data, String timeStamp)
  async {
    final prefs = await SharedPreferences.getInstance();
    String? contact = prefs.getString("LoginContact");
    FirebaseFirestore.instance.collection("Users").doc(contact).collection("Logs").add({
      "Type": type,
      "Data": data,
      "TimeStamp": timeStamp,
    });
  }
}