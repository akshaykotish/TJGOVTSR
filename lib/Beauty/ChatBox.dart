import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:governmentapp/DataLoadingSystem/JobDisplayManagement.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

class ChatBox extends StatefulWidget {
  const ChatBox({Key? key}) : super(key: key);

  @override
  State<ChatBox> createState() => _ChatBoxState();
}

class _ChatBoxState extends State<ChatBox> {

  TextEditingController textEditingController = TextEditingController();
  SpeechToText _speechToText = SpeechToText();
  bool _speechEnabled = false;
  String _lastWords = '';

  Future<void> _initSpeech() async {
    _speechEnabled = await _speechToText.initialize();
    setState(() {});
  }

  void _startListening() async {
    print("Started");
    await _speechToText.listen(onResult: _onSpeechResult);
    setState(() {});
  }

  void _stopListening() async {
    print("Stoped");
  await _speechToText.stop();
    setState(() {});
  }

  void _onSpeechResult(SpeechRecognitionResult result) {
    setState(() {
      _lastWords = result.recognizedWords;
      textEditingController.text = _lastWords;
    });
    if(result.finalResult == true)
      {
        JobDisplayManagement.ChatBoxQueryC.add(result.recognizedWords.toString());
      }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(10))
      ),
      child: TextField(
        controller: textEditingController,
        textInputAction: TextInputAction.send,
        onSubmitted: (String s){
          JobDisplayManagement.ChatBoxQueryC.add(textEditingController.text.toLowerCase());
          textEditingController.clear();
        },
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: "Title, Keyword, Department",
          hintStyle: GoogleFonts.poppins(

          ),
          prefixIcon: GestureDetector(
              onTap: () async {
                if(!_speechToText.isAvailable)
                  {
                    await _initSpeech();
                  }
                print("STARTING:- ${_speechToText.isNotListening}");
                _speechToText.isNotListening ? _startListening() : _stopListening();
              },
          child: Icon(_speechToText.isNotListening ? Icons.mic : Icons.mic_off),
          ),
    suffixIcon: GestureDetector(
              onTap: (){
                JobDisplayManagement.ChatBoxQueryC.add(textEditingController.text.toLowerCase());
                textEditingController.clear();
                },
              child: Icon(Icons.send)),
        ),
      ),
    );
  }
}
