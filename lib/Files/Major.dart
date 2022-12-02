//
// import 'dart:ui';
//
// import 'package:flutter/material.dart';
// import 'package:governmentapp/Files/Home.dart';
//
// import '../HexColors.dart';
//
// class Major extends StatefulWidget {
//   const Major({Key? key}) : super(key: key);
//
//   @override
//   State<Major> createState() => _MajorState();
// }
//
// class _MajorState extends State<Major> {
//   @override
//   Widget build(BuildContext context) {
//       return Scaffold(
//
//         body: Container(
//           width: MediaQuery.of(context).size.width,
//           height: MediaQuery.of(context).size.height,
//           child: Stack(
//             children: <Widget>[
//               Positioned(
//                 left: 0,
//                 right: 0,
//                 bottom: 60,
//                 top: 0,
//                 child: Container(
//                   color: Colors.grey[200],
//                   child: const Home(),
//                 ),
//               ),
//               Positioned(
//                 bottom: 0,
//                 left: 0,
//                 right: 0,
//                 height: 60,
//                 child: Container(
//                   color: ColorFromHexCode("#17202A"),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: <Widget>[
//                       Container(
//                         width: MediaQuery.of(context).size.width/3,
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: const <Widget>[
//                             Icon(
//                               Icons.work_outline_outlined,
//                             ),
//                             SizedBox(width: 5,),
//                             Text("Jobs", style: TextStyle(fontFamily: "uber",fontWeight: FontWeight.w600, color: Colors.white),)
//                           ],
//                         ),
//                       ),
//                       Container(
//                         width: MediaQuery.of(context).size.width/3,
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: const <Widget>[
//                             Icon(
//                               Icons.spa_outlined,
//                             ),
//                             SizedBox(width: 5,),
//                             Text("Results", style: TextStyle(fontFamily: "uber",fontWeight: FontWeight.w600),)
//                           ],
//                         ),
//                       ),
//                       Container(
//                         width: MediaQuery.of(context).size.width/3,
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: const <Widget>[
//                             Icon(
//                               Icons.badge_outlined,
//                             ),
//                             SizedBox(width: 5,),
//                             Text("Admits", style: TextStyle(fontFamily: "uber",fontWeight: FontWeight.w600),)
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               )
//             ],
//           ),
//         )
//       );
//   }
// }
