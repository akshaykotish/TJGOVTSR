import 'package:flutter/material.dart';
import 'package:governmentapp/Beauty/Banner.dart';
import 'package:governmentapp/Beauty/Branding.dart';
import 'package:governmentapp/Beauty/Buttons.dart';
import 'package:governmentapp/Beauty/ToolSection.dart';
import 'package:governmentapp/Files/JobBoxs.dart';
import 'package:governmentapp/HexColors.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        color: ColorFromHexCode("#E2E2E2"),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const <Widget>[
              Branding(),
              BannerForAds(),
              ToolSection(),
              JobBoxs(),
            ],
          ),
        ),
      ),
    );
  }
}

