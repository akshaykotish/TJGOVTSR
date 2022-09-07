import 'package:flutter/material.dart';
import 'package:governmentapp/Animations/Loading.dart';
import 'package:governmentapp/DataLoadingSystem/JobDisplayManagement.dart';

class ShowSkeleton extends StatefulWidget {
  const ShowSkeleton({Key? key}) : super(key: key);

  @override
  State<ShowSkeleton> createState() => _ShowSkeletonState();
}

class _ShowSkeletonState extends State<ShowSkeleton> {
  @override
  Widget build(BuildContext context) {
    return Column(
        children: <Widget>[
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: 250,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: const <Widget>[
                  SkeletonDeptCard(),
                  SkeltonCard(),
                ],
              ),
            ),
          ),
        ],
      );
  }
}
