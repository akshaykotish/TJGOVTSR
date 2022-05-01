import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Files/Home.dart';

class ChooseInterest extends StatefulWidget {
  const ChooseInterest({Key? key}) : super(key: key);

  @override
  State<ChooseInterest> createState() => _ChooseInterestState();
}

class _ChooseInterestState extends State<ChooseInterest> {

  TextEditingController textEditingController = TextEditingController();

  bool ShowHintBox = false;

  var SelectedInterest = <String>[];
  var SelectedInterestWidget = <Widget>[];

  void RemoveItemFromSelectedInterest(var zbox)
  {
    print(zbox);

    if(SelectedInterest.length > zbox) {
      SelectedInterest.removeAt(zbox);
      LoadSelectedInterest();
    }
  }

  void LoadSelectedInterest(){
    var _SelectedInterestWidget = <Widget>[];

    for(int i=0; i<SelectedInterest.length; i++)
    {
      int zbox = i;

      _SelectedInterestWidget.add(
          Container(
            width: MediaQuery.of(context).size.width,
            margin: const EdgeInsets.only(
              left: 20,
              top: 5,
              bottom: 5,
              right: 20,
            ),
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: Colors.white38,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.shade500,
                  offset: Offset(1, 1),
                  blurRadius: 1,
                  spreadRadius: 1,
                ),
                BoxShadow(
                  color: Colors.grey.shade400,
                  offset: Offset(1, 1),
                  blurRadius: 1,
                  spreadRadius: 1,
                ),
                BoxShadow(
                  color: Colors.grey.shade300,
                  offset: Offset(1, 1),
                  blurRadius: 1,
                  spreadRadius: 1,
                ),
                BoxShadow(
                  color: Colors.grey.shade200,
                  offset: Offset(1, 1),
                  blurRadius: 1,
                  spreadRadius: 1,
                ),
              ],
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            child: Row(
              children: <Widget>[
                Container(
                    width:MediaQuery.of(context).size.width - 100,
                    child: Text(SelectedInterest[i],
                      style: const TextStyle(
                        color: Colors.black,
                      ),
                    )
                ),
                Container(
                  child: GestureDetector(
                    onTap: (){
                      RemoveItemFromSelectedInterest(zbox);
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
      SelectedInterestWidget = _SelectedInterestWidget;
    });
  }




  var ToFindInterest = ["Engineering", "Accounts"];

  var ToFindInterestShowWidget = <Widget>[];


  void FindState(e){
    var _ToFindInterestShowWidget = <Widget>[];

    for(int i=0; i<ToFindInterest.length; i++)
    {
      if(ToFindInterest[i].toLowerCase().contains(e.toString().toLowerCase()))
      {
        _ToFindInterestShowWidget.add(
          GestureDetector(
            onTap: (){
              SelectedInterest.add(ToFindInterest[i]);
              LoadSelectedInterest();
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
              child: Text(ToFindInterest[i]),
            ),
          ),
        );
      }
    }
    _ToFindInterestShowWidget.add(
      GestureDetector(
        onTap: (){
          SelectedInterest.add(e.toString());
          CheckAndSave(e.toString());
          LoadSelectedInterest();
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
      ToFindInterestShowWidget = _ToFindInterestShowWidget;
      ShowHintBox = true;
    });

  }


  void LoadAllInterest(){
    FirebaseFirestore.instance.collection("Interest").snapshots().listen((event) {
      event.docs.forEach((element) {
        //print(element.id);
        ToFindInterest.add(element.id);
      });
    });
  }

  void CheckAndSave(String e){
    FirebaseFirestore.instance.collection("Interest").doc(e).get().then((value){
      if(!value.exists)
        {
          FirebaseFirestore.instance.collection("Interest").doc(e).set({});
        }
    });
  }

  Future<void> OnLoadSaved() async {
    final prefs = await SharedPreferences.getInstance();
    SelectedInterest = (await prefs.getStringList('UserInterest'))!;

    LoadSelectedInterest();
  }

  Future<void> SaveSelectedInterest() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('UserInterest', SelectedInterest);

    //print(prefs.getStringList('UserDepartments'));

    Navigator.push(context, MaterialPageRoute(builder: (context) => Home()));
  }


  @override
  void initState() {
    LoadAllInterest();
    OnLoadSaved();
    super.initState();
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
                      const Text("Choose the Interests",
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
                            FindState(e);
                          },
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              labelText: 'Enter Interest Name Here',
                              labelStyle: TextStyle(
                                color: Colors.grey.shade400,
                              ),
                              hintText: 'Engineering'
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
              height: MediaQuery.of(context).size.height/4,
              top: MediaQuery.of(context).size.height/4,
              child: Container(
                child: Column(
                  children: SelectedInterestWidget,
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
                      children: ToFindInterestShowWidget,
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
                  SaveSelectedInterest();
                },
                child: Container(
                  color: Colors.grey[900],
                  child: const Center(child: Text(
                    "Proceed",
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
