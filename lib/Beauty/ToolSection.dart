import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:governmentapp/Beauty/Buttons.dart';
import 'package:governmentapp/DataLoadingSystem/JobDisplayManagement.dart';
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
      margin: EdgeInsets.only(left: 10, right: 10, bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: const <Widget>[
          SearchArea(),
        ],
      ),
    );
  }
}
