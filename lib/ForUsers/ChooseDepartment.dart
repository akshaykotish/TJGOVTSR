import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:governmentapp/DataLoadingSystem/SearchAbleDataLoading.dart';
import 'package:governmentapp/DataPullers/AllPullers.dart';
import 'package:governmentapp/ForUsers/ChooseState.dart';
import 'package:governmentapp/HexColors.dart';
import 'package:governmentapp/User/WriteALog.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChooseDepartment extends StatefulWidget {
  const ChooseDepartment({Key? key}) : super(key: key);

  @override
  State<ChooseDepartment> createState() => _ChooseDepartmentState();
}

class _ChooseDepartmentState extends State<ChooseDepartment> {

  TextEditingController textEditingController = TextEditingController();

  bool ShowHintBox = false;

  var SelectedDepartment = <String>[];
  var UknownSelectedDepartment = <String>[];
  var SelectedDepartmentWidget = <Widget>[];

  var SelectedState = <String>[];


  static var States = <String>["Andaman and Nicobar", "Andhra Pradesh", "Arunachal Pradesh", "Assam", "Bihar", "Chandigarh", "Chhattisgarh", "Dadra and Nagar Haveli", "Daman and Diu", "Delhi", "Goa", "Gujarat", "Haryana", "Himachal Pradesh", "Jammu and Kashmir", "Jharkhand", "Karnataka", "Kerala", "Lakshadweep", "Madhya Pradesh", "Maharashtra", "Manipur", "Meghalaya", "Mizoram", "Nagaland", "Orissa", "Puducherry", "Punjab", "Rajasthan", "Sikkim", "Tamil Nadu", "Telangana", "Tripura", "Uttar Pradesh", "Uttarakhand", "West Bengal"];
  static String FindLocation(String Title){
    String Location = "India";

    for(int i=0; i<States.length; i++)
    {
      if(Title.contains(States[i]) ||
          Title.contains(States[i]) ||
          Title.contains(States[i].toLowerCase())
      )
      {
        Location = States[i];
        break;
      }
    }

    return Location;
  }



  Future<void> RemoveStateFromSelectedState(String State)
  async {
    final prefs = await SharedPreferences.getInstance();
    SelectedState = (await prefs.getStringList('UserStates'))!;

    if(SelectedState.contains(State))
      {
        SelectedState.remove(State);

        final prefs = await SharedPreferences.getInstance();
        await prefs.setStringList('UserStates', SelectedState);
      }
  }

  Future<bool> CheckAlreadyExsist(String State)
  async {
    final prefs = await SharedPreferences.getInstance();

    if(prefs.getStringList('UserStates') != null) {
      SelectedState = prefs.getStringList('UserStates')!;

      if (SelectedState.isNotEmpty && SelectedState.contains(State)) {
        return true;
      }
    }
    return false;
  }

  void AddStateToSelectedState(String State) async
  {
    if(!await CheckAlreadyExsist(State))
      {
        SelectedState.add(State);

        final prefs = await SharedPreferences.getInstance();
        await prefs.setStringList('UserStates', SelectedState);
        print("State  Find");
      }
    else{
      print("State Not Find");
    }
  }


  void RemoveItemFromSelectedDepartment(var zbox)
  {
    print(zbox);

    if(SelectedDepartment.length > zbox) {
      RemoveStateFromSelectedState(FindLocation(SelectedDepartment[zbox]));
      SelectedDepartment.removeAt(zbox);
      LoadSelectedDepartment();
    }
  }


  void LoadSelectedDepartment(){
    var _SelectedDepartmentWidget = <Widget>[];

    for(int i=0; i<SelectedDepartment.length; i++)
      {
        int zbox = i;

        _SelectedDepartmentWidget.add(
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
                    color: Colors.grey.shade100,
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                  ),
                  child: Row(
                    children: <Widget>[
                      Container(
                          width:MediaQuery.of(context).size.width - 100,
                          child: Text(SelectedDepartment[i],
                            style: const TextStyle(
                              color: Colors.black,
                            ),
                          )
                      ),
                      Container(
                        child: GestureDetector(
                          onTap: (){
                            RemoveItemFromSelectedDepartment(zbox);
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
      SelectedDepartmentWidget = _SelectedDepartmentWidget;
    });
  }




  var ToFindDepartments = ["UPSC", "UGA"];

  var ToFindDepartmentsShowWidget = <Widget>[];


  Future<void> FindDepartment(e) async {



    print("E" + e.toString()
    );
    var _ToFindDepartmentsShowWidget = <Widget>[];
    var alreadyadded = <String>[];


    _ToFindDepartmentsShowWidget.add(
      GestureDetector(
        onTap: (){
          SelectedDepartment.add(e.toString());
          AddStateToSelectedState(FindLocation(e.toString()));

          if(!UknownSelectedDepartment.contains(e))
          {
            UknownSelectedDepartment.add(e);
          }

          LoadSelectedDepartment();
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


    bool isexsists = false;
    for(int i=0; i<ToFindDepartments.length && _ToFindDepartmentsShowWidget.length < 10; i++)
      {
        //Jobs/Bihar School Examination Board (BSEB)/BIHAR/TeacherEligibilityTest(BETETBTET)2017
        String Departmentis = "";
        try {
           Departmentis = await ToFindDepartments[i]
              .split(";")
              .length == 4
              ? ToFindDepartments[i].split(";")[1]
              : ToFindDepartments[i].split(";")[0].split("/")[1];
        }
        catch(e){}

        if(Departmentis == "")
          {
            continue;
          }

        if(ToFindDepartments[i].toLowerCase().contains(e.toString().toLowerCase()) && await !alreadyadded.contains(Departmentis))
          {
            isexsists = true;
            alreadyadded.add(Departmentis);
            _ToFindDepartmentsShowWidget.add(
              GestureDetector(
                onTap: (){
                  SelectedDepartment.add(Departmentis);
                  AddStateToSelectedState(FindLocation(ToFindDepartments[i]));

                  LoadSelectedDepartment();

                  textEditingController.text = "";
                  setState(() {
                    ShowHintBox = false;
                  });
                },
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.all(10),
                  child: Text(Departmentis),
                ),
              ),
            );
          }

      }


    setState(() {
      ToFindDepartmentsShowWidget = _ToFindDepartmentsShowWidget;
      ShowHintBox = true;
    });

  }


   void LoadAllDepartments(){
  //   FirebaseFirestore.instance.collection("Jobs").snapshots().listen((event) {
  //     event.docs.forEach((element) {
  //       //print(element.id);
  //       ToFindDepartments.add(element.id);
  //     });
  //   });
    ToFindDepartments = SearchAbleDataLoading.SearchAbleCache;
  }

  Future<void> OnLoadSaved() async {
    final prefs = await SharedPreferences.getInstance();
    SelectedDepartment = (await prefs.getStringList('UserDepartments'))!;

    LoadSelectedDepartment();
  }



  Future<void> SaveSelectedDepartments() async {

    if(textEditingController.text != "") {
      SelectedDepartment.add(textEditingController.text);
      AddStateToSelectedState(FindLocation(textEditingController.text.toString()));
      if(!UknownSelectedDepartment.contains(textEditingController.text))
      {
        UknownSelectedDepartment.add(textEditingController.text);
      }
    }

    await OnProceed();

    print("Size is " + SelectedDepartment.length.toString());

    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('UserDepartments', SelectedDepartment);
    await prefs.setStringList("RequiredData", []);

    //print(prefs.getStringList('UserDepartments'));

    WriteALog.Write("New Choices", SelectedDepartment.toString(), DateTime.now().toString());

    Navigator.push(context, PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 300),
        transitionsBuilder: (BuildContext context, Animation<double> animation, Animation<double> secAnimation, Widget child){
          const begin = Offset(1.5, 0.0);
          const end = Offset.zero;
          const curve = Curves.ease;

          var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

          return SlideTransition(
            position: animation.drive(tween),
            child: child,
          );
        },
        pageBuilder: (BuildContext context, Animation<double> animation, Animation<double> secAnimation){
          return ChooseState();
        }));
  }

  @override
  void initState() {
    OnLoadSaved();
    LoadAllDepartments();
    super.initState();
  }


  Future<void> OnProceed() async {
    //sub inspector haryana
    await Future.forEach(UknownSelectedDepartment, (String departments) async {

      var keywords = departments.split(" ");

      String k1 = keywords.length > 0 ? keywords[0] : "";
      String k2 = keywords.length > 1 ? keywords[1] : "";
      String k3 = keywords.length > 2 ? keywords[2] : "";

      List<String> reqkeywords = <String>[];

      List<String> topsearches3 = <String>[];
      List<String> topsearches2 = <String>[];
      List<String> topsearches1 = <String>[];

      List<String> topsearches = <String>[];

      //sub
      if(k1 != "") {
        await Future.forEach(ToFindDepartments, (String dpt){
            if(dpt.toLowerCase().contains(k1.toLowerCase()))
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

      print("Top 3 = " + topsearches3.length.toString());
        await Future.forEach(topsearches3, (String res) async {
          String dep = "";
          if(res.split(";").length == 3) {
            dep = res.split(";")[2].split("/")[1];
          }
          else{
            dep = res.split(";")[1].toString();
          }
          if (!topsearches.contains(dep)) {
            topsearches.add(dep);
            print("Selected Department :- " + res + " - Top 3");
          }
        });

      topsearches.addAll(SelectedDepartment);
      SelectedDepartment = topsearches;

      await Future.forEach(SelectedDepartment, (String res){
        AddStateToSelectedState(FindLocation(res));
      });
    });
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
                              Text("Write the Choice",
                                style: TextStyle(
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
                                          SaveSelectedDepartments();
                                        },
                                        controller: textEditingController,
                                        onChanged: (e){
                                          FindDepartment(e);
                                        },
                                        decoration: InputDecoration(
                                            border: InputBorder.none,
                                            labelText: 'bank, force, defence, upsc, ssc, bihar',
                                            labelStyle: TextStyle(
                                                color: Colors.grey.shade500,
                                                fontWeight: FontWeight.w500
                                            ),
                                            hintText: 'Please spell correct',
                                            hintStyle: TextStyle(
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
                        children: SelectedDepartmentWidget,
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
                                children: ToFindDepartmentsShowWidget,
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
                      SaveSelectedDepartments();
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
          ),
        ),
      ),
    );
  }
}
