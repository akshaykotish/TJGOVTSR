import 'package:flutter/material.dart';
import 'package:governmentapp/Beauty/Buttons.dart';
import 'package:governmentapp/Files/SearchArea.dart';
import 'package:governmentapp/HexColors.dart';

class ToolSection extends StatefulWidget {
  const ToolSection({Key? key}) : super(key: key);

  @override
  State<ToolSection> createState() => _ToolSectionState();
}

class _ToolSectionState extends State<ToolSection> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.only(
        top: 10,
        bottom: 10,
      ),
      height: 210,
      decoration: BoxDecoration(
        color: ColorFromHexCode("#F0F0F0"),
        borderRadius: const BorderRadius.all(Radius.circular(15)),

      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: const <Widget>[
          Buttons(),
          SizedBox(height: 10,),
          SearchArea(),
        ],
      ),
    );
  }
}
