import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:governmentapp/HexColors.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Beauty/Home.dart';

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
                      style: TextStyle(fontFamily: "uber",
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


  void FindInterest(e){
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
          padding: EdgeInsets.all(10),
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

    if(textEditingController.text != "")
      {
        SelectedInterest.add(textEditingController.text);
      }

    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('UserInterest', SelectedInterest);
    await prefs.setStringList("RequiredData", []);

    //print(prefs.getStringList('UserDepartments'));

    Navigator.of(context).pushAndRemoveUntil(PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 300),
        transitionsBuilder: (BuildContext context, Animation<double> animation, Animation<double> secAnimation, Widget child){
          const begin = Offset(0.0, 1.0);
          const end = Offset.zero;
          const curve = Curves.ease;

          var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

          return SlideTransition(
            position: animation.drive(tween),
            child: child,
          );
        },
        pageBuilder: (BuildContext context, Animation<double> animation, Animation<double> secAnimation){
          return Home();
        }), (Route route) => false
    );
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
                                Text("Write the Interest keyword",
                                  style: TextStyle(fontFamily: "uber",
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
                                            SaveSelectedInterest();
                                          },
                                          controller: textEditingController,
                                          onChanged: (e){
                                            FindInterest(e);
                                          },
                                          decoration: InputDecoration(
                                              border: InputBorder.none,
                                              labelText: 'clerk, po, engineer, civil, inspector',
                                              labelStyle: TextStyle(fontFamily: "uber",
                                                  color: Colors.grey.shade500,
                                                  fontWeight: FontWeight.w500
                                              ),
                                              hintText: 'Please spell correct',
                                              hintStyle: TextStyle(fontFamily: "uber",
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
                          children: SelectedInterestWidget,
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
                                  children: ToFindInterestShowWidget,
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
                        SaveSelectedInterest();
                      },
                      child: Container(
                        color: Colors.grey[900],
                        child: Center(child: Text(
                          "Proceed",
                          style: TextStyle(fontFamily: "uber",fontSize: 18,
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
