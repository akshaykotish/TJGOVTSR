import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:governmentapp/Encyclopedia/EncyclopediaRead.dart';
import 'package:governmentapp/GK/CurrentAffairs.dart';
import 'package:governmentapp/GK/GKQuiz.dart';
import 'package:governmentapp/HexColors.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';


class BottomBar extends StatefulWidget {
  const BottomBar({Key? key}) : super(key: key);

  @override
  State<BottomBar> createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 60,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.withOpacity(0.2), width: 1,),
          color: ColorFromHexCode("#FFFFFF"),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          GestureDetector(
            onTap: ()
            {
              Navigator.push(context, PageRouteBuilder(
                  transitionDuration: const Duration(milliseconds: 300),
                  transitionsBuilder: (BuildContext context, Animation<double> animation, Animation<double> secAnimation, Widget child){

                    animation = CurvedAnimation(parent: animation, curve: Curves.elasticInOut);

                    return ScaleTransition(
                      scale: animation,
                      alignment: Alignment.center,
                      child: child,
                    );
                  },
                  pageBuilder: (BuildContext context, Animation<double> animation, Animation<double> secAnimation){
                    return CurrentAffairs();
                  }));
            },
            child: Container(
              width: MediaQuery.of(context).size.width/2 - 20,
              height: 60,
              padding: EdgeInsets.all(5),
              decoration: BoxDecoration(
                //color: ColorFromHexCode("#404752").withOpacity(0.1),
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                      width: 50,
                      child: Image.asset("./assets/icons/Current_Affairs.png")),
                  Container(
                    padding: EdgeInsets.all(5),
                    child: Text("Current Affairs\nMagzine",
                      style: GoogleFonts.poppins(
                          fontSize: 10,
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          GestureDetector(
            onTap: ()
            {
              Navigator.push(context, PageRouteBuilder(
                  transitionDuration: const Duration(milliseconds: 300),
                  transitionsBuilder: (BuildContext context, Animation<double> animation, Animation<double> secAnimation, Widget child){

                    animation = CurvedAnimation(parent: animation, curve: Curves.elasticInOut);

                    return ScaleTransition(
                      scale: animation,
                      alignment: Alignment.center,
                      child: child,
                    );
                  },
                  pageBuilder: (BuildContext context, Animation<double> animation, Animation<double> secAnimation){
                    return GKQuiz();
                  }));
            },
            child: Container(
              width: MediaQuery.of(context).size.width/2 - 20,
              height: 60,
              padding: EdgeInsets.all(5),
              decoration: BoxDecoration(
                //color: ColorFromHexCode("#404752").withOpacity(0.1),
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                      width: 50,
                      child: Image.asset("./assets/icons/QUizes.png")),
                  Container(
                    padding: EdgeInsets.all(5),
                    child: Text("Current Affairs\nQuiz",
                      style: GoogleFonts.poppins(
                        fontSize: 10,
                          color: Colors.black,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
