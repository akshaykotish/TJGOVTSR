import 'package:flutter/material.dart';
import 'package:governmentapp/Files/AnimatedFlips.dart';
import 'package:governmentapp/HexColors.dart';


class Branding extends StatefulWidget {
  const Branding({Key? key}) : super(key: key);

  @override
  State<Branding> createState() => _BrandingState();
}

class _BrandingState extends State<Branding> with
    SingleTickerProviderStateMixin {

  late AnimationController controller;
  late Animation colorAnimation;
  late Animation sizeAnimation;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    controller =  AnimationController(vsync: this, duration: Duration(seconds: 2));
    sizeAnimation = Tween<double>(begin: 5.0, end: 30.0).animate(controller);
    controller.forward();
    controller.addListener(() {
      setState(() {

      });
    });
  }

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
          borderRadius: BorderRadius.all(Radius.circular(15)),
          image: DecorationImage(
            image: AssetImage("./assets/branding/BrandingBackground.jpg"),
            fit: BoxFit.fill,
          ),
        ),
        child: Column(
          children: <Widget>[
            Container(
              margin: const EdgeInsets.only(top: 10),
              child: Text("TrackJobs", style: TextStyle(fontFamily: "CAMPUS", fontSize: sizeAnimation.value, color: ColorFromHexCode("#DBDBDB"), letterSpacing: 15),),
            ),
            const SizedBox(height: 8,),
            const AnimatedFlips(),
          ],
        ),
      ),
    );
  }
}
