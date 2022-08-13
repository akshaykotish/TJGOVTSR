

import 'package:governmentapp/DataPullers/AdmitCard.dart';
import 'package:governmentapp/DataPullers/AnswerKeys.dart';
import 'package:governmentapp/DataPullers/LatestJobs.dart';
import 'package:governmentapp/DataPullers/Result.dart';
import 'package:governmentapp/DataPullers/Syllabus.dart';

class ScrapperController{


  LatestJobs latestJobs = LatestJobs();
  AdmitCards admitCards = AdmitCards();
  AnswerKeys answerKeys = AnswerKeys();
  Syllabus syllabus = Syllabus();
  Result result = Result();

  Future<void> Execute() async {
    await latestJobs.Execute();
    await syllabus.Execute();
    await admitCards.Execute();
    await answerKeys.Execute();
    await result.Execute();
  }

}