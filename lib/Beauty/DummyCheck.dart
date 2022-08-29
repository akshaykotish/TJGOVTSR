import 'package:flutter/material.dart';
import 'package:governmentapp/DataLoadingSystem/RequiredDataLoading.dart';
import 'package:governmentapp/Files/JobBoxs.dart';

class DummyCheck extends StatefulWidget {
  const DummyCheck({Key? key}) : super(key: key);

  @override
  State<DummyCheck> createState() => _DummyCheckState();
}

class _DummyCheckState extends State<DummyCheck> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    RequiredDataLoading.Execute();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: const SingleChildScrollView(child: JobBoxs()),
      ),
    );
  }
}
