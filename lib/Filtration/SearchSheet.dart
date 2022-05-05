import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
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
  var SelectedSearchWordWidget = <Widget>[];


  void RemoveItemFromSelectedSearchWord(var zbox)
  {
    print(zbox);

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
          Container(
            width: MediaQuery.of(context).size.width,
            margin:  const EdgeInsets.only(
              left: 20,
              top: 5,
              bottom: 5,
              right: 20,
            ),
            padding:  const EdgeInsets.all(15),
            decoration:  BoxDecoration(
              color: Colors.grey.shade100,
              boxShadow: [
              ],
              borderRadius: const BorderRadius.all(Radius.circular(10)),
            ),
            child: Row(
              children: <Widget>[
                Container(
                    width:MediaQuery.of(context).size.width - 100,
                    child: Text(SelectedSearchWord[i],
                      style: const TextStyle(
                        color: Colors.black,
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
          )
      );
    }

    setState(() {
      SelectedSearchWordWidget = _SelectedSearchWordWidget;
    });
  }




  var ToFindSearchSheetsData = ["Andaman and Nicobar", "Andhra Pradesh", "Arunachal Pradesh", "Assam", "Bihar", "Chandigarh", "Chhattisgarh", "Dadra and Nagar Haveli", "Daman and Diu", "Delhi", "Goa", "Gujarat", "Haryana", "Himachal Pradesh", "Jammu and Kashmir", "Jharkhand", "Karnataka", "Kerala", "Lakshadweep", "Madhya Pradesh", "Maharashtra", "Manipur", "Meghalaya", "Mizoram", "Nagaland", "Orissa", "Puducherry", "Punjab", "Rajasthan", "Sikkim", "Tamil Nadu", "Telangana", "Tripura", "Uttar Pradesh", "Uttarakhand", "West Bengal"];

  var ToFindSearchSheetsDataShowWidget = <Widget>[];


  void FindSearchWord(e){

    var _ToFindSearchSheetsDataShowWidget = <Widget>[];

    for(int i=0; i<ToFindSearchSheetsData.length && _ToFindSearchSheetsDataShowWidget.length < 3; i++)
    {
      if(ToFindSearchSheetsData[i].toLowerCase().contains(e.toString().toLowerCase()))
      {
        _ToFindSearchSheetsDataShowWidget.add(
          GestureDetector(
            onTap: (){
              SelectedSearchWord.add(ToFindSearchSheetsData[i]);

              LoadSelectedSearchWord();

              textEditingController.text = "";
              setState(() {
                ShowHintBox = false;
              });
            },
            child: Container(
              width: MediaQuery.of(context).size.width,
              margin: const EdgeInsets.only(
                left: 20,
                top: 5,
                bottom: 5,
                right: 20,
              ),
              padding: EdgeInsets.all(10),
              color: Colors.grey[200],
              child: Text(ToFindSearchSheetsData[i]),
            ),
          ),
        );
      }
    }
    _ToFindSearchSheetsDataShowWidget.add(
      GestureDetector(
        onTap: (){
          SelectedSearchWord.add(e.toString());

          LoadSelectedSearchWord();
          textEditingController.text = "";
          setState(() {
            ShowHintBox = false;
          });
        },
        child: Container(
          width: MediaQuery.of(context).size.width,
          margin: const EdgeInsets.only(
            left: 20,
            top: 5,
            bottom: 5,
            right: 20,
          ),
          padding: EdgeInsets.all(10),
          color: Colors.grey[200],
          child: Text(e.toString()),
        ),
      ),
    );

    setState(() {
      ToFindSearchSheetsDataShowWidget = _ToFindSearchSheetsDataShowWidget;
      ShowHintBox = true;
    });

  }


  void LoadAllSearchSheetsData(){
    FirebaseFirestore.instance.collection("Jobs").snapshots().listen((event) {
      event.docs.forEach((element) {
        //print(element.id);
        ToFindSearchSheetsData.add(element.id);
      });
    });
  }

  Future<void> OnLoadSaved() async {
    final prefs = await SharedPreferences.getInstance();
    SelectedSearchWord = (await prefs.getStringList('UserSearchSheetsData'))!;

    LoadSelectedSearchWord();
  }

  Future<void> SaveSelectedSearchSheetsData() async {

    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('UserSearchSheetsData', SelectedSearchWord);
    //print(prefs.getStringList('UserSearchSheetsData'));

    //Navigator.push(context, MaterialPageRoute(builder: (context) => ChooseState()));

    Navigator.pop(context, SelectedSearchWord);
  }


  void LoadAllInterest(){
    FirebaseFirestore.instance.collection("Interest").snapshots().listen((event) {
      event.docs.forEach((element) {
        //print(element.id);
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


  void FN(){

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
          children: <Widget>[
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.all(20),
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height / 4,
                child: Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      const Text("Write the search keyword",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        child: TextField (
                          controller: textEditingController,
                          onChanged: (e){ 
                            FindSearchWord(e);
                          },
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              labelText: 'Your Search Keyword',
                              labelStyle: TextStyle(
                                color: Colors.grey.shade400,
                              ),
                              hintText: 'Engineer, Irrigation, Haryana'
                          ),
                        ),
                      ),

                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height/1.5,
              top: MediaQuery.of(context).size.height/4,
              child: Container(
                color: Colors.white,
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
              height: MediaQuery.of(context).size.height/4,
              top: MediaQuery.of(context).size.height/4 - 20,
              child: Visibility(
                visible: ShowHintBox,
                child: Container(
                  height: MediaQuery.of(context).size.height/4,
                  color: Colors.white,
                  child: SingleChildScrollView(
                    child: Column(
                      children: ToFindSearchSheetsDataShowWidget,
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
                  child: const Center(child: Text(
                    "Apply",
                    style: TextStyle(fontSize: 18,
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  )),
                ),
              ),
            )
          ]
      ),
    );
  }
}
