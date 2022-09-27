// import 'dart:async';
// import 'dart:io';
// import 'dart:ui';
//
// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:governmentapp/Animations/Loading.dart';
// import 'package:governmentapp/DataLoadingSystem/JobDisplayManagement.dart';
// import 'package:governmentapp/DataLoadingSystem/RequiredDataLoading.dart';
// import 'package:governmentapp/DataPullers/AllPullers.dart';
// import 'package:governmentapp/Files/CurrentJob.dart';
// import 'package:governmentapp/Files/Header.dart';
// import 'package:governmentapp/Files/JobBoxs.dart';
// import 'package:governmentapp/Files/JobSheet.dart';
// import 'package:governmentapp/Files/PositionedSearchArea.dart';
// import 'package:governmentapp/Files/SearchArea.dart';
// import 'package:governmentapp/Filtration/FilterPage.dart';
// import 'package:governmentapp/ForUsers/ChooseDepartment.dart';
// import 'package:governmentapp/HexColors.dart';
// import 'package:governmentapp/JobData.dart';
// import 'package:governmentapp/JobObject.dart';
//
// import '../JobData.dart';
//
// class Home extends StatefulWidget {
//   const Home({Key? key}) : super(key: key);
//
//   @override
//   State<Home> createState() => _HomeState();
// }
//
// class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
//
//   var initialchildsize = .0;
//   late DraggableScrollableController draggableScrollableController;
//
//   late Animation _animation;
//   late AnimationController _animationController;
//   double AnimatedDrawer = 400;
//
//   bool PositionedSearchArea_Visible = false;
//
//
//   StreamController<List<JobData>> jobdatacontroller = StreamController<List<JobData>>();
//
//
//   Stream Get_JobsData_In_RealTime() {
//     //GetJobData();
//     return jobdatacontroller.stream;
//   }
//
//   var SelectedDepartments = ["", ""];
//   var SelectedStates = ["", ""];
//   var selectedIntrest = ["", ""];
//
//
//
//   String GetShortName(String v){
//     var i = v.indexOf("(");
//     var j = v.indexOf(")");
//
//     String output = "";
//     if(i != null && i !=0 && j != null && j != 0)
//       {
//         var parts = v.split(" ");
//
//         for(int l=0; l<parts.length; l++)
//           {
//             if(parts[l][0] == "(" || parts[l][0] == ")"){
//               break;
//             }
//             output += parts[l][0].toUpperCase();
//           }
//       }
//     else{
//       output = v.substring(i, j);
//     }
//
//     return output;
//   }
//
//
//   JobData SheetjobData = JobData();
//
//
//     @override
//   void initState() {
//       RequiredDataLoading.Execute();
//       draggableScrollableController = DraggableScrollableController();
//
//       CurrentJob.currentjobStreamToCall = (value) {
//         setState(() {
//           initialchildsize = .9;
//           draggableScrollableController.animateTo(0.9, duration: Duration(milliseconds: 500), curve: Curves.easeIn);
//           SheetjobData = value;
//         });
//       };
//
//       super.initState();
//     }
//
//
//   @override
//   void dispose() {
//     _animationController.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(
//         color: ColorFromHexCode("#F4F6F7"),
//         width: MediaQuery.of(context).size.width,
//         height: MediaQuery.of(context).size.height,
//         child: Stack(
//           children: <Widget>[
//             SingleChildScrollView(
//               child: Column(
//                 children: <Widget>[
//                   Visibility(visible: !PositionedSearchArea_Visible ,child: SearchArea()),
//                   GestureDetector(
//                     onTap: (){
//                       Navigator.push(context, MaterialPageRoute(builder: (context)=>ChooseDepartment()));
//                     },
//                     child: Container(
//                       width: MediaQuery.of(context).size.width,
//                       alignment: Alignment.center,
//                       child: SingleChildScrollView(
//                         child: Column(
//                           children: <Widget>[
//                             JobDisplayManagement.ismoreloadingjobs == true ? Column(
//                               children: <Widget>[
//                                 SingleChildScrollView(
//                                   scrollDirection: Axis.horizontal,
//                                   child: Container(
//                                     width: MediaQuery.of(context).size.width,
//                                     height: 250,
//                                     child: Column(
//                                       crossAxisAlignment: CrossAxisAlignment.start,
//                                       mainAxisAlignment: MainAxisAlignment.center,
//                                       children: const <Widget>[
//                                         SkeletonDeptCard(),
//                                         SkeltonCard(),
//                                         SizedBox(height: 20,),
//                                       ],
//                                     ),
//                                   ),
//                                 ),
//
//                                 Container(
//                                   child: Image.asset("assets/images/loading.gif"),
//                                   width: 100,
//                                   height: 50,
//                                 ),
//                               ],
//                             ) : Container(),
//                             SizedBox(height: 10,),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ),
//                   SingleChildScrollView(child: JobBoxs()),
//                   SizedBox(height: 10,),
//                   JobDisplayManagement.ismoreloadingjobs == false ? Container(
//                       width: MediaQuery.of(context).size.width,
//                       child: Text("If you don't find what are you looking for", style: GoogleFonts.quicksand(color: Colors.grey[400], fontWeight: FontWeight.bold,), textAlign: TextAlign.center,)) : Container(),
//                   JobDisplayManagement.ismoreloadingjobs == false ? Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: <Widget>[
//                       Container(
//                         child: Text("click to ", style: GoogleFonts.quicksand(color: Colors.black.withOpacity(0.4), fontWeight: FontWeight.bold,), textAlign: TextAlign.center,),
//                       ),
//                       Container(
//                           child: Text("try with some more filters", style: GoogleFonts.quicksand(color: Colors.grey[400], fontWeight: FontWeight.bold,), textAlign: TextAlign.center,)),
//                       SizedBox(width: 5,),
//                       Icon(Icons.filter_list_outlined, color: Colors.grey[400],)
//                     ],
//                   ) : Container(),
//                   const SizedBox(height: 350,),
//                 ],
//               ),
//             ),
//
//             Positioned(
//               left: 0,
//               top: 0,
//               right: 0,
//               child: AnimatedOpacity(
//                 duration: Duration(milliseconds: 100,),
//                 opacity: PositionedSearchArea_Visible ? 1 : 0,
//                 child: Visibility(
//                     visible: PositionedSearchArea_Visible,
//                     child: PositionedSearchArea()),
//               ),),
//
//           ],
//         ),
//       ),
//     );
//   }
// }
