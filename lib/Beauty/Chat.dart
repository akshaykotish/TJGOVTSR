import 'package:flutter/material.dart';
import 'package:governmentapp/Beauty/ChatBox.dart';
import 'package:governmentapp/Beauty/Chats.dart';
import 'package:governmentapp/ChatDatas.dart';
import 'package:governmentapp/HexColors.dart';

class Chat extends StatefulWidget {
  const Chat({Key? key}) : super(key: key);

  @override
  State<Chat> createState() => _ChatState();
}

class _ChatState extends State<Chat> {


  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        children: <Widget>[
          Positioned(
              left: 0,
              right: 0,
              top: 0,
              bottom: 0,
              child: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("./assets/branding/chatbackground.png",),
                    fit: BoxFit.fill,
                  )
                ),
                child: Chats(),
              )
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            height: 70,
            child: Container(
              height: 50,
              width: 300,
              padding: EdgeInsets.all(10),
              child: Container(
                decoration: BoxDecoration(
                  color: ColorFromHexCode("#FFFFFF"),
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  border: Border.all(color: Colors.grey.withOpacity(0.6), width: 1),
                ),
                child: ChatBox(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
