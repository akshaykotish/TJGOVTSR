import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:governmentapp/DataLoadingSystem/JobDisplayManagement.dart';
import 'package:governmentapp/Files/CurrentJob.dart';
import 'package:governmentapp/HexColors.dart';

class Header extends StatefulWidget {
  const Header({Key? key}) : super(key: key);

  @override
  State<Header> createState() => _HeaderState();
}

class _HeaderState extends State<Header> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: ColorFromHexCode("#F4F6F7"),
      margin: const EdgeInsets.only(
        left: 15,
        top: 70,
        bottom: 5,
        right: 15,
    ),
      padding: EdgeInsets.all(10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Container(
            width: 220,
            height: 60,
            padding: EdgeInsets.all(10),
            child: Center(child: Text("#BornToProud", style: GoogleFonts.quicksand(fontSize: 24, fontWeight: FontWeight.w500, color: Colors.black),)),
          ),

      GestureDetector(
        onTap: (){
          CurrentJob.LovedJobsData.add("Loved");

        },
        child: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            color: ColorFromHexCode("#3498DB"),
          ),
          padding: const EdgeInsets.all(5),
          child: Center(
            child: Icon(
                Icons.favorite_outlined,
                color: ColorFromHexCode("#F4F6F7"),
            ),
          ),
        ),
      )


        ],
      ),
    );
  }
}
