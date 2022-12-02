import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:governmentapp/ForUsers/ChooseDepartment.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FilterPage extends StatefulWidget {
  const FilterPage({Key? key}) : super(key: key);

  @override
  State<FilterPage> createState() => _FilterPageState();
}

class _FilterPageState extends State<FilterPage> {

  var SelectedDepartment = <String>[];
  var SelectedDepartmentWidget = <Widget>[];
  var SelectedState = <String>[];
  var SelectedStateWidget = <Widget>[];
  var SelectedInterest = <String>[];
  var SelectedInterestWidget = <Widget>[];

  Future<void> OnLoadSavedDepartments() async {
    final prefs = await SharedPreferences.getInstance();
    SelectedDepartment = (await prefs.getStringList('UserDepartments'))!;

    LoadSelectedDepartment();
  }

  Future<void> OnLoadSavedStates() async {
    final prefs = await SharedPreferences.getInstance();
    SelectedState = (await prefs.getStringList('UserStates'))!;

    LoadSelectedState();
  }


  Future<void> OnLoadSavedInterest() async {
    final prefs = await SharedPreferences.getInstance();
    SelectedInterest = (await prefs.getStringList('UserInterest'))!;

    LoadSelectedInterest();
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
              left: 5,
              top: 5,
              bottom: 5,
              right: 5,
            ),
            padding:  const EdgeInsets.all(5),

            child: Row(
              children: <Widget>[
                Container(
                    width:MediaQuery.of(context).size.width - 100,
                    child: Text(SelectedDepartment[i],
                      style: TextStyle(fontFamily: "uber",
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                      ),
                    )
                ),
              ],
            ),
          )
      );
    }

    setState(() {
      SelectedDepartmentWidget = _SelectedDepartmentWidget;
    });
  }


  void LoadSelectedState(){
    var _SelectedStateWidget = <Widget>[];

    for(int i=0; i<SelectedState.length; i++)
    {
      int zbox = i;

      _SelectedStateWidget.add(
          Container(
            width: MediaQuery.of(context).size.width,
            margin:  const EdgeInsets.only(
              left: 5,
              top: 5,
              bottom: 5,
              right: 5,
            ),
            padding:  const EdgeInsets.all(5),
            decoration:  BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: const BorderRadius.all(Radius.circular(10)),
            ),
            child: Row(
              children: <Widget>[
                Container(
                    width:MediaQuery.of(context).size.width - 100,
                    child: Text(SelectedState[i],
                      style: TextStyle(fontFamily: "uber",
                        color: Colors.black,
                      ),
                    )
                ),
              ],
            ),
          )
      );
    }

    setState(() {
      SelectedStateWidget = _SelectedStateWidget;
    });
  }


  void LoadSelectedInterest(){
    var _SelectedInterestWidget = <Widget>[];

    for(int i=0; i<SelectedInterest.length; i++)
    {
      int zbox = i;

      _SelectedInterestWidget.add(
          Container(
            width: MediaQuery.of(context).size.width,
            margin:  const EdgeInsets.only(
              left: 5,
              top: 5,
              bottom: 5,
              right: 5,
            ),
            padding:  const EdgeInsets.all(5),
            decoration:  BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: const BorderRadius.all(Radius.circular(10)),
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
              ],
            ),
          )
      );
    }

    setState(() {
      SelectedInterestWidget = _SelectedInterestWidget;
    });
  }

  @override
  void initState() {
    OnLoadSavedDepartments();
    OnLoadSavedStates();
    OnLoadSavedInterest();
    super.initState();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: (){
          Navigator.pop(context);
          Navigator.push(context, MaterialPageRoute(builder: (context)=>ChooseDepartment()));
        },
        child: Container(
          height: MediaQuery.of(context).size.height,
          child: Stack(
            children: [
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                bottom: 100,
                child: SingleChildScrollView(
                child: Container(
                  padding: const EdgeInsets.only(
                    top: 70,
                    left: 10,
                    right: 10,
                    bottom: 10
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text("Filtering Jobs", style: TextStyle(fontFamily: "uber",fontSize: 35, fontWeight: FontWeight.bold, color: Colors.grey[800]),),
                      const SizedBox(height: 20,),
                      Container(
                        margin: EdgeInsets.all(10),
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.shade200,
                                spreadRadius: 6,
                                blurRadius: 13.0,
                                offset:const Offset(5, 5),
                              ),
                            ],
                            borderRadius: BorderRadius.circular(20)
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 20,),
                            Text("Departments", style: TextStyle(fontFamily: "uber",fontSize: 18, fontWeight: FontWeight.w600),),
                            Column(
                              children: SelectedDepartmentWidget,
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 20,),
                      Text("States", style: TextStyle(fontFamily: "uber",fontSize: 18, fontWeight: FontWeight.w600),),
                      Column(
                        children: SelectedStateWidget,
                      ),
                      const SizedBox(height: 20,),
                      Text("Interest", style: TextStyle(fontFamily: "uber",fontSize: 18, fontWeight: FontWeight.w600),),
                      Column(
                        children: SelectedInterestWidget,
                      ),

                    ],
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
                      Navigator.pop(context);
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>ChooseDepartment()));
                    },
                    child: Container(
                      color: Colors.grey[900],
                      child: Center(child: Text(
                        "Add/Edit Your Filters",
                        style: TextStyle(fontFamily: "uber",fontSize: 18,
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      )),
                    ),
                  ),)
            ]
          ),
        ),
      ),
    );
  }
}
