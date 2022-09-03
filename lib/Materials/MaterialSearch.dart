import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:governmentapp/Materials/MaterialData.dart';
import 'package:html/parser.dart';
import 'package:http/http.dart' as http;
import 'package:webview_flutter/webview_flutter.dart';


class MaterialSearch extends StatefulWidget {
  MaterialSearch({required this.url});

  String url = "";

  @override
  State<MaterialSearch> createState() => _MaterialSearchState();
}

class _MaterialSearchState extends State<MaterialSearch> {

  @override
  void initState() {
    print("URL " + widget.url);
    if (Platform.isAndroid) WebView.platform = AndroidWebView();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.red,
          padding: const EdgeInsets.only(
            top: 50,
            bottom: 0,
            left: 40,
            right: 40,
          ),
          child: SingleChildScrollView(
            child: WebView(
              initialUrl: widget.url,
            ),
          )
      ),
    );
  }
}
