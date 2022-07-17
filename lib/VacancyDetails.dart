
import 'dart:convert';

class VacancyDetails{
  int TotalVacancies = 0;
  String Title = "";
  List<dynamic> headers = <dynamic>[];
  List<VacancyDetailsData> datas = <VacancyDetailsData>[];


  Future<Map> toJson() async {

    List datasmp = [];

    await Future.forEach(datas, (VacancyDetailsData element) =>  datasmp.add(element.toJson()));

    return {
      "TotalVacancies" : TotalVacancies,
      "Title" : Title,
      "headers" : headers,
      "datas" : jsonEncode(datasmp),
    };
  }
}

class VacancyDetailsData{
  List<dynamic> data = <dynamic>[];

  Map toJson() => {
    "VacancyDetailsData" : jsonEncode(data),
  };
}