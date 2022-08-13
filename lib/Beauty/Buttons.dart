import 'package:flutter/material.dart';

class Buttons extends StatefulWidget {
  const Buttons({Key? key}) : super(key: key);

  @override
  State<Buttons> createState() => _ButtonsState();
}

class _ButtonsState extends State<Buttons> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            width: 80,
            height: 80,
            margin: EdgeInsets.all(5),
            decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("./assets/branding/favouritebtn.png"),
                )
            ),
          ),
          Container(
            width: 80,
            height: 80,
            margin: EdgeInsets.all(5),
            decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("./assets/branding/encycolpediabtn.png"),
                )
            ),
          ),
          Container(
            width: 80,
            height: 80,
            margin: EdgeInsets.all(5),
            decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("./assets/branding/materialbtn.png"),
                )
            ),
          ),
          Container(
            width: 80,
            height: 80,
            margin: EdgeInsets.all(5),
            decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("./assets/branding/gkbutton.png"),
                )
            ),
          ),
        ],
      ),
    );
  }
}
