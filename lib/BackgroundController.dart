import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:governmentapp/Animations/BrandSplashScreen.dart';
import 'package:governmentapp/Beauty/Home.dart';
import 'package:governmentapp/DataLoadingSystem/RequiredDataLoading.dart';
import 'package:governmentapp/Files/CurrentJob.dart';
import 'package:governmentapp/Files/JobSheet.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workmanager/workmanager.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'JobData.dart';

var mycontext;

Future<void> ShowNotification(flutterLocalNotificationsPlugin,
    String title, String body, String payload
    )
async {
  const AndroidNotificationDetails androidNotificationDetails =
  AndroidNotificationDetails('TJNotifs', 'TJ Notifications',
      channelDescription: 'Notifications and Updates',
      importance: Importance.max,
      priority: Priority.max,
      ticker: 'ticker');
  const NotificationDetails notificationDetails =
  NotificationDetails(android: androidNotificationDetails);
  await flutterLocalNotificationsPlugin.show(
      0, title, body, notificationDetails,
      payload: payload);
}

FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
@pragma("vm:entry-point")
void callbackDispatcher() {
  WidgetsFlutterBinding.ensureInitialized();
  flutterLocalNotificationsPlugin =  FlutterLocalNotificationsPlugin();
  AndroidInitializationSettings androidInitializationSettings = AndroidInitializationSettings('@mipmap/ic_launcher');

  InitializationSettings initializationSettings = InitializationSettings(android: androidInitializationSettings);
  flutterLocalNotificationsPlugin.initialize(initializationSettings, onDidReceiveNotificationResponse: onDidReceiveNotificationResponse, onDidReceiveBackgroundNotificationResponse: onDidReceiveBackgroundNotificationResponse );

  flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()?.requestPermission();


  Workmanager().executeTask((task, inputData) async {
    await Firebase.initializeApp();
    var Hots = await FirebaseFirestore.instance.collection("Logs").doc("Hots").get();

    if(Hots.exists)
    {
      List<dynamic> HotsList = await Hots.data()!["Hots"];
      var sharedPreferences = await SharedPreferences.getInstance();
      String? LastHot =  sharedPreferences.getString("LastHot");
      if((LastHot != null && LastHot != HotsList[HotsList.length - 1]) || LastHot == null)
      {
        String path = HotsList[HotsList.length - 1];
        //Jobs/Dr. Ram Manohar Lohia Institute of Medical Sciences Lucknow/INDIA/DRMLIMSLucknowNonTeachingVariousPostRecruitment2022;Dr. Ram Manohar Lohia Institute of Medical Sciences Lucknow;Dr. Ram Manohar Lohia Institute of Medical Sciences DRRMLIMS Lucknow Various Non Teaching Recruitment 2022 Apply Online for 520 Post;Dr. Ram Manohar Lohia Institute of Medical Sciences Lucknow DRRMLIMS Lucknow has released the Non Teaching Various Post notification for the recruitment of 520 Multiple Post Vacancy 2022. All the candidates who are interested in this Dr RML IMS Various Post 2022 Recruitment and fulfill the eligibility can apply online from 28 October 2022 to 27 November 2022. See the advertisement for information related to age limit, syllabus, institute wise post, selection procedure, pay scale in DR RML IMS Recruitment.
        ShowNotification(flutterLocalNotificationsPlugin, "${path.split("/")[1]}", "New vacancies | Current Affair | Quiz  is now  updated. Click to Check.", path);
      }
    }
  return Future.value(true);
  });
}

Future<void> onDidReceiveNotificationResponse(NotificationResponse details) async {
  final String? payload = details.payload;
  if (details.payload != null) {
    JobData jobData = JobData();
    jobData.path = payload!;
    await RequiredDataLoading.LoadJobFromPath(jobData.path, jobData).asStream().listen((event) {
      CurrentJob.currentjobStreamToCall(jobData);
      CurrentJob.currentjobStreamForVacanciesToCall(jobData);
    });
  }
}


Future<void> onDidReceiveBackgroundNotificationResponse(NotificationResponse details) async {
  final String? payload = details.payload;
  if (details.payload != null) {
    JobData jobData = JobData();
    jobData.path = payload!;
    await RequiredDataLoading.LoadJobFromPath(jobData.path, jobData).asStream().listen((event) {
      CurrentJob.currentjobStreamToCall(jobData);
      CurrentJob.currentjobStreamForVacanciesToCall(jobData);
    });
  }
}
