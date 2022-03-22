import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

Color ColorFromHexCode(String hexColor){
  hexColor = hexColor.replaceAll("#", "");
  if (hexColor.length == 6) {
    hexColor = "FF" + hexColor;
  }
  if (hexColor.length == 8) {
    return Color(int.parse("0x$hexColor"));
  }

  return Colors.white;
}