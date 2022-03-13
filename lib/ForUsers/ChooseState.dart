import 'dart:ui';

import 'package:flutter/material.dart';

class ChooseState extends StatefulWidget {
  const ChooseState({Key? key}) : super(key: key);

  @override
  State<ChooseState> createState() => _ChooseStateState();
}

class _ChooseStateState extends State<ChooseState> {

  TextEditingController textEditingController = TextEditingController();

  bool ShowHintBox = false;

  var SelectedState = <String>[];
  var SelectedStateWidget = <Widget>[];

  void RemoveItemFromSelectedState(var zbox)
  {
    print(zbox);

    if(SelectedState.length > zbox) {
      SelectedState.removeAt(zbox);
      LoadSelectedState();
    }
  }

  void LoadSelectedState(){
    var _SelectedStateWidget = <Widget>[];

    for(int i=0; i<SelectedState.length; i++)
    {
      int zbox = i;

      _SelectedStateWidget.add(
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
                    child: Text(SelectedState[i],
                      style: const TextStyle(
                        color: Colors.black,
                      ),
                    )
                ),
                Container(
                  child: GestureDetector(
                    onTap: (){
                      RemoveItemFromSelectedState(zbox);
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
      SelectedStateWidget = _SelectedStateWidget;
    });
  }




  var ToFindStates = ["Haryana", "Uttarakhand"];

  var ToFindStatesShowWidget = <Widget>[];


  void FindState(e){
    var _ToFindStatesShowWidget = <Widget>[];

    for(int i=0; i<ToFindStates.length; i++)
    {
      if(ToFindStates[i].toLowerCase().contains(e.toString().toLowerCase()))
      {
        _ToFindStatesShowWidget.add(
          GestureDetector(
            onTap: (){
              SelectedState.add(ToFindStates[i].toUpperCase());
              LoadSelectedState();
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
              child: Text(ToFindStates[i].toUpperCase()),
            ),
          ),
        );
      }
    }
    _ToFindStatesShowWidget.add(
      GestureDetector(
        onTap: (){
          SelectedState.add(e.toString().toUpperCase());
          LoadSelectedState();
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
      ToFindStatesShowWidget = _ToFindStatesShowWidget;
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
                      const Text("Choose the States",
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
                              labelText: 'Enter State Name Here',
                              labelStyle: TextStyle(
                                color: Colors.grey.shade400,
                              ),
                              hintText: 'Haryana'
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
                  children: SelectedStateWidget,
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
                      children: ToFindStatesShowWidget,
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
