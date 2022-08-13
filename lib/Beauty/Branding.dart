import 'package:flutter/material.dart';
import 'package:governmentapp/Files/AnimatedFlips.dart';
import 'package:governmentapp/HexColors.dart';


class Branding extends StatefulWidget {
  const Branding({Key? key}) : super(key: key);

  @override
  State<Branding> createState() => _BrandingState();
}

class _BrandingState extends State<Branding> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      margin: EdgeInsets.only(top: MediaQuery.of(context).viewPadding.top,),
      child: Container(
        padding: EdgeInsets.all(10),
        width: MediaQuery.of(context).size.width - 20,
        height: 90,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("./assets/branding/BrandingBackground.png"),
            fit: BoxFit.fill,
          ),
        ),
        child: Column(
          children: <Widget>[
            Container(
              margin: const EdgeInsets.only(top: 10),
              child: Text("TrackJobs", style: TextStyle(fontFamily: "SportsWorld", fontSize: 30, color: ColorFromHexCode("#DBDBDB"), letterSpacing: 15),),
            ),
            SizedBox(height: 8,),
            AnimatedFlips(),
          ],
        ),
      ),
    );
  }
}
