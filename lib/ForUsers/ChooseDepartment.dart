import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:governmentapp/DataPullers/AllPullers.dart';
import 'package:governmentapp/ForUsers/ChooseState.dart';
import 'package:governmentapp/HexColors.dart';
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
            )
        );
      }

    setState(() {
      SelectedDepartmentWidget = _SelectedDepartmentWidget;
    });
  }




  var ToFindDepartments = ["UPSC", "UGA"];

  var ToFindDepartmentsShowWidget = <Widget>[];


  void FindDepartment(e){

    var _ToFindDepartmentsShowWidget = <Widget>[];

    for(int i=0; i<ToFindDepartments.length && _ToFindDepartmentsShowWidget.length < 3; i++)
      {
        if(ToFindDepartments[i].toLowerCase().contains(e.toString().toLowerCase()))
          {
            _ToFindDepartmentsShowWidget.add(
              GestureDetector(
                onTap: (){
                  SelectedDepartment.add(ToFindDepartments[i]);
                  AddStateToSelectedState(FindLocation(ToFindDepartments[i]));

                  LoadSelectedDepartment();

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
                  child: Text(ToFindDepartments[i]),
                ),
              ),
            );
          }
      }
    _ToFindDepartmentsShowWidget.add(
      GestureDetector(
        onTap: (){
          SelectedDepartment.add(e.toString());
          AddStateToSelectedState(FindLocation(e.toString()));

          LoadSelectedDepartment();
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
      ToFindDepartmentsShowWidget = _ToFindDepartmentsShowWidget;
      ShowHintBox = true;
    });

  }


  void LoadAllDepartments(){
    FirebaseFirestore.instance.collection("Jobs").snapshots().listen((event) {
      event.docs.forEach((element) {
        //print(element.id);
        ToFindDepartments.add(element.id);
      });
    });
  }

  Future<void> OnLoadSaved() async {
    final prefs = await SharedPreferences.getInstance();
    SelectedDepartment = (await prefs.getStringList('UserDepartments'))!;

    LoadSelectedDepartment();
  }

  Future<void> SaveSelectedDepartments() async {

    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('UserDepartments', SelectedDepartment);
    await prefs.setStringList("RequiredData", []);

    //print(prefs.getStringList('UserDepartments'));

    Navigator.push(context, MaterialPageRoute(builder: (context) => ChooseState()));
  }

  @override
  void initState() {
    OnLoadSaved();
    LoadAllDepartments();
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
                  const Text("Choose the Departments",
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
                        FindDepartment(e);
                      },
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          labelText: 'Enter Department Name Here',
                          labelStyle: TextStyle(
                            color: Colors.grey.shade400,
                          ),
                          hintText: 'UNION PUBLIC SERVICE COMMISSION'
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
                  children: SelectedDepartmentWidget,
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
                    children: ToFindDepartmentsShowWidget,
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
    );
  }
}
