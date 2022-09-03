
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MaterialDatas{
  static String SearchTitle = "";
  static List<MaterialData> materialDatas = <MaterialData>[];
  static List<String> cachematerialDatas = <String>[];
  static List<MaterialData> searchmaterialDatas = <MaterialData>[];


  static Future<void> SaveDataToCache(String ef, String ng) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setStringList("MaterialData", cachematerialDatas);
    sharedPreferences.setString("ef", ef);
    sharedPreferences.setString("ng", ng);
  }

  static Future<void> GetDataFromCache() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();


    var c = sharedPreferences.getStringList("MaterialData");
    if(c != null)
      {
        cachematerialDatas = c;
        cachematerialDatas.forEach((String data) {
          MaterialData materialData = MaterialData("", "", "");
          materialData.FromString(data);
          materialDatas.add(materialData);
        });
      }

  }

  static Future<void> GetData()
  async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    String? ef = sharedPreferences.getString("ef");
    String? ng = sharedPreferences.getString("ng");

    await GetDataFromCache();
    print(materialDatas.length);

    if(materialDatas.length == 0 || ef == null || ef != "${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day}" || ng == null || ng != "${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day}") {

      var BookDatas = await FirebaseFirestore.instance.collection("PDFs").get();

      await Future.delayed(const Duration(milliseconds: 1), () {
        BookDatas.docs.forEach((pdf) {
          if (pdf.exists) {
            MaterialData materialData = MaterialData(
              pdf.data()["Title"].toString(), pdf.data()["PDFLink"].toString(),
              pdf.data()["Source"].toString(),);
            MaterialDatas.materialDatas.add(materialData);
            cachematerialDatas.add(materialData.ToString());
          }
        });
      }).then((value) async {
        var LastSavedPDFsDate = await FirebaseFirestore.instance.collection("Logs").doc("LastSavedPDFsDate").get();
        if(LastSavedPDFsDate.exists) {
          String ef = LastSavedPDFsDate.data()!["LastSavedPDFsDateEF"].toString();
          String ng = LastSavedPDFsDate.data()!["LastSavedPDFsDateEF"].toString();

          await SaveDataToCache(ef, ng);
        }
      });
    }
  }
}


class MaterialData{

  String Name = "";
  String URL = "";
  String Source = "";

  MaterialData(String name, String url, String source)
  {
    Name = name;
    URL = url;
    Source = source;
  }

  String ToString(){
   return "${Name};${URL};${Source}";
  }

  void FromString(String md)
  {
    var parts = md.split(";");
    if(parts.length == 3)
      {
        Name = parts[0];
        URL = parts[1];
        Source = parts[2];
      }
  }

}