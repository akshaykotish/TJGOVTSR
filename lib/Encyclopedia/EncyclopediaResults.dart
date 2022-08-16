import 'package:flutter/material.dart';
import 'package:governmentapp/Encyclopedia/EncylopediaData.dart';


class EncyclopediaResult extends StatefulWidget {
  const EncyclopediaResult({Key? key}) : super(key: key);

  @override
  State<EncyclopediaResult> createState() => _EncyclopediaResultState();
}

class _EncyclopediaResultState extends State<EncyclopediaResult> {

  var SearchResults = <Widget>[];

  void LoadSearchResult(){
    var _SearchResults = <Widget>[];
    EncylopediaDatas.encylopediaDatas.forEach((EncylopediaData encylopediaData) {
      _SearchResults.add(
        Container(
          child: Text(encylopediaData.Name),
        )
      );

      setState(() {
        SearchResults = _SearchResults;
      });
    });
  }

  @override
  void initState() {
    LoadSearchResult();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          children: <Widget>[
            Container(

            ),
            Container(
              child: Column(
                children: SearchResults,
              ),
            )
          ],
        ),
      ),
    );
  }
}
