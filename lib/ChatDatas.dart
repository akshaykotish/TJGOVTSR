import 'package:governmentapp/DataLoadingSystem/JobDisplayManagement.dart';
import 'package:governmentapp/DataLoadingSystem/RequiredDataLoading.dart';
import 'package:governmentapp/JobData.dart';
import 'package:governmentapp/JobDisplayData.dart';
import 'package:governmentapp/Notifcations.dart';

class ChatDatas{
  static List<ChatBoxData> chatBoxDatas = <ChatBoxData>[];

  static Future<void> CreateChat(String message, List<JobDisplayData> jobDisplayDatas, bool isleft) async {
    if(jobDisplayDatas.isNotEmpty) {
      ChatBoxData chatBoxData = ChatBoxData();
      await Future.forEach(jobDisplayDatas, (JobDisplayData hotJob) {
        chatBoxData.Jobs[hotJob.Designation] = hotJob.Path;
      });
      chatBoxData.Message = message;
      chatBoxData.isleft = isleft;
      chatBoxDatas.add(chatBoxData);
    }
  }
  static Future<void> CreateMessageChat(String message, bool isleft) async {
    ChatBoxData chatBoxData = ChatBoxData();
    chatBoxData.Message = message;
    chatBoxData.isleft = isleft;
    chatBoxDatas.add(chatBoxData);
  }

  static Future<void> CreateHotJobs() async {
    ChatBoxData chatBoxData = ChatBoxData();
    await Future.forEach(JobDisplayManagement.HOTJOBS, (JobDisplayData hotJob){
      chatBoxData.Jobs[hotJob.Designation] = hotJob.Path;
    });
    chatBoxData.Message = "New latest ${chatBoxData.Jobs.length} jobs.";
    chatBoxData.isleft = true;
    chatBoxDatas.add(chatBoxData);
  }

  static Future<void> CreateNotifications() async {
    if(Notifications.notifications.isNotEmpty) {
      ChatBoxData chatBoxData = ChatBoxData();
      await Future.forEach(Notifications.notifications, (String notifs) {
        List<String> parts = notifs.split(";");
        chatBoxData.Jobs[parts[2] + " - " + parts[1]] = parts[0];
      });
      chatBoxData.Message = "Here is some lates updates today - ${DateTime
          .now()
          .day}/${DateTime
          .now()
          .month}/${DateTime
          .now()
          .year}";
      chatBoxData.isleft = true;
      chatBoxDatas.add(chatBoxData);
    }
  }
}


class ChatBoxData{
  late String Message;
  late bool isleft;
  Map<String, String> Jobs = <String, String>{};
  List<String> links = <String>[];
  late String TimeStamp;
}