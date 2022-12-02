import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:governmentapp/BackgroundController.dart';
import 'package:governmentapp/ChatDatas.dart';
import 'package:governmentapp/DataLoadingSystem/JobDisplayManagement.dart';
import 'package:governmentapp/DataLoadingSystem/RequiredDataLoading.dart';
import 'package:governmentapp/DataLoadingSystem/RequiredDataLoading.dart';
import 'package:governmentapp/DataLoadingSystem/SearchAbleDataLoading.dart';
import 'package:governmentapp/Files/CurrentJob.dart';
import 'package:governmentapp/HexColors.dart';
import 'package:governmentapp/JobData.dart';
import 'package:governmentapp/JobDisplayData.dart';
import 'package:governmentapp/Notifcations.dart';

class Chats extends StatefulWidget {
  const Chats({Key? key}) : super(key: key);

  @override
  State<Chats> createState() => _ChatsState();
}

class _ChatsState extends State<Chats> {

  bool iswaiting = false;

  ScrollController scrollController = ScrollController();
  var AllChats = <Widget>[];
  var _AllChats = <Widget>[];

  void DisplayChat(ChatBoxData chatBoxData){
    var Jobs = <Widget>[];

    bool isfullwidth = false;
    int index = 1;
    for(var jbs in chatBoxData.Jobs.keys)
      {
        if(jbs.isNotEmpty) {
          if (jbs.length > 50) {
            isfullwidth = true;
          }
          Jobs.add(GestureDetector(
            onTap: () async {
              JobData jobData = JobData();
              jobData.path = chatBoxData.Jobs[jbs].toString();
              await RequiredDataLoading.LoadJobFromPath(jobData.path, jobData)
                  .asStream()
                  .listen((event) {
                CurrentJob.currentjobStreamToCall(jobData);
                CurrentJob.currentjobStreamForVacanciesToCall(jobData);
              });
            },
            child: Container(
              alignment: chatBoxData.isleft == true
                  ? Alignment.centerLeft
                  : Alignment.centerRight,
              width: jbs.length > 30 ? (80 / 100) * MediaQuery
                  .of(context)
                  .size
                  .width : null,
              padding: EdgeInsets.all(5),
              child: Row(
                crossAxisAlignment: chatBoxData.isleft == true
                    ? CrossAxisAlignment.start
                    : CrossAxisAlignment.end,
                children: <Widget>[
                  Text("$index. ", style: GoogleFonts.poppins(
                      color: ColorFromHexCode("#004687"),
                      fontWeight: FontWeight.w500, fontSize: 12,),),
                  Container(
                      alignment: chatBoxData.isleft == true ? Alignment
                          .centerLeft : Alignment.centerRight,
                      width: jbs.length > 30 ? (80 / 100) *
                          ((80 / 100) * MediaQuery
                              .of(context)
                              .size
                              .width) : null,
                      child: Text(jbs, style: GoogleFonts.poppins(
                        color: ColorFromHexCode("#004687"),
                        fontWeight: FontWeight.w300,  fontSize: 12,
                        decoration: TextDecoration.underline,),)),
                ],
              ),
            ),
          ));
          index++;
        }
      }

    _AllChats.add(Container(
      padding: EdgeInsets.only(
        top: 10,
        bottom: 10
      ),
      width: MediaQuery.of(context).size.width,
      alignment: chatBoxData.isleft == true ? Alignment.centerLeft : Alignment.centerRight,
      child: CustomPaint(
        painter: ChatBackground(chatBoxData.isleft),
        child: Container(
          width: isfullwidth == true ? (80/100) *  MediaQuery.of(context).size.width : null,
          decoration: BoxDecoration(
            borderRadius:chatBoxData.isleft == true ? BorderRadius.all(Radius.circular(20)) : BorderRadius.all(Radius.circular(20)),
            color: ColorFromHexCode("#F4F4F4"),
          ),
          padding: EdgeInsets.all(10),
          margin: EdgeInsets.only(
            left: chatBoxData.isleft == true ? (5/100) *  MediaQuery.of(context).size.width : 0,
            right: chatBoxData.isleft == true ? 0 : (5/100) *  MediaQuery.of(context).size.width,
          ),
            child: Column(
              crossAxisAlignment: chatBoxData.isleft == true ?  CrossAxisAlignment.start : CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Text(chatBoxData.Message, style: GoogleFonts  .poppins(fontWeight: chatBoxData.isleft == true ? FontWeight.w600 : FontWeight.w400, fontSize: 12),),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: Jobs,
                ),
              ],
            ),
        ),
      ),
    ));


    setState(() {
      AllChats = _AllChats;
    });
  }


  Future<void> LoadChats() async {
    _AllChats.clear();
    print("YESS!!! ${ChatDatas.chatBoxDatas.length}");
    _AllChats.add(SizedBox(height: 50,));
    ChatDatas.chatBoxDatas.forEach((ChatBoxData chatBoxData) {
      DisplayChat(chatBoxData);
    });
    if(iswaiting == true)
    {
      _AllChats.add(Container(
          padding: EdgeInsets.only(
              top: 10,
              bottom: 10
          ),
          width: 100,
          alignment: Alignment.centerLeft,
          child: CustomPaint(
            painter: ChatBackground(true),
            child: Container(
              alignment: Alignment.centerLeft,
              width: 100,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(20)),
                color: ColorFromHexCode("#FFFFFF"),
              ),
              padding: EdgeInsets.all(10),
              margin: EdgeInsets.only(
                left: 5,
              ),
              child: Image.asset("./assets/branding/loading.gif", fit: BoxFit.fill, alignment: Alignment.centerLeft,),
            )
          )
        ),
      );
    }
    _AllChats.add(SizedBox(height: 50,));

    setState(() {
      AllChats = _AllChats;
    });
  }



  Future<void> LoadingJobChat() async {
    await LoadChats();
  }


  String Query = "";
  Future<void> InitFunctions()
  async {
    JobDisplayManagement.HOTJOBSF = (List<JobDisplayData> list) async {
      iswaiting = false;
      if(list.isNotEmpty) {
        print("HOTJOBS");
        await ChatDatas.CreateChat(
            "New latest ${list.length} jobs.", list, true);
      }
      print("I Came here and ${list.length} and ${Notifications.notifications.length}");
      await LoadingJobChat();
      scrollController.animateTo(scrollController.position.maxScrollExtent + 100,
          duration: Duration(seconds: 1), curve: Curves.bounceIn);
    };
    JobDisplayManagement.CHOOSEJOBSF = (List<JobDisplayData> list) async {
      iswaiting = false;
    if(list.isNotEmpty) {
        print("CHOOSEJOBS");
        await ChatDatas.CreateChat(
            "New latest ${list.length} jobs.", list, true);
        await LoadChats();
      }
    };
    JobDisplayManagement.SEARCHJOBSF = (List<JobDisplayData> list) async {
      iswaiting = false;
      if(list.isNotEmpty) {
        print("SEARCHJOBS ${list.length}");
          await ChatDatas.CreateChat(
              "Here is some ${Query} jobs founded.", list, true);
          await LoadChats();
          scrollController.animateTo(scrollController.position.maxScrollExtent + 100,
              duration: Duration(seconds: 1), curve: Curves.bounceIn);
      }
      else{
        print("SEARCHJOBS ${list.length}");
        await ChatDatas.CreateMessageChat(
            "Sorry, we don't find any job related to ${Query}.", true);
        await LoadChats();
        scrollController.animateTo(scrollController.position.maxScrollExtent + 100,
            duration: Duration(seconds: 1), curve: Curves.bounceIn);
      }
    };
    JobDisplayManagement.FAVJOBSF = (List<JobDisplayData> list) async {
      iswaiting = false;
      if(list.isNotEmpty) {
        print("FAVJOB");
        await ChatDatas.CreateChat("Your favourite jobs are", list, true);
        await LoadChats();
      }
    };
    JobDisplayManagement.ChatBoxQueryF = (String query) async {
      iswaiting = true;
      if(query.isNotEmpty) {
        Query = query;
        print("ChatBoxQuery");
        await ChatDatas.CreateMessageChat(query, false);
        await LoadChats();
        await SearchAbleDataLoading.FastestSearchSystem(<String>[query]);
        JobDisplayManagement.SEARCHJOBSC.add(JobDisplayManagement.SEARCHJOBS);
        scrollController.animateTo(scrollController.position.maxScrollExtent, duration: Duration(seconds: 1), curve: Curves.bounceIn);
      }
    };

    Timer(Duration(seconds: 25), () async {
      if(Notifications.notifications.length != 0) {
        await ChatDatas.CreateNotifications();
        await LoadChats();
        scrollController.animateTo(
            scrollController.position.maxScrollExtent + 150,
            duration: Duration(seconds: 1), curve: Curves.ease);
        ShowNotification(flutterLocalNotificationsPlugin, "${DateTime
            .now()
            .day}/${DateTime
            .now()
            .month}/${DateTime
            .now()
            .year}, here is some latest updates.",
            "${Notifications.notifications.length
                .toString()} new events happened today.", "");
      }
      });
  }

  @override
  void initState() {
    iswaiting  = true;
    LoadChats();
    InitFunctions();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 60,),
      child: SingleChildScrollView(
        controller: scrollController,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: AllChats,
        ),
      ),
    );
  }
}

class ChatBackground extends CustomPainter{

  bool isleft = true;

  ChatBackground(l){
    this.isleft = l;
  }

  @override
  void paint(Canvas canvas, Size size) {
    if(isleft == true) {
      Paint paint = Paint();
      paint.color = ColorFromHexCode("#F4F4F4");
      paint.style = PaintingStyle.fill;
      paint.strokeWidth = 1;
      Path path = Path();
      path.moveTo(0, size.height);
      path.arcToPoint(Offset(20, size.height - 20), radius: Radius.circular(40),
          clockwise: false);
      path.lineTo(50, size.height - 20);
      path.lineTo(50, size.height);
      path.lineTo(0, size.height);
      canvas.drawPath(path, paint);
    }
    else{
      Paint paint = Paint();
      paint.color = ColorFromHexCode("#F4F4F4");
      paint.style = PaintingStyle.fill;
      paint.strokeWidth = 1;
      Path path = Path();
      path.moveTo(size.width, size.height);
      path.arcToPoint(Offset(size.width - 40, size.height - 10), radius: Radius.circular(40),
          clockwise: false);
      path.lineTo(size.width - 40, size.height - 10);
      path.lineTo(size.width - 40, size.height);
      path.lineTo(size.width, size.height);
      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
   return true;
  }

}