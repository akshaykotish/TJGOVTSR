import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:governmentapp/Beauty/BottomBar.dart';
import 'package:governmentapp/HexColors.dart';

class TopBar extends StatefulWidget {
  const TopBar({Key? key}) : super(key: key);

  @override
  State<TopBar> createState() => _TopBarState();
}

class _TopBarState extends State<TopBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey.withOpacity(0.5), width: 1)
      ),
      margin: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top,
      ),
      padding: EdgeInsets.all(10),
      alignment: Alignment.centerLeft,
        child: Row(
          children: <Widget>[
            Container(
              width: 50,
              height: 50,
              child: Image.asset("./assets/branding/Logo.png"),
            ),
            Text("Sarkari Naukri",
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
            ),
            SizedBox(width: MediaQuery.of(context).size.width/4,),
            Container(
              alignment: Alignment.centerRight,
              child: Text("Akshay Kotish & Co.\nversion: 1.1.18",
                textAlign: TextAlign.right,
                style: GoogleFonts.poppins(
                  fontSize: 8,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
            ),
          ],
        )
    );
  }
}
