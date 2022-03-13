import 'dart:ui';

import 'package:flutter/material.dart';

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

  void RemoveItemFromSelectedDepartment(var zbox)
  {
    print(zbox);

    if(SelectedDepartment.length > zbox) {
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

    for(int i=0; i<ToFindDepartments.length; i++)
      {
        if(ToFindDepartments[i].toLowerCase().contains(e.toString().toLowerCase()))
          {
            _ToFindDepartmentsShowWidget.add(
              GestureDetector(
                onTap: (){
                  SelectedDepartment.add(ToFindDepartments[i].toUpperCase());
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
                  child: Text(ToFindDepartments[i].toUpperCase()),
                ),
              ),
            );
          }
      }
    _ToFindDepartmentsShowWidget.add(
      GestureDetector(
        onTap: (){
          SelectedDepartment.add(e.toString().toUpperCase());
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
          child: Text(e.toString().toUpperCase()),
        ),
      ),
    );

    setState(() {
      ToFindDepartmentsShowWidget = _ToFindDepartmentsShowWidget;
      ShowHintBox = true;
    });

  }

  @override
  void initState() {
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
            height: MediaQuery.of(context).size.height/4,
            top: MediaQuery.of(context).size.height/4,
            child: Container(
              child: Column(
                children: SelectedDepartmentWidget,
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
          )
    ]
      ),
    );
  }
}
