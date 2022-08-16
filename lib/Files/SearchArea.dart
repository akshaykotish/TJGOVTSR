import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:governmentapp/DataLoadingSystem/JobDisplayManagement.dart';
import 'package:governmentapp/Files/CurrentJob.dart';
import 'package:governmentapp/Filtration/FilterPage.dart';
import 'package:governmentapp/Filtration/SearchSheet.dart';
import 'package:governmentapp/ForUsers/ChooseDepartment.dart';
import 'package:governmentapp/HexColors.dart';

class SearchArea extends StatefulWidget {
  const SearchArea({Key? key}) : super(key: key);

  @override
  State<SearchArea> createState() => _SearchAreaState();
}

class _SearchAreaState extends State<SearchArea> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(10),
      child: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.2),
              borderRadius: const BorderRadius.all(Radius.circular(15))
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.only(
                    top: 10,
                    left: 20,
                    bottom: 10,
                    right: 20,
                  ),
                  child: GestureDetector(
                    onTap: () async {
                      JobDisplayManagement.isloadingjobs = true;
                      JobDisplayManagement.ismoreloadingjobs = true;
                      JobDisplayManagement.jobstoshow.clear();
                      var ToSearches = await Navigator.push(context, MaterialPageRoute(builder: (context) => SearchSheet()));
                      print("ToSearches: " + ToSearches.toString());
                      CurrentJob.CurrentSearchData.add(ToSearches);
                    },
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          width: 30,
                          height: 30,
                          decoration: const BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage("./assets/icons/search.png"),
                            )
                          ),
                        ),
                        const SizedBox(width: 20,),
                        Text("Look at the jobs..", style: TextStyle(fontSize: 20, color: Colors.grey[500], fontWeight: FontWeight.w400, fontFamily: "EBGaramond"),),
                      ],
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>ChooseDepartment()));
                  },
                  child: Container(
                    width: 60,
                    height: 60,
                    padding: EdgeInsets.all(10),
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    child: Center(
                      child: Container(
                        width: 30,
                        height: 30,
                        decoration: const BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage("./assets/icons/filter-results-button.png"),
                            )
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
