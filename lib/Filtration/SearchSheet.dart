import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:governmentapp/DataLoadingSystem/JobDisplayManagement.dart';
import 'package:governmentapp/DataLoadingSystem/SearchAbleDataLoading.dart';
import 'package:governmentapp/DataPullers/AllPullers.dart';
import 'package:governmentapp/ForUsers/ChooseState.dart';
import 'package:governmentapp/HexColors.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SearchSheet extends StatefulWidget {
  const SearchSheet({Key? key}) : super(key: key);

  @override
  State<SearchSheet> createState() => _SearchSheetState();
}

class _SearchSheetState extends State<SearchSheet> {

  TextEditingController textEditingController = TextEditingController();

  bool ShowHintBox = false;

  var SelectedSearchWord = <String>[];
  var UnSelectedSearchWord = <String>[];
  var SelectedSearchWordWidget = <Widget>[];


  void RemoveItemFromSelectedSearchWord(var zbox)
  {

    if(SelectedSearchWord.length > zbox) {
      SelectedSearchWord.removeAt(zbox);
      LoadSelectedSearchWord();
    }
  }


  void LoadSelectedSearchWord(){
    var _SelectedSearchWordWidget = <Widget>[];

    for(int i=0; i<SelectedSearchWord.length; i++)
    {
      int zbox = i;

      _SelectedSearchWordWidget.add(
          ClipRect(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Container(
                width: MediaQuery.of(context).size.width,
                margin:  const EdgeInsets.only(
                  left: 20,
                  top: 5,
                  bottom: 5,
                  right: 20,
                ),
                padding:  const EdgeInsets.all(15),
                decoration:  BoxDecoration(
                  color: Colors.white.withOpacity(0.4),
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                ),
                child: Row(
                  children: <Widget>[
                    Container(
                        width:MediaQuery.of(context).size.width - 100,
                        child: Text(SelectedSearchWord[i],
                          style: GoogleFonts.quicksand(
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w500
                          ),
                        )
                    ),
                    Container(
                      child: GestureDetector(
                        onTap: (){
                          RemoveItemFromSelectedSearchWord(zbox);
                        },
                        child: const Icon(
                          Icons.remove_circle_outline_rounded,
                          color: Colors.red,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          )
      );
    }

    setState(() {
      SelectedSearchWordWidget = _SelectedSearchWordWidget;
    });
  }



  var ToFindSearchSheetsData = ["Andaman and Nicobar", "Andhra Pradesh", "Arunachal Pradesh", "Assam", "Bihar", "Chandigarh", "Chhattisgarh", "Dadra and Nagar Haveli", "Daman and Diu", "Delhi", "Goa", "Gujarat", "Haryana", "Himachal Pradesh", "Jammu and Kashmir", "Jharkhand", "Karnataka", "Kerala", "Lakshadweep", "Madhya Pradesh", "Maharashtra", "Manipur", "Meghalaya", "Mizoram", "Nagaland", "Orissa", "Puducherry", "Punjab", "Rajasthan", "Sikkim", "Tamil Nadu", "Telangana", "Tripura", "Uttar Pradesh", "Uttarakhand", "West Bengal"];

  var ToFindSearchSheetsDataShowWidget = <Widget>[];


  Future<void> FindSearchWord(e) async {

    var _ToFindSearchSheetsDataShowWidget = <Widget>[];
    var alreadyadded = <String>[];


    _ToFindSearchSheetsDataShowWidget.add(
      GestureDetector(
        onTap: (){
          SelectedSearchWord.add(e.toString());


          if(!UnSelectedSearchWord.contains(e))
          {
            UnSelectedSearchWord.add(e);
          }

          LoadSelectedSearchWord();
          textEditingController.text = "";
          setState(() {
            ShowHintBox = false;
          });
        },
        child: Container(
          width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.all(10),
          child: Text(e.toString(), style: GoogleFonts.quicksand(color: Colors.grey[600], fontWeight: FontWeight.w500),),
        ),
      ),
    );

    for(int i=0; i<ToFindSearchSheetsData.length && _ToFindSearchSheetsDataShowWidget.length < 6; i++)
    {
      String Departmentis = "";
      String Jobis = "";


      String path = ToFindSearchSheetsData[i].split(";").length == 3 ? ToFindSearchSheetsData[i].split(";")[2] : ToFindSearchSheetsData[i].split(";")[0];

      var parts = ToFindSearchSheetsData[i].split(";");
      if(parts.length == 3)
        {
          Departmentis = parts[1];
          Jobis = parts[0];
        }
      else if(parts.length == 4){
        Departmentis = parts[2];
        Jobis = parts[1];
      }

      if(Departmentis == "" || Jobis == "" || Departmentis == "UNKNOWN")
        {
          continue;
        }

    if(ToFindSearchSheetsData[i].toLowerCase().contains(e.toString().toLowerCase()) && await !alreadyadded.contains(Departmentis))
      {
        _ToFindSearchSheetsDataShowWidget.add(
          GestureDetector(
            onTap: (){
              SelectedSearchWord.add(Departmentis);

              JobDisplayManagement.SEARCHEDPATHS.add(path);

              LoadSelectedSearchWord();

              textEditingController.text = "";
              setState(() {
                ShowHintBox = false;
              });
            },
            child: Container(
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.all(10),
              child: Text(Departmentis, style: GoogleFonts.quicksand(color: Colors.grey[600], fontWeight: FontWeight.w500),),
            ),
          ),
        );

        _ToFindSearchSheetsDataShowWidget.add(
          GestureDetector(
            onTap: (){
              SelectedSearchWord.add(Jobis);

              JobDisplayManagement.SEARCHEDPATHS.add(path);
              LoadSelectedSearchWord();

              textEditingController.text = "";
              setState(() {
                ShowHintBox = false;
              });
            },
            child: Container(
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.all(10),
              child: Text(Jobis, style: GoogleFonts.quicksand(color: Colors.grey[600], fontWeight: FontWeight.w500),),
            ),
          ),
        );
      }
    }



    setState(() {
      ToFindSearchSheetsDataShowWidget = _ToFindSearchSheetsDataShowWidget;
      ShowHintBox = true;
    });

  }


  void LoadAllSearchSheetsData(){
    // FirebaseFirestore.instance.collection("Jobs").snapshots().listen((event) {
    //   event.docs.forEach((element) {
    //
    //     ToFindSearchSheetsData.add(element.id);
    //   });
    // });

    ToFindSearchSheetsData = SearchAbleDataLoading.SearchAbleCache;
  }

  Future<void> OnLoadSaved() async {
    final prefs = await SharedPreferences.getInstance();
    SelectedSearchWord = (await prefs.getStringList('UserSearchSheetsData'))!;

    LoadSelectedSearchWord();
  }

  Future<void> SaveSelectedSearchSheetsData() async {

    if(textEditingController.text != null && textEditingController.text != "") {
      SelectedSearchWord.add(textEditingController.text);
    }


      final prefs = await SharedPreferences.getInstance();
      await prefs.setStringList('UserSearchSheetsData', SelectedSearchWord);
      Navigator.pop(context, SelectedSearchWord);
  }


  void LoadAllInterest(){
    FirebaseFirestore.instance.collection("Interest").snapshots().listen((event) {
      event.docs.forEach((element) {
        ToFindSearchSheetsData.add(element.id);
      });
    });
  }

  @override
  void initState() {
    LoadAllInterest();
    LoadAllSearchSheetsData();
    super.initState();
  }

  Future<List<String>> GetKeyWord3List(List<String> keywords) async {
    String k1 = keywords.length > 0 ? keywords[0] : "";
    String k2 = keywords.length > 1 ? keywords[1] : "";
    String k3 = keywords.length > 2 ? keywords[2] : "";

    List<String> topsearches3 = <String>[];
    List<String> topsearches2 = <String>[];
    List<String> topsearches1 = <String>[];


    if(k1 != "") {
      await Future.forEach(ToFindSearchSheetsData, (String dpt){
        if(dpt.toLowerCase(). contains(k1.toLowerCase()))
        {
          topsearches1.add(dpt);
        }
      });

      if(k2 != "") {
        await Future.forEach(topsearches1, (String dpt){
          if(dpt.toLowerCase().contains(k2.toLowerCase()))
          {
            topsearches2.add(dpt);
          }
        });

        if(k3 != "") {
          await Future.forEach(topsearches2, (String dpt){
            if(dpt.toLowerCase().contains(k3.toLowerCase()))
            {
              topsearches3.add(dpt);
            }
          });
        }
        else{
          topsearches3 = topsearches2;
        }

      }
      else{
        topsearches2 = topsearches1;
        topsearches3 = topsearches1;

      }
    }

    return topsearches3;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
            color: ColorFromHexCode("#E2E2E2"),
            image: const DecorationImage(
              image: AssetImage(
                "./assets/branding/Background.jpg",
              ),
              fit: BoxFit.fill,
            )
        ),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            color: Colors.grey.withOpacity(0.1),
            child: Stack(
                children: <Widget>[
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      margin: const EdgeInsets.only(
                          top: 70, left: 10, right: 10, bottom: 10,
                      ),
                      decoration: const BoxDecoration(
                        borderRadius:  BorderRadius.all(Radius.circular(15)),
                      ),
                      child: ClipRect(
                        child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 25, sigmaY: 25),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius:  BorderRadius.all(Radius.circular(15)),
                              color: Colors.white.withOpacity(0.4),
                            ),
                            padding: const EdgeInsets.all(20),
                            width: MediaQuery.of(context).size.width,
                            height: 150,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Text("Write the search keyword",
                                  style: GoogleFonts.quicksand(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey.shade700
                                  ),
                                ),
                                SizedBox(height: 10,),
                                Container(
                                  decoration: const BoxDecoration(
                                    borderRadius:  BorderRadius.all(Radius.circular(15)),
                                  ),
                                  child: ClipRect(
                                    child: BackdropFilter(
                                      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                                      child: Container(
                                        padding: EdgeInsets.all(5),
                                        decoration: BoxDecoration(
                                          color: Colors.white.withOpacity(0.3),
                                          borderRadius:  BorderRadius.all(Radius.circular(15)),                                        ),
                                        width: MediaQuery.of(context).size.width,
                                        child: TextField (
                                          onSubmitted: (e){
                                            SaveSelectedSearchSheetsData();
                                          },
                                          controller: textEditingController,
                                          onChanged: (e){
                                            FindSearchWord(e);
                                          },
                                          decoration: InputDecoration(
                                              border: InputBorder.none,
                                              labelText: 'bank po, airforce, navy, clerk',
                                              labelStyle: GoogleFonts.quicksand(
                                                color: Colors.grey.shade500,
                                                fontWeight: FontWeight.w500
                                              ),
                                              hintText: 'Please spell correct',
                                            hintStyle: GoogleFonts.quicksand(
                                              color: Colors.grey.shade600
                                            )
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),

                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height/1.5,
                    top: MediaQuery.of(context).size.height/3,
                    child: Container(
                      height: MediaQuery.of(context).size.height/1.5,
                      child: SingleChildScrollView(
                        child: Column(
                          children: SelectedSearchWordWidget,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height/3.8,
                    top: 220,
                    child: Visibility(
                      visible: ShowHintBox,
                      child: Container(
                        padding: EdgeInsets.all(10),
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                        ),
                        child: ClipRect(
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 25, sigmaY: 25),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.grey.withOpacity(0.4),
                                borderRadius: BorderRadius.all(Radius.circular(20)),
                              ),
                              padding: EdgeInsets.all(10),
                              child: SingleChildScrollView(
                                child: Column(
                                  children: ToFindSearchSheetsDataShowWidget,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    height: 60,
                    child: GestureDetector(
                      onTap: (){
                        SaveSelectedSearchSheetsData();
                      },
                      child: Container(
                        color: Colors.grey[900],
                        child: Center(child: Text(
                          "Apply",
                          style: GoogleFonts.quicksand(fontSize: 18,
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        )),
                      ),
                    ),
                  )
                ]
            ),
          ),
        ),
      ),
    );
  }
}
